import { createHash } from 'node:crypto';
import { AiInterpretationDocumentSchema } from 'src/dtos/ai-image-interpretation.dto';

export const AI_IMAGE_INTERPRETATION_PROMPT_VERSION = 'image-interpretation-1.0.0';
export const AI_IMAGE_INTERPRETATION_MODEL = 'unsloth/Muse-Glimmer-30B-GGUF';
export const AI_IMAGE_INTERPRETATION_QUANT = 'UD-Q3_K_XL';
export const AI_IMAGE_INTERPRETATION_MAX_OUTPUT_TOKENS = 6400;

export const AI_IMAGE_INTERPRETATION_PROMPT = `You are an archival image interpreter. Analyze only evidence visible in the supplied image. Distinguish direct observation from interpretation and from uncertain contextual inference. Explain not only what is present, but how composition, gesture, light, setting, and relationships may shape the image's meaning.

No Immich face matches, person IDs, or associated names are provided. Do not guess or invent a person's identity. You may name someone only when they are a widely known public figure and you have great confidence from clear, distinctive visual evidence in this image. Otherwise use a generic description such as "a person" and put the identity limitation in uncertainties. A name is a model claim, not a verified fact. Do not infer sensitive personal traits. Do not infer exact places, dates, authorship, brands, or events unless visible evidence strongly supports them.

Return only JSON matching the supplied schema. Keep literal_description observational. Put hypotheses in interpretation or alternative_interpretations, state their evidence, and include meaningful uncertainty. Never promote a low-confidence identification into title, archive_summary, or search_keywords.`;

// Some OpenAI-compatible llama.cpp builds accept response_format but do not
// enforce every required property in the supplied JSON schema. Keep this
// contract reminder separate from the versioned archival prompt so the
// semantic prompt identity remains deliberate and reproducible.
export const AI_IMAGE_INTERPRETATION_SCHEMA_INSTRUCTION =
  'Return one JSON object with every required key, even when its value is an empty string or empty array. Do not omit any key. Required keys in this exact list: title, literal_description, visual_analysis, interpretation, context_and_significance, notable_details, identifications, alternative_interpretations, uncertainties, archive_summary, search_keywords. Array shapes: notable_details contains objects with detail, significance, confidence; identifications contains objects with name, type, confidence, basis; all other array fields contain strings. Use only the allowed confidence values high, medium, or low and allowed identification types person, place, artwork, object, organization, or other.';

export const createAiInterpretationRunKey = (model: string, quant: string, promptVersion: string): string =>
  createHash('sha256').update(`${model}\n${quant}\n${promptVersion}`, 'utf8').digest('hex');

// Failed runs retry with exponentially increasing delays, capped at one day,
// with no attempt limit: an endpoint that is down for hours (or a model being
// re-tuned) must eventually converge without ever hammering it. The dispatch
// granularity is the 15-minute reconcile pass, so delays below 15 minutes
// effectively fire on the next pass.
export const AI_INTERPRETATION_RETRY_BASE_MS = 2 * 60_000;
export const AI_INTERPRETATION_RETRY_MAX_MS = 24 * 60 * 60_000;

// A queued run is only stale when its job has been lost (e.g. queue state
// wiped). This must comfortably exceed any realistic queue wait — a busy
// worker at ~2 min per interpretation backs up 15 min for just ~7 waiting
// jobs — otherwise busy periods prematurely reap and penalize queued runs.
export const AI_INTERPRETATION_QUEUED_STALE_MS = 2 * 60 * 60_000;

export const interpretationRetryDelayMs = (attempts: number): number => {
  const exponent = Math.min(Math.max(Math.floor(attempts) - 1, 0), 13);
  return Math.min(AI_INTERPRETATION_RETRY_BASE_MS * 2 ** exponent, AI_INTERPRETATION_RETRY_MAX_MS);
};

export const isAiInterpretationDocument = (value: unknown) => AiInterpretationDocumentSchema.safeParse(value).success;
