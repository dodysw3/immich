import { createHash } from 'node:crypto';
import { AUDIO_EVENT_PHRASES } from 'src/constants/audio-event-phrases.js';
import { AUDIOSET_CLASS_MAP } from 'src/constants/audioset-class-map.js';
import type { AiAudioEvent } from 'src/dtos/ai-audio-events.dto.js';

/**
Video audio-events lane (YAMNet tagging sidecar) — run keying separate from
captions, transcripts, and interpretation, like the transcription lane. The
assembly policy below (merge gap, minimum span, cap, speech family, excluded
classes) is part of the run identity through this version: changing any of it
means bumping the version, which forks a new run and keeps the old ones.
*/
export const AI_AUDIO_EVENTS_PROMPT_VERSION = 'video-audio-events-0.1.0';
/** Pinned tagger: the server-side class map (constants/audioset-class-map.ts) matches only this model. */
export const AI_AUDIO_EVENTS_MODEL = 'yamnet';

export const createAudioEventsRunKey = (model: string, config: { threshold: number }, promptVersion: string): string =>
  createHash('sha256').update(`${model}\nthreshold=${config.threshold}\n${promptVersion}`, 'utf8').digest('hex');

/** Same-class spans separated by at most this much silence merge into one event. */
export const AUDIO_EVENTS_MERGE_GAP_MS = 600;
export const AUDIO_EVENTS_MIN_SPAN_MS = 300;
export const AUDIO_EVENTS_MAX_EVENTS = 20;

/**
The AudioSet "Speech" subtree. Words are the whisper transcript's job, so
these events are dropped when the transcript has segments; without a
transcript they stay as evidence that someone is vocalizing (a baby
babbling off-camera reads as "Child speech").
*/
const AUDIO_EVENTS_SPEECH_MIDS: ReadonlySet<string> = new Set([
  '/m/09x0r', // Speech
  '/m/0ytgt', // Child speech, kid speaking
  '/m/01h8n0', // Conversation
  '/m/02qldy', // Narration, monologue
  '/m/0261r1', // Babbling
  '/m/0brhx', // Speech synthesizer
]);

/**
Classes that describe the recording rather than something that happened:
silence (a silent video stores an empty run), the AudioSet "Acoustic
environment" and "Noise" families, and the "Field recording" meta tag. On the
2026-11-10 gate they only added lines like "Inside, small room" (car) and
"Pink noise" (river roar). Television/Radio stay: they name a sound source.
*/
const AUDIO_EVENTS_EXCLUDED_MIDS: ReadonlySet<string> = new Set([
  '/m/028v0c', // Silence
  '/t/dd00125', // Inside, small room
  '/t/dd00126', // Inside, large room or hall
  '/t/dd00127', // Inside, public space
  '/t/dd00128', // Outside, urban or manmade
  '/t/dd00129', // Outside, rural or natural
  '/m/01b9nn', // Reverberation
  '/m/01jnbd', // Echo
  '/m/096m7z', // Noise
  '/m/06_y0by', // Environmental noise
  '/m/07rgkc5', // Static
  '/m/06xkwv', // Mains hum
  '/m/0g12c5', // Distortion
  '/m/08p9q4', // Sidetone
  '/m/07szfh9', // Cacophony
  '/m/0chx_', // White noise
  '/m/0cj0r', // Pink noise
  '/m/07p_0gm', // Throbbing
  '/m/01jwx6', // Vibration
  '/m/07hvw1', // Field recording
]);

export const isSpeechFamilyAudioEvent = (event: { mid: string }): boolean => AUDIO_EVENTS_SPEECH_MIDS.has(event.mid);

/** One sidecar frame: `t` is the frame center in ms, hits are the frame's top classes. */
export type AudioTagFrame = { t: number; hits: Array<{ classIndex: number; score: number }> };

export interface AudioEventsAssemblyOptions {
  /** Minimum frame score for a class to count. */
  threshold: number;
  /** Frame window reported by the sidecar: a frame centered at t covers [t - windowMs/2, t + windowMs/2]. */
  windowMs: number;
  /** Tagged audio length; spans are clamped to it (the model zero-pads the last frame past the end). */
  durationMs: number;
  /** Drop speech-family events — set when the transcript already carries the words. */
  suppressSpeech: boolean;
}

