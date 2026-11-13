import { Injectable } from '@nestjs/common';
import { Agent, fetch as undiciFetch } from 'undici';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { TelemetryRepository } from 'src/repositories/telemetry.repository.js';
import { isTranscriptionSegmentAudible } from 'src/utils/ai-video-transcription.js';

type TranscribeResponse = {
  language?: string;
  languageProbability?: number;
  noSpeech?: boolean;
  reason?: string;
  segments?: Array<{ start?: number; end?: number; text?: string; noSpeechProb?: number; avgLogProb?: number }>;
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
};

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
  async transcribe(audio: Buffer, options?: { language?: string }): Promise<AiVideoTranscriptionResponse> {
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
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          audio: audio.toString('base64'),
          ...(options?.language && { language: options.language }),
        }),
      });

      if (!response.ok) {
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
      const segments = noSpeech
        ? []
        : (payload.segments ?? [])
            .filter(
              (segment) =>
                typeof segment.start === 'number' && typeof segment.end === 'number' && !!segment.text?.trim(),
            )
            .filter((segment) => isTranscriptionSegmentAudible(segment))
            .map((segment) => ({ startSec: segment.start!, endSec: segment.end!, text: segment.text!.trim() }));

      this.logger.debug(
        `AI video transcription completed in ${Date.now() - startedAt}ms (${noSpeech ? `no speech: ${payload.reason ?? 'unknown'}` : `${segments.length} segments`}, language: ${payload.language ?? 'unknown'})`,
      );
      this.recordRequest(backend, 'success', Date.now() - startedAt);
      return {
        language: payload.language,
        languageProbability: payload.languageProbability,
        noSpeech,
        reason: payload.reason,
        segments,
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
