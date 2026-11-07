import { createHash } from 'node:crypto';
import type { AiVideoCaptionSegment } from 'src/dtos/ai-video-captioning.dto.js';

/**
Experimental video captioning (LFM3-Omni-2B lane) — separate prompt version
and run keying from image interpretation so the two features can evolve
(and be reverted) independently.
*/
export const AI_VIDEO_CAPTIONING_PROMPT_VERSION = 'video-captioning-0.4.1';

export const createVideoCaptionRunKey = (
  model: string,
  segmentSeconds: number,
  framesPerSegment: number,
  promptVersion: string,
): string =>
  createHash('sha256')
    .update(`${model}\n${segmentSeconds}x${framesPerSegment}\n${promptVersion}`, 'utf8')
    .digest('hex');

export interface CaptionSegmentWindow {
  startMs: number;
  endMs: number;
}

/**
Fixed-width segment windows over the (capped) video timeline. `truncated`
marks videos longer than the captioning budget — only the head is captioned.
*/
export const planCaptionSegments = (
  durationMs: number,
  segmentSeconds: number,
  maxDurationSec: number,
): { segments: CaptionSegmentWindow[]; truncated: boolean } => {
  const segmentMs = segmentSeconds * 1000;
  const cappedDurationMs = Math.min(Math.max(durationMs, 0), maxDurationSec * 1000);
  const segments: CaptionSegmentWindow[] = [];
  for (let start = 0; start < cappedDurationMs; start += segmentMs) {
    const end = Math.min(start + segmentMs, cappedDurationMs);
    // Drop a trailing sliver shorter than 20% of a segment — too little
    // content for a meaningful caption and it skews the last frame grouping.
    if (end - start < segmentMs * 0.2) {
      break;
    }
    segments.push({ startMs: start, endMs: end });
  }
  return { segments, truncated: durationMs > maxDurationSec * 1000 };
};

/** Frames at (N-1)/fps seconds fall into the segment covering that timestamp. */
export const groupFramesBySegment = (
  framePaths: string[],
  fps: number,
  segments: CaptionSegmentWindow[],
): { startMs: number; endMs: number; framePaths: string[]; frameTimesMs: number[] }[] => {
  const grouped = segments.map((window) => ({ ...window, framePaths: [] as string[], frameTimesMs: [] as number[] }));
  for (const [index, path] of framePaths.entries()) {
    const frameTimeMs = (index / fps) * 1000;
    const segment = grouped.find((window) => frameTimeMs >= window.startMs && frameTimeMs < window.endMs);
    if (!segment) {
      continue;
    }
    segment.framePaths.push(path);
    segment.frameTimesMs.push(Math.round(frameTimeMs));
  }
  return grouped;
};

const LANGUAGE_NAMES: Record<string, string> = {
  en: 'English',
  id: 'Indonesian',
  de: 'German',
  fr: 'French',
  es: 'Spanish',
  ja: 'Japanese',
  zh: 'Chinese',
  ko: 'Korean',
};

export const captionLanguageName = (language: string): string => LANGUAGE_NAMES[language] ?? 'English';

/**
Captions are visual-only since v0.3.0: the omni audio path hallucinated
languages and looped on reverberant speech (2026-11-07 eval); audible content
is covered by the faster-whisper transcript fed to interpretation instead.

Since v0.4.0 every segment after the first is captioned as a delta against
the previous informative caption (2026-11-08 experiment on a 17-segment
talking-head video: −69% caption tokens, −75% interpretation-context chars,
equal interpretation quality; post-processing the finished captions with a
diff pass was also tested and failed — the 2B model parrots the input back).
The first segment keeps the full prompt so the scene is established once.

v0.4.1 fixes two live regressions of that first delta prompt on a market
video where the changes are people, not text: ranking on-screen text as
"the most important change" made the model wrap non-text deltas in a false
"A new on-screen text overlay appears:" prefix (change types are now
enumerated neutrally and text phrasing is conditional), and "any on-screen
text" in the full prompt negative-filled into "No on-screen text appears in
the frames." (absence statements are now banned outright).
*/
export interface CaptionPromptState {
  /** 1-based ordinal of the current segment in the video's segment plan. */
  ordinal: number;
  /**
  The last informative caption (never "No change.") with its window — the
  comparison anchor for the delta prompt. Undefined for the first captioned
  segment, which then gets the full scene-establishing prompt.
  */
  previous?: { caption: string; startMs: number; endMs: number };
}

