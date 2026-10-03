import { Injectable } from '@nestjs/common';
import { Agent, fetch as undiciFetch } from 'undici';
import {
  MUSE_RESULT_JSON_SCHEMA,
  MuseInterpretationResult,
  MuseInterpretationResultSchema,
} from 'src/dtos/ai-image-interpretation.dto.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import {
  AI_IMAGE_INTERPRETATION_FORMAT_INSTRUCTION,
  AI_IMAGE_INTERPRETATION_MAX_OUTPUT_TOKENS,
  AI_IMAGE_INTERPRETATION_PROMPT,
} from 'src/utils/ai-image-interpretation.js';

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
          // Muse-Glimmer is a GLM-family model that "thinks" before answering;
          // the hidden reasoning is ~35% of completion tokens and is discarded
          // by this client. 'low' is the serving stack's verified floor — the
          // stronger off switches (--reasoning-budget, template prefills) are
          // ignored or hard-error on this build. Benchmarked 2026-10-02:
          // quality judged equal-or-better blind at ~half the total tokens.
          chat_template_kwargs: { reasoning_strength: 'low' },
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
                { type: 'text', text: AI_IMAGE_INTERPRETATION_FORMAT_INSTRUCTION },
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
        decoded = parseLineContent(content);
      } catch (error) {
        this.logger.warn(
          `AI interpretation returned unparseable content (finish_reason: ${finishReason ?? 'unknown'}, completion tokens: ${usage?.completion_tokens ?? 'unknown'}, ${content.length} chars): ${contentSnippet(content)}`,
        );
        throw new AiImageInterpretationClientError(
          'invalid_json',
          `AI interpretation content did not match the line contract: ${error instanceof Error ? error.message : String(error)}`,
          usage?.prompt_tokens,
          usage?.completion_tokens,
        );
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

// Emit the exact characters around the defect — JSON.stringify keeps escapes,
// quotes, and whitespace verbatim — without flooding the log with a full ~8KB
// completion: the head shows how the output opens, the tail shows where
// generation stopped.
const contentSnippet = (content: string): string => {
  if (content.length <= 1400) {
    return JSON.stringify(content);
  }
  return `${JSON.stringify(content.slice(0, 1000))} ...[${content.length - 1400} chars omitted]... ${JSON.stringify(content.slice(-400))}`;
};

// 1.2.0 wire format: one record per line — T/D/I/A singles, N/X array records
// (`N M|detail|significance`, `X H|PLACE|Name|basis`), one K keyword line.
// Text fields may legitimately contain '|', so array records anchor on the
// enum fields: a record's first field must decode as a confidence code (and an
// X record's second as a type code); every remaining separator folds back into
// the trailing text. Anything else — unknown markers, duplicate or missing
// singles, undecodable codes — fails the run as invalid_json and retries like
// any other defect; the benchmarked malformation budget is ~2-3% of runs
// (immich-app/format-bench/REPORT.md). Markdown fences are tolerated: the
// model occasionally wraps the block despite the instruction.
const CONFIDENCE_CODES = {
  H: 'high',
  M: 'medium',
  L: 'low',
  HIGH: 'high',
  MEDIUM: 'medium',
  LOW: 'low',
} as const;

const IDENTIFICATION_TYPE_CODES = {
  PERS: 'person',
  PLACE: 'place',
  ART: 'artwork',
  OBJ: 'object',
  ORG: 'organization',
  OTH: 'other',
  PERSON: 'person',
} as const;

const decodeConfidenceCode = (value: string): string => {
  const code = CONFIDENCE_CODES[value.trim().toUpperCase() as keyof typeof CONFIDENCE_CODES];
  if (!code) {
    throw new Error(`unknown confidence code ${JSON.stringify(value.slice(0, 40))}`);
  }
  return code;
};

const decodeIdentificationTypeCode = (value: string): string => {
  const code = IDENTIFICATION_TYPE_CODES[value.trim().toUpperCase() as keyof typeof IDENTIFICATION_TYPE_CODES];
  if (!code) {
    throw new Error(`unknown identification type ${JSON.stringify(value.slice(0, 40))}`);
  }
  return code;
};

const stripFences = (content: string): string => {
  const trimmed = content.trim();
  if (!trimmed.startsWith('```')) {
    return trimmed;
  }
  return trimmed
    .replace(/^```[a-zA-Z]*\s*/, '')
    .replace(/\s*```\s*$/, '')
    .trim();
};

const parseLineContent = (content: string): unknown => {
  const singles = new Map<string, string>();
  const notableDetails: Array<{ detail: string; significance: string; confidence: string }> = [];
  const identifications: Array<{ name: string; type: string; confidence: string; basis: string }> = [];
  let keywords: string[] | undefined;

  for (const rawLine of stripFences(content).split(/\r?\n/)) {
    const line = rawLine.trimEnd();
    if (line.trim().length === 0) {
      continue;
    }
    const match = /^([TDINXAK])\s+(.*)$/s.exec(line);
    if (!match) {
      throw new Error(`unrecognized record ${JSON.stringify(line.slice(0, 60))}`);
    }
    const marker = match[1];
    const value = match[2];
    switch (marker) {
      case 'N': {
        const parts = value.split('|').map((part) => part.trim());
        if (parts.length < 3) {
          throw new Error(`N record needs <confidence>|<detail>|<significance>: ${JSON.stringify(line.slice(0, 60))}`);
        }
        notableDetails.push({
          detail: parts[1],
          significance: parts.slice(2).join('|'),
          confidence: decodeConfidenceCode(parts[0]),
        });
        break;
      }
      case 'X': {
        const parts = value.split('|').map((part) => part.trim());
        if (parts.length < 4) {
          throw new Error(`X record needs <confidence>|<type>|<name>|<basis>: ${JSON.stringify(line.slice(0, 60))}`);
        }
        identifications.push({
          name: parts[2],
          type: decodeIdentificationTypeCode(parts[1]),
          confidence: decodeConfidenceCode(parts[0]),
          basis: parts.slice(3).join('|'),
        });
        break;
      }
      case 'K': {
        if (keywords !== undefined) {
          throw new Error('duplicate K record');
        }
        keywords = value
          .split('|')
          .map((keyword) => keyword.trim())
          .filter((keyword) => keyword.length > 0);
        break;
      }
      default: {
        if (singles.has(marker)) {
          throw new Error(`duplicate ${marker} record`);
        }
        singles.set(marker, value.trim());
      }
    }
  }

  for (const marker of ['T', 'D', 'I', 'A']) {
    if (!singles.has(marker)) {
      throw new Error(`missing ${marker} record`);
    }
  }

  return {
    title: singles.get('T'),
    literal_description: singles.get('D'),
    interpretation: singles.get('I'),
    notable_details: notableDetails,
    identifications,
    archive_summary: singles.get('A'),
    search_keywords: keywords ?? [],
  };
};
