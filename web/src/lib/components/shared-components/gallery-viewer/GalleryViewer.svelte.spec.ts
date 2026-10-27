import { AssetTypeEnum } from '@immich/sdk';
import { cleanup, fireEvent, render } from '@testing-library/svelte';
import { AssetMultiSelectManager } from '$lib/managers/asset-multi-select-manager.svelte';
import { editManager } from '$lib/managers/edit/edit-manager.svelte';
import { eventManager } from '$lib/managers/event-manager.svelte';
import { type PageMap } from '$lib/utils/page-map';
import { toTimelineAsset } from '$lib/utils/timeline-util';
import { assetFactory } from '@test-data/factories/asset-factory';
import GalleryViewer from './GalleryViewer.svelte';

vi.mock('$lib/managers/edit/edit-manager.svelte', () => ({
  editManager: { applyInstantRotateBulk: vi.fn().mockResolvedValue(undefined) },
}));

vi.mock('$app/navigation', () => ({ goto: vi.fn() }));

vi.mock('$lib/utils/layout-utils', () => ({
  getJustifiedLayoutFromAssets: () => ({
    containerHeight: 200,
    containerWidth: 1000,
    getTop: () => 0,
    getLeft: () => 0,
    getWidth: () => 400,
    getHeight: () => 200,
  }),
}));

describe('GalleryViewer rotation', () => {
  afterEach(() => {
    cleanup();
    vi.clearAllMocks();
  });

  it.each([false, true])('registers bulk rotation and refreshes edited assets (paged: %s)', async (paged) => {
    const asset = assetFactory.build({
      type: AssetTypeEnum.Image,
      livePhotoVideoId: null,
      thumbhash: null,
      width: 400,
      height: 200,
    });
    const assets = $state([asset]);
    const pages: PageMap = $state({ 1: { status: 'loaded', assets: [asset], height: 200 } });
    const selection = new AssetMultiSelectManager();
    selection.selectAsset(toTimelineAsset(asset));
    const viewerAssets = $state([asset]);
    render(GalleryViewer, {
      assets,
      viewerAssets,
      assetInteraction: selection,
      viewport: { width: 1000, height: 800 },
      pageMap: paged ? pages : undefined,
    });

    await fireEvent.keyDown(document, { key: '}', code: 'BracketRight', shiftKey: true });
    expect(editManager.applyInstantRotateBulk).toHaveBeenCalledExactlyOnceWith(selection.assets, 90);

    const rotated = { ...asset, width: 200, height: 400, isEdited: true };
    eventManager.emit('AssetUpdate', rotated);
    expect(assets[0]).toEqual(rotated);
    expect(viewerAssets[0]).toEqual(rotated);
    if (pages[1].status === 'loaded' && paged) expect(pages[1].assets[0]).toEqual(rotated);
    expect(selection.assets[0].ratio).toBe(0.5);
    expect(selection.selectionActive).toBe(true);
  });
});
