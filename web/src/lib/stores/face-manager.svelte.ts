import type { AssetResponseDto, AssetFaceWithoutPersonResponseDto } from '@immich/sdk';

export type FaceBox = AssetFaceWithoutPersonResponseDto & {
  personName?: string;
};

class FaceManager {
  #data = $state<FaceBox[]>([]);

  get data() {
    return this.#data;
  }

  loadFromAsset(asset: AssetResponseDto) {
    const faceBoxes: FaceBox[] = [];

    // Add identified faces (with person names)
    if (asset.people) {
      for (const person of asset.people) {
        for (const face of person.faces) {
          faceBoxes.push({
            ...face,
            personName: person.name,
          });
        }
      }
    }

    // Add unassigned faces (without person names)
    if (asset.unassignedFaces) {
      for (const face of asset.unassignedFaces) {
        faceBoxes.push(face);
      }
    }

    this.#data = faceBoxes;
  }

  clear() {
    this.#data = [];
  }
}

export const faceManager = new FaceManager();
