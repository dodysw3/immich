import { Injectable } from '@nestjs/common';
import { Agent, fetch as undiciFetch, type Response } from 'undici';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { TelemetryRepository } from 'src/repositories/telemetry.repository.js';
import { isTranscriptionSegmentAudible } from 'src/utils/ai-video-transcription.js';

type TranscribeResponse = {
  language?: string | null;
  languageProbability?: number | null;
  noSpeech?: boolean;
  reason?: string;
  segments?: Array<{ start?: number; end?: number; text?: string; noSpeechProb?: number; avgLogProb?: number }>;
  vad?: { speechRatio?: number };
};

type IsolateResponse = {
  audio?: string;
  sampleRate?: number;
};

// The sidecar transcribes synchronously (large-v3 int8 on CPU can take tens of
// seconds per request and queues them serially), so like the caption client the
// socket timeouts stay off and the per-request AbortController is the deadline.
const transcriptionDispatcher = new Agent({ headersTimeout: 0, bodyTimeout: 0 });

export class AiVideoTranscriptionClientError extends Error {
  constructor(
    readonly code:
      | 'timeout'
      | 'network_error'
      | 'endpoint_error'
      | 'gpu_capacity'
      | 'invalid_json'
      | 'invalid_output'
      | 'feature_disabled'
      | 'media_error',
    message: string,
  ) {
    super(message);
    this.name = AiVideoTranscriptionClientError.name;
  }
}

export type AiVideoTranscriptionResponse = {
  language?: string;
  languageProbability?: number;
  noSpeech: boolean;
  reason?: string;
  segments: Array<{ startSec: number; endSec: number; text: string }>;
  /** Confidence evidence for the isolation gate/acceptance (voice-isolation pass). */
  diagnostics: { meanAvgLogProb?: number; speechRatio?: number; segmentCount: number };
};

export type TranscriptionRequestClass = 'live' | 'backfill';

type TranscriptionOutcome = 'success' | AiVideoTranscriptionClientError['code'];

@Injectable()
export class AiVideoTranscriptionClient {
  constructor(
    private configRepository: ConfigRepository,
    private logger: LoggingRepository,
    private telemetryRepository: TelemetryRepository,
  ) {}

