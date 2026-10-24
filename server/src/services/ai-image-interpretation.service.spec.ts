import { mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import sharp from 'sharp';
import { beforeEach, describe, expect, it, vi } from 'vitest';
import { AiInterpretationDocument } from 'src/dtos/ai-image-interpretation.dto.js';
import { AssetFileType, AssetType, AssetVisibility, JobName, JobStatus, QueueName } from 'src/enum.js';
import { AiImageInterpretationRepository } from 'src/repositories/ai-image-interpretation.repository.js';
import { AssetJobRepository } from 'src/repositories/asset-job.repository.js';
import { AssetRepository } from 'src/repositories/asset.repository.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { JobRepository } from 'src/repositories/job.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { SystemMetadataRepository } from 'src/repositories/system-metadata.repository.js';
import {
  AiImageInterpretationClient,
  AiImageInterpretationClientError,
} from 'src/services/ai-image-interpretation.client.js';
import { AiImageInterpretationService } from 'src/services/ai-image-interpretation.service.js';
import { createAiInterpretationPublicRunKey } from 'src/utils/ai-image-interpretation.js';
import { clearConfigCache } from 'src/utils/config.js';
import { AssetFactory } from 'test/factories/asset.factory.js';

const runKey = 'a'.repeat(64);
const config = {
  enabled: true,
  // eslint-disable-next-line unicorn/prefer-https -- the local host-gateway endpoint is HTTP by design
  url: 'http://host.docker.internal:8888/v1',
  // eslint-disable-next-line unicorn/prefer-https -- the public hybrid route is HTTP by design
  publicUrl: 'http://host.docker.internal:51900/public/v1',
  publicModel: 'mai/muse-spark-1.3-contributor',
  model: 'model-a',
  quant: 'quant-a',
  promptVersion: 'prompt-a',
  timeoutMs: 900_000,
  maxEdge: 1600,
  maxPixels: 16_000_000,
  concurrency: 1,
  discord: { webhookUrl: 'https://discord.com/api/webhooks/123/token', includeThumbnail: true },
};

const publicRunKey = createAiInterpretationPublicRunKey(config.publicModel, config.promptVersion);

const makeService = () => {
  const dependencies = {
    logger: { setContext: vi.fn(), debug: vi.fn(), warn: vi.fn(), error: vi.fn(), log: vi.fn() },
    configRepository: {
      getEnv: vi.fn().mockReturnValue({ aiImageInterpretation: config, aiInterpretSearch: { enabled: false } }),
      getWorker: vi.fn(),
    },
    assetJobRepository: { getForGenerateThumbnailJob: vi.fn() },
    assetRepository: {
      // Not pending by default: a detected marker lets deliveries proceed.
      getDuplicateAnalysisState: vi.fn().mockResolvedValue({
        stackId: null,
        visibility: AssetVisibility.Timeline,
        duplicatesDetectedAt: new Date(),
      }),
    },
    systemMetadataRepository: { get: vi.fn().mockResolvedValue({}) },
    jobRepository: {
      queue: vi.fn(),
      jobExists: vi.fn(),
      recordAiInterpretationCompletion: vi.fn().mockResolvedValue(undefined),
    },
    interpretationRepository: {
      claim: vi.fn(),
      get: vi.fn(),
      transitionToRunning: vi.fn(),
      complete: vi.fn(),
      completeCopy: vi.fn(),
      findCopySource: vi.fn().mockResolvedValue(null),
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
    dependencies.assetRepository as never as AssetRepository,
    dependencies.systemMetadataRepository as never as SystemMetadataRepository,
    dependencies.jobRepository as never as JobRepository,
    dependencies.interpretationRepository as never as AiImageInterpretationRepository,
    dependencies.client as never as AiImageInterpretationClient,
  );
  return { service, dependencies };
};

const makeRunningAsset = (
  service: AiImageInterpretationService,
  dependencies: ReturnType<typeof makeService>['dependencies'],
) => {
  dependencies.interpretationRepository.transitionToRunning.mockResolvedValue(true);
  dependencies.interpretationRepository.get.mockResolvedValue({
    schemaVersion: 1,
    runs: { [runKey]: { model: config.model, quant: config.quant, promptVersion: config.promptVersion } },
  } as AiInterpretationDocument);
  const asset = AssetFactory.from({ type: AssetType.Image, visibility: AssetVisibility.Timeline })
    .files([AssetFileType.Preview])
    .build();
  dependencies.assetJobRepository.getForGenerateThumbnailJob.mockResolvedValue(asset);
  service_preparePreview(service);
  return { asset };
};

const service_preparePreview = (service: AiImageInterpretationService) => {
  const internals = service as never as { preparePreview: ReturnType<typeof vi.fn> };
  internals.preparePreview = vi.fn().mockResolvedValue({
    buffer: Buffer.from('preview'),
    input: { source: 'preview', width: 100, height: 80, mimeType: 'image/jpeg' },
  });
  return internals;
};

const makePublicRun = (
  service: AiImageInterpretationService,
  dependencies: ReturnType<typeof makeService>['dependencies'],
) => {
  dependencies.interpretationRepository.transitionToRunning.mockResolvedValue(true);
  dependencies.interpretationRepository.get.mockResolvedValue({
    schemaVersion: 1,
    runs: {
      [publicRunKey]: { model: config.publicModel, quant: 'hosted', promptVersion: config.promptVersion },
    },
  } as AiInterpretationDocument);
  const asset = AssetFactory.from({ type: AssetType.Image, visibility: AssetVisibility.Timeline })
    .files([AssetFileType.Preview])
    .build();
  dependencies.assetJobRepository.getForGenerateThumbnailJob.mockResolvedValue(asset);
  service_preparePreview(service);
  return { asset };
};

const enableSkipFlag = (dependencies: ReturnType<typeof makeService>['dependencies']) => {
  dependencies.configRepository.getEnv.mockReturnValue({
    aiImageInterpretation: { ...config, skipIfInterpreted: true },
    aiInterpretSearch: { enabled: false },
  });
};

describe(AiImageInterpretationService.name, () => {
  beforeEach(() => {
    clearConfigCache();
  });

  it('claims and queues only enabled image uploads with an unedited preview after duplicate analysis', async () => {
    const { service, dependencies } = makeService();
    const asset = AssetFactory.from({ type: AssetType.Image, visibility: AssetVisibility.Timeline })
      .files([AssetFileType.Preview])
      .build();
    dependencies.assetJobRepository.getForGenerateThumbnailJob.mockResolvedValue(asset);
    dependencies.interpretationRepository.claim.mockResolvedValue({ alreadyExists: false, runKey, run: {} });

    await service.onDuplicateDetectionCompleted({ assetId: asset.id });

    expect(dependencies.interpretationRepository.claim).toHaveBeenCalledWith(asset.id, {
      model: config.model,
      quant: config.quant,
      promptVersion: config.promptVersion,
    });
    expect(dependencies.jobRepository.queue).toHaveBeenCalledWith({
      name: JobName.AssetInterpretImage,
      data: { id: asset.id, runKey, source: 'upload', priority: 2 },
    });
  });

  it('ignores disabled mode, hidden assets, and duplicate claims', async () => {
    const { service, dependencies } = makeService();
    const asset = AssetFactory.from({ visibility: AssetVisibility.Hidden }).files([AssetFileType.Preview]).build();
    dependencies.assetJobRepository.getForGenerateThumbnailJob.mockResolvedValue(asset);

    dependencies.configRepository.getEnv.mockReturnValue({
      aiImageInterpretation: { ...config, enabled: false },
      aiInterpretSearch: { enabled: false },
    });
    await service.onDuplicateDetectionCompleted({ assetId: asset.id });
    expect(dependencies.assetJobRepository.getForGenerateThumbnailJob).not.toHaveBeenCalled();

    dependencies.configRepository.getEnv.mockReturnValue({
      aiImageInterpretation: config,
      aiInterpretSearch: { enabled: false },
    });
    dependencies.assetJobRepository.getForGenerateThumbnailJob.mockResolvedValue({
      ...asset,
      visibility: AssetVisibility.Timeline,
      type: AssetType.Video,
    });
    await service.onDuplicateDetectionCompleted({ assetId: asset.id });
    expect(dependencies.interpretationRepository.claim).not.toHaveBeenCalled();

    dependencies.assetJobRepository.getForGenerateThumbnailJob.mockResolvedValue({
      ...asset,
      visibility: AssetVisibility.Timeline,
      type: AssetType.Image,
    });
    dependencies.interpretationRepository.claim.mockResolvedValue({ alreadyExists: true, runKey, run: {} });
    await service.onDuplicateDetectionCompleted({ assetId: asset.id });

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
    service_preparePreview(service);
    dependencies.client.interpret.mockRejectedValue(new AiImageInterpretationClientError('timeout', 'secret details'));

    await expect(service.handleInterpretation({ id: 'asset-1', runKey } as never)).resolves.toBe(JobStatus.Success);
    expect(dependencies.interpretationRepository.fail).toHaveBeenCalledWith(
      'asset-1',
      runKey,
      { code: 'timeout', message: 'secret details' },
      expect.objectContaining({ durationMs: expect.any(Number) }),
      expect.objectContaining({ source: 'preview' }),
      expect.any(Date),
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
    );
  });

  it('defers manual deliveries until duplicate detection has completed for the asset', async () => {
    const { service, dependencies } = makeService();
    makeRunningAsset(service, dependencies);
    dependencies.assetRepository.getDuplicateAnalysisState.mockResolvedValue({
      stackId: null,
      visibility: AssetVisibility.Timeline,
      duplicatesDetectedAt: null,
    });

    await expect(service.handleInterpretation({ id: 'asset-1', runKey } as never)).resolves.toBe(JobStatus.Success);

    expect(dependencies.interpretationRepository.fail).toHaveBeenCalledWith(
      'asset-1',
      runKey,
      { code: 'duplicates_pending', message: 'Duplicate detection has not completed yet' },
      expect.objectContaining({ durationMs: expect.any(Number) }),
    );
    expect(dependencies.client.interpret).not.toHaveBeenCalled();
    expect(dependencies.interpretationRepository.complete).not.toHaveBeenCalled();
    expect(dependencies.jobRepository.recordAiInterpretationCompletion).not.toHaveBeenCalled();
  });

  it('does not defer upload-sourced deliveries that the duplicate completion event queued', async () => {
    const { service, dependencies } = makeService();
    makeRunningAsset(service, dependencies);
    dependencies.assetRepository.getDuplicateAnalysisState.mockResolvedValue({
      stackId: null,
      visibility: AssetVisibility.Timeline,
      duplicatesDetectedAt: null,
    });
    dependencies.client.interpret.mockResolvedValue({ result: {} as never });
    dependencies.interpretationRepository.complete.mockResolvedValue(true);

    await expect(service.handleInterpretation({ id: 'asset-1', runKey, source: 'upload' } as never)).resolves.toBe(
      JobStatus.Success,
    );

    expect(dependencies.client.interpret).toHaveBeenCalled();
    expect(dependencies.interpretationRepository.fail).not.toHaveBeenCalled();
  });

  it('interprets immediately when duplicate analysis will never run for the asset', async () => {
    const { service, dependencies } = makeService();
    makeRunningAsset(service, dependencies);
    dependencies.client.interpret.mockResolvedValue({ result: {} as never });
    dependencies.interpretationRepository.complete.mockResolvedValue(true);

    // no job-status row: the non-force duplicate scan will never stream it
    dependencies.assetRepository.getDuplicateAnalysisState.mockResolvedValue(undefined);
    await expect(service.handleInterpretation({ id: 'asset-1', runKey } as never)).resolves.toBe(JobStatus.Success);

    // stacked assets are excluded from duplicate detection
    dependencies.assetRepository.getDuplicateAnalysisState.mockResolvedValue({
      stackId: 'stack-1',
      visibility: AssetVisibility.Timeline,
      duplicatesDetectedAt: null,
    });
    await expect(service.handleInterpretation({ id: 'asset-1', runKey } as never)).resolves.toBe(JobStatus.Success);

    expect(dependencies.client.interpret).toHaveBeenCalledTimes(2);
    expect(dependencies.interpretationRepository.fail).not.toHaveBeenCalled();
  });

  it('interprets immediately when duplicate detection is disabled', async () => {
    const { service, dependencies } = makeService();
    makeRunningAsset(service, dependencies);
    dependencies.client.interpret.mockResolvedValue({ result: {} as never });
    dependencies.interpretationRepository.complete.mockResolvedValue(true);
    dependencies.systemMetadataRepository.get.mockResolvedValue({
      machineLearning: { duplicateDetection: { enabled: false } },
    });

    await expect(service.handleInterpretation({ id: 'asset-1', runKey } as never)).resolves.toBe(JobStatus.Success);

    expect(dependencies.client.interpret).toHaveBeenCalled();
    expect(dependencies.assetRepository.getDuplicateAnalysisState).not.toHaveBeenCalled();
  });

  it('copies the result from an interpreted duplicate without calling the model', async () => {
    const { service, dependencies } = makeService();
    makeRunningAsset(service, dependencies);
    const copySource = {
      assetId: 'asset-2',
      runKey,
      result: { title: 'Copied result' } as never,
      input: { source: 'preview', width: 100, height: 80, mimeType: 'image/jpeg' },
      model: config.model,
      quant: config.quant,
      promptVersion: config.promptVersion,
    };
    dependencies.interpretationRepository.findCopySource.mockResolvedValue(copySource);
    dependencies.interpretationRepository.completeCopy.mockResolvedValue(true);
    dependencies.configRepository.getEnv.mockReturnValue({
      aiImageInterpretation: config,
      aiInterpretSearch: { enabled: true },
    });

    await expect(service.handleInterpretation({ id: 'asset-1', runKey } as never)).resolves.toBe(JobStatus.Success);

    expect(dependencies.interpretationRepository.findCopySource).toHaveBeenCalledWith('asset-1', runKey);
    expect(dependencies.client.interpret).not.toHaveBeenCalled();
    expect(dependencies.interpretationRepository.complete).not.toHaveBeenCalled();
    expect(dependencies.interpretationRepository.completeCopy).toHaveBeenCalledWith(
      'asset-1',
      runKey,
      copySource,
      expect.objectContaining({ durationMs: expect.any(Number) }),
    );
    expect(dependencies.jobRepository.recordAiInterpretationCompletion).toHaveBeenCalledWith('asset-1', runKey);
    expect(dependencies.jobRepository.queue).toHaveBeenCalledWith({
      name: JobName.AiInterpretSearchSync,
      data: { id: 'asset-1' },
    });
    expect(dependencies.jobRepository.queue).not.toHaveBeenCalledWith({
      name: JobName.SendAiInterpretationDiscordAlert,
      data: { assetId: 'asset-1', runKey },
    });
  });

  it('falls back to the model path when no duplicate sibling has a completed result', async () => {
    const { service, dependencies } = makeService();
    makeRunningAsset(service, dependencies);
    dependencies.client.interpret.mockResolvedValue({ result: {} as never });
    dependencies.interpretationRepository.complete.mockResolvedValue(true);

    await expect(service.handleInterpretation({ id: 'asset-1', runKey } as never)).resolves.toBe(JobStatus.Success);

    expect(dependencies.client.interpret).toHaveBeenCalledWith(Buffer.from('preview'), { model: config.model });
    expect(dependencies.interpretationRepository.completeCopy).not.toHaveBeenCalled();
    expect(dependencies.jobRepository.queue).toHaveBeenCalledWith({
      name: JobName.SendAiInterpretationDiscordAlert,
      data: { assetId: 'asset-1', runKey },
    });
  });

  it('claims a missing tuple for a manual delivery before running', async () => {
    const { service, dependencies } = makeService();
    const { asset } = makeRunningAsset(service, dependencies);
    dependencies.assetJobRepository.getForGenerateThumbnailJob.mockResolvedValue(asset);
    dependencies.interpretationRepository.claim.mockResolvedValue({ alreadyExists: false, runKey, run: {} });
    dependencies.client.interpret.mockResolvedValue({ result: {} as never });
    dependencies.interpretationRepository.complete.mockResolvedValue(true);

    await expect(service.handleInterpretation({ id: asset.id } as never)).resolves.toBe(JobStatus.Success);

    expect(dependencies.interpretationRepository.claim).toHaveBeenCalledWith(asset.id, {
      model: config.model,
      quant: config.quant,
      promptVersion: config.promptVersion,
    });
    expect(dependencies.interpretationRepository.transitionToRunning).toHaveBeenCalledWith(asset.id, runKey);
    expect(dependencies.client.interpret).toHaveBeenCalledWith(Buffer.from('preview'), { model: config.model });
    expect(dependencies.jobRepository.recordAiInterpretationCompletion).toHaveBeenCalledWith(asset.id, runKey);
    expect(dependencies.jobRepository.queue).toHaveBeenCalledWith({
      name: JobName.SendAiInterpretationDiscordAlert,
      data: { assetId: asset.id, runKey },
    });
  });

  it('queues an alert only for a newly persisted completion with a configured webhook', async () => {
    const { service, dependencies } = makeService();
    makeRunningAsset(service, dependencies);
    dependencies.client.interpret.mockResolvedValue({ result: {} as never });
    dependencies.interpretationRepository.complete.mockResolvedValue(false);

    await expect(service.handleInterpretation({ id: 'asset-1', runKey } as never)).resolves.toBe(JobStatus.Success);
    expect(dependencies.jobRepository.queue).not.toHaveBeenCalled();
    expect(dependencies.jobRepository.recordAiInterpretationCompletion).not.toHaveBeenCalled();

    dependencies.interpretationRepository.complete.mockResolvedValue(true);
    dependencies.configRepository.getEnv.mockReturnValue({
      aiImageInterpretation: { ...config, discord: { includeThumbnail: true } },
      aiInterpretSearch: { enabled: false },
    });
    await expect(service.handleInterpretation({ id: 'asset-1', runKey } as never)).resolves.toBe(JobStatus.Success);
    expect(dependencies.jobRepository.queue).not.toHaveBeenCalled();
  });

  it('does not alter a completed interpretation when alert enqueueing fails', async () => {
    const { service, dependencies } = makeService();
    makeRunningAsset(service, dependencies);
    dependencies.client.interpret.mockResolvedValue({ result: {} as never });
    dependencies.interpretationRepository.complete.mockResolvedValue(true);
    dependencies.jobRepository.queue.mockRejectedValue(new Error('queue unavailable'));

    await expect(service.handleInterpretation({ id: 'asset-1', runKey } as never)).resolves.toBe(JobStatus.Success);

    expect(dependencies.interpretationRepository.complete).toHaveBeenCalledTimes(1);
    expect(dependencies.interpretationRepository.fail).not.toHaveBeenCalled();
    expect(dependencies.logger.error).toHaveBeenCalledWith(
      `Failed to queue Discord alert for AI interpretation asset-1/${runKey}`,
    );
  });

  it('does not alter a completed interpretation when the completion sample cannot be recorded', async () => {
    const { service, dependencies } = makeService();
    makeRunningAsset(service, dependencies);
    dependencies.client.interpret.mockResolvedValue({ result: {} as never });
    dependencies.interpretationRepository.complete.mockResolvedValue(true);
    dependencies.jobRepository.recordAiInterpretationCompletion.mockRejectedValue(new Error('redis unavailable'));

    await expect(service.handleInterpretation({ id: 'asset-1', runKey } as never)).resolves.toBe(JobStatus.Success);

    expect(dependencies.interpretationRepository.complete).toHaveBeenCalledTimes(1);
    expect(dependencies.interpretationRepository.fail).not.toHaveBeenCalled();
    expect(dependencies.logger.warn).toHaveBeenCalledWith(
      expect.stringContaining(
        `Failed to record AI interpretation completion sample for asset-1/${runKey}: redis unavailable`,
      ),
    );
    expect(dependencies.jobRepository.queue).toHaveBeenCalledWith({
      name: JobName.SendAiInterpretationDiscordAlert,
      data: { assetId: 'asset-1', runKey },
    });
  });

  it('prepares an orientation-correct bounded JPEG, clamps oversized previews, and rejects missing previews', async () => {
    const { service, dependencies } = makeService();
    const directory = mkdtempSync(join(tmpdir(), 'ai-interpretation-'));
    const previewPath = join(directory, 'preview.jpg');
    const tallPreviewPath = join(directory, 'tall-preview.jpg');

    try {
      const preview = await sharp({
        create: { width: 2000, height: 1000, channels: 3, background: { r: 20, g: 40, b: 60 } },
      })
        .withMetadata({ orientation: 6 })
        .jpeg()
        .toBuffer();
      writeFileSync(previewPath, preview);
      // 18 MP: above the configured 16 MP budget but far below the decode
      // ceiling, so preparePreview must clamp it to the edge limit.
      const tallPreview = await sharp({
        create: { width: 2000, height: 9000, channels: 3, background: { r: 60, g: 40, b: 20 } },
      })
        .jpeg()
        .toBuffer();
      writeFileSync(tallPreviewPath, tallPreview);
      const asset = AssetFactory.from({ type: AssetType.Image, visibility: AssetVisibility.Timeline })
        .files([{ type: AssetFileType.Preview, path: previewPath }])
        .build();
      const tallAsset = AssetFactory.from({ type: AssetType.Image, visibility: AssetVisibility.Timeline })
        .files([{ type: AssetFileType.Preview, path: tallPreviewPath }])
        .build();
      const internals = service as never as {
        preparePreview: (asset: unknown) => Promise<{ buffer: Buffer; input: { width: number; height: number } }>;
      };

      const prepared = await internals.preparePreview(asset);
      expect(prepared.input).toMatchObject({ source: 'preview', mimeType: 'image/jpeg' });
      expect(prepared.input.height).toBeGreaterThan(prepared.input.width);
      expect(Math.max(prepared.input.width, prepared.input.height)).toBe(1600);

      const clamped = await internals.preparePreview(tallAsset);
      expect(Math.max(clamped.input.width, clamped.input.height)).toBe(1600);
      expect(dependencies.logger.log).toHaveBeenCalledWith(
        expect.stringContaining('Clamping oversized AI interpretation preview (2000x9000)'),
      );

      dependencies.configRepository.getEnv.mockReturnValue({
        aiImageInterpretation: { ...config, maxPixels: 100 },
        aiInterpretSearch: { enabled: false },
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
      expect.any(Function),
    );
    const [, hasPendingJob] = dependencies.interpretationRepository.failStale.mock.calls[0];
    dependencies.jobRepository.jobExists.mockResolvedValueOnce(true);
    await expect(hasPendingJob('asset-1', runKey)).resolves.toBe(true);
    expect(dependencies.jobRepository.jobExists).toHaveBeenCalledWith(
      QueueName.ImageInterpretation,
      `asset-1/${runKey}`,
    );
    expect(dependencies.interpretationRepository.findDueRetries).toHaveBeenCalledWith(expect.any(Date));
    expect(dependencies.interpretationRepository.requeue).toHaveBeenCalledTimes(2);
    expect(dependencies.jobRepository.queue).toHaveBeenCalledWith({
      name: JobName.AssetInterpretImage,
      data: { id: 'asset-1', runKey, priority: 2 },
    });
    expect(dependencies.jobRepository.queue).toHaveBeenCalledWith({
      name: JobName.AssetInterpretImage,
      data: { id: 'asset-2', runKey, priority: 2 },
    });
  });

  it('reconciles public runs through the dedicated public queue', async () => {
    const { service, dependencies } = makeService();
    dependencies.interpretationRepository.failStale.mockResolvedValue(0);
    dependencies.interpretationRepository.findDueRetries.mockResolvedValue([
      { assetId: 'asset-1', runKey: publicRunKey },
    ]);
    dependencies.interpretationRepository.requeue.mockResolvedValue(true);

    await expect(service.handleReconcile()).resolves.toBe(JobStatus.Success);

    const [, hasPendingJob] = dependencies.interpretationRepository.failStale.mock.calls[0];
    dependencies.jobRepository.jobExists.mockResolvedValueOnce(true);
    await expect(hasPendingJob('asset-1', publicRunKey)).resolves.toBe(true);
    expect(dependencies.jobRepository.jobExists).toHaveBeenCalledWith(
      QueueName.ImageInterpretationPublic,
      `asset-1/${publicRunKey}`,
    );
    expect(dependencies.jobRepository.queue).toHaveBeenCalledWith({
      name: JobName.AssetInterpretImagePublic,
      data: { id: 'asset-1', runKey: publicRunKey, priority: 1 },
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

  describe('skipIfInterpreted (backlog compute saver)', () => {
    it('skips a main-queue delivery before claiming when any completed run exists for the asset', async () => {
      const { service, dependencies } = makeService();
      enableSkipFlag(dependencies);
      // A completed run from another identity (here: a public-spark run) is
      // enough to skip — model, quant, and prompt version do not matter.
      dependencies.interpretationRepository.get.mockResolvedValue({
        schemaVersion: 1,
        runs: {
          [publicRunKey]: {
            model: config.publicModel,
            quant: 'hosted',
            promptVersion: config.promptVersion,
            trigger: 'manual-public',
            requestedAt: new Date().toISOString(),
            status: 'completed',
          },
        },
      } as AiInterpretationDocument);

      await expect(service.handleInterpretation({ id: 'asset-1' } as never)).resolves.toBe(JobStatus.Skipped);

      expect(dependencies.interpretationRepository.claim).not.toHaveBeenCalled();
      expect(dependencies.interpretationRepository.transitionToRunning).not.toHaveBeenCalled();
      expect(dependencies.client.interpret).not.toHaveBeenCalled();
      expect(dependencies.interpretationRepository.complete).not.toHaveBeenCalled();
    });

    it('delivers normally when the asset only has non-completed runs', async () => {
      const { service, dependencies } = makeService();
      enableSkipFlag(dependencies);
      dependencies.interpretationRepository.get.mockResolvedValue({
        schemaVersion: 1,
        runs: {
          legacy: {
            model: 'model-old',
            quant: 'quant-old',
            promptVersion: 'prompt-old',
            trigger: 'upload',
            requestedAt: new Date().toISOString(),
            status: 'failed',
            error: { code: 'timeout', message: 'timed out' },
          },
          [runKey]: {
            model: config.model,
            quant: config.quant,
            promptVersion: config.promptVersion,
            trigger: 'upload',
            requestedAt: new Date().toISOString(),
            status: 'queued',
          },
        },
      } as AiInterpretationDocument);
      dependencies.interpretationRepository.claim.mockResolvedValue({
        alreadyExists: false,
        runKey,
        run: { model: config.model, quant: config.quant, promptVersion: config.promptVersion },
      });
      dependencies.interpretationRepository.transitionToRunning.mockResolvedValue(true);
      dependencies.assetJobRepository.getForGenerateThumbnailJob.mockResolvedValue(
        AssetFactory.from({ type: AssetType.Image, visibility: AssetVisibility.Timeline })
          .files([AssetFileType.Preview])
          .build(),
      );
      service_preparePreview(service);
      dependencies.client.interpret.mockResolvedValue({
        result: { title: 't' } as never,
        model: config.model,
        promptTokens: 1,
        completionTokens: 1,
      });
      dependencies.interpretationRepository.complete.mockResolvedValue(true);

      await expect(service.handleInterpretation({ id: 'asset-1' } as never)).resolves.toBe(JobStatus.Success);

      expect(dependencies.interpretationRepository.complete).toHaveBeenCalled();
      expect(dependencies.client.interpret).toHaveBeenCalled();
    });

    it('gates public deliveries on the flag as well', async () => {
      const { service, dependencies } = makeService();
      enableSkipFlag(dependencies);
      // A completed run from any identity is enough to skip the public
      // delivery too: multi-select "Interpret image (public)" cannot assume
      // the user knows which assets are already interpreted.
      dependencies.interpretationRepository.get.mockResolvedValue({
        schemaVersion: 1,
        runs: {
          [runKey]: {
            model: config.model,
            quant: config.quant,
            promptVersion: config.promptVersion,
            trigger: 'upload',
            requestedAt: new Date().toISOString(),
            status: 'completed',
          },
        },
      } as AiInterpretationDocument);

      await expect(service.handleInterpretationPublic({ id: 'asset-1', runKey: publicRunKey } as never)).resolves.toBe(
        JobStatus.Skipped,
      );

      expect(dependencies.interpretationRepository.claim).not.toHaveBeenCalled();
      expect(dependencies.interpretationRepository.transitionToRunning).not.toHaveBeenCalled();
      expect(dependencies.client.interpret).not.toHaveBeenCalled();
    });

    it('still delivers public runs for assets without completed runs while the flag is on', async () => {
      const { service, dependencies } = makeService();
      enableSkipFlag(dependencies);
      dependencies.interpretationRepository.get.mockResolvedValue({
        schemaVersion: 1,
        runs: {
          [publicRunKey]: {
            model: config.publicModel,
            quant: 'hosted',
            promptVersion: config.promptVersion,
            trigger: 'manual-public',
            requestedAt: new Date().toISOString(),
            status: 'queued',
          },
        },
      } as AiInterpretationDocument);
      dependencies.assetJobRepository.getForGenerateThumbnailJob.mockResolvedValue(
        AssetFactory.from({ type: AssetType.Image, visibility: AssetVisibility.Timeline })
          .files([AssetFileType.Preview])
          .build(),
      );
      service_preparePreview(service);
      dependencies.interpretationRepository.claim.mockResolvedValue({
        alreadyExists: false,
        runKey: publicRunKey,
        run: { model: config.publicModel, quant: 'hosted', promptVersion: config.promptVersion },
      });
      dependencies.interpretationRepository.transitionToRunning.mockResolvedValue(true);
      dependencies.client.interpret.mockResolvedValue({
        result: { title: 't' } as never,
        model: config.publicModel,
        promptTokens: 1,
        completionTokens: 1,
      });
      dependencies.interpretationRepository.complete.mockResolvedValue(true);

      await expect(service.handleInterpretationPublic({ id: 'asset-1', runKey: publicRunKey } as never)).resolves.toBe(
        JobStatus.Success,
      );

      expect(dependencies.client.interpret).toHaveBeenCalledWith(
        expect.anything(),
        expect.objectContaining({ url: config.publicUrl }),
      );
    });

    it('leaves due retries un-requeued for already-interpreted assets but requeues the rest', async () => {
      const { service, dependencies } = makeService();
      enableSkipFlag(dependencies);
      dependencies.interpretationRepository.failStale.mockResolvedValue(0);
      dependencies.interpretationRepository.findDueRetries.mockResolvedValue([
        { assetId: 'asset-interpreted', runKey },
        { assetId: 'asset-fresh', runKey },
      ]);
      dependencies.interpretationRepository.get
        .mockResolvedValueOnce({
          schemaVersion: 1,
          runs: {
            other: {
              model: 'model-old',
              quant: 'quant-old',
              promptVersion: 'prompt-old',
              trigger: 'upload',
              requestedAt: new Date().toISOString(),
              status: 'completed',
            },
          },
        } as AiInterpretationDocument)
        .mockResolvedValueOnce({
          schemaVersion: 1,
          runs: {
            [runKey]: {
              model: config.model,
              quant: config.quant,
              promptVersion: config.promptVersion,
              trigger: 'upload',
              requestedAt: new Date().toISOString(),
              status: 'failed',
              error: { code: 'timeout', message: 'timed out' },
            },
          },
        } as AiInterpretationDocument);
      dependencies.interpretationRepository.requeue.mockResolvedValue(true);

      await expect(service.handleReconcile()).resolves.toBe(JobStatus.Success);

      expect(dependencies.interpretationRepository.requeue).toHaveBeenCalledTimes(1);
      expect(dependencies.jobRepository.queue).toHaveBeenCalledTimes(1);
      expect(dependencies.jobRepository.queue).toHaveBeenCalledWith({
        name: JobName.AssetInterpretImage,
        data: { id: 'asset-fresh', runKey, priority: 2 },
      });
    });
  });

  describe('public (hosted model) runs', () => {
    it('claims the hosted identity, routes to the public endpoint, and never copies from duplicates', async () => {
      const { service, dependencies } = makeService();
      makePublicRun(service, dependencies);
      // A duplicate sibling with a completed (local) result must be ignored.
      dependencies.interpretationRepository.findCopySource.mockResolvedValue({
        assetId: 'asset-2',
        runKey,
        result: {} as never,
        model: config.model,
        quant: config.quant,
        promptVersion: config.promptVersion,
      });
      // Duplicate analysis still pending: the public run does not wait on it.
      dependencies.assetRepository.getDuplicateAnalysisState.mockResolvedValue({
        stackId: null,
        visibility: AssetVisibility.Timeline,
        duplicatesDetectedAt: null,
      });
      dependencies.interpretationRepository.claim.mockResolvedValue({
        alreadyExists: false,
        runKey: publicRunKey,
        run: {},
      } as never);
      dependencies.client.interpret.mockResolvedValue({ result: {} as never, model: config.publicModel });
      dependencies.interpretationRepository.complete.mockResolvedValue(true);

      await expect(service.handleInterpretation({ id: 'asset-1', runKey: publicRunKey } as never)).resolves.toBe(
        JobStatus.Success,
      );

      expect(dependencies.interpretationRepository.claim).toHaveBeenCalledWith(
        'asset-1',
        { model: config.publicModel, quant: 'hosted', promptVersion: config.promptVersion },
        expect.any(Date),
        { trigger: 'manual-public' },
      );
      expect(dependencies.interpretationRepository.findCopySource).not.toHaveBeenCalled();
      expect(dependencies.client.interpret).toHaveBeenCalledWith(Buffer.from('preview'), {
        model: config.publicModel,
        url: config.publicUrl,
        backendLabel: 'public-spark',
      });
      expect(dependencies.interpretationRepository.fail).not.toHaveBeenCalled();
    });

    it('skips without claiming when the asset is not eligible', async () => {
      const { service, dependencies } = makeService();
      dependencies.assetJobRepository.getForGenerateThumbnailJob.mockResolvedValue(
        AssetFactory.from({ visibility: AssetVisibility.Hidden }).build(),
      );

      await expect(service.handleInterpretation({ id: 'asset-1', runKey: publicRunKey } as never)).resolves.toBe(
        JobStatus.Skipped,
      );

      expect(dependencies.interpretationRepository.claim).not.toHaveBeenCalled();
      expect(dependencies.interpretationRepository.transitionToRunning).not.toHaveBeenCalled();
    });

    it('handles deliveries on the dedicated public queue with the hosted identity', async () => {
      const { service, dependencies } = makeService();
      makePublicRun(service, dependencies);
      dependencies.interpretationRepository.claim.mockResolvedValue({
        alreadyExists: false,
        runKey: publicRunKey,
        run: {},
      } as never);
      dependencies.client.interpret.mockResolvedValue({ result: {} as never, model: config.publicModel });
      dependencies.interpretationRepository.complete.mockResolvedValue(true);

      await expect(
        service.handleInterpretationPublic({ id: 'asset-1', runKey: publicRunKey, priority: 1 } as never),
      ).resolves.toBe(JobStatus.Success);

      expect(dependencies.interpretationRepository.claim).toHaveBeenCalledWith(
        'asset-1',
        { model: config.publicModel, quant: 'hosted', promptVersion: config.promptVersion },
        expect.any(Date),
        { trigger: 'manual-public' },
      );
      expect(dependencies.client.interpret).toHaveBeenCalledWith(Buffer.from('preview'), {
        model: config.publicModel,
        url: config.publicUrl,
        backendLabel: 'public-spark',
      });
    });

    it('derives the public run key when a public job arrives without one', async () => {
      const { service, dependencies } = makeService();
      makePublicRun(service, dependencies);
      dependencies.interpretationRepository.claim.mockResolvedValue({
        alreadyExists: false,
        runKey: publicRunKey,
        run: {},
      } as never);
      dependencies.client.interpret.mockResolvedValue({ result: {} as never, model: config.publicModel });
      dependencies.interpretationRepository.complete.mockResolvedValue(true);

      await expect(service.handleInterpretationPublic({ id: 'asset-1' } as never)).resolves.toBe(JobStatus.Success);

      expect(dependencies.interpretationRepository.claim).toHaveBeenCalledWith(
        'asset-1',
        { model: config.publicModel, quant: 'hosted', promptVersion: config.promptVersion },
        expect.any(Date),
        { trigger: 'manual-public' },
      );
      expect(dependencies.interpretationRepository.claim.mock.calls[0][0]).toBe('asset-1');
      expect(dependencies.interpretationRepository.transitionToRunning).toHaveBeenCalledWith('asset-1', publicRunKey);
    });

    it('skips a public delivery while another one is still running', async () => {
      const { service, dependencies } = makeService();
      makePublicRun(service, dependencies);
      dependencies.interpretationRepository.claim.mockResolvedValue({
        alreadyExists: true,
        runKey: publicRunKey,
        run: { status: 'running' },
      } as never);

      await expect(service.handleInterpretation({ id: 'asset-1', runKey: publicRunKey } as never)).resolves.toBe(
        JobStatus.Skipped,
      );

      expect(dependencies.client.interpret).not.toHaveBeenCalled();
    });

    it('skips a public delivery when the same model+prompt run already completed', async () => {
      const { service, dependencies } = makeService();
      makePublicRun(service, dependencies);
      dependencies.interpretationRepository.claim.mockResolvedValue({
        alreadyExists: true,
        runKey: publicRunKey,
        run: { status: 'completed' },
      } as never);

      await expect(service.handleInterpretation({ id: 'asset-1', runKey: publicRunKey } as never)).resolves.toBe(
        JobStatus.Skipped,
      );

      expect(dependencies.interpretationRepository.transitionToRunning).not.toHaveBeenCalled();
      expect(dependencies.client.interpret).not.toHaveBeenCalled();
    });

    it('routes local runs to the local endpoint even when a public endpoint is configured', async () => {
      const { service, dependencies } = makeService();
      makeRunningAsset(service, dependencies);
      dependencies.client.interpret.mockResolvedValue({ result: {} as never, model: config.model });
      dependencies.interpretationRepository.complete.mockResolvedValue(true);

      await expect(service.handleInterpretation({ id: 'asset-1', runKey } as never)).resolves.toBe(JobStatus.Success);

      expect(dependencies.client.interpret).toHaveBeenCalledWith(Buffer.from('preview'), { model: config.model });
      expect(dependencies.interpretationRepository.claim).not.toHaveBeenCalled();
    });
  });
});
