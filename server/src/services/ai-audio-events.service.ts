import { Injectable } from '@nestjs/common';
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import {
  AiAudioEventsError,
  AiAudioEventsMetrics,
  AiAudioEventsRun,
  AiAudioEventsTrigger,
} from 'src/dtos/ai-audio-events.dto.js';
import { AssetType } from 'src/enum.js';
import { AiAudioEventsRepository } from 'src/repositories/ai-audio-events.repository.js';
import { AiVideoTranscriptionRepository } from 'src/repositories/ai-video-transcription.repository.js';
import { AssetRepository } from 'src/repositories/asset.repository.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { MediaRepository } from 'src/repositories/media.repository.js';
import { AiAudioEventsClient, AiAudioEventsClientError } from 'src/services/ai-audio-events.client.js';
import {
  AI_AUDIO_EVENTS_MODEL,
  AI_AUDIO_EVENTS_PROMPT_VERSION,
  assembleAudioEvents,
  createAudioEventsRunKey,
} from 'src/utils/ai-audio-events.js';

/**
Environmental-sound tagging for videos via the YAMNet ONNX sidecar (:51906).
Stores assembled sound events in asset_metadata `video-audio-events-v1`. Like
the transcription lane there is no queue of its own: the AI interpretation job
chains `tagIfMissing` alongside the GPU captioning and CPU whisper lanes, and
a down sidecar degrades to captions + transcript without failing delivery.
*/
@Injectable()
export class AiAudioEventsService {
  constructor(
    private logger: LoggingRepository,
    private configRepository: ConfigRepository,
    private assetRepository: AssetRepository,
    private mediaRepository: MediaRepository,
    private eventsRepository: AiAudioEventsRepository,
    private transcriptionRepository: AiVideoTranscriptionRepository,
    private client: AiAudioEventsClient,
  ) {
    this.logger.setContext(AiAudioEventsService.name);
  }

  /**
  Chained from the AI interpretation job: tag this video if no completed run
  exists for the current run identity. Never throws — a sidecar outage
  degrades interpretation to captions/transcript only. Returns the completed
  run of the current identity (else the latest completed one) for
  prompt-context composition, or undefined.
  */
  async tagIfMissing(assetId: string, trigger: AiAudioEventsTrigger): Promise<AiAudioEventsRun | undefined> {
    const config = this.configRepository.getEnv().aiAudioEvents;
    if (!config.enabled) {
      return await this.latestCompletedRun(assetId);
    }

    const [asset] = await this.assetRepository.getByIds([assetId]);
    if (!asset || asset.type !== AssetType.Video) {
      return undefined;
    }

    const runKey = createAudioEventsRunKey(
      AI_AUDIO_EVENTS_MODEL,
      { threshold: config.threshold },
      AI_AUDIO_EVENTS_PROMPT_VERSION,
    );
    const document = await this.eventsRepository.get(assetId);
    const existing = document?.runs[runKey];
    if (existing && existing.status !== 'failed') {
      // completed: reuse it; queued/running: a concurrent delivery is already
      // producing this run — don't double-claim.
      return await this.latestCompletedRun(assetId, runKey);
    }

    try {
      await this.tagRun(assetId, asset.originalPath, runKey, trigger);
    } catch (error) {
      this.logger.warn(`Chained video audio-events tagging failed for asset ${assetId}: ${error}`);
    }
    return await this.latestCompletedRun(assetId, runKey);
  }

  // The current identity's run wins over a more recently finished run of
  // another identity (a threshold flipped A -> B -> A must read A's events).
  private async latestCompletedRun(assetId: string, runKey?: string): Promise<AiAudioEventsRun | undefined> {
    const document = await this.eventsRepository.get(assetId);
    if (!document) {
      return undefined;
    }
    const current = runKey ? document.runs[runKey] : undefined;
    if (current?.status === 'completed') {
      return current;
    }
    return this.eventsRepository.findLatestCompletedRun(document) ?? undefined;
  }

