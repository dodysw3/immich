import type { AiInterpretationDocument, MuseInterpretationResult } from 'src/dtos/ai-image-interpretation.dto.js';

// The lexical document is matched with pg_trgm word similarity, which rewards
// exact tokens: names and keywords only. Prose fields stay out so a trigram
// hit always lands on something the interpretation explicitly named.
export const buildAiInterpretLexicalDoc = (result: MuseInterpretationResult): string => {
  return [result.title, ...result.search_keywords, ...result.identifications.map(({ name }) => name)]
    .map((part) => part.trim())
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
