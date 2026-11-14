import { beforeEach, describe, expect, it, vi } from 'vitest';

const sharpChain = {
  rotate: vi.fn(),
  resize: vi.fn(),
  jpeg: vi.fn(),
  toBuffer: vi.fn().mockResolvedValue(Buffer.from('jpeg')),
};
vi.mock('sharp', () => ({
  default: vi.fn(() => {
    sharpChain.rotate.mockReturnValue(sharpChain);
    sharpChain.resize.mockReturnValue(sharpChain);
    sharpChain.jpeg.mockReturnValue(sharpChain);
    return sharpChain;
  }),
}));
import { RotationSuggestionDocument } from 'src/dtos/rotation-suggestion.dto.js';
import { AssetEditAction } from 'src/dtos/editing.dto.js';
import { AssetType } from 'src/enum.js';
import { AccessRepository } from 'src/repositories/access.repository.js';
import { AssetEditRepository } from 'src/repositories/asset-edit.repository.js';
import { AssetJobRepository } from 'src/repositories/asset-job.repository.js';
import { AssetRepository } from 'src/repositories/asset.repository.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { MachineLearningRepository } from 'src/repositories/machine-learning.repository.js';
import { RotationSuggestionRepository } from 'src/repositories/rotation-suggestion.repository.js';
import { AssetService } from 'src/services/asset.service.js';
import { OrientationSuggestionService } from 'src/services/orientation-suggestion.service.js';
import { authStub } from 'test/fixtures/auth.stub.js';
import { mockEnvData } from 'test/repositories/config.repository.mock.js';
import { createRotationSuggestionRunKey } from 'src/utils/rotation-suggestion.js';

const runKey = createRotationSuggestionRunKey('rightwayup', 'fast', 'orientation-1.0.0');

const document = (runs: Record<string, unknown>): RotationSuggestionDocument =>
  ({ schemaVersion: 1, runs }) as unknown as RotationSuggestionDocument;

const makeRun = (overrides: Record<string, unknown> = {}) => ({
  model: 'rightwayup',
  tier: 'fast',
  predictedRotation: 90,
  confidence: 0.9,
  abstain: false,
  status: 'pending',
  startedAt: '2026-11-14T00:00:00.000Z',
  finishedAt: '2026-11-14T00:00:00.050Z',
  ...overrides,
});

const eligibleAsset = {
  type: AssetType.Image,
  livePhotoVideoId: null,
  originalPath: '/photos/a.jpg',
  originalFileName: 'a.jpg',
  projectionType: null,
  orientation: null,
  exifImageWidth: 4000,
  exifImageHeight: 3000,
};

const makeService = (envOverrides: Record<string, unknown> = {}) => {
  const configRepository = {
    getEnv: vi.fn().mockReturnValue(
      mockEnvData({
        orientationSuggestion: { enabled: true, modelTier: 'fast' as const, threshold: 0.5, ...envOverrides },
      }),
    ),
    getWorker: vi.fn().mockReturnValue('microservices'),
  } as unknown as ConfigRepository;
  const accessRepository = {
    asset: {
      checkOwnerAccess: vi.fn().mockResolvedValue(new Set(['asset-1'])),
      checkAlbumAccess: vi.fn().mockResolvedValue(new Set()),
      checkPartnerAccess: vi.fn().mockResolvedValue(new Set()),
      checkSharedLinkAccess: vi.fn().mockResolvedValue(new Set()),
    },
  } as unknown as AccessRepository;
  const assetRepository = { getForEdit: vi.fn().mockResolvedValue(eligibleAsset) } as unknown as AssetRepository;
  const assetJobRepository = {
    getForOcr: vi.fn().mockResolvedValue({ ownerId: 'user-1', visibility: 'timeline', previewFile: '/preview.jpg' }),
    streamForOrientationSuggestion: vi.fn().mockReturnValue([]),
  } as unknown as AssetJobRepository;
  const jobRepository = { queue: vi.fn().mockResolvedValue(undefined), queueAll: vi.fn().mockResolvedValue(undefined) };
  const machineLearningRepository = {
    orientation: vi.fn().mockResolvedValue({ angleCw: 270, correctionCw: 90, confidence: 0.93, abstain: false, routed: false, tier: 'fast' }),
  } as unknown as MachineLearningRepository;
  const rotationSuggestionRepository = {
    get: vi.fn().mockResolvedValue(null),
    getLatestRun: vi.fn().mockResolvedValue(null),
    recordRun: vi.fn().mockResolvedValue({ runKey, preserved: false }),
    setStatus: vi.fn().mockImplementation((_assetId: string, _runKey: string, status: string) =>
      Promise.resolve(makeRun({ status })),
    ),
    listDocuments: vi.fn().mockResolvedValue([]),
  } as unknown as RotationSuggestionRepository;
  const assetEditRepository = { getAll: vi.fn().mockResolvedValue([]) } as unknown as AssetEditRepository;
  const assetService = {
    editAsset: vi.fn().mockResolvedValue({ assetId: 'asset-1', edits: [] }),
    removeAssetEdits: vi.fn().mockResolvedValue({ assetId: 'asset-1', edits: [] }),
  } as unknown as AssetService;
  const logger = {
    setContext: vi.fn().mockReturnThis(),
    debug: vi.fn(),
    log: vi.fn(),
    warn: vi.fn(),
    error: vi.fn(),
  } as unknown as LoggingRepository;

  const sut = new OrientationSuggestionService(
    logger,
    configRepository,
    assetRepository,
    assetJobRepository,
    jobRepository as never,
    machineLearningRepository,
    rotationSuggestionRepository,
    assetEditRepository,
    accessRepository,
    assetService,
  );

  return {
    sut,
    accessRepository,
    assetRepository,
    assetJobRepository,
    jobRepository,
    machineLearningRepository,
    rotationSuggestionRepository,
    assetEditRepository,
    assetService,
  };
};

