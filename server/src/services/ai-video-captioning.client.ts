import { Injectable } from '@nestjs/common';
import { Agent, fetch as undiciFetch } from 'undici';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { TelemetryRepository } from 'src/repositories/telemetry.repository.js';
import { stripCaptionOpener, stripCaptionThinking } from 'src/utils/ai-video-captioning.js';

type CompletionResponse = {
  model?: string;
  choices?: Array<{ finish_reason?: string; message?: { content?: string | Array<{ type?: string; text?: string }> } }>;
  usage?: { prompt_tokens?: number; completion_tokens?: number };
};

// Same serving-stack contract as the interpretation client: the local
// llama-server generates the whole completion before sending bytes, so undici's
// socket timeouts must stay off; the per-request AbortController is the deadline.
const captionDispatcher = new Agent({ headersTimeout: 0, bodyTimeout: 0 });

export class AiVideoCaptioningClientError extends Error {
  constructor(
    readonly code:
      'timeout' | 'network_error' | 'endpoint_error' | 'invalid_json' | 'invalid_output' | 'feature_disabled',
    message: string,
    readonly promptTokens?: number,
    readonly completionTokens?: number,
  ) {
    super(message);
    this.name = AiVideoCaptioningClientError.name;
  }
}

export type AiVideoCaptioningResponse = {
  caption: string;
  promptTokens?: number;
  completionTokens?: number;
  servedModel?: string;
};

type CaptionOutcome = 'success' | AiVideoCaptioningClientError['code'];

export interface CaptionFrame {
  /** Full base64 data URI for the sampled JPEG frame. */
  dataUri: string;
  /** Frame timestamp in seconds from the video start (nominal sample time). */
  timeSec: number;
}

const CAPTION_MAX_OUTPUT_TOKENS = 1024;

@Injectable()
export class AiVideoCaptioningClient {
  constructor(
    private configRepository: ConfigRepository,
    private logger: LoggingRepository,
    private telemetryRepository: TelemetryRepository,
  ) {}

