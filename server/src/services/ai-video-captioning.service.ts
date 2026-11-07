import { Injectable } from '@nestjs/common';
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { OnJob } from 'src/decorators.js';
import {
  AiVideoCaptionError,
  AiVideoCaptionMetrics,
  AiVideoCaptionRun,
  AiVideoCaptionSegment,
  AiVideoCaptionTrigger,
} from 'src/dtos/ai-video-captioning.dto.js';
import { AssetType, JobName, JobStatus, QueueName } from 'src/enum.js';
import { AiVideoCaptioningRepository } from 'src/repositories/ai-video-captioning.repository.js';
import { AssetRepository } from 'src/repositories/asset.repository.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { MediaRepository } from 'src/repositories/media.repository.js';
import { AiVideoCaptioningClient, AiVideoCaptioningClientError, CaptionFrame } from 'src/services/ai-video-captioning.client.js';
import type { JobOf } from 'src/types.js';
import {
  AI_VIDEO_CAPTIONING_PROMPT_VERSION,
  buildCaptionPrompt,
  createVideoCaptionRunKey,
  groupFramesBySegment,
  planCaptionSegments,
} from 'src/utils/ai-video-captioning.js';

@Injectable()
export class AiVideoCaptioningService {
  constructor(
    private logger: LoggingRepository,
    private configRepository: ConfigRepository,
    private assetRepository: AssetRepository,
    private mediaRepository: MediaRepository,
    private captioningRepository: AiVideoCaptioningRepository,
    private client: AiVideoCaptioningClient,
  ) {
    this.logger.setContext(AiVideoCaptioningService.name);
  }

  /**
  Manual per-video captioning (asset viewer menu → AssetJobName.CAPTION_VIDEO).
  Experimental lane: writes asset_metadata `video-captions-v1` only; no
  auto-triggers, retries, Discord, or search sync. Served by LFM3-Omni-2B with
  frames only — captions are visual-only since v0.3.0 (omni's audio slices
  hallucinated languages and looped on reverberant speech, 2026-11-07 eval;
  audible content is covered by the faster-whisper transcript instead).
  */
  @OnJob({ name: JobName.AssetCaptionVideo, queue: QueueName.VideoCaptioning })
  async handleCaptionVideo({ id: assetId }: JobOf<JobName.AssetCaptionVideo>): Promise<JobStatus> {
    const config = this.configRepository.getEnv().aiVideoCaptioning;
    const [asset] = await this.assetRepository.getByIds([assetId]);
    if (!asset || asset.type !== AssetType.Video) {
      this.logger.warn(`Video captioning requires a video asset (asset ${assetId} missing or not a video)`);
      return JobStatus.Failed;
    }

    const runKey = this.runKey(config);

    if (!config.enabled) {
      // Claim + fail so the sidebar surfaces the disabled state instead of a
      // silent no-op behind the toast.
      const { runKey: claimedKey } = await this.captioningRepository.claim(assetId, {
        runKey,
        model: config.model,
        promptVersion: AI_VIDEO_CAPTIONING_PROMPT_VERSION,
        config: {
          segmentSeconds: config.segmentSeconds,
          framesPerSegment: config.framesPerSegment,
          frameEdge: config.frameEdge,
          maxDurationSec: config.maxDurationSec,
          language: config.language,
        },
        trigger: 'manual',
      });
      await this.captioningRepository.fail(assetId, claimedKey, {
        code: 'feature_disabled',
        message: 'Video captioning is disabled (IMMICH_AI_VIDEO_CAPTIONING_ENABLED=false)',
      });
      return JobStatus.Failed;
    }

    return this.captionRun(assetId, asset.originalPath, runKey, 'manual');
  }

  /**
  Chained from the AI interpretation job: caption this video if no completed
  run exists yet, so a manual "Interpret" on an old video (or the first
  interpretation of a new upload) gets caption context without a separate
  menu action. Runs on the LFM GPU lane concurrently with the CPU whisper
  transcription. Never throws — an LFM lane outage degrades interpretation to
  its thumbnail, it must not fail the interpretation job. Returns the latest
  completed run for prompt-context composition, or undefined.
  */
  async captionIfMissing(assetId: string, trigger: AiVideoCaptionTrigger): Promise<AiVideoCaptionRun | undefined> {
    const config = this.configRepository.getEnv().aiVideoCaptioning;
    if (!config.enabled) {
      return await this.latestCompletedRun(assetId);
    }

    const [asset] = await this.assetRepository.getByIds([assetId]);
    if (!asset || asset.type !== AssetType.Video) {
      return undefined;
    }

    const runKey = this.runKey(config);
    const existing = (await this.captioningRepository.get(assetId))?.runs[runKey];
    if (existing && existing.status !== 'failed') {
      // completed: reuse it; queued/running: a concurrent delivery is already
      // producing this run — don't double-claim and let interpretation use
      // whatever completed run exists today.
      return await this.latestCompletedRun(assetId);
    }

    try {
      await this.captionRun(assetId, asset.originalPath, runKey, trigger);
    } catch (error) {
      this.logger.warn(`Chained video captioning failed for asset ${assetId}: ${error}`);
    }
    return await this.latestCompletedRun(assetId);
  }

