import type { Faces } from '#lib/managers/asset-viewer-manager.svelte.ts';
import type { Size } from '#lib/utils/container-utils.ts';
import {
  SIGHTING_EDGE_TOLERANCE_MS,
  getBoundingBox,
  getFaceReferenceLabels,
  getFaceStats,
  getPersonDisplayName,
  getVideoFaceSightingBoxes,
  isPlaceholderFaceName,
  type FaceWithName,
  type VideoFaceSightingBox,
} from '#lib/utils/people-utils.ts';

// the utils barrel runs DOM-dependent module side effects unrelated to these tests
vi.mock('#lib/utils.ts', () => ({ getAssetMediaUrl: vi.fn() }));

const makeFace = (overrides: Partial<Faces> = {}): Faces => ({
  id: 'face-1',
  imageWidth: 4000,
  imageHeight: 3000,
  boundingBoxX1: 1000,
  boundingBoxY1: 750,
  boundingBoxX2: 2000,
  boundingBoxY2: 1500,
  ...overrides,
});

const makeFaceWithPerson = (person: { name: string } | undefined, overrides: Partial<Faces> = {}): FaceWithName => ({
  ...makeFace(overrides),
  person,
});

const makeFaceWithStatsPerson = (
  person: { id: string; name: string; isHidden: boolean } | null,
  overrides: Partial<Faces> = {},
) => ({
  ...makeFace(overrides),
  person,
});

describe('getBoundingBox', () => {
  it('should scale face coordinates to display dimensions', () => {
    const face = makeFace();
    const imageSize: Size = { width: 800, height: 600 };

    const boxes = getBoundingBox([face], imageSize);

    expect(boxes).toHaveLength(1);
    expect(boxes[0]).toEqual({
      id: 'face-1',
      top: 600 * (750 / 3000),
      left: 800 * (1000 / 4000),
      width: 800 * (2000 / 4000) - 800 * (1000 / 4000),
      height: 600 * (1500 / 3000) - 600 * (750 / 3000),
      labelWidth: 800 * (2000 / 4000) - 800 * (1000 / 4000),
    });
  });

  it('should map full-image face to full display area', () => {
    const face = makeFace({
      imageWidth: 1000,
      imageHeight: 1000,
      boundingBoxX1: 0,
      boundingBoxY1: 0,
      boundingBoxX2: 1000,
      boundingBoxY2: 1000,
    });
    const imageSize: Size = { width: 600, height: 600 };

    const boxes = getBoundingBox([face], imageSize);

    expect(boxes[0]).toEqual({
      id: 'face-1',
      top: 0,
      left: 0,
      width: 600,
      height: 600,
      labelWidth: 600,
    });
  });

  it('should return empty array for empty faces', () => {
    expect(getBoundingBox([], { width: 800, height: 600 })).toEqual([]);
  });

  it('should handle multiple faces', () => {
    const faces = [
      makeFace({ id: 'face-1', boundingBoxX1: 0, boundingBoxY1: 0, boundingBoxX2: 1000, boundingBoxY2: 1000 }),
      makeFace({ id: 'face-2', boundingBoxX1: 2000, boundingBoxY1: 1500, boundingBoxX2: 3000, boundingBoxY2: 2500 }),
    ];

    const boxes = getBoundingBox(faces, { width: 800, height: 600 });

    expect(boxes).toHaveLength(2);
    expect(boxes[0].left).toBeLessThan(boxes[1].left);
  });
});

describe('isPlaceholderFaceName', () => {
  it('should match empty, dot and ellipsis names', () => {
    expect(isPlaceholderFaceName('')).toBe(true);
    expect(isPlaceholderFaceName(' '.repeat(3))).toBe(true);
    expect(isPlaceholderFaceName('...')).toBe(true);
    expect(isPlaceholderFaceName('…')).toBe(true);
    expect(isPlaceholderFaceName(undefined)).toBe(true);
  });

  it('should not match real names', () => {
    expect(isPlaceholderFaceName('Bu Lexy')).toBe(false);
    expect(isPlaceholderFaceName('.')).toBe(false);
    expect(isPlaceholderFaceName('..')).toBe(false);
  });
});

