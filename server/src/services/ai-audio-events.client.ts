import { Injectable } from '@nestjs/common';
import { fetch as undiciFetch } from 'undici';
import { AUDIOSET_CLASS_MAP } from 'src/constants/audioset-class-map.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { TelemetryRepository } from 'src/repositories/telemetry.repository.js';
import { AI_AUDIO_EVENTS_MODEL, AudioTagFrame } from 'src/utils/ai-audio-events.js';

type TagResponse = {
  model?: string;
  durationMs?: number;
  windowMs?: number;
  frameCount?: number;
  inferMs?: number;
  frames?: Array<{ t?: number; hits?: Array<{ classIndex?: number; score?: number }> }>;
};

export class AiAudioEventsClientError extends Error {
  constructor(
    readonly code: 'timeout' | 'network_error' | 'endpoint_error' | 'invalid_json' | 'invalid_output',
    message: string,
  ) {
    super(message);
    this.name = AiAudioEventsClientError.name;
  }
}

export type AiAudioEventsTagResponse = {
  durationMs: number;
  /** Frame window: a frame centered at t covers [t - windowMs/2, t + windowMs/2]. */
  windowMs: number;
  frameCount?: number;
  inferMs?: number;
  frames: AudioTagFrame[];
};

type TagOutcome = 'success' | AiAudioEventsClientError['code'];

const isAbortError = (error: unknown) =>
  (error as Error)?.name === 'AbortError' || (error as { code?: string })?.code === 'ABORT_ERR';

const isFiniteNumber = (value: unknown): value is number => typeof value === 'number' && Number.isFinite(value);

@Injectable()
export class AiAudioEventsClient {
  constructor(
    private configRepository: ConfigRepository,
    private logger: LoggingRepository,
    private telemetryRepository: TelemetryRepository,
  ) {}

  /**
  Tag a 16 kHz mono s16 WAV (the media repository's `extractVideoAudio`
  output) through the YAMNet sidecar. The sidecar returns raw frame-level
  class hits only; thresholding and span assembly happen server-side.
  */
  async tag(audio: Buffer): Promise<AiAudioEventsTagResponse> {
    const config = this.configRepository.getEnv().aiAudioEvents;
    if (!config.url) {
      throw new AiAudioEventsClientError('endpoint_error', 'AI audio events endpoint is not configured');
    }

    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), config.timeoutMs);
    const startedAt = Date.now();
    const backend = 'local-yamnet';

    try {
      const response = await undiciFetch(`${config.url.replace(/\/$/, '')}/tag`, {
        method: 'POST',
        signal: controller.signal,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ audio: audio.toString('base64') }),
      });

      if (!response.ok) {
        this.logger.warn(`AI audio events endpoint returned HTTP ${response.status} after ${Date.now() - startedAt}ms`);
        throw new AiAudioEventsClientError('endpoint_error', `AI audio events endpoint returned ${response.status}`);
      }

      let payload: TagResponse;
      try {
        payload = (await response.json()) as TagResponse;
      } catch (error) {
        if (error instanceof SyntaxError) {
          throw new AiAudioEventsClientError('invalid_json', 'AI audio events endpoint returned invalid JSON');
        }
        if (isAbortError(error)) {
          throw new AiAudioEventsClientError('timeout', 'AI audio events request timed out');
        }
        throw new AiAudioEventsClientError('network_error', 'AI audio events response stream failed');
      }

      const result = this.parse(payload);
      this.logger.debug(
        `AI audio events tagging completed in ${Date.now() - startedAt}ms (${result.frames.length} frames with hits, sidecar ${result.inferMs ?? '?'}ms)`,
      );
      this.recordRequest(backend, 'success', Date.now() - startedAt);
      return result;
    } catch (error) {
      const normalized =
        error instanceof AiAudioEventsClientError
          ? error
          : isAbortError(error)
            ? new AiAudioEventsClientError('timeout', 'AI audio events request timed out')
            : new AiAudioEventsClientError('network_error', 'AI audio events request failed');
      this.recordRequest(backend, normalized.code, Date.now() - startedAt);
      throw normalized;
    } finally {
      clearTimeout(timeout);
    }
  }

  // A different sidecar model would come with a different class map: indices
  // would silently mean other sounds, so the identity check is a hard failure.
  private parse(payload: TagResponse): AiAudioEventsTagResponse {
    if (payload.model !== AI_AUDIO_EVENTS_MODEL) {
      throw new AiAudioEventsClientError(
        'invalid_output',
        `AI audio events endpoint serves model "${payload.model}", expected "${AI_AUDIO_EVENTS_MODEL}"`,
      );
    }
    if (!isFiniteNumber(payload.durationMs) || !isFiniteNumber(payload.windowMs) || payload.windowMs <= 0) {
      throw new AiAudioEventsClientError('invalid_output', 'AI audio events response is missing durationMs/windowMs');
    }
    if (!Array.isArray(payload.frames)) {
      throw new AiAudioEventsClientError('invalid_output', 'AI audio events response has no frames array');
    }

    const frames: AudioTagFrame[] = [];
    for (const frame of payload.frames) {
      if (!isFiniteNumber(frame?.t) || !Array.isArray(frame.hits)) {
        throw new AiAudioEventsClientError('invalid_output', 'AI audio events response has a malformed frame');
      }
      const hits = frame.hits.filter(
        (hit): hit is { classIndex: number; score: number } =>
          Number.isSafeInteger(hit?.classIndex) &&
          hit.classIndex! >= 0 &&
          hit.classIndex! < AUDIOSET_CLASS_MAP.length &&
          isFiniteNumber(hit.score) &&
          hit.score >= 0 &&
          hit.score <= 1,
      );
      frames.push({ t: frame.t, hits });
    }

    return {
      durationMs: Math.round(payload.durationMs),
      windowMs: payload.windowMs,
      frameCount: isFiniteNumber(payload.frameCount) ? payload.frameCount : undefined,
      inferMs: isFiniteNumber(payload.inferMs) ? Math.round(payload.inferMs) : undefined,
      frames,
    };
  }

  private recordRequest(backend: string, outcome: TagOutcome, durationMs: number): void {
    this.telemetryRepository.jobs.recordCounter(
      'immich.ai.audio-events.requests',
      1,
      { backend, outcome },
      { description: 'AI audio events tagging requests, by serving backend and outcome' },
    );
    this.telemetryRepository.jobs.recordHistogram(
      'immich.ai.audio-events.request',
      durationMs,
      { backend },
      { unit: 'ms', description: 'Duration in ms of each AI audio events tagging request, by serving backend' },
    );
  }
}
