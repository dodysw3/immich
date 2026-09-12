import { Injectable } from '@nestjs/common';
import {
  MUSE_RESULT_JSON_SCHEMA,
  MuseInterpretationResult,
  MuseInterpretationResultSchema,
} from 'src/dtos/ai-image-interpretation.dto';
import { ConfigRepository } from 'src/repositories/config.repository';
import { LoggingRepository } from 'src/repositories/logging.repository';
import {
  AI_IMAGE_INTERPRETATION_MAX_OUTPUT_TOKENS,
  AI_IMAGE_INTERPRETATION_PROMPT,
  AI_IMAGE_INTERPRETATION_SCHEMA_INSTRUCTION,
} from 'src/utils/ai-image-interpretation';
import { Agent, fetch as undiciFetch } from 'undici';

type CompletionResponse = {
  choices?: Array<{ message?: { content?: string | Array<{ type?: string; text?: string }> } }>;
  usage?: { prompt_tokens?: number; completion_tokens?: number };
};

// The local VLM endpoint generates the entire completion before sending any
// bytes, so undici's default 300s headers timeout kills long generations
// mid-flight (observed 2026-09-12: network_error at ~300.3s when two
// concurrent requests share the server at ~7 t/s). Disable the socket-level
// timeouts; the AbortController per request remains the sole deadline.
const interpretDispatcher = new Agent({ headersTimeout: 0, bodyTimeout: 0 });

export class AiImageInterpretationClientError extends Error {
  constructor(
    readonly code:
      | 'timeout'
      | 'network_error'
      | 'endpoint_error'
      | 'invalid_json'
      | 'invalid_output'
      | 'preview_missing'
      | 'preview_too_large'
      | 'preview_invalid'
      | 'feature_disabled',
    message: string,
    readonly promptTokens?: number,
    readonly completionTokens?: number,
  ) {
    super(message);
    this.name = AiImageInterpretationClientError.name;
  }
}

export type AiImageInterpretationResponse = {
  result: MuseInterpretationResult;
  promptTokens?: number;
  completionTokens?: number;
};

@Injectable()
export class AiImageInterpretationClient {
  constructor(
    private configRepository: ConfigRepository,
    private logger: LoggingRepository,
  ) {}