describe('getFaceReferenceLabels', () => {
  it('should number faces without a person left to right', () => {
    const labels = getFaceReferenceLabels([
      makeFaceWithPerson(undefined, { id: 'c', boundingBoxX1: 500 }),
      makeFaceWithPerson(undefined, { id: 'a', boundingBoxX1: 100 }),
      makeFaceWithPerson(undefined, { id: 'b', boundingBoxX1: 300 }),
    ]);

    expect(labels.get('a')).toBe('[1]');
    expect(labels.get('b')).toBe('[2]');
    expect(labels.get('c')).toBe('[3]');
  });

  it('should tie-break equal left edges by top edge', () => {
    const labels = getFaceReferenceLabels([
      makeFaceWithPerson(undefined, { id: 'lower', boundingBoxX1: 100, boundingBoxY1: 2000 }),
      makeFaceWithPerson(undefined, { id: 'upper', boundingBoxX1: 100, boundingBoxY1: 500 }),
    ]);

    expect(labels.get('upper')).toBe('[1]');
    expect(labels.get('lower')).toBe('[2]');
  });

  it('should number unnamed and dot-named persons from the same pool with an asterisk only for unnamed', () => {
    const labels = getFaceReferenceLabels([
      makeFaceWithPerson({ name: '' }, { id: 'unnamed', boundingBoxX1: 100 }),
      makeFaceWithPerson(undefined, { id: 'no-person', boundingBoxX1: 200 }),
      makeFaceWithPerson({ name: '...' }, { id: 'dots', boundingBoxX1: 300 }),
    ]);

    expect(labels.get('unnamed')).toBe('[1*]');
    expect(labels.get('no-person')).toBe('[2]');
    expect(labels.get('dots')).toBe('[3]');
  });

  it('should not number named faces', () => {
    const labels = getFaceReferenceLabels([
      makeFaceWithPerson({ name: 'Bu Lexy' }, { id: 'named', boundingBoxX1: 100 }),
      makeFaceWithPerson(undefined, { id: 'no-person', boundingBoxX1: 200 }),
    ]);

    expect(labels.has('named')).toBe(false);
    expect(labels.get('no-person')).toBe('[1]');
  });
});

describe('getPersonDisplayName', () => {
  const labels = new Map([
    ['face-1', '[2*]'],
    ['face-2', '[5*]'],
  ]);

  it('should return the name for named persons', () => {
    expect(getPersonDisplayName({ name: 'Bu Lexy' }, [makeFaceWithPerson({ name: 'Bu Lexy' })], labels)).toBe(
      'Bu Lexy',
    );
  });

  it('should return reference labels in position order for unnamed persons', () => {
    const faces = [
      makeFaceWithPerson({ name: '' }, { id: 'face-2', boundingBoxX1: 3000 }),
      makeFaceWithPerson({ name: '' }, { id: 'face-1', boundingBoxX1: 1000 }),
    ];

    expect(getPersonDisplayName({ name: '' }, faces, labels)).toBe('[2*] [5*]');
  });

  it('should return reference labels for dot-named persons', () => {
    expect(
      getPersonDisplayName({ name: '...' }, [makeFaceWithPerson({ name: '...' })], new Map([['face-1', '[3]']])),
    ).toBe('[3]');
  });
});

describe('getFaceStats', () => {
  it('should count named persons, unnamed persons, and faces separately', () => {
    const faces = [
      makeFaceWithStatsPerson({ id: 'p-alice', name: 'Alice', isHidden: false }),
      makeFaceWithStatsPerson({ id: 'p-alice', name: 'Alice', isHidden: false }, { id: 'face-2' }),
      makeFaceWithStatsPerson({ id: 'p-bob', name: 'Bob', isHidden: false }),
      makeFaceWithStatsPerson({ id: 'p-unnamed', name: '', isHidden: false }),
      makeFaceWithStatsPerson(null, { id: 'face-5' }),
    ];

    expect(getFaceStats(faces)).toEqual({ namedPersons: 2, unnamedPersons: 1, faces: 5 });
  });

  it('should exclude hidden persons and their faces from every count', () => {
    const faces = [
      makeFaceWithStatsPerson({ id: 'p-alice', name: 'Alice', isHidden: false }),
      makeFaceWithStatsPerson({ id: 'p-junk', name: 'Junk', isHidden: true }),
      makeFaceWithStatsPerson({ id: 'p-junk', name: 'Junk', isHidden: true }, { id: 'face-3' }),
      makeFaceWithStatsPerson({ id: 'p-hidden-unnamed', name: '', isHidden: true }),
      makeFaceWithStatsPerson(null, { id: 'face-5' }),
    ];

    expect(getFaceStats(faces)).toEqual({ namedPersons: 1, unnamedPersons: 0, faces: 2 });
  });

  it('should treat "..." placeholder names as unnamed', () => {
    const faces = [
      makeFaceWithStatsPerson({ id: 'p-placeholder', name: '...', isHidden: false }),
      makeFaceWithStatsPerson({ id: 'p-spaced', name: ' Alice ', isHidden: false }),
    ];

    expect(getFaceStats(faces)).toEqual({ namedPersons: 1, unnamedPersons: 1, faces: 2 });
  });
});

