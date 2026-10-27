import { isModalOpen } from '@immich/ui';
import { cleanup, fireEvent, render } from '@testing-library/svelte';
import { ProjectionType } from '$lib/constants';
import { AssetMultiSelectManager } from '$lib/managers/asset-multi-select-manager.svelte';
import { authManager } from '$lib/managers/auth-manager.svelte';
import { editManager } from '$lib/managers/edit/edit-manager.svelte';
import { searchStore } from '$lib/stores/search.svelte';
import { timelineAssetFactory } from '@test-data/factories/asset-factory';
import { preferencesFactory } from '@test-data/factories/preferences-factory';
import { userAdminFactory } from '@test-data/factories/user-factory';
import AssetSelectionRotateShortcuts from './AssetSelectionRotateShortcuts.svelte';

const viewerState = vi.hoisted(() => ({ isViewing: false }));

vi.mock('$lib/managers/edit/edit-manager.svelte', () => ({
  editManager: { applyInstantRotateBulk: vi.fn().mockResolvedValue(undefined) },
}));
vi.mock('$lib/managers/asset-viewer-manager.svelte', () => ({ assetViewerManager: viewerState }));
vi.mock('@immich/ui', async (importOriginal) => ({
  ...(await importOriginal<typeof import('@immich/ui')>()),
  isModalOpen: vi.fn().mockReturnValue(false),
}));

const left = { key: '{', code: 'BracketLeft', shiftKey: true };
const right = { key: '}', code: 'BracketRight', shiftKey: true };

describe('AssetSelectionRotateShortcuts', () => {
  let selection: AssetMultiSelectManager;
  const user = userAdminFactory.build();

  beforeEach(() => {
    vi.clearAllMocks();
    vi.mocked(isModalOpen).mockReturnValue(false);
    viewerState.isViewing = false;
    searchStore.isSearchEnabled = false;
    authManager.setUser(user);
    authManager.setPreferences(preferencesFactory.build());
    selection = new AssetMultiSelectManager();
    selection.selectAsset(timelineAssetFactory.build({ ownerId: user.id, livePhotoVideoId: null }));
  });

  afterEach(() => {
    cleanup();
    authManager.reset();
  });

  it.each([
    [left, -90],
    [right, 90],
  ] as const)('rotates the selection using physical bracket codes: %j', async (key, angle) => {
    render(AssetSelectionRotateShortcuts, { assetInteraction: selection });
    const event = new KeyboardEvent('keydown', { ...key, bubbles: true, cancelable: true });
    await fireEvent(document, event);
    expect(event.defaultPrevented).toBe(true);
    expect(editManager.applyInstantRotateBulk).toHaveBeenCalledExactlyOnceWith(selection.ownedAssets, angle);
  });

  it('only rotates owned still images that support editing', async () => {
    selection.selectAssets([
      timelineAssetFactory.build({ ownerId: 'another-user', livePhotoVideoId: null }),
      timelineAssetFactory.build({ ownerId: user.id, isImage: false, isVideo: true, livePhotoVideoId: null }),
      timelineAssetFactory.build({ ownerId: user.id, livePhotoVideoId: 'motion-video' }),
      timelineAssetFactory.build({
        ownerId: user.id,
        projectionType: ProjectionType.EQUIRECTANGULAR,
        livePhotoVideoId: null,
      }),
    ]);
    render(AssetSelectionRotateShortcuts, { assetInteraction: selection });
    await fireEvent.keyDown(document, right);
    expect(editManager.applyInstantRotateBulk).toHaveBeenCalledExactlyOnceWith([selection.assets[0]], 90);
  });

  it.each([{ repeat: true }, { ctrlKey: true }, { altKey: true }, { metaKey: true }, { shiftKey: false }])(
    'ignores repeats and unrelated modifier combinations: %j',
    async (modifiers) => {
      render(AssetSelectionRotateShortcuts, { assetInteraction: selection });
      await fireEvent.keyDown(document, { ...right, ...modifiers });
      expect(editManager.applyInstantRotateBulk).not.toHaveBeenCalled();
    },
  );

  it.each(['input', 'textarea'])('ignores shortcuts while typing in a %s', async (tag) => {
    render(AssetSelectionRotateShortcuts, { assetInteraction: selection });
    const input = document.createElement(tag);
    document.body.append(input);
    try {
      await fireEvent.keyDown(input, right);
      expect(editManager.applyInstantRotateBulk).not.toHaveBeenCalled();
    } finally {
      input.remove();
    }
  });

  it.each(['viewer', 'search', 'modal', 'empty-selection'])('ignores shortcuts with %s active', async (state) => {
    switch (state) {
      case 'viewer': {
        viewerState.isViewing = true;
        break;
      }
      case 'search': {
        searchStore.isSearchEnabled = true;
        break;
      }
      case 'modal': {
        vi.mocked(isModalOpen).mockReturnValue(true);
        break;
      }
      case 'empty-selection': {
        selection.clear();
        // No default
        break;
      }
    }
    render(AssetSelectionRotateShortcuts, { assetInteraction: selection });
    await fireEvent.keyDown(document, right);
    expect(editManager.applyInstantRotateBulk).not.toHaveBeenCalled();
  });
});
