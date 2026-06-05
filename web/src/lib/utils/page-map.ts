import type { AssetResponseDto } from '@immich/sdk';

export type PageState =
  | { status: 'loaded'; assets: AssetResponseDto[]; height: number }
  | { status: 'ghost'; height: number }
  | { status: 'loading'; ghostHeight: number }
  | { status: 'unloaded' };

/**
 * A record of page states keyed by page number (1-indexed).
 */
export type PageMap = Record<number, PageState>;

/**
 * Create an empty PageMap.
 */
export function createPageMap(): PageMap {
  return {};
}

/**
 * Flatten all loaded pages in page-number order into a single array of assets.
 * Pages loaded out of order are still returned in the correct sequence.
 */
export function getLoadedAssets(pages: PageMap): AssetResponseDto[] {
  const sorted = Object.keys(pages)
    .map(Number)
    .sort((a, b) => a - b);

  const result: AssetResponseDto[] = [];
  for (const key of sorted) {
    const state = pages[key];
    if (state.status === 'loaded') {
      result.push(...state.assets);
    }
  }
  return result;
}

/**
 * Sum heights from all loaded pages and ghost pages.
 * Unloaded and loading pages contribute 0 to the container height.
 */
export function getContainerHeight(pages: PageMap): number {
  let total = 0;
  for (const state of Object.values(pages)) {
    if (state.status === 'loaded' || state.status === 'ghost') {
      total += state.height;
    }
  }
  return total;
}

/**
 * Return the page number that owns a given vertical pixel position,
 * or `undefined` if the offset is past all pages.
 */
export function getPageAtScrollOffset(pages: PageMap, offset: number): number | undefined {
  let accumulated = 0;
  const sorted = Object.keys(pages)
    .map(Number)
    .sort((a, b) => a - b);

  for (const pageNum of sorted) {
    const state = pages[pageNum];
    if (state.status === 'loaded' || state.status === 'ghost') {
      accumulated += state.height;
      if (offset < accumulated) {
        return pageNum;
      }
    }
  }
  return undefined;
}

/**
 * Find ghost page numbers whose position overlaps with the given
 * viewport range (extended by `threshold` viewport heights in both directions).
 */
export function findGhostPagesNearViewport(
  pages: PageMap,
  scrollTop: number,
  viewportHeight: number,
  threshold: number,
): number[] {
  const rangeTop = scrollTop - threshold * viewportHeight;
  const rangeBottom = scrollTop + viewportHeight + threshold * viewportHeight;

  const ghostPages: number[] = [];
  let accumulated = 0;

  const sorted = Object.keys(pages)
    .map(Number)
    .sort((a, b) => a - b);

  for (const pageNum of sorted) {
    const state = pages[pageNum];
    const pageHeight = state.status === 'loaded' || state.status === 'ghost' ? state.height : 0;

    if (state.status === 'ghost') {
      const pageTop = accumulated;
      const pageBottom = accumulated + pageHeight;
      if (pageBottom > rangeTop && pageTop < rangeBottom) {
        ghostPages.push(pageNum);
      }
    }

    if (pageHeight > 0) {
      accumulated += pageHeight;
    }
  }

  return ghostPages;
}
