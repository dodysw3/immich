import { type AssetFaceResponseDto, AssetJobName, AssetTypeEnum, getAssetInfo, runAssetJobs } from '@immich/sdk';
import { toastManager } from '@immich/ui';
import { vitest } from 'vitest';
import { assetViewerManager } from '$lib/managers/asset-viewer-manager.svelte';
import { authManager } from '$lib/managers/auth-manager.svelte';
import { getAssetActions, handleDownloadAsset } from '$lib/services/asset.service';
import { faceManager } from '$lib/stores/face.svelte';
import { downloadUrl, getAssetAnnotatedUrl, setSharedLink } from '$lib/utils';
import { getFormatter } from '$lib/utils/i18n';
import { assetFactory } from '@test-data/factories/asset-factory';
import { personFactory } from '@test-data/factories/person-factory';
import { preferencesFactory } from '@test-data/factories/preferences-factory';
import { sharedLinkFactory } from '@test-data/factories/shared-link-factory';
import { userAdminFactory } from '@test-data/factories/user-factory';

vitest.mock('@immich/ui', () => ({
  toastManager: {
    primary: vitest.fn(),
    info: vitest.fn(),
  },
}));

vitest.mock('$lib/utils/i18n', () => ({
  getFormatter: vitest.fn(),
  getPreferredLocale: vitest.fn(),
}));

vitest.mock('@immich/sdk');
vitest.mock('$lib/stores/face.svelte', () => ({ faceManager: { data: [] as AssetFaceResponseDto[] } }));

vitest.mock('$lib/utils', async () => {
  const originalModule = await vitest.importActual('$lib/utils');
  return {
    ...originalModule,
    sleep: vitest.fn(),
    downloadUrl: vitest.fn(),
    getAssetAnnotatedUrl: vitest.fn(),
  };
});

vi.mock(import('$lib/managers/feature-flags-manager.svelte'), function () {
  return {
    featureFlagsManager: { init: vi.fn(), loadFeatureFlags: vi.fn(), value: {} } as never,
  };
});

