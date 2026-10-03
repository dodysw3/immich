import { DateTime } from 'luxon';
import { createHash } from 'node:crypto';
import { AiInterpretationDocumentSchema } from 'src/dtos/ai-image-interpretation.dto.js';

export const AI_IMAGE_INTERPRETATION_PROMPT_VERSION = 'image-interpretation-1.2.0';
export const AI_IMAGE_INTERPRETATION_MODEL = 'unsloth/Muse-Glimmer-30B-GGUF';
export const AI_IMAGE_INTERPRETATION_QUANT = 'UD-Q3_K_XL';
export const AI_IMAGE_INTERPRETATION_MAX_OUTPUT_TOKENS = 6400;

// 1.2.0 (2026-10-03): serialization-only swap — the compact single-line JSON is
// replaced by the positional line format (T/D/I/N/X/A/K records, H/M/L
// confidence codes, PERS/PLACE/… type codes) plus a shortest-natural-wording
// instruction. Controlled benchmark on 39 library images
// (immich-app/format-bench/REPORT.md): −27% total tokens, −53% visible tokens,
// −24% latency, zero hallucinated identifications, semantic quality within
// noise of 1.1.0. The archival prompt below changed one sentence: "Return only
// JSON matching the supplied schema" became "Return only the requested output
// representation" so the system message no longer contradicts the line format.
// Runs completed under 1.1.0 stay valid: storage is the canonical document,
// not the wire representation.
// 1.1.0 (2026-10-02): dropped the four speculative fields that no consumer
// ever read (visual_analysis, context_and_significance,
// alternative_interpretations, uncertainties) and switched to compact
// single-line JSON with reasoning_strength low — blind A/B judging on 16
// images showed equal-or-better completeness/accuracy at ~half the tokens.
// Hypotheses and uncertainty now fold into interpretation itself.
export const AI_IMAGE_INTERPRETATION_PROMPT = `You are an archival image interpreter. Analyze only evidence visible in the supplied image. Distinguish direct observation from interpretation and from uncertain contextual inference. Explain not only what is present, but how composition, gesture, light, setting, and relationships may shape the image's meaning.

No Immich face matches, person IDs, or associated names are provided. Do not guess or invent a person's identity. You may name someone only when they are a widely known public figure and you have great confidence from clear, distinctive visual evidence in this image. Otherwise use a generic description such as "a person" and note the identity limitation briefly within interpretation. A name is a model claim, not a verified fact. Do not infer sensitive personal traits. Do not infer exact places, dates, authorship, brands, or events unless visible evidence strongly supports them.

Return only the requested output representation. Keep literal_description observational. Put hypotheses in interpretation together with their evidence, and briefly note meaningful alternatives and uncertainties there. Never promote a low-confidence identification into title, archive_summary, or search_keywords.`;

// The serving endpoint (an Unsloth llama.cpp fork) ignores response_format
// entirely — verified 2026-09-15 — so the output contract lives in this
// instruction. Kept separate from the versioned archival prompt so the
// semantic prompt identity stays deliberate while the wire representation
// evolves. 1.2.0 format: one record per line, confidence/type as letter codes
// (the model drifts to lowercase h/m/l even when told full words — the parser
// accepts both). The wording block is the "concise" arm of the 1.2.0
// benchmark; it is what buys the extra ~17pp of token savings.
export const AI_IMAGE_INTERPRETATION_FORMAT_INSTRUCTION = `Return plain text, one record per line, using these record types (single space between marker and content):
T <title>
D <literal_description>
I <interpretation>
N <confidence>|<detail>|<significance>
X <confidence>|<type>|<name>|<basis>
A <archive_summary>
K <keyword1>|<keyword2>
Exactly one T, D, I, and A line each. One N line per notable detail (omit all N lines if none). One X line per identification (omit all X lines if none). One K line with keywords separated by | (omit if none). Order: T, D, I, then all N lines, then all X lines, then A, then K. Confidence codes: H = high, M = medium, L = low. Identification type codes: PERS = person, PLACE = place, ART = artwork, OBJ = object, ORG = organization, OTH = other. No other text, no blank lines, no markdown, do not wrap lines.

Use the shortest natural wording that stays useful in every field. Prefer "People walking through an outdoor market." over "The image appears to show a group of people who are walking through an outdoor marketplace.". Omit filler ("The image shows", "It appears that"), hedging boilerplate, and any information repeated in another field. Do not use telegraphic phrasing that changes meaning.`;

export const createAiInterpretationRunKey = (model: string, quant: string, promptVersion: string): string =>
  createHash('sha256').update(`${model}\n${quant}\n${promptVersion}`, 'utf8').digest('hex');

// Failed runs retry with exponentially increasing delays, capped at one day,
// with no attempt limit: an endpoint that is down for hours (or a model being
// re-tuned) must eventually converge without ever hammering it. The dispatch
// granularity is the 15-minute reconcile pass, so delays below 15 minutes
// effectively fire on the next pass.
export const AI_INTERPRETATION_RETRY_BASE_MS = 2 * 60_000;
export const AI_INTERPRETATION_RETRY_MAX_MS = 24 * 60 * 60_000;

// BullMQ job id for a run's delivery: deterministic so concurrent queueing
// collapses to a single job, and shared by the reconcile pass, which declares a
// queued run lost only when no job with this id exists in the queue anymore.
export const createAiInterpretationJobId = (assetId: string, runKey: string): string => `${assetId}/${runKey}`;

export const interpretationRetryDelayMs = (attempts: number): number => {
  const exponent = Math.min(Math.max(Math.floor(attempts) - 1, 0), 13);
  return Math.min(AI_INTERPRETATION_RETRY_BASE_MS * 2 ** exponent, AI_INTERPRETATION_RETRY_MAX_MS);
};

export const isAiInterpretationDocument = (value: unknown) => AiInterpretationDocumentSchema.safeParse(value).success;

// The completion-rate window used for queue ETA estimates: the average of the
// last N minutes of completed interpretations (aggregated across workers via
// Redis) is divided into the remaining queue depth.
export const AI_INTERPRETATION_RATE_WINDOW_MINUTES = 5;
export const AI_INTERPRETATION_RATE_WINDOW_MS = AI_INTERPRETATION_RATE_WINDOW_MINUTES * 60_000;

const formatEtaDuration = (minutes: number): string => {
  if (minutes < 1) {
    return '<1m';
  }

  const total = Math.round(minutes);
  const days = Math.floor(total / 1440);
  const hours = Math.floor((total % 1440) / 60);
  const mins = total % 60;
  const parts = [days > 0 ? `${days}d` : '', hours > 0 ? `${hours}h` : '', mins > 0 ? `${mins}m` : ''];
  return parts.filter(Boolean).join(' ') || '<1m';
};

export const formatAiInterpretationQueueEta = (
  remainingCount: number,
  completionsPerMinute: number,
  now: DateTime = DateTime.now(),
): string => {
  if (remainingCount <= 0) {
    return 'queue drained';
  }

  if (completionsPerMinute <= 0) {
    return `unknown (no completions in the last ${AI_INTERPRETATION_RATE_WINDOW_MINUTES} minutes)`;
  }

  const minutes = remainingCount / completionsPerMinute;
  const finishAt = now.plus({ minutes });
  const duration = formatEtaDuration(minutes);
  return `${duration.startsWith('<') ? '' : '~'}${duration} (around ${finishAt.toFormat('LLL d, h:mm a')} ${
    finishAt.offsetNameShort || finishAt.toFormat('ZZ')
  })`;
};
