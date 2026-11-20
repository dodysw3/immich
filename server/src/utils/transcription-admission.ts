export const LIVE_VIDEO_TRANSCRIPTION_PRIORITY = 2;

/** Internal control flow: this is neither a failed pass nor a failed BullMQ attempt. */
export class TranscriptionDeferred extends Error {
  constructor(readonly reason: 'live_waiting' | 'gpu_capacity') {
    super(reason);
    this.name = TranscriptionDeferred.name;
  }
}

/** Yield to a runnable upload promptly; spread pressure retries with capped jitter. */
export const transcriptionDeferralDelay = (
  reason: TranscriptionDeferred['reason'],
  attemptsStarted: number,
  random = Math.random(),
): number => {
  if (reason === 'live_waiting') {
    return 250 + Math.round(250 * random);
  }
  const ceiling = Math.min(30_000, 1000 * 2 ** Math.min(5, Math.max(0, attemptsStarted - 1)));
  return Math.round(ceiling * (0.5 + 0.5 * random));
};
