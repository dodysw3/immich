import type { AiInterpretationDocument, MuseInterpretationResult } from 'src/dtos/ai-image-interpretation.dto.js';

// pg_trgm treats every non-alphanumeric character as a word separator, so
// tokenizing prose into a flat word stream is matching-neutral — it just
// keeps the stored document compact and free of stray punctuation runs.
const tokenizeForTrigram = (part: string): string =>
  part
    .split(/[^\p{L}\p{N}]+/u)
    .filter((token) => token.length > 0)
    .join(' ');

// The lexical document is matched with pg_trgm strict word similarity, which
// rewards exact tokens. Named entities (title, keywords, identifications)
// come first, then tokenized prose from literal_description and
// notable_details so a name the interpretation only mentions in prose
// ("Doctor listed as drg NIDIA SALEH Sp KG") still produces an exact
// word-boundary hit. The interpretation narrative stays out: it describes
// what the scene means, not what it shows.
export const buildAiInterpretLexicalDoc = (result: MuseInterpretationResult): string => {
  return [
    result.title,
    ...result.search_keywords,
    ...result.identifications.map(({ name }) => name),
    result.literal_description,
    ...result.notable_details.flatMap(({ detail, significance }) => [detail, significance]),
  ]
    .map((part) => tokenizeForTrigram(part))
    .filter((part) => part.length > 0)
    .join(' ');
};

// The dense document embeds only grounded fields. Prompt 1.1.0 removed the
// speculative fields (context_and_significance, alternative_interpretations,
// uncertainties, visual_analysis) entirely — they described what the image
// might be rather than what it shows, and embedding them diluted the signal
// for cross-lingual retrieval. Documents from older runs may still carry
// those keys; zod strips them, so they never reach this builder.
export const buildAiInterpretDenseDoc = (result: MuseInterpretationResult): string => {
  const parts = [
    result.title,
    result.literal_description,
    result.interpretation,
    ...result.notable_details.flatMap(({ detail, significance }) => [detail, significance]),
    ...result.search_keywords,
  ];
  return parts
    .map((part) => part.trim())
    .filter((part) => part.length > 0)
    .join('\n');
};

// The latest completed run wins; `finishedAt` is the primary sort, with
// `requestedAt` (then runKey for determinism) as the fallback for runs that
// somehow completed without a finish timestamp.
export const findLatestCompletedRun = (
  document: AiInterpretationDocument | null,
): { runKey: string; result: MuseInterpretationResult } | null => {
  const completed = Object.entries(document?.runs ?? {})
    .filter(([, run]) => run.status === 'completed' && run.result)
    .sort(([aKey, a], [bKey, b]) => {
      const aEnd = a.finishedAt ?? a.requestedAt;
      const bEnd = b.finishedAt ?? b.requestedAt;
      if (aEnd !== bEnd) {
        return aEnd < bEnd ? 1 : -1;
      }
      return aKey < bKey ? 1 : -1;
    });

  const [runKey, run] = completed[0] ?? [];
  return runKey && run.result ? { runKey, result: run.result } : null;
};

// pgvector parses a text literal like '[0.1,0.2,...]'; the JSON transport from
// the embedding endpoint gives plain arrays, so they are serialized here.
export const toPgvectorString = (vector: number[]): string => `[${vector.join(',')}]`;

// Normalizes a raw query into its word tokens: lowercased, diacritic-stripped
// (NFD decomposition removes combining marks; equivalent to Postgres
// f_unaccent for decomposable Latin diacritics), split exactly like
// tokenizeForTrigram tokenizes the stored document. These tokens drive the
// exact-token branch's GIN prefilter patterns; the word-boundary verification
// itself always runs in Postgres against f_unaccent'ed text.
export const searchQueryTokens = (q: string): string[] =>
  q
    .toLowerCase()
    .normalize('NFD')
    .replaceAll(/\p{Diacritic}/gu, '')
    .split(/[^\p{L}\p{N}]+/u)
    .filter((token) => token.length > 0);
