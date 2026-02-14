import type { AssetFaceWithoutPersonResponseDto, AssetResponseDto } from '@immich/sdk';

export type FaceOverlayData = AssetFaceWithoutPersonResponseDto & {
  personId?: string;
  personName?: string;
};

class FaceOverlayStore {
  #data = $state<FaceOverlayData[]>([]);
  showOverlay = $state(false);
  #hasFaceData = $derived(this.#data.length > 0);

  get data() {
    return this.#data;
  }

  get hasFaceData() {
    return this.#hasFaceData;
  }

  loadFromAsset(asset: AssetResponseDto) {
    const faceData: FaceOverlayData[] = [];

    if (asset.people) {
      for (const person of asset.people) {
        for (const face of person.faces) {
          faceData.push({
            ...face,
            personId: person.id,
            personName: person.name,
          });
        }
      }
    }

    if (asset.unassignedFaces) {
      for (const face of asset.unassignedFaces) {
        faceData.push(face);
      }
    }

    this.#data = faceData;
  }

  clear() {
    this.#data = [];
    // Keep toggle state across asset navigation.
  }

  toggleOverlay() {
    this.showOverlay = !this.showOverlay;
  }
}

export const faceOverlayStore = new FaceOverlayStore();