  /**
  Caption one video segment from its sampled frames — visual-only since the
  2026-11-07 eval (omni audio slices hallucinated languages and looped on
  reverberant speech; audible content is covered by the whisper transcript
  fed to interpretation). Frames travel as interleaved timestamp/image
  content so the VLM sees the timeline order. No sampling params and never
  any response_format (llama.cpp compiles it into a grammar — see the
  interpretation client for that fight).
  */
  async captionSegment(
    frames: CaptionFrame[],
    segment: { startMs: number; endMs: number },
    prompt: string,
  ): Promise<AiVideoCaptioningResponse> {
    const config = this.configRepository.getEnv().aiVideoCaptioning;
    if (!config.url) {
      throw new AiVideoCaptioningClientError('endpoint_error', 'AI video captioning endpoint is not configured');
    }

    if (frames.length === 0) {
      throw new AiVideoCaptioningClientError('invalid_output', 'Captioning segment has no frames');
    }

    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), config.timeoutMs);
    const startedAt = Date.now();
    const backend = 'local';

    const content: Array<Record<string, unknown>> = [{ type: 'text', text: prompt }];
    for (const frame of frames) {
      content.push(
        { type: 'text', text: `Frame at ${frame.timeSec.toFixed(1)}s:` },
        {
          type: 'image_url',
          image_url: { url: frame.dataUri },
        },
      );
    }

    try {
      const response = await undiciFetch(`${config.url.replace(/\/$/, '')}/chat/completions`, {
        method: 'POST',
        signal: controller.signal,
        dispatcher: captionDispatcher,
        headers: {
          'Content-Type': 'application/json',
          ...(config.apiKey && { Authorization: `Bearer ${config.apiKey}` }),
        },
        body: JSON.stringify({
          model: config.model,
          max_tokens: CAPTION_MAX_OUTPUT_TOKENS,
          messages: [{ role: 'user', content }],
        }),
      });

      if (!response.ok) {
        this.logger.warn(
          `AI video captioning endpoint returned HTTP ${response.status} after ${Date.now() - startedAt}ms`,
        );
        throw new AiVideoCaptioningClientError(
          'endpoint_error',
          `AI video captioning endpoint returned ${response.status}`,
        );
      }

      let payload: CompletionResponse;
      try {
        payload = (await response.json()) as CompletionResponse;
      } catch (error) {
        if (error instanceof SyntaxError) {
          throw new AiVideoCaptioningClientError('invalid_json', 'AI video captioning endpoint returned invalid JSON');
        }
        if ((error as Error)?.name === 'AbortError' || (error as { code?: string })?.code === 'ABORT_ERR') {
          throw new AiVideoCaptioningClientError('timeout', 'AI video captioning request timed out');
        }
        throw new AiVideoCaptioningClientError('network_error', 'AI video captioning response stream failed');
      }

      const usage = payload.usage;
      const finishReason = payload.choices?.[0]?.finish_reason;
      const raw = getContent(payload);
      const caption = normalizeCaption(raw);
      if (!caption) {
        throw new AiVideoCaptioningClientError(
          'invalid_output',
          'AI video captioning response had no caption text',
          usage?.prompt_tokens,
          usage?.completion_tokens,
        );
      }
      if (finishReason === 'length') {
        this.logger.warn(
          `AI video captioning output truncated (finish_reason: length, completion tokens: ${usage?.completion_tokens ?? 'unknown'})`,
        );
      }

      this.logger.debug(
        `AI video captioning segment ${segment.startMs}-${segment.endMs}ms completed in ${Date.now() - startedAt}ms (model: ${config.model}, prompt tokens: ${usage?.prompt_tokens ?? 'unknown'}, completion tokens: ${usage?.completion_tokens ?? 'unknown'})`,
      );
      this.recordRequest(backend, 'success', Date.now() - startedAt);
      return {
        caption,
        promptTokens: usage?.prompt_tokens,
        completionTokens: usage?.completion_tokens,
        servedModel: payload.model,
      };
    } catch (error) {
      const normalized =
        error instanceof AiVideoCaptioningClientError
          ? error
          : (error as Error)?.name === 'AbortError' || (error as { code?: string })?.code === 'ABORT_ERR'
            ? new AiVideoCaptioningClientError('timeout', 'AI video captioning request timed out')
            : new AiVideoCaptioningClientError('network_error', 'AI video captioning request failed');
      this.recordRequest(backend, normalized.code, Date.now() - startedAt);
      throw normalized;
    } finally {
      clearTimeout(timeout);
    }
  }

  private recordRequest(backend: string, outcome: CaptionOutcome, durationMs: number): void {
    this.telemetryRepository.jobs.recordCounter(
      'immich.ai.video-captioning.requests',
      1,
      { backend, outcome },
      { description: 'AI video captioning endpoint requests, by serving backend and outcome' },
    );
    this.telemetryRepository.jobs.recordHistogram(
      'immich.ai.video-captioning.request',
      durationMs,
      { backend },
      { unit: 'ms', description: 'Duration in ms of each AI video captioning request, by serving backend' },
    );
  }
}

const getContent = (payload: CompletionResponse): string => {
  const content = payload.choices?.[0]?.message?.content;
  if (typeof content === 'string' && content.length > 0) {
    return content;
  }

  if (Array.isArray(content)) {
    const text = content
      .filter((item) => item.type === 'text' && item.text)
      .map((item) => item.text)
      .join('');
    if (text) {
      return text;
    }
  }

  return '';
};

const normalizeCaption = (raw: string): string =>
  stripCaptionOpener(
    stripCaptionThinking(raw)
      .replaceAll(/\s*\n+\s*/g, ' ')
      .replaceAll(/\s{2,}/g, ' ')
      .trim(),
  );
