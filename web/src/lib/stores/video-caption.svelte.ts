import { CancellableTask } from '#lib/utils/cancellable-task.ts';
import { getAssetMetadataByKey } from '@immich/sdk';

const VIDEO_CAPTIONS_KEY = 'video-captions-v1';

export type VideoCaptionSegment = {
  startMs: number;
  endMs: number;
  caption: string;
};

export type VideoCaptionRun = {
  model: string;
  servedModel?: string;
  promptVersion: string;
  status: 'queued' | 'running' | 'completed' | 'failed';
  trigger: 'manual';
  requestedAt: string;
  startedAt?: string;
  finishedAt?: string;
  durationMs?: number;
  truncated?: boolean;
  segments: VideoCaptionSegment[];
  error?: { code: string; message: string };
};

type MetadataValue = { key: string; value: unknown } | undefined;

/** Loose parsing: the metadata value is a JSONB record, not SDK-typed. */
const parseRun = (value: unknown): VideoCaptionRun | null => {
  if (!value || typeof value !== 'object') {
    return null;
  }
  const runs = (value as { runs?: unknown }).runs;
  if (!runs || typeof runs !== 'object') {
    return null;
  }

  let latest: VideoCaptionRun | null = null;
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
          (segment): segment is VideoCaptionSegment =>
            !!segment &&
            typeof segment === 'object' &&
            typeof (segment as VideoCaptionSegment).startMs === 'number' &&
            typeof (segment as VideoCaptionSegment).endMs === 'number' &&
            typeof (segment as VideoCaptionSegment).caption === 'string',
        )
      : [];

    const parsed: VideoCaptionRun = {
      model: typeof run.model === 'string' ? run.model : '',
      servedModel: typeof run.servedModel === 'string' ? run.servedModel : undefined,
      promptVersion: typeof run.promptVersion === 'string' ? run.promptVersion : '',
      status: status as VideoCaptionRun['status'],
      trigger: 'manual',
      requestedAt: typeof run.requestedAt === 'string' ? run.requestedAt : '',
      startedAt: typeof run.startedAt === 'string' ? run.startedAt : undefined,
      finishedAt: typeof run.finishedAt === 'string' ? run.finishedAt : undefined,
      durationMs: typeof run.durationMs === 'number' ? run.durationMs : undefined,
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

class VideoCaptionManager {
  #run = $state<VideoCaptionRun | null>(null);
  showOverlay = $state(true);
  #loader = new CancellableTask();
  #cleared = false;

  get run() {
    return this.#run;
  }

  get segments(): VideoCaptionSegment[] {
    return this.#run?.segments ?? [];
  }

  get hasCaptions() {
    return this.segments.length > 0;
  }

  get status(): VideoCaptionRun['status'] | null {
    return this.#run?.status ?? null;
  }

  /** Segment covering the given playback time, if any. */
  segmentAt(timeMs: number): VideoCaptionSegment | undefined {
    return this.segments.find((segment) => timeMs >= segment.startMs && timeMs < segment.endMs);
  }

  async getAssetCaptions(id: string) {
    if (this.#cleared) {
      await this.#loader.reset();
      this.#cleared = false;
    }
    await this.#loader.execute(async () => {
      let value: MetadataValue;
      try {
        value = await getAssetMetadataByKey({ id, key: VIDEO_CAPTIONS_KEY });
      } catch {
        // No captions for this asset — not an error for the UI.
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

export const videoCaptionManager = new VideoCaptionManager();
