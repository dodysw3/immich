import { CancellableTask } from '#lib/utils/cancellable-task.ts';
import { getAssetMetadataByKey } from '@immich/sdk';

const VIDEO_TRANSCRIPTS_KEY = 'video-transcripts-v1';

export type VideoTranscriptSegment = {
  startMs: number;
  endMs: number;
  text: string;
};

export type VideoTranscriptRun = {
  model: string;
  promptVersion: string;
  status: 'queued' | 'running' | 'completed' | 'failed';
  trigger: 'manual' | 'auto-interpret';
  requestedAt: string;
  startedAt?: string;
  finishedAt?: string;
  language?: string;
  noAudio?: boolean;
  truncated?: boolean;
  segments: VideoTranscriptSegment[];
  error?: { code: string; message: string };
};

type MetadataValue = { key: string; value: unknown } | undefined;

/** Loose parsing: the metadata value is a JSONB record, not SDK-typed. */
const parseRun = (value: unknown): VideoTranscriptRun | null => {
  if (!value || typeof value !== 'object') {
    return null;
  }
  const runs = (value as { runs?: unknown }).runs;
  if (!runs || typeof runs !== 'object') {
    return null;
  }

  let latest: VideoTranscriptRun | null = null;
  for (const candidate of Object.values(runs as Record<string, unknown>)) {
    if (!candidate || typeof candidate !== 'object') {
      continue;
    }
    const run = candidate as Record<string, unknown>;
    const status = run.status;
    if (typeof status !== 'string' || !['queued', 'running', 'completed', 'failed'].includes(status)) {
      continue;
    }
    const segments = Array.isArray(run.segments)
      ? run.segments.filter(
          (segment): segment is VideoTranscriptSegment =>
            !!segment &&
            typeof segment === 'object' &&
            typeof (segment as VideoTranscriptSegment).startMs === 'number' &&
            typeof (segment as VideoTranscriptSegment).endMs === 'number' &&
            typeof (segment as VideoTranscriptSegment).text === 'string',
        )
      : [];

    const parsed: VideoTranscriptRun = {
      model: typeof run.model === 'string' ? run.model : '',
      promptVersion: typeof run.promptVersion === 'string' ? run.promptVersion : '',
      status: status as VideoTranscriptRun['status'],
      trigger: run.trigger === 'manual' ? 'manual' : 'auto-interpret',
      requestedAt: typeof run.requestedAt === 'string' ? run.requestedAt : '',
      startedAt: typeof run.startedAt === 'string' ? run.startedAt : undefined,
      finishedAt: typeof run.finishedAt === 'string' ? run.finishedAt : undefined,
      language: typeof run.language === 'string' ? run.language : undefined,
      noAudio: run.noAudio === true,
      truncated: run.truncated === true,
      segments,
      error:
        run.error && typeof run.error === 'object'
          ? {
              code: String((run.error as Record<string, unknown>).code ?? 'unknown'),
              message: String((run.error as Record<string, unknown>).message ?? ''),
            }
          : undefined,
    };
    if (!latest || parsed.requestedAt > latest.requestedAt) {
      latest = parsed;
    }
  }
  return latest;
};

class VideoTranscriptManager {
  #run = $state<VideoTranscriptRun | null>(null);
  showOverlay = $state(true);
  #loader = new CancellableTask();
  #cleared = false;

  get run() {
    return this.#run;
  }

  get segments(): VideoTranscriptSegment[] {
    return this.#run?.segments ?? [];
  }

  get hasTranscript() {
    return this.segments.length > 0;
  }

  get status(): VideoTranscriptRun['status'] | null {
    return this.#run?.status ?? null;
  }

  /** Segment covering the given playback time, if any. */
  segmentAt(timeMs: number): VideoTranscriptSegment | undefined {
    return this.segments.find((segment) => timeMs >= segment.startMs && timeMs < segment.endMs);
  }

  async getAssetTranscripts(id: string) {
    if (this.#cleared) {
      await this.#loader.reset();
      this.#cleared = false;
    }
    await this.#loader.execute(async () => {
      let value: MetadataValue;
      try {
        value = await getAssetMetadataByKey({ id, key: VIDEO_TRANSCRIPTS_KEY });
      } catch {
        // No transcript for this asset — not an error for the UI.
        value = undefined;
      }
      this.#run = value ? parseRun(value.value) : null;
    }, false);
  }

  clear() {
    this.#cleared = true;
    this.#run = null;
  }

  toggleOverlay() {
    this.showOverlay = !this.showOverlay;
  }
}

export const videoTranscriptManager = new VideoTranscriptManager();
