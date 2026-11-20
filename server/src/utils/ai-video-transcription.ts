import { createHash } from 'node:crypto';
import type {
  AiVideoTranscriptionChunk,
  AiVideoTranscriptionCoverageInterval,
  AiVideoTranscriptionDocument,
  AiVideoTranscriptionRun,
} from 'src/dtos/ai-video-transcription.dto.js';
import type { VoiceIsolationEvidence } from 'src/utils/ai-audio-events.js';

/**
Experimental video transcription (faster-whisper CPU sidecar) — separate run
keying from captions and interpretation so the three features can evolve
(and be reverted) independently.
*/
export const AI_VIDEO_TRANSCRIPTION_PROMPT_VERSION = 'video-transcription-0.2.0';

/**
Producer pipeline version for the chunked full-duration producer: bumps when a
behavior-affecting implementation detail changes (chunking policy, overlap,
hallucination filtering). Part of the run identity alongside the model, so
re-running after a producer change never collides with older runs' keys.
*/
export const AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION = 'video-transcription-producer-1.0.0';

/** Coverage policy of the chunked producer: bounded chunks over the whole duration. */
export const AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY = 'chunked-full-duration-v1';

export const AI_VIDEO_TRANSCRIPTION_SERVICE = 'faster-whisper-sidecar';

/**
Gated second pass (experiment 2026-11-19): the same ASR over voice-isolated
audio, stored as its own run under this producer id. The raw-audio run keeps
its original identity, so adding this pass never invalidates existing runs.
*/
export const AI_VIDEO_TRANSCRIPTION_VOICE_ISOLATION = 'inworld-voice-isolator-v1';

/**
Gate thresholds, validated on the 22-clip bench (voice-isolator-bench/REPORT.md).
The first pass must look untrustworthy on at least one of these before the
isolator runs; running it on everything costs ~8x ASR compute for no gain on
the 7/22 clips that were already fine.
*/
export const VOICE_ISOLATION_GATE_MIN_LOG_PROB = -0.5;
export const VOICE_ISOLATION_GATE_MIN_LANGUAGE_PROB = 0.65;
/** YAMNet Speech peak must clear this when the first pass found no speech at all (music-only clips stay noSpeech). */
export const VOICE_ISOLATION_GATE_MIN_YAMNET_SPEECH = 0.8;
/**
Gate v2: a peak score alone is not enough. The union of speech-family spans
must be sustained, and music/singing must not dominate the audio (the scale run
turned sung lyrics into "recovered speech").
*/
export const VOICE_ISOLATION_GATE_MIN_SPEECH_MS = 600;
export const VOICE_ISOLATION_GATE_MUSIC_DOMINANCE_RATIO = 1;
/** A speech-led clip with a music bed still passes when speech covers 2× the minimum. */
export const VOICE_ISOLATION_GATE_MUSIC_DOMINANCE_BYPASS_FACTOR = 2;

/**
Acceptance of an isolated transcript. The bench produced two failure modes the
raw pass does not: whisper amplifying near-silent isolation residue into
semi-coherent nonsense (low log prob), and language drift on non-English clips
(confident English invented from an Indonesian video).
*/
export const VOICE_ISOLATION_ACCEPT_MIN_LOG_PROB = -0.7;
export const VOICE_ISOLATION_ACCEPT_MIN_LANGUAGE_PROB = 0.65;

export interface AiVideoTranscriptionProducerIdentity {
  model: string;
  producerVersion: string;
  /** Language hint used ('' = auto-detect). */
  language: string;
  coveragePolicy: string;
  /** Voice-isolator id for the gated second pass; empty = raw audio. */
  voiceIsolation?: string;
}

/**
Run identity hash over the full producer configuration. Legacy runs were keyed
by model + promptVersion only; those stored keys remain readable, but new runs
with a raised limit, changed language, or new producer version derive a fresh
key instead of being skipped by an older completed run.
*/
export const createVideoTranscriptionRunKey = (identity: AiVideoTranscriptionProducerIdentity): string =>
  createHash('sha256')
    .update(
      `${identity.model}\n${identity.producerVersion}\n${identity.language}\n${identity.coveragePolicy}` +
        // Appended only when set: every existing raw-audio run keeps its key.
        (identity.voiceIsolation ? `\n${identity.voiceIsolation}` : ''),
      'utf8',
    )
    .digest('hex');

