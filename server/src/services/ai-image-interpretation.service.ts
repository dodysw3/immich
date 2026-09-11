import { Injectable } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import sharp from 'sharp';
import { OnEvent, OnJob } from 'src/decorators';
import { AiInterpretationInput, AiInterpretationMetrics } from 'src/dtos/ai-image-interpretation.dto';
import { AssetFileType, AssetType, AssetVisibility, ImmichWorker, JobName, JobStatus, QueueName } from 'src/enum';
import { AiImageInterpretationRepository } from 'src/repositories/ai-image-interpretation.repository';
import { AssetJobRepository } from 'src/repositories/asset-job.repository';
import { ConfigRepository } from 'src/repositories/config.repository';
import { ArgOf } from 'src/repositories/event.repository';
import { JobRepository } from 'src/repositories/job.repository';
import { LoggingRepository } from 'src/repositories/logging.repository';
import { AI_INTERPRETATION_QUEUED_STALE_MS } from 'src/utils/ai-image-interpretation';
import {
  AiImageInterpretationClient,
  AiImageInterpretationClientError,
} from 'src/services/ai-image-interpretation.client';
import { JobOf } from 'src/types';
import { getAssetFile } from 'src/utils/asset.util';

type PreparedPreview = {
  buffer: Buffer;
  input: AiInterpretationInput;
};

@Injectable()
export class AiImageInterpretationService {
  constructor(
    private logger: LoggingRepository,
    private configRepository: ConfigRepository,
    private assetJobRepository: AssetJobRepository,
    private jobRepository: JobRepository,
    private interpretationRepository: AiImageInterpretationRepository,
    private client: AiImageInterpretationClient,
  ) {
    this.logger.setContext(AiImageInterpretationService.name);
  }

  @OnEvent({ name: 'AppBootstrap', workers: [ImmichWorker.Microservices] })
  async onBootstrap() {
    if (this.configRepository.getEnv().aiImageInterpretation.enabled) {
      await this.jobRepository.queue({ name: JobName.AssetInterpretationReconcile });
    }
  }

  @Cron('*/15 * * * *')
  async reconcilePeriodically() {
    if (
      this.configRepository.getWorker() !== ImmichWorker.Microservices ||
      !this.configRepository.getEnv().aiImageInterpretation.enabled
    ) {
      return;
    }

    await this.reconcile();
  }

  @OnEvent({ name: 'AssetThumbnailGenerated', workers: [ImmichWorker.Microservices] })
  async onThumbnailGenerated({ assetId, source }: ArgOf<'AssetThumbnailGenerated'>) {
    if (source !== 'upload') {
      return;
    }

    const runKey = await this.claimMissingRun(assetId);
    if (!runKey) {
      return;
    }

    await this.jobRepository.queue({
      name: JobName.AssetInterpretImage,
      data: { id: assetId, runKey, source: 'upload' },
    });
  }

  @OnJob({ name: JobName.AssetInterpretImage, queue: QueueName.ImageInterpretation })
  async handleInterpretation({
    id: assetId,
    runKey: requestedRunKey,
  }: JobOf<JobName.AssetInterpretImage>): Promise<JobStatus> {
    const config = this.configRepository.getEnv().aiImageInterpretation;
    let runKey = requestedRunKey;
    if (!runKey) {
      runKey = await this.claimMissingRun(assetId);
      if (!runKey) {
        this.logger.debug(`Skipping manual AI interpretation request for ${assetId}`);
        return JobStatus.Skipped;
      }
    }

    const startedAt = Date.now();
    const started = await this.interpretationRepository.transitionToRunning(assetId, runKey);
    if (!started) {
      this.logger.debug(`Skipping duplicate AI interpretation delivery for ${assetId}/${runKey}`);
      return JobStatus.Skipped;
    }

    let input: AiInterpretationInput | undefined;
    try {
      if (!config.enabled) {
        throw new AiImageInterpretationClientError('feature_disabled', 'AI interpretation is disabled');
      }

      const document = await this.interpretationRepository.get(assetId);
      const run = document?.runs[runKey];
      if (!run) {
        throw new AiImageInterpretationClientError('invalid_output', 'AI interpretation run was not found');
      }

      const asset = await this.assetJobRepository.getForGenerateThumbnailJob(assetId);
      if (!asset || asset.type !== AssetType.Image || asset.visibility === AssetVisibility.Hidden) {
        throw new AiImageInterpretationClientError('preview_missing', 'Generated image preview is unavailable');
      }

      const prepared = await this.preparePreview(asset);
      input = prepared.input;
      const response = await this.client.interpret(prepared.buffer, {
        model: run.model,
      });

      await this.interpretationRepository.complete(assetId, runKey, input, response.result, {
        durationMs: Date.now() - startedAt,
        promptTokens: response.promptTokens,
        completionTokens: response.completionTokens,
      });
    } catch (error) {
      const failure = this.asFailure(error);
      const metrics: AiInterpretationMetrics = { durationMs: Date.now() - startedAt };
      // feature_disabled is a configuration state, not a transient endpoint
      // failure: record it without scheduling an automatic retry. Everything
      // else retries with exponentially increasing delays capped at one day
      // (dispatched by the reconcile pass), with no attempt limit.
      const updated = await this.interpretationRepository.fail(assetId, runKey, failure, metrics, input, new Date(), {
        retry: failure.code !== 'feature_disabled',
      });
      this.logger.warn(
        `AI interpretation failed for ${assetId}: ${failure.code}${
          updated?.nextAttemptAt ? ` (retry scheduled for ${updated.nextAttemptAt})` : ' (no retry scheduled)'
        }`,
      );
    }

    return JobStatus.Success;
  }

