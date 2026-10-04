import { Injectable } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import sharp from 'sharp';
import type { ArgOf } from 'src/repositories/event.repository.js';
import type { JobOf } from 'src/types.js';
import { OnEvent, OnJob } from 'src/decorators.js';
import { AiInterpretationInput, AiInterpretationMetrics } from 'src/dtos/ai-image-interpretation.dto.js';
import { AssetFileType, AssetType, AssetVisibility, ImmichWorker, JobName, JobStatus, QueueName } from 'src/enum.js';
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
import { createAiInterpretationJobId } from 'src/utils/ai-image-interpretation.js';
import { getAssetFile } from 'src/utils/asset.util.js';
import { getConfig } from 'src/utils/config.js';
import { isDuplicateDetectionEnabled } from 'src/utils/misc.js';

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
    private assetRepository: AssetRepository,
    private systemMetadataRepository: SystemMetadataRepository,
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

  // Upload-path trigger: the duplicate service emits once duplicate analysis has
  // concluded for the asset (final pass, exclusion, or feature off), so
  // interpretation can deduplicate against already-interpreted group members
  // instead of racing the duplicate pipeline.
  @OnEvent({ name: 'AssetDuplicateDetectionCompleted', workers: [ImmichWorker.Microservices] })
  async onDuplicateDetectionCompleted({ assetId }: ArgOf<'AssetDuplicateDetectionCompleted'>) {
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
    source,
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
    let completed = false;
    let copied = false;
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

      // Upload-sourced deliveries come from the duplicate-detection completion
      // event, so their analysis is final by construction. Everything else
      // (manual actions, ops scripts, retry requeues) waits out the analysis
      // instead of interpreting against a still-changing duplicate group.
      if (source !== 'upload' && (await this.isDuplicateAnalysisPending(assetId))) {
        const failure = { code: 'duplicates_pending', message: 'Duplicate detection has not completed yet' } as const;
        await this.interpretationRepository.fail(assetId, runKey, failure, { durationMs: Date.now() - startedAt });
        this.logger.debug(`Deferring AI interpretation for ${assetId} until duplicate detection completes`);
        return JobStatus.Success;
      }

      const copySource = await this.interpretationRepository.findCopySource(assetId, runKey);
      if (copySource) {
        completed = await this.interpretationRepository.completeCopy(assetId, runKey, copySource, {
          durationMs: Date.now() - startedAt,
        });
        copied = completed;
        if (completed) {
          this.logger.log(
            `Copied AI interpretation for ${assetId} from duplicate asset ${copySource.assetId} (run ${copySource.runKey})`,
          );
        }
      } else {
        const prepared = await this.preparePreview(asset);
        input = prepared.input;
        const response = await this.client.interpret(prepared.buffer, {
          model: run.model,
        });

        completed = await this.interpretationRepository.complete(assetId, runKey, input, response.result, {
          durationMs: Date.now() - startedAt,
          promptTokens: response.promptTokens,
          completionTokens: response.completionTokens,
        });
      }
    } catch (error) {
      const failure = this.asFailure(error);
      const metrics: AiInterpretationMetrics = { durationMs: Date.now() - startedAt };
      // Every failure retries with exponentially increasing delays capped at
      // one day (dispatched by the reconcile pass), with no attempt limit.
      // feature_disabled retries too: a deployment window that starts with the
      // feature off must not permanently strand already-queued runs.
      const updated = await this.interpretationRepository.fail(assetId, runKey, failure, metrics, input, new Date());
      this.logger.warn(
        `AI interpretation failed for ${assetId}: ${failure.code}${
          updated?.nextAttemptAt ? ` (retry scheduled for ${updated.nextAttemptAt})` : ' (no retry scheduled)'
        }`,
      );
    }

    if (completed) {
      try {
        await this.jobRepository.recordAiInterpretationCompletion(assetId, runKey);
      } catch (error) {
        this.logger.warn(
          `Failed to record AI interpretation completion sample for ${assetId}/${runKey}: ${
            error instanceof Error ? error.message : error
          }`,
        );
      }

      // Copied runs add no information the source run's alert did not already
      // cover, and a backlog drain would otherwise emit a burst of empty ones.
      if (config.discord.webhookUrl && !copied) {
        try {
          await this.jobRepository.queue({
            name: JobName.SendAiInterpretationDiscordAlert,
            data: { assetId, runKey },
          });
        } catch {
          this.logger.error(`Failed to queue Discord alert for AI interpretation ${assetId}/${runKey}`);
        }
      }

      // Embedding failure never fails interpretation: the sync job retries via
      // BullMQ backoff and the reconcile sweep re-covers gaps (design D5).
      if (this.configRepository.getEnv().aiInterpretSearch.enabled) {
        try {
          await this.jobRepository.queue({ name: JobName.AiInterpretSearchSync, data: { id: assetId } });
        } catch {
          this.logger.error(`Failed to queue AI interpret search sync for ${assetId}/${runKey}`);
        }
      }
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

  // Whether duplicate-detection analysis can still change this asset's duplicate
  // group. Assets duplicate detection will never process (no job-status row —
  // the non-force scan inner-joins asset_job_status — stacked, hidden, locked)
  // are treated as concluded so they cannot be stranded here.
  private async isDuplicateAnalysisPending(assetId: string): Promise<boolean> {
    const { machineLearning } = await getConfig(
      {
        configRepo: this.configRepository,
        metadataRepo: this.systemMetadataRepository,
        logger: this.logger,
      },
      { withCache: true },
    );
    if (!isDuplicateDetectionEnabled(machineLearning)) {
      return false;
    }

    const state = await this.assetRepository.getDuplicateAnalysisState(assetId);
    if (
      !state ||
      state.stackId ||
      state.visibility === AssetVisibility.Hidden ||
      state.visibility === AssetVisibility.Locked
    ) {
      return false;
    }

    return !state.duplicatesDetectedAt;
  }

  @OnJob({ name: JobName.AssetInterpretationReconcile, queue: QueueName.ImageInterpretation })
  async handleReconcile(): Promise<JobStatus> {
    await this.reconcile();
    return JobStatus.Success;
  }

  private async reconcile() {
    const timeoutMs = this.configRepository.getEnv().aiImageInterpretation.timeoutMs;
    const now = Date.now();
    // A queued run is only declared lost when its BullMQ job no longer exists
    // (e.g. queue state wiped); waiting behind a long backlog is not loss.
    const failed = await this.interpretationRepository.failStale(new Date(now - timeoutMs), (assetId, runKey) =>
      this.jobRepository.jobExists(QueueName.ImageInterpretation, createAiInterpretationJobId(assetId, runKey)),
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
