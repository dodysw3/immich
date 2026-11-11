import { Injectable } from '@nestjs/common';
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import sharp from 'sharp';
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
import {
  AiVideoCaptioningClient,
  AiVideoCaptioningClientError,
  CaptionFrame,
} from 'src/services/ai-video-captioning.client.js';
import { VideoFaceService } from 'src/services/video-face.service.js';
import type { JobOf } from 'src/types.js';
import {
  AI_VIDEO_CAPTIONING_PROMPT_VERSION,
  adaptiveSegmentationKey,
  buildCaptionPrompt,
  createVideoCaptionRunKey,
  fixedSegmentationKey,
  foldCaptionSegment,
  groupFramesBySegment,
  isNoChangeCaption,
  planAdaptiveSegments,
  planCaptionSegments,
  selectWindowFrames,
} from 'src/utils/ai-video-captioning.js';

/** Probe-frame diff resolution (32x32 grayscale), matching the offline prototype. */
const FRAME_DIFF_SIZE = 32;

@Injectable()
export class AiVideoCaptioningService {
  constructor(
    private logger: LoggingRepository,
    private configRepository: ConfigRepository,
    private assetRepository: AssetRepository,
    private mediaRepository: MediaRepository,
    private captioningRepository: AiVideoCaptioningRepository,
    private client: AiVideoCaptioningClient,
    private videoFaceService: VideoFaceService,
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
        config: this.storedConfig(config),
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
    const document = await this.captioningRepository.get(assetId);
    const existing = document?.runs[runKey];
    if (existing && existing.status !== 'failed') {
      // completed: reuse it; queued/running: a concurrent delivery is already
      // producing this run — don't double-claim and let interpretation use
      // whatever completed run exists today. Only the completed case chains
      // face discovery here (a live captionRun chains at claim time — no-op
      // once a scan run exists).
      if (existing.status === 'completed') {
        await this.videoFaceService.scanIfMissing(assetId);
      }
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

  private runKey(config: {
    model: string;
    segmentSeconds: number;
    framesPerSegment: number;
    adaptive: boolean;
    probeFps: number;
    minSegmentSeconds: number;
    maxSegmentSeconds: number;
    changeBudget: number;
  }): string {
    const segmentation = config.adaptive
      ? adaptiveSegmentationKey(config.probeFps, config.minSegmentSeconds, config.maxSegmentSeconds, config.changeBudget)
      : fixedSegmentationKey(config.segmentSeconds, config.framesPerSegment);
    return createVideoCaptionRunKey(config.model, segmentation, AI_VIDEO_CAPTIONING_PROMPT_VERSION);
  }

  /**
  The config stored on each run/claim. Adaptive runs record their knobs so the
  interpretation context can label the caption granularity and old fixed-grid
  documents stay schema-valid (the adaptive fields are optional).
  */
  private storedConfig(config: {
    segmentSeconds: number;
    framesPerSegment: number;
    frameEdge: number;
    maxDurationSec: number;
    language: string;
    adaptive: boolean;
    probeFps: number;
    minSegmentSeconds: number;
    maxSegmentSeconds: number;
  }) {
    return {
      segmentSeconds: config.segmentSeconds,
      framesPerSegment: config.framesPerSegment,
      frameEdge: config.frameEdge,
      maxDurationSec: config.maxDurationSec,
      language: config.language,
      ...(config.adaptive && {
            adaptive: true,
            probeFps: config.probeFps,
            minSegmentSeconds: config.minSegmentSeconds,
            maxSegmentSeconds: config.maxSegmentSeconds,
          }),
    };
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
      config: this.storedConfig(config),
      durationMs,
      trigger,
    });
    await this.captioningRepository.transitionToRunning(assetId, runKey);

    // Captioning samples this video anyway — chain face discovery so the same
    // action populates the face strip (video-face.service gates and skips
    // already-scanned assets itself). Fire-and-forget: the scan has its own
    // queue and must not delay or fail the caption run.
    await this.videoFaceService.scanIfMissing(assetId);

    const tempDir = await mkdtemp(join(tmpdir(), 'immich-video-caption-'));
    try {
      // Adaptive mode probes at a higher fps and lets the pixel-change signal
      // draw the windows; fixed mode keeps the segmentSeconds x framesPerSegment grid.
      const fps = config.adaptive ? config.probeFps : config.framesPerSegment / config.segmentSeconds;
      const cappedDurationSec = Math.min(durationMs / 1000, config.maxDurationSec);
      const framePaths = await this.mediaRepository.extractVideoFrames(originalPath, tempDir, {
        fps,
        maxEdge: config.frameEdge,
        durationSec: cappedDurationSec,
      });
      if (framePaths.length === 0) {
        throw new AiVideoCaptioningClientError('invalid_output', 'No frames could be extracted from the video');
      }

      const frameTimesMs = framePaths.map((_, index) => Math.round((index / fps) * 1000));
      let segments: { startMs: number; endMs: number }[];
      let truncated: boolean;
      let diffScores: number[] | undefined;
      if (config.adaptive) {
        diffScores = await this.frameDiffScores(framePaths);
        segments = planAdaptiveSegments(frameTimesMs, diffScores, {
          minSegmentMs: config.minSegmentSeconds * 1000,
          maxSegmentMs: config.maxSegmentSeconds * 1000,
          changeBudget: config.changeBudget,
          cutThreshold: config.cutThreshold,
          // Call-count ceiling: the fixed-grid equivalent for this duration.
          maxCalls: Math.ceil(cappedDurationSec / config.segmentSeconds),
        });
        truncated = durationMs > config.maxDurationSec * 1000;
      } else {
        ({ segments, truncated } = planCaptionSegments(durationMs, config.segmentSeconds, config.maxDurationSec));
      }
      const grouped = groupFramesBySegment(framePaths, fps, segments);
      const plannedSegments = diffScores
        ? grouped.map((segment) => {
            const indices = selectWindowFrames(frameTimesMs, diffScores!, segment);
            return {
              ...segment,
              framePaths: indices.map((index) => framePaths[index]),
              frameTimesMs: indices.map((index) => frameTimesMs[index]),
            };
          })
        : grouped;

      let promptTokens = 0;
      let completionTokens = 0;
      let servedModel: string | undefined;
      let completedSegments: AiVideoCaptionSegment[] = [];
      // Delta captioning (v0.4.0): every captioned segment compares against
      // the last informative caption; "No change." segments carry no anchor,
      // so the previous substantive caption stays the comparison point (and
      // a change the model missed gets a second chance to be reported).
      let previousCaption: { caption: string; startMs: number; endMs: number } | undefined;

      for (const [segmentIndex, segment] of plannedSegments.entries()) {
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
          buildCaptionPrompt(segment, config.language, {
            ordinal: segmentIndex + 1,
            previous: previousCaption,
          }),
        );
        servedModel = response.servedModel ?? servedModel;
        promptTokens += response.promptTokens ?? 0;
        completionTokens += response.completionTokens ?? 0;

        // v0.4.1 folding: a "No change." answer (or a verbatim repeat of the
        // previous caption) extends that caption's window instead of being
        // stored, so the overlay keeps showing the previous caption across
        // unchanged stretches. A folded segment is not threaded as the next
        // comparison anchor.
        const folded = foldCaptionSegment(completedSegments, {
          startMs: segment.startMs,
          endMs: segment.endMs,
          caption: response.caption,
        });
        completedSegments = folded.segments;
        if (!folded.foldedIntoPrevious && !isNoChangeCaption(response.caption)) {
          previousCaption = { caption: response.caption, startMs: segment.startMs, endMs: segment.endMs };
        }

        // Incremental persistence: the stored list always equals the folded
        // list, so a crash mid-video keeps the earlier segments and the
        // sidebar shows progress for long videos.
        await this.captioningRepository.setSegments(assetId, runKey, completedSegments);
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

  /**
  Change signal for adaptive planning: mean absolute diff between consecutive
  probe frames downscaled to 32x32 grayscale (BT.601 luma, matching the
  offline prototype's PIL "L" convert). Index 0 is the zero baseline; a score
  of ~1 is a still tripod shot, ~40 is continuous motion (2026-11-08 bench:
  static sermon p50 0.7, busy market p50 38).
  */
  private async frameDiffScores(framePaths: string[]): Promise<number[]> {
    const scores: number[] = [0];
    let previous: Uint8Array | undefined;
    for (const path of framePaths) {
      const { data, info } = await sharp(path)
        .resize(FRAME_DIFF_SIZE, FRAME_DIFF_SIZE, { fit: 'fill' })
        .removeAlpha()
        .raw()
        .toBuffer({ resolveWithObject: true });
      const gray = new Uint8Array(FRAME_DIFF_SIZE * FRAME_DIFF_SIZE);
      for (let pixel = 0; pixel < gray.length; pixel++) {
        const offset = pixel * info.channels;
        gray[pixel] = Math.round(0.299 * data[offset] + 0.587 * data[offset + 1] + 0.114 * data[offset + 2]);
      }
      if (previous !== undefined) {
        let total = 0;
        for (let pixel = 0; pixel < gray.length; pixel++) {
          total += Math.abs(gray[pixel] - previous[pixel]);
        }
        scores.push(total / gray.length);
      }
      previous = gray;
    }
    return scores;
  }
}