export const buildCaptionPrompt = (
  segment: { startMs: number; endMs: number },
  language: string,
  state?: CaptionPromptState,
): string => {
  const languageName = captionLanguageName(language);
  const start = (segment.startMs / 1000).toFixed(1);
  const end = (segment.endMs / 1000).toFixed(1);
  const previous = state?.previous;
  if (!previous) {
    return [
      `These frames are sampled from ${start}s to ${end}s of a video, in chronological order.`,
      'Describe what happens in this video segment concisely in 1-3 sentences:',
      'who or what is visible, the actions, the scene, and any on-screen text (quote it exactly if present).',
      'If there is no on-screen text, leave it unmentioned — do not write absence statements like "No on-screen text appears in the frames."; just leave it out.',
      'Start directly with the subject (e.g. "A busy city street...", "A man in a blue shirt..."); never open with "The video shows", "The frames show", "In this scene", "In a busy street scene" or any scene-setting phrase — put that context in the sentences that follow.',
      `Write the caption in ${languageName}. Stick to what is actually there; do not speculate.`,
      'Reply with the caption text only — no preamble, no quotes, no reasoning.',
    ].join(' ');
  }
  const previousStart = (previous.startMs / 1000).toFixed(0);
  const previousEnd = (previous.endMs / 1000).toFixed(0);
  return [
    `These frames are sampled from ${start}s to ${end}s of a video, in chronological order.`,
    `This is segment ${state?.ordinal ?? 1} of a longer video; the previous described segment (${previousStart}s-${previousEnd}s) was captioned as: "${previous.caption}"`,
    'Describe ONLY what is new or changed in this segment compared to the previous one, in at most 2 short sentences:',
    'a person or object entering or leaving, someone starting a different action or moving, the scene or camera changing, or new text appearing on screen.',
    'The person, their clothing, the background and the camera carry over — do not mention them.',
    'Ignore small facial changes (blinks, gaze direction, mouth movement) and do not describe expressions at all; mention a gesture only if it is genuinely new.',
    'When text actually appears on screen, quote it exactly as it appears, in order, e.g. Text now shows "SAYA?" then "INILAH". If the change is not about text, describe it directly and do not mention "on-screen text" or "text overlay" at all.',
    'State the new state directly — never refer to "the previous segment", "the previous frame" or "compared to" inside your caption, never write that something is absent, and never wrap your description in quotation marks. If literally nothing is new, reply "No change."',
    'Start directly with what is new; never open with scene-setting phrases.',
    `Write the caption in ${languageName}. Stick to what is actually there; do not speculate.`,
    'Reply with the caption text only — no preamble, no quotes, no reasoning.',
  ].join(' ');
};

/**
The delta prompt (v0.4.0) tells the model to answer exactly this when a
segment adds nothing; callers rely on the shape to fold unchanged stretches
into the previous caption's window and to keep threading the last
informative caption as the comparison anchor.
*/
export const isNoChangeCaption = (text: string): boolean => /^no change\.?$/i.test(text.trim());

/**
Fold a captioned segment into the stored segment list. A "No change." answer
— or a verbatim repeat of the previous caption, the model's copy failure —
carries no new content, so instead of storing a no-op row the previous
segment's window extends to cover the unchanged stretch: the overlay's
time-in-window lookup keeps showing the previous caption, and the
interpretation context keeps one line per real caption. The first segment
has nothing to fold into, so a "No change." there is stored verbatim
(defensive — the full prompt never asks for it). Callers must not thread a
folded caption forward as the comparison anchor.
*/
export const foldCaptionSegment = (
  segments: AiVideoCaptionSegment[],
  next: AiVideoCaptionSegment,
): { segments: AiVideoCaptionSegment[]; foldedIntoPrevious: boolean } => {
  const previous = segments.at(-1);
  const isNoOp =
    previous !== undefined && (isNoChangeCaption(next.caption) || next.caption.trim() === previous.caption.trim());
  if (!isNoOp || !previous) {
    return { segments: [...segments, next], foldedIntoPrevious: false };
  }
  return {
    segments: [...segments.slice(0, -1), { ...previous, endMs: next.endMs }],
    foldedIntoPrevious: true,
  };
};

/** Belt-and-braces: strip a leaked <think>…</think> block if the server did not. */
export const stripCaptionThinking = (text: string): string =>
  text
    .replaceAll(/<think>[\s\S]*?<\/think>/gi, '')
    .replace(/^\s*<think>[\s\S]*$/i, '')
    .trim();

/**
Models love opening captions with "The video shows…" or "In this scene,"
filler; the prompt bans both, but a leading phrase that slips through is cut
here (verb variants kept deliberately narrow so a caption genuinely about a
video's showing is safe; "In the foreground," stays — that is real content).
*/
const CAPTION_OPENER_PATTERNS = [
  /^\s*(?:the |this |that )?(?:video|clip|segment|footage|recording|frames?|scene)s?\s+(?:show|shows|showing|depict|depicts|depicting|present|presents|presenting|capture|captures|capturing|reveal|reveals|revealing|display|displays|displaying|exhibit|exhibits|exhibiting|feature|features|featuring|highlight|highlights|portray|portrays|portraying|illustrate|illustrates|illustrating)\b[,:]? */i,
  /^\s*In (?:a|an|this|that) [^.,;:]{0,60}?(?:video|clip|scene|footage|setting|frame)\b[,.:]? */i,
];

export const stripCaptionOpener = (text: string): string => {
  let stripped = text.trim();
  for (const pattern of CAPTION_OPENER_PATTERNS) {
    stripped = stripped.replace(pattern, '').trim();
  }
  if (stripped === text.trim()) {
    return stripped;
  }
  return stripped.charAt(0).toUpperCase() + stripped.slice(1);
};

/* Audio handling left the captioning lane with v0.3.0: the omni audio slices
(hallucination-prone, see buildCaptionPrompt) were replaced by a
faster-whisper transcript stored separately under `video-transcripts-v1`. */
