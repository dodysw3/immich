import { DateTime } from 'luxon';
import { createHash } from 'node:crypto';
import type { AiAudioEventsRun } from 'src/dtos/ai-audio-events.dto.js';
import { AiInterpretationDocumentSchema } from 'src/dtos/ai-image-interpretation.dto.js';
import type { AiVideoCaptionRun, AiVideoCaptionSegment } from 'src/dtos/ai-video-captioning.dto.js';
import type { AiVideoTranscriptionRun } from 'src/dtos/ai-video-transcription.dto.js';
import { renderAudioEventSentences } from 'src/utils/ai-audio-events.js';
import { isNoChangeCaption } from 'src/utils/ai-video-captioning.js';

export const AI_IMAGE_INTERPRETATION_PROMPT_VERSION = 'image-interpretation-1.2.0';
/**
Run identity for videos whose interpretation is enriched with caption/transcript
context. Forking the promptVersion forks the runKey, so existing video
interpretations (thumbnail-only, under 1.2.0) stay intact; turning the feature
off or changing context inputs changes the identity again.
*/
export const AI_IMAGE_INTERPRETATION_VIDEO_PROMPT_VERSION = 'image-interpretation-1.2.0-video-0.1.0';
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

// The output contract lives in this instruction — the client must not send
// response_format: llama.cpp builds since 2026-10-15 (b11541-mix) enforce it
// as a hard JSON grammar, and a grammar-confined model leaks the T/D/I/A/K
// markers into JSON values, failing every parse. (Older builds ignored the
// field entirely — verified 2026-09-15 — which is why it was once safe to
// send.) Kept separate from the versioned archival prompt so the
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

// Hosted-router identity quant: marks results served by a remote hosted model
// (the manual "Interpret image (public)" path) as opposed to a locally
// quantized GGUF.
export const AI_INTERPRETATION_HOSTED_QUANT = 'hosted';

export const createAiInterpretationPublicRunKey = (publicModel: string, promptVersion: string): string =>
  createAiInterpretationRunKey(publicModel, AI_INTERPRETATION_HOSTED_QUANT, promptVersion);

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

// Per-section cap on the composed video context (captions / transcript), so a
// long video cannot balloon the interpretation prompt; everything past the cap
// is replaced with an explicit omission marker.
const VIDEO_CONTEXT_SECTION_CAP_CHARS = 6000;

const capContextSection = (lines: string[]): string => {
  const kept: string[] = [];
  let length = 0;
  for (const line of lines) {
    if (kept.length > 0 && length + line.length > VIDEO_CONTEXT_SECTION_CAP_CHARS) {
      kept.push('[… additional segments omitted]');
      break;
    }
    kept.push(line);
    length += line.length + 1;
  }
  return kept.join('\n');
};

const formatContextWindow = (startMs: number, endMs: number): string =>
  `[${(startMs / 1000).toFixed(1)}-${(endMs / 1000).toFixed(1)}s]`;

/**
Delta captioning (v0.4.0) emits "No change." for static stretches; in the
interpretation context those lines are info-free, so consecutive ones
collapse into a single line spanning the whole unchanged window.
*/
const collapseNoChangeCaptions = (segments: AiVideoCaptionSegment[]): string[] => {
  const lines: string[] = [];
  let pendingNoChange: { startMs: number; endMs: number } | undefined;
  const flushPending = () => {
    if (!pendingNoChange) {
      return;
    }
    lines.push(`${formatContextWindow(pendingNoChange.startMs, pendingNoChange.endMs)} No change.`);
    pendingNoChange = undefined;
  };
  for (const segment of segments) {
    if (isNoChangeCaption(segment.caption)) {
      pendingNoChange = { startMs: pendingNoChange?.startMs ?? segment.startMs, endMs: segment.endMs };
      continue;
    }
    flushPending();
    lines.push(`${formatContextWindow(segment.startMs, segment.endMs)} ${segment.caption}`);
  }
  flushPending();
  return lines;
};

export interface AiVideoInterpretationContextInput {
  durationMs?: number;
  /** Latest completed caption run, when the captioning lane produced one. */
  captions?: AiVideoCaptionRun;
  /** Latest completed transcription run, when the whisper sidecar produced one. */
  transcripts?: AiVideoTranscriptionRun;
  /** Latest completed audio-events run, when the YAMNet sidecar produced one. */
  audioEvents?: AiAudioEventsRun;
}

