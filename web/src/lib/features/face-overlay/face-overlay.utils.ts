import type { FaceOverlayData } from '$lib/features/face-overlay/face-overlay.store.svelte';
import type { ZoomImageWheelState } from '@zoom-image/core';

const getContainedSize = (img: HTMLImageElement): { width: number; height: number } => {
  const ratio = img.naturalWidth / img.naturalHeight;
  let width = img.height * ratio;
  let height = img.height;
  if (width > img.width) {
    width = img.width;
    height = img.width / ratio;
  }
  return { width, height };
};

export interface FaceOverlayBoundingBox {
  id: string;
  top: number;
  left: number;
  width: number;
  height: number;
  personId?: string;
  personName?: string;
}

export const getFaceOverlayBoxes = (
  faceData: FaceOverlayData[],
  zoom: ZoomImageWheelState,
  photoViewer: HTMLImageElement | undefined,
): FaceOverlayBoundingBox[] => {
  const boxes: FaceOverlayBoundingBox[] = [];

  if (!photoViewer) {
    return boxes;
  }

  const clientHeight = photoViewer.clientHeight;
  const clientWidth = photoViewer.clientWidth;
  const { width, height } = getContainedSize(photoViewer);

  for (const face of faceData) {
    const coordinates = {
      x1:
        (width / face.imageWidth) * zoom.currentZoom * face.boundingBoxX1 +
        ((clientWidth - width) / 2) * zoom.currentZoom +
        zoom.currentPositionX,
      x2:
        (width / face.imageWidth) * zoom.currentZoom * face.boundingBoxX2 +
        ((clientWidth - width) / 2) * zoom.currentZoom +
        zoom.currentPositionX,
      y1:
        (height / face.imageHeight) * zoom.currentZoom * face.boundingBoxY1 +
        ((clientHeight - height) / 2) * zoom.currentZoom +
        zoom.currentPositionY,
      y2:
        (height / face.imageHeight) * zoom.currentZoom * face.boundingBoxY2 +
        ((clientHeight - height) / 2) * zoom.currentZoom +
        zoom.currentPositionY,
    };

    boxes.push({
      id: face.id,
      top: Math.round(coordinates.y1),
      left: Math.round(coordinates.x1),
      width: Math.round(coordinates.x2 - coordinates.x1),
      height: Math.round(coordinates.y2 - coordinates.y1),
      personId: face.personId,
      personName: face.personName,
    });
  }

  return boxes;
};
