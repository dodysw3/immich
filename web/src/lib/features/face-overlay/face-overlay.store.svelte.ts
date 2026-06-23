export type FaceOverlayData = {
  id: string;
  imageWidth: number;
  imageHeight: number;
  boundingBoxX1: number;
  boundingBoxX2: number;
  boundingBoxY1: number;
  boundingBoxY2: number;
  personId?: string;
  personName?: string;
};

class FaceOverlayStore {
  showOverlay = $state(false);
  activeFaceId = $state<string | undefined>(undefined);

  clear() {
    this.activeFaceId = undefined;
  }

  toggleOverlay() {
    this.showOverlay = !this.showOverlay;
  }
}

export const faceOverlayStore = new FaceOverlayStore();