/**
Frames → events: per class, keep frames scoring at or above the threshold,
merge them into spans over their real frame windows (a single 0.96 s frame is
a valid event — the bench's car beep is exactly one frame), bridge gaps up to
AUDIO_EVENTS_MERGE_GAP_MS, drop spans shorter than AUDIO_EVENTS_MIN_SPAN_MS,
apply speech suppression, then keep the AUDIO_EVENTS_MAX_EVENTS strongest
spans in time order. Speech is dropped before the cap so suppressed events
never take a slot from a real sound.
*/
export const assembleAudioEvents = (
  frames: AudioTagFrame[],
  options: AudioEventsAssemblyOptions,
): { events: AiAudioEvent[]; speechSuppressed: boolean } => {
  const halfWindowMs = options.windowMs / 2;
  const spansByClass = new Map<number, Array<{ startMs: number; endMs: number; score: number }>>();

  for (const frame of [...frames].sort((a, b) => a.t - b.t)) {
    const startMs = Math.max(0, Math.round(frame.t - halfWindowMs));
    const endMs = Math.min(options.durationMs, Math.round(frame.t + halfWindowMs));
    if (endMs <= startMs) {
      continue;
    }

    for (const hit of frame.hits) {
      const entry = AUDIOSET_CLASS_MAP[hit.classIndex];
      if (hit.score < options.threshold || !entry || AUDIO_EVENTS_EXCLUDED_MIDS.has(entry.mid)) {
        continue;
      }

      const spans = spansByClass.get(hit.classIndex) ?? [];
      const last = spans.at(-1);
      if (last && startMs - last.endMs <= AUDIO_EVENTS_MERGE_GAP_MS) {
        last.endMs = Math.max(last.endMs, endMs);
        last.score = Math.max(last.score, hit.score);
      } else {
        spans.push({ startMs, endMs, score: hit.score });
      }
      spansByClass.set(hit.classIndex, spans);
    }
  }

  let speechSuppressed = false;
  const events: AiAudioEvent[] = [];
  for (const [classIndex, spans] of spansByClass) {
    const { mid, label } = AUDIOSET_CLASS_MAP[classIndex];
    for (const span of spans) {
      if (span.endMs - span.startMs < AUDIO_EVENTS_MIN_SPAN_MS) {
        continue;
      }
      if (options.suppressSpeech && AUDIO_EVENTS_SPEECH_MIDS.has(mid)) {
        speechSuppressed = true;
        continue;
      }
      events.push({
        mid,
        label,
        score: Math.round(span.score * 1000) / 1000,
        startMs: span.startMs,
        endMs: span.endMs,
      });
    }
  }

  const strongest = events.sort((a, b) => b.score - a.score || a.startMs - b.startMs).slice(0, AUDIO_EVENTS_MAX_EVENTS);
  return {
    events: strongest.sort((a, b) => a.startMs - b.startMs || b.score - a.score),
    speechSuppressed,
  };
};

/** Prompt lines of one sentence bridge gaps up to this much (stored events keep the fine 0.6 s structure). */
export const AUDIO_EVENTS_RENDER_MERGE_GAP_MS = 2000;
export const AUDIO_EVENTS_RENDER_MAX_PER_SENTENCE = 2;
export const AUDIO_EVENTS_RENDER_MAX_LINES = 12;
/**
A voice event only reaches the prompt on strong tagger evidence: it is
rendered when whisper found no words, i.e. it contradicts the transcript
lane's own VAD (river noise scores "Speech" ~0.45-0.5; a real child's voice
0.86+).
*/
export const AUDIO_EVENTS_RENDER_SPEECH_MIN_SCORE = 0.6;

export type AudioEventSentence = { startMs: number; endMs: number; sentence: string };

const audioEventSentence = (event: Pick<AiAudioEvent, 'mid' | 'label'>): string =>
  AUDIO_EVENT_PHRASES[event.mid] ?? `A sound like ${event.label.split(',', 1)[0].toLowerCase()} is heard.`;

/**
Stored events → prompt lines. The interpretation model ignored telegraph rows
("Sound of Beep, bleep.") on the 2026-11-10 gate, so each event becomes a
natural sentence; sibling classes that share a sentence (Water / Ocean /
Waves / Stream / Waterfall all fire on a river) merge into one line over their
joint window, at most AUDIO_EVENTS_RENDER_MAX_PER_SENTENCE lines per sentence
and AUDIO_EVENTS_RENDER_MAX_LINES overall (strongest first), in time order.
Voice events are dropped when the transcript carries the words and need
AUDIO_EVENTS_RENDER_SPEECH_MIN_SCORE otherwise.
*/
export const renderAudioEventSentences = (
  events: AiAudioEvent[],
  options: { transcriptHasWords: boolean },
): AudioEventSentence[] => {
  const spansBySentence = new Map<string, Array<{ startMs: number; endMs: number; score: number }>>();
  for (const event of events.toSorted((a, b) => a.startMs - b.startMs)) {
    if (
      isSpeechFamilyAudioEvent(event) &&
      (options.transcriptHasWords || event.score < AUDIO_EVENTS_RENDER_SPEECH_MIN_SCORE)
    ) {
      continue;
    }

    const sentence = audioEventSentence(event);
    const spans = spansBySentence.get(sentence) ?? [];
    const last = spans.at(-1);
    if (last && event.startMs - last.endMs <= AUDIO_EVENTS_RENDER_MERGE_GAP_MS) {
      last.endMs = Math.max(last.endMs, event.endMs);
      last.score = Math.max(last.score, event.score);
    } else {
      spans.push({ startMs: event.startMs, endMs: event.endMs, score: event.score });
    }
    spansBySentence.set(sentence, spans);
  }

  const lines: Array<AudioEventSentence & { score: number }> = [];
  for (const [sentence, spans] of spansBySentence) {
    const strongest = spans.toSorted((a, b) => b.score - a.score).slice(0, AUDIO_EVENTS_RENDER_MAX_PER_SENTENCE);
    lines.push(...strongest.map((span) => ({ ...span, sentence })));
  }

  return lines
    .toSorted((a, b) => b.score - a.score || a.startMs - b.startMs)
    .slice(0, AUDIO_EVENTS_RENDER_MAX_LINES)
    .toSorted((a, b) => a.startMs - b.startMs || b.score - a.score)
    .map(({ startMs, endMs, sentence }) => ({ startMs, endMs, sentence }));
};