  async interpret(image: Buffer, overrides?: { model?: string }): Promise<AiImageInterpretationResponse> {
    const config = this.configRepository.getEnv().aiImageInterpretation;
    if (!config.url) {
      throw new AiImageInterpretationClientError('endpoint_error', 'AI interpretation endpoint is not configured');
    }

    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), config.timeoutMs);
    const startedAt = Date.now();

    try {
      const response = await undiciFetch(`${config.url.replace(/\/$/, '')}/chat/completions`, {
        method: 'POST',
        signal: controller.signal,
        dispatcher: interpretDispatcher,
        headers: {
          'Content-Type': 'application/json',
          ...(config.apiKey && { Authorization: `Bearer ${config.apiKey}` }),
        },
        body: JSON.stringify({
          model: overrides?.model ?? config.model,
          temperature: 0.2,
          max_tokens: AI_IMAGE_INTERPRETATION_MAX_OUTPUT_TOKENS,
          response_format: {
            type: 'json_schema',
            json_schema: {
              name: 'muse_image_interpretation',
              strict: true,
              schema: MUSE_RESULT_JSON_SCHEMA,
            },
          },
          messages: [
            { role: 'system', content: AI_IMAGE_INTERPRETATION_PROMPT },
            {
              role: 'user',
              content: [
                { type: 'image_url', image_url: { url: `data:image/jpeg;base64,${image.toString('base64')}` } },
                { type: 'text', text: AI_IMAGE_INTERPRETATION_SCHEMA_INSTRUCTION },
              ],
            },
          ],
        }),
      });

      if (!response.ok) {
        this.logger.warn(
          `AI interpretation endpoint returned HTTP ${response.status} after ${Date.now() - startedAt}ms`,
        );
        throw new AiImageInterpretationClientError(
          'endpoint_error',
          `AI interpretation endpoint returned ${response.status}`,
        );
      }

      let payload: CompletionResponse;
      try {
        payload = (await response.json()) as CompletionResponse;
      } catch {
        throw new AiImageInterpretationClientError('invalid_json', 'AI interpretation endpoint returned invalid JSON');
      }

      const usage = payload.usage;
      const content = getContent(payload);
      const decoded = parseJsonContent(content, usage);

      const result = MuseInterpretationResultSchema.safeParse(decoded);
      if (!result.success) {
        throw new AiImageInterpretationClientError(
          'invalid_output',
          'AI interpretation response failed schema validation',
          usage?.prompt_tokens,
          usage?.completion_tokens,
        );
      }

      this.logger.debug(
        `AI interpretation completed in ${Date.now() - startedAt}ms (prompt tokens: ${usage?.prompt_tokens ?? 'unknown'}, completion tokens: ${usage?.completion_tokens ?? 'unknown'})`,
      );
      return {
        result: result.data,
        promptTokens: usage?.prompt_tokens,
        completionTokens: usage?.completion_tokens,
      };
    } catch (error) {
      if (error instanceof AiImageInterpretationClientError) {
        throw error;
      }

      if ((error as Error)?.name === 'AbortError' || (error as { code?: string })?.code === 'ABORT_ERR') {
        throw new AiImageInterpretationClientError('timeout', 'AI interpretation request timed out');
      }

      throw new AiImageInterpretationClientError('network_error', 'AI interpretation request failed');
    } finally {
      clearTimeout(timeout);
    }
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

  throw new AiImageInterpretationClientError('invalid_output', 'AI interpretation response had no text content');
};

const tryParseJson = (text: string): { parsed: true; value: unknown } | { parsed: false } => {
  try {
    return { parsed: true, value: JSON.parse(text) };
  } catch {
    return { parsed: false };
  }
};

const fixStrayQuote = (text: string) => text.replace(/"\s*\}\s*$/, '}');
const fixTrailingCommas = (text: string) => text.replaceAll(/,\s*([}\]])/g, '$1');

// The local VLM occasionally emits a complete JSON object with a single
// stray `"` after the final bracket (`..."]"}` instead of `..."]}`), which
// the requested json_schema grammar does not catch (observed 2026-09-11:
// finish=stop, ~1200 completion tokens, well under max_tokens). Repair the
// single response in place instead of failing the run: no additional outbound
// request is made, and content that is still unparseable fails as invalid_json
// exactly as before. Schema validation downstream remains the safety net.
const parseJsonContent = (content: string, usage?: { prompt_tokens?: number; completion_tokens?: number }): unknown => {
  const direct = tryParseJson(content);
  if (direct.parsed) {
    return direct.value;
  }

  const start = content.indexOf('{');
  const end = content.lastIndexOf('}');
  if (start === -1 || end <= start) {
    throw new AiImageInterpretationClientError(
      'invalid_json',
      'AI interpretation response content was not valid JSON',
      usage?.prompt_tokens,
      usage?.completion_tokens,
    );
  }

  const extracted = content.slice(start, end + 1);
  const dequoted = fixStrayQuote(extracted);
  const candidates = [
    extracted,
    // Stray quote before the final brace: the observed `..."]"}` defect.
    // End-anchored, so a legitimately terminated object is never altered
    // (it would have parsed directly above).
    dequoted,
    // Trailing commas, the other common single-response LLM defect.
    fixTrailingCommas(extracted),
    fixTrailingCommas(dequoted),
  ];

  for (const candidate of candidates) {
    const attempt = tryParseJson(candidate);
    if (attempt.parsed) {
      return attempt.value;
    }
  }

  throw new AiImageInterpretationClientError(
    'invalid_json',
    'AI interpretation response content was not valid JSON',
    usage?.prompt_tokens,
    usage?.completion_tokens,
  );
};
