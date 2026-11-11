import { CancellableTask } from '#lib/utils/cancellable-task.ts';
import { getVideoFaces, type VideoFacesResponseDto } from '@immich/sdk';

/**
Video face identities + latest scan run for the asset currently open in the
viewer (`GET /assets/:id/video-faces`). Shared between the playback overlay
(time-indexed sighting boxes) and the sidebar strip, so both read one fetch.
Null when the video was never scanned (or on shared links, where the
owner-scoped endpoint is not reachable).
*/
class VideoFacesManager {
  #data = $state<VideoFacesResponseDto | null>(null);
  #loader = new CancellableTask();
  #cleared = false;

  get data() {
    return this.#data;
  }

  async getAssetVideoFaces(id: string) {
    if (this.#cleared) {
      await this.#loader.reset();
      this.#cleared = false;
    }
    await this.#loader.execute(async () => {
      try {
        this.#data = await getVideoFaces({ id });
      } catch {
        // asset was never scanned or endpoint unavailable — stays null and the
        // viewer falls back to the static published-face boxes
      }
    }, false);
  }

  clear() {
    this.#cleared = true;
    this.#data = null;
  }
}

export const videoFacesManager = new VideoFacesManager();