/** Legacy pre-chunking run key (model + promptVersion only) for reading existing documents. */
export const createLegacyVideoTranscriptionRunKey = (model: string, promptVersion: string): string =>
  createHash('sha256').update(`${model}\n${promptVersion}`, 'utf8').digest('hex');

/**
Content revision over the transcript itself (segments + terminal outcome
flags). A runKey is reused across retries; this hash changes whenever the
stored transcript content changes, and indexed search data keys off it.
*/
export const createTranscriptionRevision = (
  run: Pick<AiVideoTranscriptionRun, 'segments' | 'noAudio' | 'noSpeech'>,
): string =>
  createHash('sha256')
    .update(
      JSON.stringify({
        segments: run.segments.map(({ startMs, endMs, text }) => [startMs, endMs, text]),
        noAudio: run.noAudio === true,
        noSpeech: run.noSpeech === true,
      }),
    )
    .digest('hex');

/**
Noise-hallucination guard: faster-whisper on reverberant/near-silent audio
fluently invents text (the classic "Terima kasih telah menonton" YouTube-ism).
The sidecar owns the full filter (stock phrases, short low-confidence
fragments, repetition); this coarse server-side check still drops a segment
that fails both its speech probability and average confidence, e.g. when an
older sidecar returns raw metrics.
*/
export const isTranscriptionSegmentAudible = (segment: { noSpeechProb?: number; avgLogProb?: number }): boolean => {
  const noSpeechProb = segment.noSpeechProb ?? 0;
  const avgLogProb = segment.avgLogProb ?? 0;
  return !(noSpeechProb > 0.6 && avgLogProb < -1);
};

/** Evidence the isolation gate decides on, all from the raw-audio run. */
export interface VoiceIsolationGateInput {
  noSpeech: boolean;
  meanAvgLogProb?: number;
  languageProbability?: number;
  /** Sustained speech/music evidence from the latest completed audio-event run. */
  evidence: VoiceIsolationEvidence;
  /** Rollout knobs; omitted values use the code defaults. */
  thresholds?: Partial<VoiceIsolationGateThresholds>;
}

export interface VoiceIsolationGateThresholds {
  /** Peak generic-Speech score required for an empty transcript. */
  minSpeechScore: number;
  /** Sustained speech required for an empty transcript. */
  minSpeechMs: number;
  /** Speech duration must be at least this multiple of music duration. */
  musicDominanceRatio: number;
  musicExclusion: boolean;
}

/** Telemetry labels: one decision per evaluated raw run. */
export type VoiceIsolationGateReason = 'trustworthy' | 'no-speech-evidence' | 'music-excluded' | 'scheduled';

/**
Gate v2 decision over the evidence summary.

- A confident transcript is left alone (the 7/22 neutral clips).
- An empty transcript needs a Speech peak *and* sustained speech evidence, so
  one loud transient cannot open the gate.
- Music/singing dominance blocks the pass for both empty and untrustworthy
  non-empty runs (sung lyrics enter through both paths); speech at 2× the
  configured minimum still wins over a background music bed.
*/
export const evaluateVoiceIsolationGate = (
  input: VoiceIsolationGateInput,
): { isolate: boolean; reason: VoiceIsolationGateReason } => {
  const thresholds: VoiceIsolationGateThresholds = {
    minSpeechScore: VOICE_ISOLATION_GATE_MIN_YAMNET_SPEECH,
    minSpeechMs: VOICE_ISOLATION_GATE_MIN_SPEECH_MS,
    musicDominanceRatio: VOICE_ISOLATION_GATE_MUSIC_DOMINANCE_RATIO,
    musicExclusion: true,
    ...input.thresholds,
  };

  const confident =
    !input.noSpeech &&
    (input.meanAvgLogProb === undefined || input.meanAvgLogProb >= VOICE_ISOLATION_GATE_MIN_LOG_PROB) &&
    (input.languageProbability === undefined || input.languageProbability >= VOICE_ISOLATION_GATE_MIN_LANGUAGE_PROB);
  if (confident) {
    return { isolate: false, reason: 'trustworthy' };
  }

  const { speechMs, speechPeak, musicMs } = input.evidence;
  if (input.noSpeech && (speechPeak < thresholds.minSpeechScore || speechMs < thresholds.minSpeechMs)) {
    return { isolate: false, reason: 'no-speech-evidence' };
  }

  if (thresholds.musicExclusion && musicMs > 0) {
    const speechLeads =
      speechMs >= musicMs * thresholds.musicDominanceRatio ||
      speechMs >= thresholds.minSpeechMs * VOICE_ISOLATION_GATE_MUSIC_DOMINANCE_BYPASS_FACTOR;
    if (!speechLeads) {
      return { isolate: false, reason: 'music-excluded' };
    }
  }

  return { isolate: true, reason: 'scheduled' };
};