  /** Probe → claim → extract audio → sidecar tagging → assemble → complete/fail. */
  private async tagRun(
    assetId: string,
    originalPath: string,
    runKey: string,
    trigger: AiAudioEventsTrigger,
  ): Promise<void> {
    const config = this.configRepository.getEnv().aiAudioEvents;
    const startedAt = new Date();

    let probe;
    try {
      probe = await this.mediaRepository.probe(originalPath);
    } catch (error) {
      throw new AiAudioEventsClientError('endpoint_error', `probe failed: ${error}`);
    }
    const durationMs = Math.round((probe.format.duration || 0) * 1000);
    if (durationMs <= 0) {
      throw new AiAudioEventsClientError('invalid_output', `asset ${assetId} has no measurable duration`);
    }

    const tempDir = await mkdtemp(join(tmpdir(), 'immich-video-audio-events-'));
    try {
      await this.eventsRepository.claim(assetId, {
        runKey,
        model: AI_AUDIO_EVENTS_MODEL,
        promptVersion: AI_AUDIO_EVENTS_PROMPT_VERSION,
        config: { threshold: config.threshold },
        durationMs,
        trigger,
      });
      await this.eventsRepository.transitionToRunning(assetId, runKey);

      if (probe.audioStreams.length === 0) {
        // Completed with no events: the run documents "this video has no
        // audio" so later deliveries don't re-probe.
        await this.eventsRepository.complete(assetId, runKey, {
          noAudio: true,
          metrics: this.metrics(startedAt),
        });
        this.logger.log(`Tagged video asset ${assetId}: no audio stream`);
        return;
      }

      const cappedDurationSec = Math.min(durationMs / 1000, config.maxDurationSec);
      const audioPath = await this.mediaRepository.extractVideoAudio(originalPath, tempDir, {
        durationSec: cappedDurationSec,
      });
      const audio = audioPath ? await readFile(audioPath) : null;
      if (!audio) {
        // Extraction can also fail on a broken audio stream; treat like no audio.
        await this.eventsRepository.complete(assetId, runKey, {
          noAudio: true,
          metrics: this.metrics(startedAt),
        });
        this.logger.log(`Tagged video asset ${assetId}: audio extraction produced no audio`);
        return;
      }

      const response = await this.client.tag(audio);

      // Speech-family events are the whisper transcript's domain: drop them
      // when the current transcript run carries segments, keep them when it
      // reports no speech (vocalization presence is then evidence).
      const suppressSpeech = await this.transcriptHasSegments(assetId);
      const { events, speechSuppressed } = assembleAudioEvents(response.frames, {
        threshold: config.threshold,
        windowMs: response.windowMs,
        durationMs: response.durationMs,
        suppressSpeech,
      });

      // Append before complete, mirroring the transcript lane.
      if (events.length > 0) {
        await this.eventsRepository.appendEvents(assetId, runKey, events);
      }
      await this.eventsRepository.complete(assetId, runKey, {
        speechSuppressed,
        truncated: durationMs / 1000 > config.maxDurationSec,
        metrics: this.metrics(startedAt, response),
      });
      this.logger.log(
        `Tagged video asset ${assetId} (${events.length} events${speechSuppressed ? ', speech suppressed by transcript' : ''}) in ${Date.now() - startedAt.getTime()}ms`,
      );
    } catch (error) {
      const eventsError: AiAudioEventsError =
        error instanceof AiAudioEventsClientError
          ? { code: error.code, message: error.message }
          : { code: 'internal_error', message: error instanceof Error ? error.message : String(error) };
      this.logger.warn(
        `Video audio-events tagging failed for asset ${assetId}: ${eventsError.code} — ${eventsError.message}`,
      );
      await this.eventsRepository.fail(assetId, runKey, eventsError);
    } finally {
      await rm(tempDir, { recursive: true, force: true }).catch(() => void 0);
    }
  }

  /** True when the latest completed transcript run carries segments (words exist). */
  private async transcriptHasSegments(assetId: string): Promise<boolean> {
    const document = await this.transcriptionRepository.get(assetId);
    const run = document ? this.transcriptionRepository.findLatestCompletedRun(document) : null;
    return (run?.segments.length ?? 0) > 0;
  }

  private metrics(startedAt: Date, response?: { inferMs?: number; frameCount?: number }): AiAudioEventsMetrics {
    return {
      durationMs: Date.now() - startedAt.getTime(),
      inferMs: response?.inferMs,
      frameCount: response?.frameCount,
    };
  }
}
