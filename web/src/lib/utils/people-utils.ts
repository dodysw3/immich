import type { Faces } from '#lib/managers/asset-viewer-manager.svelte.ts';
import { getAssetMediaUrl } from '#lib/utils.ts';
import { mapNormalizedRectToContent, type Rect, type Size } from '#lib/utils/container-utils.ts';
import { AssetTypeEnum, type AssetFaceResponseDto } from '@immich/sdk';

export type BoundingBox = Rect & { id: string; labelWidth: number };

export const getBoundingBox = (faces: Faces[], imageSize: Size): BoundingBox[] => {
  const boxes: BoundingBox[] = [];

  for (const face of faces) {
    const rect = mapNormalizedRectToContent(
      { x: face.boundingBoxX1 / face.imageWidth, y: face.boundingBoxY1 / face.imageHeight },
      { x: face.boundingBoxX2 / face.imageWidth, y: face.boundingBoxY2 / face.imageHeight },
      imageSize,
    );

    boxes.push({ id: face.id, ...rect, labelWidth: rect.width });
  }

  return boxes;
};

export type VideoFaceSightingBox = {
  timeMs: number;
  score: number;
  x1: number;
  y1: number;
  x2: number;
  y2: number;
  imageWidth: number;
  imageHeight: number;
};

export type VideoFaceSightingsSource = {
  id: string;
  personName?: string | null;
  sightings: VideoFaceSightingBox[];
};

/** How far past the first/last sighting a face's box stays on screen (ms). */
export const SIGHTING_EDGE_TOLERANCE_MS = 1500;

const normalizedSightingCorners = (sighting: VideoFaceSightingBox) => ({
  minX: sighting.x1 / sighting.imageWidth,
  minY: sighting.y1 / sighting.imageHeight,
  maxX: sighting.x2 / sighting.imageWidth,
  maxY: sighting.y2 / sighting.imageHeight,
});

/**
Boxes for video face identities at playback time. Sightings are sparse
per-frame samples, so each box linearly interpolates between the two sightings
bracketing `timeMs` and holds the first/last sighting's box for
SIGHTING_EDGE_TOLERANCE_MS past the edges; faces without a covering sighting
are omitted (not on screen at that moment).
*/
export const getVideoFaceSightingBoxes = (
  faces: VideoFaceSightingsSource[],
  timeMs: number,
  imageSize: Size,
): (BoundingBox & { personName: string | null })[] => {
  const boxes: (BoundingBox & { personName: string | null })[] = [];

  for (const face of faces) {
    if (face.sightings.length === 0) {
      continue;
    }
    const sorted = [...face.sightings].sort((a, b) => a.timeMs - b.timeMs);
    const first = sorted[0];
    const last = sorted.at(-1);
    if (!first || !last) {
      continue;
    }
    if (timeMs < first.timeMs - SIGHTING_EDGE_TOLERANCE_MS || timeMs > last.timeMs + SIGHTING_EDGE_TOLERANCE_MS) {
      continue;
    }

    let corners: ReturnType<typeof normalizedSightingCorners>;
    if (timeMs <= first.timeMs) {
      corners = normalizedSightingCorners(first);
    } else if (timeMs >= last.timeMs) {
      corners = normalizedSightingCorners(last);
    } else {
      let index = 0;
      while (index < sorted.length - 2 && sorted[index + 1].timeMs <= timeMs) {
        index += 1;
      }
      const a = sorted[index];
      const b = sorted[index + 1];
      const ca = normalizedSightingCorners(a);
      const cb = normalizedSightingCorners(b);
      const span = b.timeMs - a.timeMs;
      const t = span > 0 ? (timeMs - a.timeMs) / span : 0;
      corners = {
        minX: ca.minX + (cb.minX - ca.minX) * t,
        minY: ca.minY + (cb.minY - ca.minY) * t,
        maxX: ca.maxX + (cb.maxX - ca.maxX) * t,
        maxY: ca.maxY + (cb.maxY - ca.maxY) * t,
      };
    }

    const rect = mapNormalizedRectToContent(
      { x: corners.minX, y: corners.minY },
      { x: corners.maxX, y: corners.maxY },
      imageSize,
    );
    boxes.push({ id: face.id, ...rect, labelWidth: rect.width, personName: face.personName ?? null });
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

const measureAt = (context: CanvasRenderingContext2D | OffscreenCanvasRenderingContext2D, text: string): number => {
  context.font = `${LABEL_MAX_FONT}px sans-serif`;
  return context.measureText(text).width;
};

const fitSize = (measured: number, maxWidth: number): number =>
  measured <= maxWidth ? LABEL_MAX_FONT : Math.max(LABEL_MIN_FONT, Math.floor((LABEL_MAX_FONT * maxWidth) / measured));

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
Reference labels ([1], [2*], …) for faces without a usable name: faces with
no person and persons named "..." get [n], faces of unnamed persons get [n*].
Numbers come from a single pool per asset ordered by face position, so they
are stable across reloads and match between the viewer overlay and the
people panel.
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

export type FaceStats = {
  namedPersons: number;
  unnamedPersons: number;
  faces: number;
};

/** Show the face-stats summary line once visible faces exceed this count. */
export const FACE_STATS_MIN_FACES = 16;

export const getFaceStats = (
  faces: { person?: { id: string; name: string; isHidden?: boolean } | null }[],
): FaceStats => {
  const persons = new Map<string, { name: string }>();
  let faceCount = 0;
  for (const face of faces) {
    if (!face.person) {
      faceCount += 1;
      continue;
    }
    if (face.person.isHidden) {
      continue;
    }
    faceCount += 1;
    persons.set(face.person.id, face.person);
  }
  let namedPersons = 0;
  for (const person of persons.values()) {
    if (!isPlaceholderFaceName(person.name)) {
      namedPersons += 1;
    }
  }
  return { namedPersons, unnamedPersons: persons.size - namedPersons, faces: faceCount };
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
      const widest = Math.max(...words.map((word) => measureAt(context, word)));
      size = fitSize(widest, maxWidth);
    }
    return { fontSize: size, wrap: true };
  }
  let size = LABEL_MAX_FONT;
  if (context) {
    size = fitSize(measureAt(context, text), maxWidth);
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
