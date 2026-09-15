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
  choices?: Array<{ finish_reason?: string; message?: { content?: string | Array<{ type?: string; text?: string }> } }>;
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
      } catch (error) {
        // A rejected body read is not necessarily malformed JSON: a connection
        // that dies mid-body rejects with TypeError, an abort with AbortError.
        // Classify those honestly so the pattern analysis isn't poisoned.
        if (error instanceof SyntaxError) {
          throw new AiImageInterpretationClientError(
            'invalid_json',
            'AI interpretation endpoint returned invalid JSON',
          );
        }
        if ((error as Error)?.name === 'AbortError' || (error as { code?: string })?.code === 'ABORT_ERR') {
          throw new AiImageInterpretationClientError('timeout', 'AI interpretation request timed out');
        }
        throw new AiImageInterpretationClientError('network_error', 'AI interpretation response stream failed');
      }

      const usage = payload.usage;
      const finishReason = payload.choices?.[0]?.finish_reason;
      const content = getContent(payload);

      let decoded: unknown;
      try {
        decoded = parseJsonContent(content, usage);
      } catch (error) {
        if ((error as AiImageInterpretationClientError)?.code === 'invalid_json') {
          this.logger.warn(
            `AI interpretation returned unparseable content (finish_reason: ${finishReason ?? 'unknown'}, completion tokens: ${usage?.completion_tokens ?? 'unknown'}, ${content.length} chars): ${contentSnippet(content)}`,
          );
        }
        throw error;
      }

      const result = MuseInterpretationResultSchema.safeParse(decoded);
      if (!result.success) {
        this.logger.debug(
          `AI interpretation response failed schema validation (finish_reason: ${finishReason ?? 'unknown'}, completion tokens: ${usage?.completion_tokens ?? 'unknown'}): ${result.error.issues
            .slice(0, 3)
            .map((issue) => `${issue.path.join('.')}: ${issue.message}`)
            .join('; ')}`,
        );
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

// String-aware scan for delimiters still open at the end of the text; if a
// string was left unterminated, close it too before the bracket closers.
const closeOpenDelimiters = (text: string): string => {
  const stack: string[] = [];
  let inString = false;
  let escaped = false;
  for (const ch of text) {
    if (inString) {
      if (escaped) {
        escaped = false;
      } else if (ch === '\\') {
        escaped = true;
      } else if (ch === '"') {
        inString = false;
      }
      continue;
    }
    switch (ch) {
      case '"': {
        inString = true;
        break;
      }
      case '{': {
        stack.push('}');
        break;
      }
      case '[': {
        stack.push(']');
        break;
      }
      case '}':
      case ']': {
        stack.pop();
        break;
      }
      default: {
        break;
      }
    }
  }
  if (stack.length === 0 && !inString) {
    return text;
  }
  return `${text}${inString ? '"' : ''}${stack.toReversed().join('')}`;
};

// Emit the exact characters around the defect — JSON.stringify keeps escapes,
// quotes, and whitespace verbatim — without flooding the log with a full ~8KB
// completion: the head shows how the object opens, the tail shows where
// generation stopped.
const contentSnippet = (content: string): string => {
  if (content.length <= 1400) {
    return JSON.stringify(content);
  }
  return `${JSON.stringify(content.slice(0, 1000))} ...[${content.length - 1400} chars omitted]... ${JSON.stringify(content.slice(-400))}`;
};

// The serving endpoint (an Unsloth llama.cpp fork running the local VLM)
// ignores response_format entirely — verified 2026-09-15: json_schema and
// json_object both return unconstrained prose — so completions arrive as
// unguided JSON. Repair single-response defects in place instead of failing
// the run: no additional outbound request is made, and content that is still
// unparseable fails as invalid_json exactly as before (with a snippet logged
// for pattern analysis). Schema validation downstream remains the safety net.
//
// Candidate order matters: repairs that preserve every field come first.
// The brace-extraction candidates below can cut off trailing required fields
// (the model sometimes stops one token early — observed 2026-09-15:
// finish=stop with the root object's final `}` missing — in which case
// closing the full content parses cleanly, while extraction would amputate
// everything after the last inner `}` and fail the required-field schema).
const parseJsonContent = (content: string, usage?: { prompt_tokens?: number; completion_tokens?: number }): unknown => {
  const direct = tryParseJson(content);
  if (direct.parsed) {
    return direct.value;
  }

  const closed = closeOpenDelimiters(content);
  const candidates = [
    closed,
    fixTrailingCommas(content),
    closeOpenDelimiters(fixTrailingCommas(content)),
    fixStrayQuote(closed),
  ];

  for (const candidate of candidates) {
    const attempt = tryParseJson(candidate);
    if (attempt.parsed) {
      return attempt.value;
    }
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
  const extractionCandidates = [
    extracted,
    // Stray quote before the final brace: the observed `..."]"}` defect.
    // End-anchored, so a legitimately terminated object is never altered
    // (it would have parsed directly above).
    dequoted,
    // Trailing commas, the other common single-response LLM defect.
    fixTrailingCommas(extracted),
    fixTrailingCommas(dequoted),
    closeOpenDelimiters(extracted),
    closeOpenDelimiters(fixTrailingCommas(dequoted)),
  ];

  for (const candidate of extractionCandidates) {
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