export const shouldIsolateVoice = (input: VoiceIsolationGateInput): boolean =>
  evaluateVoiceIsolationGate(input).isolate;

/** May this isolated transcript replace the raw-audio one downstream? */
export interface IsolatedTranscriptAcceptance {
  segments: number;
  meanAvgLogProb?: number;
  languageProbability?: number;
  language?: string;
  /** Language of the raw-audio run that triggered the pass. */
  baselineLanguage?: string;
  baselineLanguageProbability?: number;
}

export const acceptsIsolatedTranscript = (input: IsolatedTranscriptAcceptance): boolean => {
  if (input.segments === 0) {
    return false;
  }
  if (input.meanAvgLogProb !== undefined && input.meanAvgLogProb < VOICE_ISOLATION_ACCEPT_MIN_LOG_PROB) {
    return false;
  }
  if (input.languageProbability !== undefined && input.languageProbability < VOICE_ISOLATION_ACCEPT_MIN_LANGUAGE_PROB) {
    return false;
  }
  // A source language the raw pass was confident about must not change under
  // isolation (the pt->en drift observed on an Indonesian clip); a weak raw
  // detection carries no such authority.
  if (
    input.baselineLanguage &&
    (input.baselineLanguageProbability ?? 0) >= VOICE_ISOLATION_ACCEPT_MIN_LANGUAGE_PROB &&
    input.language &&
    input.language !== input.baselineLanguage
  ) {
    return false;
  }
  return true;
};

/**
The transcript downstream consumers (interpretation, search index) should see:
the newest completed raw-audio run, or a newer *accepted* isolated run. An
unaccepted isolated run stays in the document as audit evidence only. With the
kill switch off, accepted runs stay stored but raw audio wins again.
*/
export const selectEffectiveCompletedRun = (
  document: AiVideoTranscriptionDocument,
  options: { voiceIsolationEnabled?: boolean } = {},
): AiVideoTranscriptionRun | null => {
  const voiceIsolationEnabled = options.voiceIsolationEnabled ?? true;
  const completed = Object.values(document.runs).filter((run) => run.status === 'completed');
  if (completed.length === 0) {
    return null;
  }
  const newest = (a: AiVideoTranscriptionRun, b: AiVideoTranscriptionRun) =>
    (b.finishedAt ?? b.requestedAt) > (a.finishedAt ?? a.requestedAt) ? 1 : -1;
  for (const run of completed.sort(newest)) {
    if (run.producer?.voiceIsolation) {
      if (voiceIsolationEnabled && run.voiceIsolation?.accepted === true) {
        return run;
      }
      continue;
    }
    return run;
  }
  // Only rejected isolated runs exist (should not happen: the raw run that
  // triggered them always completes first); newest is the least surprising.
  return completed[0] ?? null;
};

/**
Contiguous, non-overlapping responsibility ranges for bounded chunked
extraction: chunk k owns [k*chunkMs, min((k+1)*chunkMs, targetDurationMs)).
Extraction windows are padded with the overlap separately; a segment belongs
to the chunk whose responsibility range contains its absolute start.
*/
export const buildTranscriptionChunkPlan = (
  targetDurationMs: number,
  chunkSec: number,
): AiVideoTranscriptionChunk[] => {
  if (!Number.isFinite(targetDurationMs) || targetDurationMs <= 0) {
    throw new Error(`Invalid transcription target duration: ${targetDurationMs}`);
  }
  const chunkMs = Math.max(1000, Math.round(chunkSec * 1000));
  const chunks: AiVideoTranscriptionChunk[] = [];
  for (let startMs = 0; startMs < targetDurationMs; startMs += chunkMs) {
    chunks.push({
      index: chunks.length,
      startMs,
      endMs: Math.min(startMs + chunkMs, targetDurationMs),
      status: 'pending',
    });
  }
  return chunks;
};

/**
Honest coverage states for a transcription run. A completed run counts as
`complete` only when recorded coverage intervals span its target duration —
legacy documents without that evidence stay `partial` (usable for search, but
not proof of full-duration coverage).
*/
export type AiVideoTranscriptionCoverageState =
  'missing' | 'queued' | 'running' | 'failed' | 'partial' | 'complete' | 'no-audio' | 'no-speech';

