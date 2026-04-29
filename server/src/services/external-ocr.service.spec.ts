import { BadRequestException } from '@nestjs/common';
import { AssetType, AssetVisibility } from 'src/enum';
import { ExternalOcrService } from 'src/services/external-ocr.service';
import { authStub } from 'test/fixtures/auth.stub';
import { systemConfigStub } from 'test/fixtures/system-config.stub';
import { newTestService, ServiceMocks } from 'test/utils';

describe(ExternalOcrService.name, () => {
  let sut: ExternalOcrService;
  let mocks: ServiceMocks;

  beforeEach(() => {
    ({ sut, mocks } = newTestService(ExternalOcrService));

    mocks.access.asset.checkOwnerAccess.mockResolvedValue(new Set(['asset-1']));
    mocks.asset.getById.mockResolvedValue({ id: 'asset-1' } as any);
    mocks.systemMetadata.get.mockResolvedValue(systemConfigStub.machineLearningEnabled);
  });

  it('should write replace-mode OCR and tokenize search text when omitted', async () => {
    const response = await sut.writeResult(authStub.admin, 'asset-1', {
      provider: 'immich-ocr-gpu',
      model: 'paddleocr+trocr-base-printed',
      modelRevision: 'v1.0.0',
      sourceChecksum: 'abc123',
      mode: 'replace',
      processedAt: '2026-02-28T00:00:00.000Z',
      lines: [
        {
          x1: 0,
          y1: 0,
          x2: 1,
          y2: 0,
          x3: 1,
          y3: 1,
          x4: 0,
          y4: 1,
          boxScore: 0.9,
          textScore: 0.8,
          text: 'Hello World',
        },
      ],
    });

    expect(mocks.ocr.upsert).toHaveBeenCalledWith(
      'asset-1',
      [
        expect.objectContaining({
          assetId: 'asset-1',
          text: 'Hello World',
          isVisible: true,
        }),
      ],
      'Hello World',
    );

    expect(mocks.asset.upsertMetadata).toHaveBeenCalledWith(
      'asset-1',
      expect.arrayContaining([
        expect.objectContaining({ key: 'external.ocr.v1' }),
        expect.objectContaining({ key: 'external.ocr.status' }),
      ]),
    );

    expect(response).toEqual({ written: 1, searchTextLength: 11 });
  });

  it('should merge existing OCR data in merge mode', async () => {
    mocks.ocr.getByAssetId.mockResolvedValue([
      {
        assetId: 'asset-1',
        x1: 0,
        y1: 0,
        x2: 0,
        y2: 0,
        x3: 0,
        y3: 0,
        x4: 0,
        y4: 0,
        boxScore: 1,
        textScore: 1,
        text: 'Existing',
        isVisible: true,
      },
    ] as any);

    await sut.writeResult(authStub.admin, 'asset-1', {
      provider: 'immich-ocr-gpu',
      model: 'paddleocr+trocr-base-printed',
      modelRevision: 'v1.0.0',
      sourceChecksum: 'abc123',
      mode: 'merge',
      processedAt: '2026-02-28T00:00:00.000Z',
      lines: [
        {
          x1: 0,
          y1: 0,
          x2: 1,
          y2: 0,
          x3: 1,
          y3: 1,
          x4: 0,
          y4: 1,
          boxScore: 0.9,
          textScore: 0.8,
          text: 'Incoming',
        },
      ],
    });

    expect(mocks.ocr.getByAssetId).toHaveBeenCalledWith('asset-1', { isVisible: undefined });
    expect(mocks.ocr.upsert).toHaveBeenCalledWith(
      'asset-1',
      [expect.objectContaining({ text: 'Existing' }), expect.objectContaining({ text: 'Incoming' })],
      'Existing Incoming',
    );
  });

  it('should report failure metadata', async () => {
    await sut.reportFailure(authStub.admin, 'asset-1', {
      provider: 'immich-ocr-gpu',
      reason: 'GPU OOM',
      retryCount: 2,
      retriable: true,
    });

    expect(mocks.asset.upsertMetadata).toHaveBeenCalledWith('asset-1', [
      expect.objectContaining({
        key: 'external.ocr.status',
        value: expect.objectContaining({
          status: 'failed',
          provider: 'immich-ocr-gpu',
          reason: 'GPU OOM',
          retryCount: 2,
          retriable: true,
        }),
      }),
    ]);
  });

  it('should reject when no update access', async () => {
    mocks.access.asset.checkOwnerAccess.mockResolvedValue(new Set());

    await expect(
      sut.writeResult(authStub.admin, 'asset-1', {
        provider: 'immich-ocr-gpu',
        model: 'paddleocr+trocr-base-printed',
        modelRevision: 'v1.0.0',
        sourceChecksum: 'abc123',
        mode: 'replace',
        processedAt: '2026-02-28T00:00:00.000Z',
        lines: [],
      }),
    ).rejects.toBeInstanceOf(BadRequestException);

    expect(mocks.ocr.upsert).not.toHaveBeenCalled();
  });

  describe('handleAssetCreate', () => {
    it('should set ocrAt when internal OCR is disabled for image assets', async () => {
      mocks.systemMetadata.get.mockResolvedValue(systemConfigStub.machineLearningDisabled);

      await sut.handleAssetCreate({
        asset: {
          id: 'asset-1',
          type: AssetType.Image,
          visibility: AssetVisibility.Timeline,
        } as any,
      });

      expect(mocks.asset.upsertJobStatus).toHaveBeenCalledWith({ assetId: 'asset-1', ocrAt: expect.any(Date) });
    });

    it('should skip when internal OCR is enabled', async () => {
      await sut.handleAssetCreate({
        asset: {
          id: 'asset-1',
          type: AssetType.Image,
          visibility: AssetVisibility.Timeline,
        } as any,
      });

      expect(mocks.asset.upsertJobStatus).not.toHaveBeenCalled();
    });

    it('should skip non-image and hidden assets', async () => {
      mocks.systemMetadata.get.mockResolvedValue(systemConfigStub.machineLearningDisabled);

      await sut.handleAssetCreate({
        asset: {
          id: 'asset-video',
          type: AssetType.Video,
          visibility: AssetVisibility.Timeline,
        } as any,
      });

      await sut.handleAssetCreate({
        asset: {
          id: 'asset-hidden',
          type: AssetType.Image,
          visibility: AssetVisibility.Hidden,
        } as any,
      });

      expect(mocks.asset.upsertJobStatus).not.toHaveBeenCalled();
    });
  });
});
