import { createHash } from 'node:crypto';
import type {
  AiVideoTranscriptionChunk,
  AiVideoTranscriptionCoverageInterval,
  AiVideoTranscriptionRun,
} from 'src/dtos/ai-video-transcription.dto.js';

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

export interface AiVideoTranscriptionProducerIdentity {
  model: string;
  producerVersion: string;
  /** Language hint used ('' = auto-detect). */
  language: string;
  coveragePolicy: string;
}

/**
Run identity hash over the full producer configuration. Legacy runs were keyed
by model + promptVersion only; those stored keys remain readable, but new runs
with a raised limit, changed language, or new producer version derive a fresh
key instead of being skipped by an older completed run.
*/
export const createVideoTranscriptionRunKey = (identity: AiVideoTranscriptionProducerIdentity): string =>
  createHash('sha256')
    .update(`${identity.model}\n${identity.producerVersion}\n${identity.language}\n${identity.coveragePolicy}`, 'utf8')
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
