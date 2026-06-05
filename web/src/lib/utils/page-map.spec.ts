import { describe, expect, it } from 'vitest';
import {
  type PageMap,
  getLoadedAssets,
  getContainerHeight,
  getPageAtScrollOffset,
  findGhostPagesNearViewport,
} from '$lib/utils/page-map';

import type { AssetResponseDto } from '@immich/sdk';

const createAsset = (id: string) =>
  ({
    id,
    localDateTime: new Date().toISOString(),
    exifInfo: {},
    type: 'IMAGE',
  }) as AssetResponseDto;

function makePage(entries: [number, PageState][], initial?: PageMap): PageMap {
  const map: PageMap = initial ?? {};
  for (const [key, value] of entries) {
    map[key] = value;
  }
  return map;
}

import type { PageState } from '$lib/utils/page-map';

describe('getLoadedAssets', () => {
  it('returns empty array for empty map', () => {
    expect(getLoadedAssets({})).toEqual([]);
  });

  it('returns assets from loaded pages in page-number order', () => {
    const map = makePage([
      [2, { status: 'loaded', assets: [createAsset('a'), createAsset('b')], height: 100 }],
      [1, { status: 'loaded', assets: [createAsset('c')], height: 50 }],
      [3, { status: 'ghost', height: 100 }],
    ]);

    expect(getLoadedAssets(map)).toEqual([createAsset('c'), createAsset('a'), createAsset('b')]);
  });

  it('skips ghost, loading, and unloaded pages', () => {
    const map = makePage([
      [1, { status: 'loaded', assets: [createAsset('a')], height: 100 }],
      [2, { status: 'ghost', height: 100 }],
      [3, { status: 'loading', ghostHeight: 0 }],
      [4, { status: 'unloaded' }],
    ]);

    expect(getLoadedAssets(map)).toEqual([createAsset('a')]);
  });
});

describe('getContainerHeight', () => {
  it('returns 0 for empty map', () => {
    expect(getContainerHeight({})).toBe(0);
  });

  it('sums heights from loaded and ghost pages', () => {
    const map = makePage([
      [1, { status: 'loaded', assets: [createAsset('a')], height: 200 }],
      [2, { status: 'ghost', height: 150 }],
      [3, { status: 'loaded', assets: [createAsset('b')], height: 300 }],
    ]);

    expect(getContainerHeight(map)).toBe(650);
  });

  it('excludes loading and unloaded pages', () => {
    const map = makePage([
      [1, { status: 'loaded', assets: [createAsset('a')], height: 100 }],
      [2, { status: 'loading', ghostHeight: 50 }],
      [3, { status: 'unloaded' }],
    ]);

    expect(getContainerHeight(map)).toBe(100);
  });
});

describe('getPageAtScrollOffset', () => {
  it('returns undefined for empty map', () => {
    expect(getPageAtScrollOffset({}, 0)).toBeUndefined();
  });

  it('returns the correct page for a given offset', () => {
    const map = makePage([
      [1, { status: 'loaded', assets: [createAsset('a')], height: 200 }],
      [2, { status: 'loaded', assets: [createAsset('b')], height: 150 }],
      [3, { status: 'ghost', height: 100 }],
    ]);

    expect(getPageAtScrollOffset(map, 0)).toBe(1);
    expect(getPageAtScrollOffset(map, 100)).toBe(1);
    expect(getPageAtScrollOffset(map, 199)).toBe(1);
    expect(getPageAtScrollOffset(map, 200)).toBe(2);
    expect(getPageAtScrollOffset(map, 300)).toBe(2);
    expect(getPageAtScrollOffset(map, 349)).toBe(2);
    expect(getPageAtScrollOffset(map, 350)).toBe(3);
    expect(getPageAtScrollOffset(map, 449)).toBe(3);
    expect(getPageAtScrollOffset(map, 450)).toBeUndefined();
  });

  it('skips loading and unloaded pages in offset calculation', () => {
    const map = makePage([
      [1, { status: 'loaded', assets: [createAsset('a')], height: 100 }],
      [2, { status: 'loading', ghostHeight: 0 }],
      [3, { status: 'loaded', assets: [createAsset('b')], height: 100 }],
    ]);

    expect(getPageAtScrollOffset(map, 50)).toBe(1);
    expect(getPageAtScrollOffset(map, 100)).toBe(3);
  });
});

describe('evictPage (direct mutation)', () => {
  it('transitions a loaded page to ghost, preserving height', () => {
    const map: PageMap = { 1: { status: 'loaded', assets: [createAsset('a')], height: 200 } };

    const prev = map[1];
    if (prev.status === 'loaded') {
      map[1] = { status: 'ghost', height: prev.height };
    }

    expect(map[1]).toEqual({ status: 'ghost', height: 200 });
  });

  it('getContainerHeight remains unchanged after eviction', () => {
    const map = makePage([
      [1, { status: 'loaded', assets: [createAsset('a')], height: 200 }],
      [2, { status: 'loaded', assets: [createAsset('b')], height: 300 }],
    ]);

    expect(getContainerHeight(map)).toBe(500);

    // Evict page 1 via direct mutation
    const prev = map[1] as Extract<PageState, { status: 'loaded' }>;
    map[1] = { status: 'ghost', height: prev.height };

    expect(getContainerHeight(map)).toBe(500);
  });
});

describe('findGhostPagesNearViewport', () => {
  it('returns empty array when no ghost pages exist', () => {
    const map = makePage([
      [1, { status: 'loaded', assets: [createAsset('a')], height: 200 }],
      [2, { status: 'loading', ghostHeight: 0 }],
    ]);

    expect(findGhostPagesNearViewport(map, 0, 800, 2)).toEqual([]);
  });

  it('returns ghost pages within the viewport range', () => {
    const map = makePage([
      [1, { status: 'ghost', height: 200 }],
      [2, { status: 'loaded', assets: [createAsset('b')], height: 200 }],
      [3, { status: 'ghost', height: 200 }],
      [4, { status: 'ghost', height: 200 }],
    ]);

    const result = findGhostPagesNearViewport(map, 300, 800, 2);
    expect(result.sort()).toEqual([1, 3, 4]);
  });

  it('excludes ghost pages far outside the threshold', () => {
    const map = makePage([
      [1, { status: 'ghost', height: 100 }],
      [2, { status: 'loaded', assets: [createAsset('b')], height: 400 }],
      [3, { status: 'loaded', assets: [createAsset('c')], height: 400 }],
      [4, { status: 'loaded', assets: [createAsset('d')], height: 400 }],
      [5, { status: 'ghost', height: 100 }],
    ]);

    const result = findGhostPagesNearViewport(map, 600, 500, 1);
    expect(result).not.toContain(1);
  });
});
