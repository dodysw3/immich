import { CancellableTask } from '#lib/utils/cancellable-task.ts';
import {
  getAudioEventsAt,
  parseLatestCompletedAudioEventsRun,
  type VideoAudioEvent,
  type VideoAudioEventsRun,
} from '#lib/utils/video-audio-events.ts';
import { getAssetMetadataByKey } from '@immich/sdk';

const VIDEO_AUDIO_EVENTS_KEY = 'video-audio-events-v1';

type MetadataValue = { key: string; value: unknown } | undefined;

class VideoAudioEventsManager {
  #run = $state<VideoAudioEventsRun | null>(null);
  showOverlay = $state(true);
  #loader = new CancellableTask();
  #cleared = false;

  get events(): VideoAudioEvent[] {
    return this.#run?.events ?? [];
  }

  get hasEvents() {
    return this.events.length > 0;
  }

  /** Sound tags to show at the given playback time (strongest first, capped). */
  eventsAt(timeMs: number): VideoAudioEvent[] {
    return getAudioEventsAt(this.events, timeMs);
  }

  async getAssetAudioEvents(id: string) {
    if (this.#cleared) {
      await this.#loader.reset();
      this.#cleared = false;
    }
    await this.#loader.execute(async () => {
      let value: MetadataValue;
      try {
        value = await getAssetMetadataByKey({ id, key: VIDEO_AUDIO_EVENTS_KEY });
      } catch {
        // No sound events for this asset — not an error for the UI.
        value = undefined;
      }
      this.#run = value ? parseLatestCompletedAudioEventsRun(value.value) : null;
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

export const videoAudioEventsManager = new VideoAudioEventsManager();
