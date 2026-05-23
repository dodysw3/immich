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