  /**
  Transcribe a 16 kHz mono s16 WAV (the media repository's `extractVideoAudio`
  output) through the faster-whisper sidecar. The sidecar applies the VAD +
  post-ASR hallucination filter and reports `noSpeech` when no usable speech
  survives.
  */
  async transcribe(
    audio: Buffer,
    options?: { language?: string; requestClass?: TranscriptionRequestClass },
  ): Promise<AiVideoTranscriptionResponse> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    if (!config.url) {
      throw new AiVideoTranscriptionClientError('endpoint_error', 'AI video transcription endpoint is not configured');
    }

    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), config.timeoutMs);
    const startedAt = Date.now();
    const backend = 'local-whisper';

    try {
      const response = await undiciFetch(`${config.url.replace(/\/$/, '')}/transcribe`, {
        method: 'POST',
        signal: controller.signal,
        dispatcher: transcriptionDispatcher,
        headers: {
          'Content-Type': 'application/json',
          ...(options?.requestClass && { 'X-Immich-Transcription-Class': options.requestClass }),
        },
        body: JSON.stringify({
          audio: audio.toString('base64'),
          ...(options?.language && { language: options.language }),
        }),
      });

      if (!response.ok) {
        if (config.dualGpu && (await this.isGpuCapacity(response))) {
          throw new AiVideoTranscriptionClientError('gpu_capacity', 'Shared GPU admission deferred Whisper');
        }
        this.logger.warn(
          `AI video transcription endpoint returned HTTP ${response.status} after ${Date.now() - startedAt}ms`,
        );
        throw new AiVideoTranscriptionClientError(
          'endpoint_error',
          `AI video transcription endpoint returned ${response.status}`,
        );
      }

      let payload: TranscribeResponse;
      try {
        payload = (await response.json()) as TranscribeResponse;
      } catch (error) {
        if (error instanceof SyntaxError) {
          throw new AiVideoTranscriptionClientError(
            'invalid_json',
            'AI video transcription endpoint returned invalid JSON',
          );
        }
        if ((error as Error)?.name === 'AbortError' || (error as { code?: string })?.code === 'ABORT_ERR') {
          throw new AiVideoTranscriptionClientError('timeout', 'AI video transcription request timed out');
        }
        throw new AiVideoTranscriptionClientError('network_error', 'AI video transcription response stream failed');
      }

      const noSpeech = payload.noSpeech === true;
      const kept = noSpeech
        ? []
        : (payload.segments ?? [])
            .filter(
              (segment) =>
                typeof segment.start === 'number' && typeof segment.end === 'number' && !!segment.text?.trim(),
            )
            .filter((segment) => isTranscriptionSegmentAudible(segment));
      const segments = kept.map((segment) => ({
        startSec: segment.start!,
        endSec: segment.end!,
        text: segment.text!.trim(),
      }));
      const logProbs = kept
        .map((segment) => segment.avgLogProb)
        .filter((value): value is number => typeof value === 'number');
      const diagnostics = {
        meanAvgLogProb:
          logProbs.length > 0
            ? Math.round((logProbs.reduce((sum, value) => sum + value, 0) / logProbs.length) * 1000) / 1000
            : undefined,
        speechRatio: payload.vad?.speechRatio,
        segmentCount: segments.length,
      };

      this.logger.debug(
        `AI video transcription completed in ${Date.now() - startedAt}ms (${noSpeech ? `no speech: ${payload.reason ?? 'unknown'}` : `${segments.length} segments`}, language: ${payload.language ?? 'unknown'})`,
      );
      this.recordRequest(backend, 'success', Date.now() - startedAt);
      return {
        language: payload.language ?? undefined,
        languageProbability: payload.languageProbability ?? undefined,
        noSpeech,
        reason: payload.reason,
        segments,
        diagnostics,
      };
    } catch (error) {
      const normalized =
        error instanceof AiVideoTranscriptionClientError
          ? error
          : (error as Error)?.name === 'AbortError' || (error as { code?: string })?.code === 'ABORT_ERR'
            ? new AiVideoTranscriptionClientError('timeout', 'AI video transcription request timed out')
            : new AiVideoTranscriptionClientError('network_error', 'AI video transcription request failed');
      this.recordRequest(backend, normalized.code, Date.now() - startedAt);
      throw normalized;
    } finally {
      clearTimeout(timeout);
    }
  }

  /**
  Run a 48 kHz mono chunk through the voice-isolator sidecar and get the
  isolated voice back as a 16 kHz mono WAV, ready for `transcribe`.
  */
  async isolateVoice(
    audio: Buffer,
    options?: { outputSampleRate?: number; requestClass?: TranscriptionRequestClass },
  ): Promise<Buffer> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    if (!config.voiceIsolationUrl) {
      throw new AiVideoTranscriptionClientError('feature_disabled', 'Voice isolation endpoint is not configured');
    }
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), config.timeoutMs);
    const startedAt = Date.now();
    try {
      const response = await undiciFetch(`${config.voiceIsolationUrl.replace(/\/$/, '')}/isolate`, {
        method: 'POST',
        signal: controller.signal,
        dispatcher: transcriptionDispatcher,
        headers: {
          'Content-Type': 'application/json',
          ...(options?.requestClass && { 'X-Immich-Transcription-Class': options.requestClass }),
        },
        body: JSON.stringify({
          audio: audio.toString('base64'),
          outputSampleRate: options?.outputSampleRate ?? 16_000,
        }),
      });
      if (!response.ok) {
        if (config.dualGpu && (await this.isGpuCapacity(response))) {
          throw new AiVideoTranscriptionClientError('gpu_capacity', 'Shared GPU admission deferred isolation');
        }
        this.logger.warn(`Voice isolation endpoint returned HTTP ${response.status} after ${Date.now() - startedAt}ms`);
        throw new AiVideoTranscriptionClientError(
          'endpoint_error',
          `Voice isolation endpoint returned ${response.status}`,
        );
      }
      const payload = (await response.json()) as IsolateResponse;
      if (!payload.audio) {
        throw new AiVideoTranscriptionClientError('invalid_output', 'Voice isolation returned no audio');
      }
      this.recordRequest('voice-isolator', 'success', Date.now() - startedAt);
      return Buffer.from(payload.audio, 'base64');
    } catch (error) {
      const normalized =
        error instanceof AiVideoTranscriptionClientError
          ? error
          : (error as Error)?.name === 'AbortError' || (error as { code?: string })?.code === 'ABORT_ERR'
            ? new AiVideoTranscriptionClientError('timeout', 'Voice isolation request timed out')
            : new AiVideoTranscriptionClientError('network_error', 'Voice isolation request failed');
      this.recordRequest('voice-isolator', normalized.code, Date.now() - startedAt);
      throw normalized;
    } finally {
      clearTimeout(timeout);
    }
  }

  private async isGpuCapacity(response: Response): Promise<boolean> {
    if (response.status !== 503) {
      return false;
    }
    try {
      const body = (await response.json()) as { code?: unknown; retryable?: unknown } | null;
      return body?.code === 'gpu_capacity' && body.retryable === true;
    } catch (error) {
      if ((error as Error)?.name === 'AbortError') {
        throw error;
      }
      return false;
    }
  }

  private recordRequest(backend: string, outcome: TranscriptionOutcome, durationMs: number): void {
    this.telemetryRepository.jobs.recordCounter(
      'immich.ai.video-transcription.requests',
      1,
      { backend, outcome },
      { description: 'AI video transcription endpoint requests, by serving backend and outcome' },
    );
    this.telemetryRepository.jobs.recordHistogram(
      'immich.ai.video-transcription.request',
      durationMs,
      { backend },
      { unit: 'ms', description: 'Duration in ms of each AI video transcription request, by serving backend' },
    );
  }
}