describe('getVideoFaceSightingBoxes', () => {
  const imageSize: Size = { width: 1000, height: 500 };

  const makeSighting = (
    timeMs: number,
    box: [number, number, number, number],
    dims: [number, number] = [100, 100],
  ): VideoFaceSightingBox => ({
    timeMs,
    score: 0.9,
    x1: box[0],
    y1: box[1],
    x2: box[2],
    y2: box[3],
    imageWidth: dims[0],
    imageHeight: dims[1],
  });

  it('should omit faces without sightings', () => {
    expect(getVideoFaceSightingBoxes([{ id: 'face-1', sightings: [] }], 5000, imageSize)).toEqual([]);
  });

  it('should hold a single sighting within the edge tolerance and omit it outside', () => {
    const face = { id: 'face-1', personName: 'Alice', sightings: [makeSighting(10_000, [0, 0, 100, 100])] };

    const [atSighting] = getVideoFaceSightingBoxes([face], 10_000, imageSize);
    expect(atSighting).toEqual({
      id: 'face-1',
      top: 0,
      left: 0,
      width: 1000,
      height: 500,
      labelWidth: 1000,
      personName: 'Alice',
    });

    const [held] = getVideoFaceSightingBoxes([face], 10_000 + SIGHTING_EDGE_TOLERANCE_MS, imageSize);
    expect(held).toEqual(atSighting);

    expect(getVideoFaceSightingBoxes([face], 10_000 + SIGHTING_EDGE_TOLERANCE_MS + 1, imageSize)).toEqual([]);
    expect(getVideoFaceSightingBoxes([face], 10_000 - SIGHTING_EDGE_TOLERANCE_MS - 1, imageSize)).toEqual([]);
  });

  it('should interpolate the box between the sightings bracketing the playhead', () => {
    const face = {
      id: 'face-1',
      sightings: [makeSighting(0, [0, 0, 100, 100]), makeSighting(1000, [100, 0, 200, 100])],
    };

    const [halfway] = getVideoFaceSightingBoxes([face], 500, imageSize);
    expect(halfway.left).toBeCloseTo(500);
    expect(halfway.width).toBeCloseTo(1000);

    const [atEnd] = getVideoFaceSightingBoxes([face], 1000, imageSize);
    expect(atEnd.left).toBeCloseTo(1000);
  });

  it('should clamp to the first/last sighting box just past the edges', () => {
    const face = {
      id: 'face-1',
      sightings: [makeSighting(0, [0, 0, 100, 100]), makeSighting(1000, [100, 0, 200, 100])],
    };

    const [beforeStart] = getVideoFaceSightingBoxes([face], -200, imageSize);
    expect(beforeStart.left).toBe(0);
    const [afterEnd] = getVideoFaceSightingBoxes([face], 1200, imageSize);
    expect(afterEnd.left).toBeCloseTo(1000);
    expect(getVideoFaceSightingBoxes([face], -SIGHTING_EDGE_TOLERANCE_MS - 1, imageSize)).toEqual([]);
  });

  it('should normalize each sighting by its own frame dimensions', () => {
    const face = {
      id: 'face-1',
      // same physical half-frame box expressed in 200px and 100px wide frames
      sightings: [makeSighting(0, [0, 0, 100, 100], [200, 200]), makeSighting(1000, [0, 0, 50, 50], [100, 100])],
    };

    const [atStart] = getVideoFaceSightingBoxes([face], 0, imageSize);
    const [atEnd] = getVideoFaceSightingBoxes([face], 1000, imageSize);
    expect(atStart).toEqual(atEnd);
  });
});
