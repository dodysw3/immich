import type { Faces } from '$lib/managers/asset-viewer-manager.svelte';
import type { Size } from '$lib/utils/container-utils';
import {
  getBoundingBox,
  getFaceReferenceLabels,
  getPersonDisplayName,
  isPlaceholderFaceName,
  type FaceWithName,
} from '$lib/utils/people-utils';

// the $lib/utils barrel runs DOM-dependent module side effects unrelated to these tests
vi.mock('$lib/utils', () => ({ getAssetMediaUrl: vi.fn() }));

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
