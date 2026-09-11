import { mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import sharp from 'sharp';
import { AiInterpretationDocument } from 'src/dtos/ai-image-interpretation.dto';
import { AssetFileType, AssetType, AssetVisibility, JobName, JobStatus } from 'src/enum';
import { AiImageInterpretationRepository } from 'src/repositories/ai-image-interpretation.repository';
import { AssetJobRepository } from 'src/repositories/asset-job.repository';
import { ConfigRepository } from 'src/repositories/config.repository';
import { JobRepository } from 'src/repositories/job.repository';
import { LoggingRepository } from 'src/repositories/logging.repository';
import {
  AiImageInterpretationClient,
  AiImageInterpretationClientError,
} from 'src/services/ai-image-interpretation.client';
import { AiImageInterpretationService } from 'src/services/ai-image-interpretation.service';
import { AssetFactory } from 'test/factories/asset.factory';
import { describe, expect, it, vi } from 'vitest';

const runKey = 'a'.repeat(64);
const config = {
  enabled: true,
  // eslint-disable-next-line unicorn/prefer-https -- the local host-gateway endpoint is HTTP by design
  url: 'http://host.docker.internal:8888/v1',
  model: 'model-a',
  quant: 'quant-a',
  promptVersion: 'prompt-a',
  timeoutMs: 900_000,
  maxEdge: 1600,
  maxPixels: 16_000_000,
  concurrency: 1,
};

const makeService = () => {
  const dependencies = {
    logger: { setContext: vi.fn(), debug: vi.fn(), warn: vi.fn(), log: vi.fn() },
    configRepository: { getEnv: vi.fn().mockReturnValue({ aiImageInterpretation: config }), getWorker: vi.fn() },
    assetJobRepository: { getForGenerateThumbnailJob: vi.fn() },
    jobRepository: { queue: vi.fn() },
    interpretationRepository: {
      claim: vi.fn(),
      get: vi.fn(),
      transitionToRunning: vi.fn(),
      complete: vi.fn(),
      fail: vi.fn(),
      failStale: vi.fn(),
      findDueRetries: vi.fn(),
      requeue: vi.fn(),
    },
    client: { interpret: vi.fn() },
  };
  const service = new AiImageInterpretationService(
    dependencies.logger as never as LoggingRepository,
    dependencies.configRepository as never as ConfigRepository,
    dependencies.assetJobRepository as never as AssetJobRepository,
    dependencies.jobRepository as never as JobRepository,
    dependencies.interpretationRepository as never as AiImageInterpretationRepository,
    dependencies.client as never as AiImageInterpretationClient,
  );
  return { service, dependencies };
};

describe(AiImageInterpretationService.name, () => {
  it('claims and queues only enabled image uploads with an unedited preview', async () => {
    const { service, dependencies } = makeService();
    const asset = AssetFactory.from({ type: AssetType.Image, visibility: AssetVisibility.Timeline })
      .files([AssetFileType.Preview])
      .build();
    dependencies.assetJobRepository.getForGenerateThumbnailJob.mockResolvedValue(asset);
    dependencies.interpretationRepository.claim.mockResolvedValue({ alreadyExists: false, runKey, run: {} });

    await service.onThumbnailGenerated({ assetId: asset.id, source: 'upload' });

    expect(dependencies.interpretationRepository.claim).toHaveBeenCalledWith(asset.id, {
      model: config.model,
      quant: config.quant,
      promptVersion: config.promptVersion,
    });
    expect(dependencies.jobRepository.queue).toHaveBeenCalledWith({
      name: JobName.AssetInterpretImage,
      data: { id: asset.id, runKey, source: 'upload' },
    });
  });

  it('ignores disabled mode, non-upload sources, hidden assets, and duplicate claims', async () => {
    const { service, dependencies } = makeService();
    const asset = AssetFactory.from({ visibility: AssetVisibility.Hidden }).files([AssetFileType.Preview]).build();
    dependencies.assetJobRepository.getForGenerateThumbnailJob.mockResolvedValue(asset);

    await service.onThumbnailGenerated({ assetId: asset.id, source: 'edit' });
    expect(dependencies.assetJobRepository.getForGenerateThumbnailJob).not.toHaveBeenCalled();

    dependencies.configRepository.getEnv.mockReturnValue({ aiImageInterpretation: { ...config, enabled: false } });
    await service.onThumbnailGenerated({ assetId: asset.id, source: 'upload' });
    expect(dependencies.assetJobRepository.getForGenerateThumbnailJob).not.toHaveBeenCalled();

    dependencies.configRepository.getEnv.mockReturnValue({ aiImageInterpretation: config });
    dependencies.assetJobRepository.getForGenerateThumbnailJob.mockResolvedValue({
      ...asset,
      visibility: AssetVisibility.Timeline,
      type: AssetType.Video,
    });
    await service.onThumbnailGenerated({ assetId: asset.id, source: 'upload' });
    expect(dependencies.interpretationRepository.claim).not.toHaveBeenCalled();

    dependencies.assetJobRepository.getForGenerateThumbnailJob.mockResolvedValue({
      ...asset,
      visibility: AssetVisibility.Timeline,
      type: AssetType.Image,
    });
    dependencies.interpretationRepository.claim.mockResolvedValue({ alreadyExists: true, runKey, run: {} });
    await service.onThumbnailGenerated({ assetId: asset.id, source: 'upload' });

    expect(dependencies.jobRepository.queue).not.toHaveBeenCalled();
  });

  it('skips duplicate deliveries, records client failures, and schedules a retry', async () => {
    const { service, dependencies } = makeService();
    dependencies.interpretationRepository.transitionToRunning.mockResolvedValue(false);

    await expect(service.handleInterpretation({ id: 'asset-1', runKey } as never)).resolves.toBe(JobStatus.Skipped);
    expect(dependencies.client.interpret).not.toHaveBeenCalled();

    dependencies.interpretationRepository.transitionToRunning.mockResolvedValue(true);
    dependencies.interpretationRepository.get.mockResolvedValue({
      schemaVersion: 1,
      runs: { [runKey]: { model: config.model, quant: config.quant, promptVersion: config.promptVersion } },
    } as AiInterpretationDocument);
    dependencies.assetJobRepository.getForGenerateThumbnailJob.mockResolvedValue(
      AssetFactory.create({ type: AssetType.Image, visibility: AssetVisibility.Timeline }),
    );
    const internals = service as never as { preparePreview: ReturnType<typeof vi.fn> };
    internals.preparePreview = vi.fn().mockResolvedValue({
      buffer: Buffer.from('preview'),
      input: { source: 'preview', width: 100, height: 80, mimeType: 'image/jpeg' },
    });
    dependencies.client.interpret.mockRejectedValue(new AiImageInterpretationClientError('timeout', 'secret details'));

    await expect(service.handleInterpretation({ id: 'asset-1', runKey } as never)).resolves.toBe(JobStatus.Success);
    expect(dependencies.interpretationRepository.fail).toHaveBeenCalledWith(
      'asset-1',
      runKey,
      { code: 'timeout', message: 'secret details' },
      expect.objectContaining({ durationMs: expect.any(Number) }),
      expect.objectContaining({ source: 'preview' }),
      expect.any(Date),
      { retry: true },
    );

    dependencies.client.interpret.mockRejectedValue(
      new AiImageInterpretationClientError('feature_disabled', 'AI interpretation is disabled'),
    );
    dependencies.interpretationRepository.fail.mockClear();
    await expect(service.handleInterpretation({ id: 'asset-1', runKey } as never)).resolves.toBe(JobStatus.Success);
    expect(dependencies.interpretationRepository.fail).toHaveBeenCalledWith(
      'asset-1',
      runKey,
      { code: 'feature_disabled', message: 'AI interpretation is disabled' },
      expect.objectContaining({ durationMs: expect.any(Number) }),
      expect.objectContaining({ source: 'preview' }),
      expect.any(Date),
      { retry: false },
    );
  });

  it('claims a missing tuple for a manual delivery before running', async () => {
    const { service, dependencies } = makeService();
    const asset = AssetFactory.from({ type: AssetType.Image, visibility: AssetVisibility.Timeline })
      .files([AssetFileType.Preview])
      .build();
    dependencies.assetJobRepository.getForGenerateThumbnailJob.mockResolvedValue(asset);
    dependencies.interpretationRepository.claim.mockResolvedValue({ alreadyExists: false, runKey, run: {} });
    dependencies.interpretationRepository.transitionToRunning.mockResolvedValue(true);
    dependencies.interpretationRepository.get.mockResolvedValue({
      schemaVersion: 1,
      runs: { [runKey]: { model: config.model, quant: config.quant, promptVersion: config.promptVersion } },
    } as AiInterpretationDocument);
    const internals = service as never as { preparePreview: ReturnType<typeof vi.fn> };
    internals.preparePreview = vi.fn().mockResolvedValue({
      buffer: Buffer.from('preview'),
      input: { source: 'preview', width: 100, height: 80, mimeType: 'image/jpeg' },
    });
    dependencies.client.interpret.mockResolvedValue({ result: {} as never });

    await expect(service.handleInterpretation({ id: asset.id } as never)).resolves.toBe(JobStatus.Success);

    expect(dependencies.interpretationRepository.claim).toHaveBeenCalledWith(asset.id, {
      model: config.model,
      quant: config.quant,
      promptVersion: config.promptVersion,
    });
    expect(dependencies.interpretationRepository.transitionToRunning).toHaveBeenCalledWith(asset.id, runKey);
    expect(dependencies.client.interpret).toHaveBeenCalledWith(Buffer.from('preview'), { model: config.model });
  });

  it('prepares an orientation-correct bounded JPEG and rejects oversized or missing previews', async () => {
    const { service, dependencies } = makeService();
    const directory = mkdtempSync(join(tmpdir(), 'ai-interpretation-'));
    const previewPath = join(directory, 'preview.jpg');

    try {
      const preview = await sharp({
        create: { width: 2000, height: 1000, channels: 3, background: { r: 20, g: 40, b: 60 } },
      })
        .withMetadata({ orientation: 6 })
        .jpeg()
        .toBuffer();
      writeFileSync(previewPath, preview);
      const asset = AssetFactory.from({ type: AssetType.Image, visibility: AssetVisibility.Timeline })
        .files([{ type: AssetFileType.Preview, path: previewPath }])
        .build();
      const internals = service as never as {
        preparePreview: (asset: unknown) => Promise<{ buffer: Buffer; input: { width: number; height: number } }>;
      };

      const prepared = await internals.preparePreview(asset);
      expect(prepared.input).toMatchObject({ source: 'preview', mimeType: 'image/jpeg' });
      expect(prepared.input.height).toBeGreaterThan(prepared.input.width);
      expect(Math.max(prepared.input.width, prepared.input.height)).toBe(1600);

      dependencies.configRepository.getEnv.mockReturnValue({
        aiImageInterpretation: { ...config, maxPixels: 100 },
      });
      await expect(internals.preparePreview(asset)).rejects.toMatchObject({ code: 'preview_too_large' });
      await expect(internals.preparePreview({ ...asset, files: [] })).rejects.toMatchObject({
        code: 'preview_missing',
      });
      await expect(
        internals.preparePreview({
          ...asset,
          files: asset.files.map((file) => ({ ...file, path: join(directory, 'missing.jpg') })),
        }),
      ).rejects.toMatchObject({ code: 'preview_invalid' });
    } finally {
      rmSync(directory, { recursive: true, force: true });
    }
  });

  it('reconciles stale runs and dispatches due retries', async () => {
    const { service, dependencies } = makeService();
    dependencies.interpretationRepository.failStale.mockResolvedValue(2);
    dependencies.interpretationRepository.findDueRetries.mockResolvedValue([
      { assetId: 'asset-1', runKey },
      { assetId: 'asset-2', runKey },
    ]);
    dependencies.interpretationRepository.requeue.mockResolvedValue(true);

    await expect(service.handleReconcile()).resolves.toBe(JobStatus.Success);

    expect(dependencies.interpretationRepository.failStale).toHaveBeenCalledWith(
      expect.any(Date),
      expect.any(Date),
    );
    expect(dependencies.interpretationRepository.findDueRetries).toHaveBeenCalledWith(expect.any(Date));
    expect(dependencies.interpretationRepository.requeue).toHaveBeenCalledTimes(2);
    expect(dependencies.jobRepository.queue).toHaveBeenCalledWith({
      name: JobName.AssetInterpretImage,
      data: { id: 'asset-1', runKey },
    });
    expect(dependencies.jobRepository.queue).toHaveBeenCalledWith({
      name: JobName.AssetInterpretImage,
      data: { id: 'asset-2', runKey },
    });
  });

  it('skips due retries that another trigger already requeued', async () => {
    const { service, dependencies } = makeService();
    dependencies.interpretationRepository.failStale.mockResolvedValue(0);
    dependencies.interpretationRepository.findDueRetries.mockResolvedValue([{ assetId: 'asset-1', runKey }]);
    dependencies.interpretationRepository.requeue.mockResolvedValue(false);

    await expect(service.handleReconcile()).resolves.toBe(JobStatus.Success);

    expect(dependencies.jobRepository.queue).not.toHaveBeenCalled();
  });
});
