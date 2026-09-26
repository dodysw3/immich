import { AssetTypeEnum, type AssetFaceResponseDto } from '@immich/sdk';
import type { Faces } from '$lib/managers/asset-viewer-manager.svelte';
import { getAssetMediaUrl } from '$lib/utils';
import { mapNormalizedRectToContent, type Rect, type Size } from '$lib/utils/container-utils';

export type BoundingBox = Rect & { id: string };

export const getBoundingBox = (faces: Faces[], imageSize: Size): BoundingBox[] => {
  const boxes: BoundingBox[] = [];

  for (const face of faces) {
    const rect = mapNormalizedRectToContent(
      { x: face.boundingBoxX1 / face.imageWidth, y: face.boundingBoxY1 / face.imageHeight },
      { x: face.boundingBoxX2 / face.imageWidth, y: face.boundingBoxY2 / face.imageHeight },
      imageSize,
    );

    boxes.push({ id: face.id, ...rect });
  }

  return boxes;
};

let labelMeasureCtx: CanvasRenderingContext2D | OffscreenCanvasRenderingContext2D | null = null;

const getLabelMeasureContext = (): CanvasRenderingContext2D | OffscreenCanvasRenderingContext2D | null => {
  if (labelMeasureCtx) {
    return labelMeasureCtx;
  }
  const canvas = typeof OffscreenCanvas === 'undefined' ? document.createElement('canvas') : new OffscreenCanvas(1, 1);
  labelMeasureCtx = canvas.getContext('2d');
  return labelMeasureCtx;
};

const measureAt = (
  context: CanvasRenderingContext2D | OffscreenCanvasRenderingContext2D,
  text: string,
  size: number,
): number => {
  context.font = `${size}px sans-serif`;
  return context.measureText(text).width;
};

const fitSize = (measured: number, maxWidth: number, max: number, min: number): number =>
  measured <= maxWidth ? max : Math.max(min, Math.floor((max * maxWidth) / measured));

export type FaceLabelStyle = { fontSize: number; wrap: boolean };

const LABEL_PAD_X = 8;
const LABEL_MIN_FONT = 6;
const LABEL_MAX_FONT = 9;
const LABEL_WRAP_CLEARANCE = 40;

const hasFaceBelow = (box: BoundingBox, allBoxes: BoundingBox[]): boolean => {
  const bottom = box.top + box.height;
  return allBoxes.some((other) => {
    if (other.id === box.id || other.top < bottom || other.top > bottom + LABEL_WRAP_CLEARANCE) {
      return false;
    }
    return other.left + other.width > box.left && other.left < box.left + box.width;
  });
};

export type FaceWithName = Faces & { person?: { name: string } | null | undefined };

export const facePositionOrder = (a: Faces, b: Faces): number =>
  a.boundingBoxX1 - b.boundingBoxX1 || a.boundingBoxY1 - b.boundingBoxY1;

const PLACEHOLDER_FACE_NAMES = new Set(['', '...', '…']);

export const isPlaceholderFaceName = (name: string | undefined): boolean =>
  PLACEHOLDER_FACE_NAMES.has(name?.trim() ?? '');

/**
 * Reference labels ([1], [2*], …) for faces without a usable name: faces with
 * no person and persons named "..." get [n], faces of unnamed persons get [n*].
 * Numbers come from a single pool per asset ordered by face position, so they
 * are stable across reloads and match between the viewer overlay and the
 * people panel.
 */
export const getFaceReferenceLabels = (faces: FaceWithName[]): Map<string, string> => {
  const labels = new Map<string, string>();
  const numbered = faces
    .filter((face) => !face.person || isPlaceholderFaceName(face.person.name))
    .sort(facePositionOrder);
  let counter = 0;
  for (const face of numbered) {
    counter += 1;
    const suffix = face.person && face.person.name.trim() === '' ? '*' : '';
    labels.set(face.id, `[${counter}${suffix}]`);
  }
  return labels;
};

export const getPersonDisplayName = (
  person: { name: string },
  faces: FaceWithName[],
  referenceLabels: Map<string, string>,
): string => {
  if (!isPlaceholderFaceName(person.name)) {
    return person.name;
  }
  return [...faces]
    .sort(facePositionOrder)
    .map((face) => referenceLabels.get(face.id))
    .filter((label): label is string => label !== undefined)
    .join(' ');
};

export const getFaceLabelStyle = (
  name: string | undefined,
  box: BoundingBox,
  allBoxes: BoundingBox[],
): FaceLabelStyle => {
  const text = (name ?? '').trim();
  const maxWidth = box.width - LABEL_PAD_X;
  if (!text || maxWidth <= 0) {
    return { fontSize: LABEL_MAX_FONT, wrap: false };
  }
  const context = getLabelMeasureContext();
  const words = text.split(/\s+/).filter(Boolean);
  if (words.length > 1 && !hasFaceBelow(box, allBoxes)) {
    let size = LABEL_MAX_FONT;
    if (context) {
      const widest = Math.max(...words.map((word) => measureAt(context, word, LABEL_MAX_FONT)));
      size = fitSize(widest, maxWidth, LABEL_MAX_FONT, LABEL_MIN_FONT);
    }
    return { fontSize: size, wrap: true };
  }
  let size = LABEL_MAX_FONT;
  if (context) {
    size = fitSize(measureAt(context, text, LABEL_MAX_FONT), maxWidth, LABEL_MAX_FONT, LABEL_MIN_FONT);
  }
  return { fontSize: size, wrap: false };
};

export const zoomImageToBase64 = async (
  face: AssetFaceResponseDto,
  assetId: string,
  assetType: AssetTypeEnum,
  photoViewer: HTMLImageElement | undefined,
): Promise<string | null> => {
  let image: HTMLImageElement | undefined;
  if (assetType === AssetTypeEnum.Image) {
    image = photoViewer;
  } else if (assetType === AssetTypeEnum.Video) {
    const data = getAssetMediaUrl({ id: assetId });
    const img: HTMLImageElement = new Image();
    img.src = data;

    await new Promise<void>((resolve) => {
      img.addEventListener('load', () => resolve());
      img.addEventListener('error', () => resolve());
    });

    image = img;
  }
  if (!image) {
    return null;
  }
  const { boundingBoxX1: x1, boundingBoxX2: x2, boundingBoxY1: y1, boundingBoxY2: y2, imageWidth, imageHeight } = face;

  const coordinates = {
    x1: (image.naturalWidth / imageWidth) * x1,
    x2: (image.naturalWidth / imageWidth) * x2,
    y1: (image.naturalHeight / imageHeight) * y1,
    y2: (image.naturalHeight / imageHeight) * y2,
  };

  const faceWidth = coordinates.x2 - coordinates.x1;
  const faceHeight = coordinates.y2 - coordinates.y1;

  const faceImage = new Image();
  faceImage.src = image.src;

  await new Promise((resolve) => {
    faceImage.addEventListener('load', resolve);
    faceImage.addEventListener('error', () => resolve(null));
  });

  const canvas = document.createElement('canvas');
  canvas.width = faceWidth;
  canvas.height = faceHeight;

  const context = canvas.getContext('2d');
  if (!context) {
    return null;
  }
  context.drawImage(faceImage, coordinates.x1, coordinates.y1, faceWidth, faceHeight, 0, 0, faceWidth, faceHeight);
  return canvas.toDataURL();
};