/** Union of intervals as sorted, non-overlapping [start, end] pairs. */
export const mergeCoverageIntervals = (
  intervals: readonly AiVideoTranscriptionCoverageInterval[],
): Array<{ startMs: number; endMs: number }> => {
  const sorted = intervals.map(({ startMs, endMs }) => ({ startMs, endMs })).sort((a, b) => a.startMs - b.startMs);
  const merged: Array<{ startMs: number; endMs: number }> = [];
  for (const interval of sorted) {
    const last = merged.at(-1);
    if (last && interval.startMs <= last.endMs) {
      last.endMs = Math.max(last.endMs, interval.endMs);
    } else {
      merged.push({ ...interval });
    }
  }
  return merged;
};

/** True when the union of intervals spans [0, targetMs] (within tolerance). */
export const coversTranscriptionCoverage = (
  intervals: readonly AiVideoTranscriptionCoverageInterval[],
  targetMs: number,
  toleranceMs = 1000,
): boolean => {
  if (!Number.isFinite(targetMs) || targetMs <= 0) {
    return false;
  }
  let coveredEnd = 0;
  for (const { startMs, endMs } of mergeCoverageIntervals(intervals)) {
    if (startMs > coveredEnd + toleranceMs) {
      return false;
    }
    coveredEnd = Math.max(coveredEnd, endMs);
    if (coveredEnd >= targetMs - toleranceMs) {
      return true;
    }
  }
  return coveredEnd >= targetMs - toleranceMs;
};

export const classifyTranscriptionRun = (
  run: AiVideoTranscriptionRun | null | undefined,
): AiVideoTranscriptionCoverageState => {
  if (!run) {
    return 'missing';
  }
  if (run.status === 'queued') {
    return 'queued';
  }
  if (run.status === 'running') {
    return 'running';
  }
  if (run.status === 'failed') {
    return 'failed';
  }
  if (run.noAudio) {
    return 'no-audio';
  }
  if (run.noSpeech) {
    return 'no-speech';
  }
  if (run.truncated) {
    return 'partial';
  }
  if (run.coverage && run.targetDurationMs !== undefined) {
    return coversTranscriptionCoverage(run.coverage.intervals, run.targetDurationMs) ? 'complete' : 'partial';
  }
  // Completed legacy run without coverage evidence: it can serve search, but
  // it has not proven full-duration coverage.
  return 'partial';
};

/**
True when the run is either finished (usable work) or actively owned by a
producer with a live lease. A running run whose lease is missing or expired is
abandoned work that a new claim may reclaim.
*/
export const isRunActive = (run: AiVideoTranscriptionRun, now = new Date()): boolean =>
  run.status === 'completed' ||
  run.status === 'queued' ||
  (run.status === 'running' && run.lease !== undefined && Date.parse(run.lease.expiresAt) > now.getTime());

export type LegacyTranscriptionAssessment =
  | { verdict: 'reuse'; reason: 'full-coverage' | 'no-speech' }
  | { verdict: 'schedule'; reason: 'truncated' | 'missing-coverage' | 'unverified-no-audio' };

/**
Decide whether a legacy (pre-chunking, whole-file producer) run satisfies the
current full-duration coverage requirement.

- The legacy `truncated` flag was evaluated per-run with the cap in effect at
  the time, so a completed run without it covered the entire video: trustworthy
  full coverage, reused as-is.
- `noSpeech` was only ever set from a successful sidecar response (decode +
  VAD found no speech): terminal and trustworthy.
- `noAudio` is NOT trustworthy: the legacy producer also recorded extraction
  failures as no-audio. Re-verification is a cheap probe (no inference) — the
  chunked producer's normal flow does exactly that and records an honest,
  probe-verified terminal outcome.
- A truncated run stays usable for partial search but gets a full-duration
  chunked run scheduled over it.
*/
export const assessLegacyTranscriptionRun = (run: AiVideoTranscriptionRun): LegacyTranscriptionAssessment => {
  if (run.status !== 'completed') {
    return { verdict: 'schedule', reason: 'missing-coverage' };
  }
  if (run.noAudio) {
    return { verdict: 'schedule', reason: 'unverified-no-audio' };
  }
  if (run.noSpeech) {
    return { verdict: 'reuse', reason: 'no-speech' };
  }
  if (run.truncated) {
    return { verdict: 'schedule', reason: 'truncated' };
  }
  return { verdict: 'reuse', reason: 'full-coverage' };
};