/**
Compose the prompt-context block fed to the interpretation model for videos:
per-segment visual captions, the whisper transcript, and tagged environmental
sounds, framed as direct evidence from the full video (the system prompt only
knows about "the supplied image"). Returns undefined when there is nothing to
add — an absent transcript run means "unknown", never "no speech", so it stays
silent rather than claiming anything about the audio; likewise a missing or
empty audio-events run never claims the video is silent.
*/
export const composeVideoInterpretationContext = (input: AiVideoInterpretationContextInput): string | undefined => {
  const { durationMs, captions, transcripts, audioEvents } = input;

  const captionLines = collapseNoChangeCaptions(captions?.segments ?? []);
  const transcriptLines = (transcripts?.segments ?? []).map(
    (segment) => `${formatContextWindow(segment.startMs, segment.endMs)} ${segment.text}`,
  );

  const hasCaptions = captionLines.length > 0;
  const hasTranscript = transcriptLines.length > 0;
  // Tagging drops speech-family events when the transcript already had words;
  // a transcript that only arrived after the tagging run is caught here, so
  // speech never shows up both as words and as a sound sentence. Natural
  // sentences, no scores: the bench model ignored label+score telegraph rows.
  const audioEventLines = renderAudioEventSentences(audioEvents?.events ?? [], {
    transcriptHasWords: hasTranscript,
  }).map((line) => `${formatContextWindow(line.startMs, line.endMs)} ${line.sentence}`);
  const hasAudioEvents = audioEventLines.length > 0;
  if (!hasCaptions && !hasTranscript && !hasAudioEvents) {
    return undefined;
  }

  const durationSec = durationMs !== undefined ? (durationMs / 1000).toFixed(1) : undefined;
  const sections: string[] = [];

  let header = 'The attached image is only the preview thumbnail of a video';
  if (durationSec) {
    header += ` (${durationSec}s long)`;
  }
  header +=
    '. Evidence captured from the full video follows; treat it as direct observation alongside the thumbnail, distinguish it from inference, and include what is said or heard when it matters.';
  sections.push(header);

  if (hasCaptions) {
    const truncatedNote = captions?.truncated ? '\n[Captions cover only the head of a longer video.]' : '';
    // Adaptive runs use change-driven variable-length windows — the caption
    // ranges below are real windows, not fixed grid steps.
    const captionsHeader = captions?.config.adaptive
      ? 'Visual captions (variable-length segments)'
      : `Visual captions per ${(captions?.config.segmentSeconds ?? 5).toFixed(0)}-second segment`;
    sections.push(`${captionsHeader}:\n${capContextSection(captionLines)}${truncatedNote}`);
  }

  if (hasTranscript) {
    const languageNote = transcripts?.language ? ` (detected language: ${transcripts.language})` : '';
    sections.push(`Speech transcript${languageNote}:\n${capContextSection(transcriptLines)}`);
  } else if (transcripts) {
    // A completed run without segments is a real observation about the audio
    // (no stream, or whisper/VAD heard nothing through the noise filter); a
    // MISSING run would stay silent above instead of claiming this.
    sections.push(transcripts.noAudio ? 'The video has no audio track.' : 'No speech was detected in the video.');
  }

  if (hasAudioEvents) {
    sections.push(`Other sounds detected in the audio:\n${capContextSection(audioEventLines)}`);
  }

  return sections.join('\n\n');
};

// The completion-rate window used for queue ETA estimates: the average of the
// last N minutes of completed interpretations (aggregated across workers via
// Redis) is divided into the remaining queue depth.
export const AI_INTERPRETATION_RATE_WINDOW_MINUTES = 5;
export const AI_INTERPRETATION_RATE_WINDOW_MS = AI_INTERPRETATION_RATE_WINDOW_MINUTES * 60_000;

// The two serving lanes: the main queue's local (or burst-rented hybrid)
// endpoint and the dedicated public queue's hosted muse-spark router. Their
// throughputs differ by an order of magnitude, so the completion-rate ledger
// and every queue-depth ETA are tracked per lane — a blended rate divides one
// lane's backlog by the other lane's speed and makes both ETAs wrong.
export type AiInterpretationLane = 'local' | 'public';

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
