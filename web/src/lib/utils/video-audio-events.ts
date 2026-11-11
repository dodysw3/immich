/**
YAMNet sound events stored by the server in asset_metadata
`video-audio-events-v1`, read back for the viewer's sound-tag overlay. The
metadata value is a JSONB record, not SDK-typed, so parsing stays loose and
skips anything malformed instead of throwing.
*/

export type VideoAudioEvent = {
  /** AudioSet display name, e.g. "Beep, bleep". */
  label: string;
  /** Highest frame score inside the span (0-1). */
  score: number;
  startMs: number;
  endMs: number;
};

export type VideoAudioEventsRun = {
  status: 'completed';
  requestedAt: string;
  finishedAt?: string;
  events: VideoAudioEvent[];
};

/** Simultaneous tags beyond this are dropped (weakest first) to keep the row readable. */
export const MAX_VISIBLE_SOUND_TAGS = 3;

const isEvent = (value: unknown): value is VideoAudioEvent => {
  if (!value || typeof value !== 'object') {
    return false;
  }
  const event = value as Record<string, unknown>;
  return (
    typeof event.label === 'string' &&
    event.label.length > 0 &&
    typeof event.score === 'number' &&
    typeof event.startMs === 'number' &&
    typeof event.endMs === 'number' &&
    event.endMs > event.startMs
  );
};

/**
The latest COMPLETED run: unlike the transcript overlay, a newer failed or
in-flight retag must not hide events an older run already found.
*/
export const parseLatestCompletedAudioEventsRun = (value: unknown): VideoAudioEventsRun | null => {
  const runs = value && typeof value === 'object' ? (value as { runs?: unknown }).runs : undefined;
  if (!runs || typeof runs !== 'object') {
    return null;
  }

  let latest: VideoAudioEventsRun | null = null;
  for (const candidate of Object.values(runs as Record<string, unknown>)) {
    if (!candidate || typeof candidate !== 'object') {
      continue;
    }
    const run = candidate as Record<string, unknown>;
    if (run.status !== 'completed') {
      continue;
    }
    const parsed: VideoAudioEventsRun = {
      status: 'completed',
      requestedAt: typeof run.requestedAt === 'string' ? run.requestedAt : '',
      finishedAt: typeof run.finishedAt === 'string' ? run.finishedAt : undefined,
      events: Array.isArray(run.events)
        ? run.events
            .filter((event) => isEvent(event))
            .map(({ label, score, startMs, endMs }) => ({
              label,
              score,
              startMs,
              endMs,
            }))
        : [],
    };
    const finished = parsed.finishedAt ?? parsed.requestedAt;
    if (!latest || finished > (latest.finishedAt ?? latest.requestedAt)) {
      latest = parsed;
    }
  }
  return latest;
};

/** Events covering the playback time, strongest first, at most MAX_VISIBLE_SOUND_TAGS. */
export const getAudioEventsAt = (events: VideoAudioEvent[], timeMs: number): VideoAudioEvent[] =>
  // filter() returns a fresh array, so sorting it never reorders the caller's
  events
    .filter((event) => timeMs >= event.startMs && timeMs < event.endMs)
    .sort((a, b) => b.score - a.score || a.startMs - b.startMs)
    .slice(0, MAX_VISIBLE_SOUND_TAGS);

/** Closed-caption style sound tag, e.g. "[Beep, bleep]". */
export const formatSoundTag = (event: Pick<VideoAudioEvent, 'label'>): string => `[${event.label}]`;
