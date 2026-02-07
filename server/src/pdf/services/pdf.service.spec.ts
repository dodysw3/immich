import { PdfService } from 'src/pdf/services/pdf.service';
import { newTestService, ServiceMocks } from 'test/utils';
import { beforeEach, vitest } from 'vitest';

vitest.useFakeTimers();

describe(PdfService.name, () => {
  let sut: PdfService;
  let mocks: ServiceMocks;

  beforeEach(() => {
    ({ sut, mocks } = newTestService(PdfService));
  });

  it('should work', () => {
    expect(sut).toBeDefined();
  });

  describe('getPdfAssets', () => {
    it('should get all PDF assets for the user', async () => {
      const auth = { user: { id: 'user-id' } } as any;

      mocks.assetRepository.getAll.mockResolvedValue([]);
      mocks.databaseRepository.db = {
        selectFrom: vitest.fn().mockReturnThis(),
        where: vitest.fn().mockReturnThis(),
        selectAll: vitest.fn().mockReturnThis(),
        execute: vitest.fn().mockResolvedValue([]),
      } as any;

      await sut.getPdfAssets(auth);

      expect(mocks.assetRepository.getAll).toHaveBeenCalled();
    });
  });

  describe('getPdfAsset', () => {
    it('should throw error if asset not found', async () => {
      const auth = { user: { id: 'user-id' } } as any;
      const assetId = 'asset-id';

      mocks.assetRepository.getById.mockResolvedValue(null);

      await expect(sut.getPdfAsset(auth, assetId)).rejects.toThrow('Asset not found');
    });

    it('should throw error if asset is not a PDF', async () => {
      const auth = { user: { id: 'user-id' } } as any;
      const assetId = 'asset-id';

      mocks.assetRepository.getById.mockResolvedValue({
        id: assetId,
        type: 'image',
        originalPath: '/path/to/image.jpg',
      } as any);

      await expect(sut.getPdfAsset(auth, assetId)).rejects.toThrow('Asset is not a PDF');
    });
  });

  describe('getPdfPages', () => {
    it('should throw error if asset not found', async () => {
      const auth = { user: { id: 'user-id' } } as any;
      const assetId = 'asset-id';

      mocks.assetRepository.getById.mockResolvedValue(null);

      await expect(sut.getPdfPages(auth, assetId)).rejects.toThrow('Asset not found');
    });
  });

  describe('getPdfPage', () => {
    it('should throw error if asset not found', async () => {
      const auth = { user: { id: 'user-id' } } as any;
      const assetId = 'asset-id';
      const pageNumber = 1;

      mocks.assetRepository.getById.mockResolvedValue(null);

      await expect(sut.getPdfPage(auth, assetId, pageNumber)).rejects.toThrow('Asset not found');
    });
  });

  describe('getPdfDownloadPath', () => {
    it('should throw error if asset not found', async () => {
      const auth = { user: { id: 'user-id' } } as any;
      const assetId = 'asset-id';

      mocks.assetRepository.getById.mockResolvedValue(null);

      await expect(sut.getPdfDownloadPath(auth, assetId)).rejects.toThrow('Asset not found');
    });
  });

  describe('getPageImagePath', () => {
    it('should throw error if page not found', async () => {
      const pageId = 'page-id';

      mocks.pdfPageRepository.getById.mockResolvedValue(null);

      await expect(sut.getPageImagePath(pageId)).rejects.toThrow('Page not found');
    });

    it('should throw error if asset not found', async () => {
      const pageId = 'page-id';

      mocks.pdfPageRepository.getById.mockResolvedValue({
        id: pageId,
        assetId: 'asset-id',
        thumbnailPath: '/path/to/thumb.webp',
      } as any);

      mocks.assetRepository.getById.mockResolvedValue(null);

      await expect(sut.getPageImagePath(pageId)).rejects.toThrow('Asset not found');
    });
  });
});