  private async claimMissingRun(assetId: string): Promise<string | undefined> {
    const config = this.configRepository.getEnv().aiImageInterpretation;
    if (!config.enabled) {
      return;
    }

    const asset = await this.assetJobRepository.getForGenerateThumbnailJob(assetId);
    if (!asset || asset.type !== AssetType.Image || asset.visibility === AssetVisibility.Hidden) {
      return;
    }

    const preview = getAssetFile(asset.files, AssetFileType.Preview, { isEdited: false });
    if (!preview) {
      return;
    }

    const claim = await this.interpretationRepository.claim(assetId, {
      model: config.model,
      quant: config.quant,
      promptVersion: config.promptVersion,
    });
    return claim.alreadyExists ? undefined : claim.runKey;
  }

  @OnJob({ name: JobName.AssetInterpretationReconcile, queue: QueueName.ImageInterpretation })
  async handleReconcile(): Promise<JobStatus> {
    await this.reconcile();
    return JobStatus.Success;
  }

  private async reconcile() {
    const timeoutMs = this.configRepository.getEnv().aiImageInterpretation.timeoutMs;
    const now = Date.now();
    const failed = await this.interpretationRepository.failStale(
      new Date(now - timeoutMs),
      new Date(now - AI_INTERPRETATION_QUEUED_STALE_MS),
    );
    if (failed > 0) {
      this.logger.log(`Marked ${failed} stale AI interpretation run(s) as failed`);
    }

    const due = await this.interpretationRepository.findDueRetries(new Date());
    let dispatched = 0;
    for (const { assetId, runKey } of due) {
      const requeued = await this.interpretationRepository.requeue(assetId, runKey);
      if (!requeued) {
        continue;
      }

      await this.jobRepository.queue({ name: JobName.AssetInterpretImage, data: { id: assetId, runKey } });
      dispatched++;
    }

    if (dispatched > 0) {
      this.logger.log(`Requeued ${dispatched} due AI interpretation retry run(s)`);
    }
  }

  private async preparePreview(
    asset: Awaited<ReturnType<AssetJobRepository['getForGenerateThumbnailJob']>>,
  ): Promise<PreparedPreview> {
    const config = this.configRepository.getEnv().aiImageInterpretation;
    const preview = asset && getAssetFile(asset.files, AssetFileType.Preview, { isEdited: false });
    if (!asset || !preview) {
      throw new AiImageInterpretationClientError('preview_missing', 'Generated image preview is unavailable');
    }

    try {
      const metadata = await sharp(preview.path, { limitInputPixels: config.maxPixels }).metadata();
      if (!metadata.width || !metadata.height || metadata.width * metadata.height > config.maxPixels) {
        throw new AiImageInterpretationClientError(
          'preview_too_large',
          'Generated image preview exceeds the pixel limit',
        );
      }

      const output = await sharp(preview.path, { limitInputPixels: config.maxPixels })
        .rotate()
        .resize(config.maxEdge, config.maxEdge, { fit: 'inside', withoutEnlargement: true })
        .jpeg({ quality: 85 })
        .toBuffer({ resolveWithObject: true });

      const { width, height } = output.info;
      if (!width || !height || width > config.maxEdge || height > config.maxEdge || width * height > config.maxPixels) {
        throw new AiImageInterpretationClientError(
          'preview_too_large',
          'Prepared preview exceeds the configured bound',
        );
      }

      return {
        buffer: output.data,
        input: { source: 'preview', width, height, mimeType: 'image/jpeg' },
      };
    } catch (error) {
      if (error instanceof AiImageInterpretationClientError) {
        throw error;
      }
      if (error instanceof Error && /pixel|limitInputPixels/i.test(error.message)) {
        throw new AiImageInterpretationClientError(
          'preview_too_large',
          'Generated image preview exceeds the pixel limit',
        );
      }
      throw new AiImageInterpretationClientError('preview_invalid', 'Generated image preview could not be decoded');
    }
  }

  private asFailure(error: unknown) {
    if (error instanceof AiImageInterpretationClientError) {
      return { code: error.code, message: error.message.slice(0, 200) };
    }

    return { code: 'internal_error', message: 'AI interpretation failed before completion' };
  }
}