  private async latestCompletedRun(assetId: string): Promise<AiVideoCaptionRun | undefined> {
    const document = await this.captioningRepository.get(assetId);
    return this.captioningRepository.findLatestCompletedRun(document ?? { schemaVersion: 1, runs: {} }) ?? undefined;
  }

  private runKey(config: { model: string; segmentSeconds: number; framesPerSegment: number }): string {
    return createVideoCaptionRunKey(config.model, config.segmentSeconds, config.framesPerSegment, AI_VIDEO_CAPTIONING_PROMPT_VERSION);
  }

  /** Probe → claim → extract frames → per-segment captioning → complete/fail. */
  private async captionRun(
    assetId: string,
    originalPath: string,
    runKey: string,
    trigger: AiVideoCaptionTrigger,
  ): Promise<JobStatus> {
    const config = this.configRepository.getEnv().aiVideoCaptioning;
    const startedAt = new Date();

    let probe;
    try {
      probe = await this.mediaRepository.probe(originalPath);
    } catch (error) {
      this.logger.warn(`Video captioning probe failed for asset ${assetId}: ${error}`);
      return JobStatus.Failed;
    }
    const durationMs = Math.round((probe.format.duration || 0) * 1000);
    if (durationMs <= 0) {
      this.logger.warn(`Video captioning skipped: asset ${assetId} has no measurable duration`);
      return JobStatus.Failed;
    }

    await this.captioningRepository.claim(assetId, {
      runKey,
      model: config.model,
      promptVersion: AI_VIDEO_CAPTIONING_PROMPT_VERSION,
      config: {
        segmentSeconds: config.segmentSeconds,
        framesPerSegment: config.framesPerSegment,
        frameEdge: config.frameEdge,
        maxDurationSec: config.maxDurationSec,
        language: config.language,
      },
      durationMs,
      trigger,
    });
    await this.captioningRepository.transitionToRunning(assetId, runKey);

    const tempDir = await mkdtemp(join(tmpdir(), 'immich-video-caption-'));
    try {
      const fps = config.framesPerSegment / config.segmentSeconds;
      const cappedDurationSec = Math.min(durationMs / 1000, config.maxDurationSec);
      const framePaths = await this.mediaRepository.extractVideoFrames(originalPath, tempDir, {
        fps,
        maxEdge: config.frameEdge,
        durationSec: cappedDurationSec,
      });
      if (framePaths.length === 0) {
        throw new AiVideoCaptioningClientError('invalid_output', 'No frames could be extracted from the video');
      }

      const { segments, truncated } = planCaptionSegments(durationMs, config.segmentSeconds, config.maxDurationSec);
      const grouped = groupFramesBySegment(framePaths, fps, segments);

      let promptTokens = 0;
      let completionTokens = 0;
      let servedModel: string | undefined;
      const completedSegments: AiVideoCaptionSegment[] = [];

      for (const segment of grouped) {
        if (segment.framePaths.length === 0) {
          continue;
        }

        const frames: CaptionFrame[] = [];
        for (const [index, path] of segment.framePaths.entries()) {
          const buffer = await readFile(path);
          frames.push({
            dataUri: `data:image/jpeg;base64,${buffer.toString('base64')}`,
            timeSec: segment.frameTimesMs[index] / 1000,
          });
        }

        const response = await this.client.captionSegment(
          frames,
          { startMs: segment.startMs, endMs: segment.endMs },
          buildCaptionPrompt(segment, config.language),
        );
        servedModel = response.servedModel ?? servedModel;
        promptTokens += response.promptTokens ?? 0;
        completionTokens += response.completionTokens ?? 0;
        completedSegments.push({ startMs: segment.startMs, endMs: segment.endMs, caption: response.caption });

        // Incremental persistence: a crash mid-video keeps the earlier
        // segments, and the sidebar shows progress for long videos.
        await this.captioningRepository.appendSegments(assetId, runKey, [completedSegments.at(-1)!]);
      }

      const metrics: AiVideoCaptionMetrics = {
        durationMs: Date.now() - startedAt.getTime(),
        promptTokens: promptTokens > 0 ? promptTokens : undefined,
        completionTokens: completionTokens > 0 ? completionTokens : undefined,
      };

      if (completedSegments.length === 0) {
        throw new AiVideoCaptioningClientError('invalid_output', 'No segment produced a caption');
      }

      await this.captioningRepository.complete(assetId, runKey, { servedModel, truncated, metrics });
      this.logger.log(
        `Captioned video asset ${assetId} (${completedSegments.length}/${segments.length} segments${truncated ? ', truncated' : ''}) in ${metrics.durationMs}ms`,
      );
      return JobStatus.Success;
    } catch (error) {
      const captionError: AiVideoCaptionError =
        error instanceof AiVideoCaptioningClientError
          ? { code: error.code, message: error.message }
          : { code: 'internal_error', message: error instanceof Error ? error.message : String(error) };
      this.logger.warn(`Video captioning failed for asset ${assetId}: ${captionError.code} — ${captionError.message}`);
      await this.captioningRepository.fail(assetId, runKey, captionError);
      return JobStatus.Failed;
    } finally {
      await rm(tempDir, { recursive: true, force: true }).catch(() => void 0);
    }
  }
}