describe(OrientationSuggestionService.name, () => {
  beforeEach(() => {
    vi.unstubAllEnvs();
  });

  describe('handleSuggestion', () => {
    it('skips when the feature is disabled', async () => {
      const { sut, machineLearningRepository, rotationSuggestionRepository } = makeService({ enabled: false });
      expect(await sut.handleSuggestion({ id: 'asset-1' })).toBe('skipped');
      expect(machineLearningRepository.orientation).not.toHaveBeenCalled();
      expect(rotationSuggestionRepository.recordRun).not.toHaveBeenCalled();
    });

    it('skips ineligible assets', async () => {
      const { sut, assetRepository, machineLearningRepository } = makeService();
      assetRepository.getForEdit = vi.fn().mockResolvedValue({ ...eligibleAsset, type: AssetType.Video });
      expect(await sut.handleSuggestion({ id: 'asset-1' })).toBe('skipped');
      expect(machineLearningRepository.orientation).not.toHaveBeenCalled();
    });

    it('persists a pending run with the suggested correction', async () => {
      const { sut, rotationSuggestionRepository } = makeService();
      expect(await sut.handleSuggestion({ id: 'asset-1' })).toBe('success');
      expect(rotationSuggestionRepository.recordRun).toHaveBeenCalledWith(
        'asset-1',
        runKey,
        expect.objectContaining({ model: 'rightwayup', tier: 'fast', predictedRotation: 90, abstain: false, status: 'pending' }),
      );
    });

    it('records an abstention below the threshold (no rotation class)', async () => {
      const { sut, machineLearningRepository, rotationSuggestionRepository } = makeService();
      (machineLearningRepository.orientation as ReturnType<typeof vi.fn>).mockResolvedValue({
        angleCw: 180,
        correctionCw: 180,
        confidence: 0.31,
        abstain: false,
        routed: false,
        tier: 'fast',
      });

      await sut.handleSuggestion({ id: 'asset-1' });
      expect(rotationSuggestionRepository.recordRun).toHaveBeenCalledWith(
        'asset-1',
        runKey,
        expect.objectContaining({ predictedRotation: null, abstain: true, confidence: 0.31 }),
      );
    });

    it('records a native abstention (no rotation class)', async () => {
      const { sut, machineLearningRepository, rotationSuggestionRepository } = makeService();
      (machineLearningRepository.orientation as ReturnType<typeof vi.fn>).mockResolvedValue({
        angleCw: 45,
        correctionCw: 315,
        confidence: 0.8,
        abstain: true,
        routed: false,
        tier: 'fast',
      });

      await sut.handleSuggestion({ id: 'asset-1' });
      expect(rotationSuggestionRepository.recordRun).toHaveBeenCalledWith(
        'asset-1',
        runKey,
        expect.objectContaining({ predictedRotation: null, abstain: true }),
      );
    });

    it('does not resurrect a dismissed run on same-identity re-run', async () => {
      const { sut, rotationSuggestionRepository } = makeService();
      (rotationSuggestionRepository.recordRun as ReturnType<typeof vi.fn>).mockResolvedValue({
        runKey,
        preserved: true,
      });

      await sut.handleSuggestion({ id: 'asset-1' });
      expect(rotationSuggestionRepository.recordRun).toHaveBeenCalled();
    });
  });

  describe('handleQueueAll', () => {
    it('queues every image asset at the backfill tier', async () => {
      const { sut, assetJobRepository, jobRepository } = makeService();
      assetJobRepository.streamForOrientationSuggestion = vi.fn().mockReturnValue([
        { id: 'asset-1' },
        { id: 'asset-2' },
      ]);
      expect(await sut.handleQueueAll()).toBe('success');
      expect(jobRepository.queueAll).toHaveBeenCalledWith([
        { name: 'AssetOrientationSuggestion', data: { id: 'asset-1', priority: 3 } },
        { name: 'AssetOrientationSuggestion', data: { id: 'asset-2', priority: 3 } },
      ]);
    });

    it('skips when disabled', async () => {
      const { sut, jobRepository } = makeService({ enabled: false });
      expect(await sut.handleQueueAll()).toBe('skipped');
      expect(jobRepository.queueAll).not.toHaveBeenCalled();
    });
  });

  describe('get', () => {
    it('responds as if no suggestion exists without read access', async () => {
      const { sut, accessRepository, rotationSuggestionRepository } = makeService();
      (accessRepository.asset.checkOwnerAccess as ReturnType<typeof vi.fn>).mockResolvedValue(new Set());
      expect(await sut.get(authStub.admin, 'asset-1')).toBeNull();
      expect(rotationSuggestionRepository.getLatestRun).not.toHaveBeenCalled();
    });

    it('returns the latest run and reconciles applied → pending when the rotate edit is gone', async () => {
      const { sut, rotationSuggestionRepository, assetEditRepository } = makeService();
      (rotationSuggestionRepository.getLatestRun as ReturnType<typeof vi.fn>).mockResolvedValue({
        runKey,
        run: makeRun({ status: 'applied' }),
      });
      const response = await sut.get(authStub.admin, 'asset-1');

      expect(response).toEqual(
        expect.objectContaining({ assetId: 'asset-1', runKey, status: 'pending', predictedRotation: 90 }),
      );
      expect(assetEditRepository.getAll).toHaveBeenCalledWith('asset-1');
    });

    it('reconciles pending → applied when the rotation already matches asset_edit', async () => {
      const { sut, rotationSuggestionRepository, assetEditRepository } = makeService();
      (rotationSuggestionRepository.getLatestRun as ReturnType<typeof vi.fn>).mockResolvedValue({
        runKey,
        run: makeRun({ status: 'pending' }),
      });
      (assetEditRepository.getAll as ReturnType<typeof vi.fn>).mockResolvedValue([
        { action: AssetEditAction.Rotate, parameters: { angle: 90 } },
      ]);

      const response = await sut.get(authStub.admin, 'asset-1');
      expect(response?.status).toBe('applied');
    });

    it('returns null when no run exists', async () => {
      const { sut } = makeService();
      expect(await sut.get(authStub.admin, 'asset-1')).toBeNull();
    });
  });

  describe('apply', () => {
    it('creates a single rotate edit on an asset without prior edits', async () => {
      const { sut, rotationSuggestionRepository, assetService } = makeService();
      (rotationSuggestionRepository.getLatestRun as ReturnType<typeof vi.fn>).mockResolvedValue({
        runKey,
        run: makeRun(),
      });

      const response = await sut.apply(authStub.admin, 'asset-1');
      expect(assetService.editAsset).toHaveBeenCalledWith(authStub.admin, 'asset-1', {
        edits: [{ action: AssetEditAction.Rotate, parameters: { angle: 90 } }],
      });
      expect(rotationSuggestionRepository.setStatus).toHaveBeenCalledWith('asset-1', runKey, 'applied');
      expect(response.status).toBe('applied');
    });

    it('composes with an existing rotate 270 into 0 (rotate dropped)', async () => {
      const { sut, rotationSuggestionRepository, assetService, assetEditRepository } = makeService();
      (rotationSuggestionRepository.getLatestRun as ReturnType<typeof vi.fn>).mockResolvedValue({
        runKey,
        run: makeRun(),
      });
      (assetEditRepository.getAll as ReturnType<typeof vi.fn>).mockResolvedValue([
        { id: 'e1', action: AssetEditAction.Rotate, parameters: { angle: 270 } },
      ]);

      await sut.apply(authStub.admin, 'asset-1');
      // 270 + 90 = 0 → the rotate edit is dropped, no other edits remain →
      // removeAssetEdits clears the list.
      expect(assetService.removeAssetEdits).toHaveBeenCalledWith(authStub.admin, 'asset-1');
      expect(assetService.editAsset).not.toHaveBeenCalled();
    });

    it('composes with an existing rotate 90 into 180, preserving crop-first ordering', async () => {
      const { sut, rotationSuggestionRepository, assetService, assetEditRepository } = makeService();
      (rotationSuggestionRepository.getLatestRun as ReturnType<typeof vi.fn>).mockResolvedValue({
        runKey,
        run: makeRun({ predictedRotation: 90 }),
      });
      (assetEditRepository.getAll as ReturnType<typeof vi.fn>).mockResolvedValue([
        { id: 'e1', action: AssetEditAction.Crop, parameters: { x: 0, y: 0, width: 10, height: 10 } },
        { id: 'e2', action: AssetEditAction.Mirror, parameters: { axis: 'horizontal' } },
        { id: 'e3', action: AssetEditAction.Rotate, parameters: { angle: 90 } },
      ]);

      await sut.apply(authStub.admin, 'asset-1');
      const call = (assetService.editAsset as ReturnType<typeof vi.fn>).mock.calls[0];
      expect(call[2].edits).toEqual([
        { action: AssetEditAction.Crop, parameters: { x: 0, y: 0, width: 10, height: 10 } },
        { action: AssetEditAction.Mirror, parameters: { axis: 'horizontal' } },
        { action: AssetEditAction.Rotate, parameters: { angle: 180 } },
      ]);
    });

    it('rejects applying an abstaining suggestion', async () => {
      const { sut, rotationSuggestionRepository } = makeService();
      (rotationSuggestionRepository.getLatestRun as ReturnType<typeof vi.fn>).mockResolvedValue({
        runKey,
        run: makeRun({ abstain: true, predictedRotation: null }),
      });

      await expect(sut.apply(authStub.admin, 'asset-1')).rejects.toThrowError(/does not propose a rotation/);
    });

    it('rejects applying when no suggestion exists', async () => {
      const { sut } = makeService();
      await expect(sut.apply(authStub.admin, 'asset-1')).rejects.toThrowError(/No rotation suggestion exists/);
    });
  });

  describe('dismiss', () => {
    it('sets the latest run to dismissed', async () => {
      const { sut, rotationSuggestionRepository } = makeService();
      (rotationSuggestionRepository.getLatestRun as ReturnType<typeof vi.fn>).mockResolvedValue({
        runKey,
        run: makeRun(),
      });

      const response = await sut.dismiss(authStub.admin, 'asset-1');
      expect(rotationSuggestionRepository.setStatus).toHaveBeenCalledWith('asset-1', runKey, 'dismissed');
      expect(response.status).toBe('dismissed');
    });

    it('rejects dismissing an already-applied run', async () => {
      const { sut, rotationSuggestionRepository } = makeService();
      (rotationSuggestionRepository.getLatestRun as ReturnType<typeof vi.fn>).mockResolvedValue({
        runKey,
        run: makeRun({ status: 'applied' }),
      });
      (rotationSuggestionRepository.setStatus as ReturnType<typeof vi.fn>).mockResolvedValue(null);

      await expect(sut.dismiss(authStub.admin, 'asset-1')).rejects.toThrowError(/not dismissible/);
    });
  });

  describe('listPending', () => {
    it('returns only the owner\'s actionable pending suggestions', async () => {
      const { sut, rotationSuggestionRepository } = makeService();
      (rotationSuggestionRepository.listDocuments as ReturnType<typeof vi.fn>).mockResolvedValue([
        { assetId: 'asset-1', ownerId: authStub.admin.user.id, document: document({ [runKey]: makeRun() }) },
        { assetId: 'asset-2', ownerId: 'someone-else', document: document({ [runKey]: makeRun() }) },
        { assetId: 'asset-3', ownerId: authStub.admin.user.id, document: document({ [runKey]: makeRun({ abstain: true, predictedRotation: null }) }) },
        { assetId: 'asset-4', ownerId: authStub.admin.user.id, document: document({ [runKey]: makeRun({ predictedRotation: 0 }) }) },
        { assetId: 'asset-5', ownerId: authStub.admin.user.id, document: document({ [runKey]: makeRun({ status: 'dismissed' }) }) },
      ]);

      const results = await sut.listPending(authStub.admin);
      expect(results.map(({ assetId }) => assetId)).toEqual(['asset-1']);
    });
  });
});
