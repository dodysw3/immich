import { Injectable } from '@nestjs/common';
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import {
  AiVideoTranscriptionError,
  AiVideoTranscriptionMetrics,
  AiVideoTranscriptionRun,
  AiVideoTranscriptionSegment,
  AiVideoTranscriptionTrigger,
} from 'src/dtos/ai-video-transcription.dto.js';
import { AssetType } from 'src/enum.js';
import { AiVideoTranscriptionRepository } from 'src/repositories/ai-video-transcription.repository.js';
import { AssetRepository } from 'src/repositories/asset.repository.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { MediaRepository } from 'src/repositories/media.repository.js';
import {
  AiVideoTranscriptionClient,
  AiVideoTranscriptionClientError,
} from 'src/services/ai-video-transcription.client.js';
import {
  AI_VIDEO_TRANSCRIPTION_PROMPT_VERSION,
  createVideoTranscriptionRunKey,
} from 'src/utils/ai-video-transcription.js';

/**
Experimental speech transcription for videos via a faster-whisper CPU sidecar
(:51905). Stores timestamped segments in asset_metadata `video-transcripts-v1`
(kept separate from captions and interpretation so the data survives either
experiment ending, and a future transcription UI can read it back). No queue
of its own: the AI interpretation job chains `transcribeIfMissing` alongside
the GPU captioning lane, so the CPU and GPU work overlap.
*/
@Injectable()
export class AiVideoTranscriptionService {
  constructor(
    private logger: LoggingRepository,
    private configRepository: ConfigRepository,
    private assetRepository: AssetRepository,
    private mediaRepository: MediaRepository,
    private transcriptionRepository: AiVideoTranscriptionRepository,
    private client: AiVideoTranscriptionClient,
  ) {
    this.logger.setContext(AiVideoTranscriptionService.name);
  }

  /**
  Chained from the AI interpretation job: transcribe this video if no
  completed run exists yet. Never throws — a sidecar outage degrades
  interpretation to captions/thumbnail only. Returns the latest completed run
  for prompt-context composition, or undefined.
  */
  async transcribeIfMissing(
    assetId: string,
    trigger: AiVideoTranscriptionTrigger,
  ): Promise<AiVideoTranscriptionRun | undefined> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    if (!config.enabled) {
      return await this.latestCompletedRun(assetId);
    }

    const [asset] = await this.assetRepository.getByIds([assetId]);
    if (!asset || asset.type !== AssetType.Video) {
      return undefined;
    }

    const runKey = createVideoTranscriptionRunKey(config.model, AI_VIDEO_TRANSCRIPTION_PROMPT_VERSION);
    const document = await this.transcriptionRepository.get(assetId);
    const existing = document?.runs[runKey];
    if (existing && existing.status !== 'failed') {
      // completed: reuse it; queued/running: a concurrent delivery is already
      // producing this run — don't double-claim.
      return await this.latestCompletedRun(assetId);
    }

    try {
      await this.transcribeRun(assetId, asset.originalPath, runKey, trigger);
    } catch (error) {
      this.logger.warn(`Chained video transcription failed for asset ${assetId}: ${error}`);
    }
    return await this.latestCompletedRun(assetId);
  }

  private async latestCompletedRun(assetId: string): Promise<AiVideoTranscriptionRun | undefined> {
    const document = await this.transcriptionRepository.get(assetId);
    return this.transcriptionRepository.findLatestCompletedRun(document ?? { schemaVersion: 1, runs: {} }) ?? undefined;
  }

  /** Probe → claim → extract audio → sidecar transcription → complete/fail. */
  private async transcribeRun(
    assetId: string,
    originalPath: string,
    runKey: string,
    trigger: AiVideoTranscriptionTrigger,
  ): Promise<void> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    const startedAt = new Date();

    let probe;
    try {
      probe = await this.mediaRepository.probe(originalPath);
    } catch (error) {
      throw new AiVideoTranscriptionClientError('endpoint_error', `probe failed: ${error}`);
    }
    const durationMs = Math.round((probe.format.duration || 0) * 1000);
    if (durationMs <= 0) {
      throw new AiVideoTranscriptionClientError('invalid_output', `asset ${assetId} has no measurable duration`);
    }

    const tempDir = await mkdtemp(join(tmpdir(), 'immich-video-transcribe-'));
    try {
      await this.transcriptionRepository.claim(assetId, {
        runKey,
        model: config.model,
        promptVersion: AI_VIDEO_TRANSCRIPTION_PROMPT_VERSION,
        config: { language: config.language },
        durationMs,
        trigger,
      });
      await this.transcriptionRepository.transitionToRunning(assetId, runKey);

      if (probe.audioStreams.length === 0) {
        // Completed with no segments: the run documents "this video has no
        // audio" so later deliveries don't re-probe, and interpretation skips
        // the transcript block instead of waiting on the sidecar again.
        await this.transcriptionRepository.complete(assetId, runKey, {
          noAudio: true,
          metrics: this.metrics(startedAt),
        });
        this.logger.log(`Transcribed video asset ${assetId}: no audio stream`);
        return;
      }

      const cappedDurationSec = Math.min(durationMs / 1000, config.maxDurationSec);
      const audioPath = await this.mediaRepository.extractVideoAudio(originalPath, tempDir, {
        durationSec: cappedDurationSec,
      });
      const audio = audioPath ? await readFile(audioPath) : null;
      if (!audio) {
        // Extraction can also fail on a broken audio stream; treat like no audio.
        await this.transcriptionRepository.complete(assetId, runKey, {
          noAudio: true,
          metrics: this.metrics(startedAt),
        });
        this.logger.log(`Transcribed video asset ${assetId}: audio extraction produced no audio`);
        return;
      }

      const response = await this.client.transcribe(audio, { language: config.language || undefined });
      const segments: AiVideoTranscriptionSegment[] = response.segments.map((segment) => ({
        startMs: Math.max(0, Math.round(segment.startSec * 1000)),
        endMs: Math.round(segment.endSec * 1000),
        text: segment.text,
      }));

      // Append before complete: the completed-run zod contract requires
      // segments (or noAudio/noSpeech), so the document must never be observable
      // in a completed-but-empty intermediate state.
      if (segments.length > 0) {
        await this.transcriptionRepository.appendSegments(assetId, runKey, segments);
      }
      await this.transcriptionRepository.complete(assetId, runKey, {
        language: response.language,
        languageProbability: response.languageProbability,
        noSpeech: response.noSpeech,
        truncated: durationMs / 1000 > config.maxDurationSec,
        metrics: this.metrics(startedAt),
      });
      this.logger.log(
        `Transcribed video asset ${assetId} (${response.noSpeech ? `no speech: ${response.reason ?? 'unknown'}` : `${segments.length} segments`}, language: ${response.language ?? 'unknown'}) in ${Date.now() - startedAt.getTime()}ms`,
      );
    } catch (error) {
      const transcriptionError: AiVideoTranscriptionError =
        error instanceof AiVideoTranscriptionClientError
          ? { code: error.code, message: error.message }
          : { code: 'internal_error', message: error instanceof Error ? error.message : String(error) };
      this.logger.warn(
        `Video transcription failed for asset ${assetId}: ${transcriptionError.code} — ${transcriptionError.message}`,
      );
      await this.transcriptionRepository.fail(assetId, runKey, transcriptionError);
    } finally {
      await rm(tempDir, { recursive: true, force: true }).catch(() => void 0);
    }
  }

  private metrics(startedAt: Date): AiVideoTranscriptionMetrics {
    return { durationMs: Date.now() - startedAt.getTime() };
  }
}