describe('AssetService', () => {
  describe('getAssetActions', () => {
    beforeEach(() => {
      authManager.setPreferences(preferencesFactory.build());
    });

    it('should allow shared link downloads if the user owns the asset and shared link downloads are disabled', () => {
      const ownerId = 'owner';
      const user = userAdminFactory.build({ id: ownerId });
      const asset = assetFactory.build({ ownerId });
      authManager.setUser(user);
      setSharedLink(sharedLinkFactory.build({ allowDownload: false }));
      const assetActions = getAssetActions(() => '', asset);
      expect(assetActions.SharedLinkDownload.$if?.()).toStrictEqual(true);
    });

    it('should not allow shared link downloads if the user does not own the asset and shared link downloads are disabled', () => {
      const ownerId = 'owner';
      const user = userAdminFactory.build({ id: 'non-owner' });
      const asset = assetFactory.build({ ownerId });
      authManager.setUser(user);
      setSharedLink(sharedLinkFactory.build({ allowDownload: false }));
      const assetActions = getAssetActions(() => '', asset);
      expect(assetActions.SharedLinkDownload.$if?.()).toStrictEqual(false);
    });

    it('should allow shared link downloads if shared link downloads are enabled regardless of user', () => {
      const asset = assetFactory.build();
      setSharedLink(sharedLinkFactory.build({ allowDownload: true }));
      const assetActions = getAssetActions(() => '', asset);
      expect(assetActions.SharedLinkDownload.$if?.()).toStrictEqual(true);
    });

    it('should allow an owner to manually request image interpretation', async () => {
      const ownerId = 'owner';
      const user = userAdminFactory.build({ id: ownerId });
      const asset = assetFactory.build({ ownerId, type: AssetTypeEnum.Image, isTrashed: false });
      const formatter = vitest.fn().mockReturnValue('interpreting image');
      authManager.setUser(user);
      vitest.mocked(getFormatter).mockResolvedValue(formatter);

      const assetActions = getAssetActions(() => '', asset);
      expect(assetActions.InterpretImageJob.$if?.()).toStrictEqual(true);

      await assetActions.InterpretImageJob.onAction({
        action: assetActions.InterpretImageJob,
        event: new MouseEvent('click'),
      });

      expect(runAssetJobs).toHaveBeenCalledWith({
        assetJobsDto: { name: AssetJobName.InterpretImage, assetIds: [asset.id] },
      });
      expect(toastManager.primary).toHaveBeenCalledWith('interpreting image');
    });
  });

  describe('DownloadWithFaces', () => {
    const face: AssetFaceResponseDto = {
      id: 'face',
      imageWidth: 100,
      imageHeight: 100,
      boundingBoxX1: 10,
      boundingBoxX2: 20,
      boundingBoxY1: 10,
      boundingBoxY2: 20,
      person: null,
    };
    beforeEach(() => {
      authManager.setUser(userAdminFactory.build());
      authManager.setPreferences(preferencesFactory.build());
      setSharedLink(undefined);
      faceManager.data.length = 0;
    });
    it('requires an image in the current viewer with at least one visible face', () => {
      const asset = assetFactory.build({ type: AssetTypeEnum.Image });
      assetViewerManager.setAsset(asset);
      const actions = getAssetActions(() => '', asset);
      expect(actions.DownloadWithFaces.$if?.()).toBe(false);
      faceManager.data.push({ ...face, person: personFactory.build({ isHidden: true }) });
      expect(actions.DownloadWithFaces.$if?.()).toBe(false);
      faceManager.data.push(face);
      expect(actions.DownloadWithFaces.$if?.()).toBe(true);
      assetViewerManager.setAsset(assetFactory.build());
      expect(actions.DownloadWithFaces.$if?.()).toBe(false);
    });
    it('hides the action for shared links and videos', () => {
      const asset = assetFactory.build({ type: AssetTypeEnum.Image });
      assetViewerManager.setAsset(asset);
      faceManager.data.push(face);
      setSharedLink(sharedLinkFactory.build({ allowDownload: true }));
      expect(getAssetActions(() => '', asset).DownloadWithFaces.$if?.()).toBe(false);
      setSharedLink(undefined);
      const video = { ...asset, type: AssetTypeEnum.Video };
      assetViewerManager.setAsset(video);
      expect(getAssetActions(() => '', video).DownloadWithFaces.$if?.()).toBe(false);
    });
    it('downloads HEIC annotations under a JPEG filename and shows a toast', async () => {
      const asset = assetFactory.build({ type: AssetTypeEnum.Image, originalFileName: 'Group.HEIC' });
      assetViewerManager.setAsset(asset);
      faceManager.data.push(face);
      vitest.mocked(getAssetAnnotatedUrl).mockReturnValue('/annotated');
      const action = getAssetActions(String, asset).DownloadWithFaces;
      await action.onAction({ action, event: new MouseEvent('click') });
      expect(getAssetAnnotatedUrl).toHaveBeenCalledWith(asset.id);
      expect(downloadUrl).toHaveBeenCalledWith('/annotated', 'Group (faces).jpg');
      expect(toastManager.info).toHaveBeenCalledWith('downloading_photo_with_faces');
    });
  });

  describe('handleDownloadAsset', () => {
    it('should use the asset originalFileName when showing toasts', async () => {
      const $t = vitest.fn().mockReturnValue('formatter');
      vitest.mocked(getFormatter).mockResolvedValue($t);
      const asset = assetFactory.build({ originalFileName: 'asset.heic' });
      await handleDownloadAsset(asset, { edited: false });
      expect($t).toHaveBeenNthCalledWith(1, 'downloading_asset_filename', { values: { filename: 'asset.heic' } });
      expect(toastManager.primary).toHaveBeenCalledWith('formatter');
    });

    it('should use the motion asset originalFileName when showing toasts', async () => {
      const $t = vitest.fn().mockReturnValue('formatter');
      vitest.mocked(getFormatter).mockResolvedValue($t);
      const motionAsset = assetFactory.build({ originalFileName: 'asset.mov' });
      vitest.mocked(getAssetInfo).mockResolvedValue(motionAsset);
      const asset = assetFactory.build({ originalFileName: 'asset.heic', livePhotoVideoId: '1' });
      await handleDownloadAsset(asset, { edited: false });
      expect($t).toHaveBeenNthCalledWith(1, 'downloading_asset_filename', { values: { filename: 'asset.heic' } });
      expect($t).toHaveBeenNthCalledWith(2, 'downloading_asset_filename', { values: { filename: 'asset-motion.mov' } });
      expect(toastManager.primary).toHaveBeenCalledWith('formatter');
    });
  });
});
