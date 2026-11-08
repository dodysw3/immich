import { createHash } from 'node:crypto';

/**
Experimental video transcription (faster-whisper CPU sidecar) — separate run
keying from captions and interpretation so the three features can evolve
(and be reverted) independently.
*/
export const AI_VIDEO_TRANSCRIPTION_PROMPT_VERSION = 'video-transcription-0.2.0';

export const createVideoTranscriptionRunKey = (model: string, promptVersion: string): string =>
  createHash('sha256').update(`${model}\n${promptVersion}`, 'utf8').digest('hex');

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
