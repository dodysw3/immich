import { Injectable } from '@nestjs/common';
import { fetch as undiciFetch } from 'undici';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';

type EmbeddingsResponse = {
  data?: Array<{ index?: number; embedding?: number[] }>;
};

export class AiInterpretSearchClientError extends Error {
  constructor(
    readonly code: 'timeout' | 'network_error' | 'endpoint_error' | 'invalid_output' | 'feature_disabled',
    message: string,
  ) {
    super(message);
    this.name = AiInterpretSearchClientError.name;
  }
}

@Injectable()
export class AiInterpretSearchClient {
  constructor(
    private configRepository: ConfigRepository,
    private logger: LoggingRepository,
  ) {}

  /**
   * Embed one or more texts against the OpenAI-compatible `/v1/embeddings`
   * endpoint of the llama-server serving the BGE-M3 embedding model. Returns
   * one vector per input, in input order.
   */
  async embed(texts: string[]): Promise<number[][]> {
    const config = this.configRepository.getEnv().aiInterpretSearch;
    if (!config.enabled) {
      throw new AiInterpretSearchClientError('feature_disabled', 'AI interpret search is disabled');
    }
    if (!config.url) {
      throw new AiInterpretSearchClientError('endpoint_error', 'AI interpret search endpoint is not configured');
    }

    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), config.timeoutMs);
    const startedAt = Date.now();

    try {
      const response = await undiciFetch(`${config.url.replace(/\/$/, '')}/v1/embeddings`, {
        method: 'POST',
        signal: controller.signal,
        headers: {
          'Content-Type': 'application/json',
          ...(config.apiKey && { Authorization: `Bearer ${config.apiKey}` }),
        },
        body: JSON.stringify({
          model: config.model,
          input: texts,
        }),
      });

      if (!response.ok) {
        this.logger.warn(
          `AI interpret search embedding endpoint returned HTTP ${response.status} after ${Date.now() - startedAt}ms`,
        );
        throw new AiInterpretSearchClientError(
          'endpoint_error',
          `AI interpret search endpoint returned ${response.status}`,
        );
      }

      let payload: EmbeddingsResponse;
      try {
        payload = (await response.json()) as EmbeddingsResponse;
      } catch (error) {
        if ((error as Error)?.name === 'AbortError' || (error as { code?: string })?.code === 'ABORT_ERR') {
          throw new AiInterpretSearchClientError('timeout', 'AI interpret search request timed out');
        }
        throw new AiInterpretSearchClientError('invalid_output', 'AI interpret search response stream failed');
      }

      const data = payload.data?.toSorted((a, b) => (a.index ?? 0) - (b.index ?? 0));
      if (!data || data.length !== texts.length) {
        throw new AiInterpretSearchClientError(
          'invalid_output',
          `AI interpret search endpoint returned ${data?.length ?? 0} embeddings for ${texts.length} input(s)`,
        );
      }

      const embeddings: number[][] = [];
      for (const { embedding } of data) {
        if (!embedding?.length) {
          throw new AiInterpretSearchClientError('invalid_output', 'AI interpret search response had an empty vector');
        }
        embeddings.push(embedding);
      }

      this.logger.debug(`AI interpret search embedded ${texts.length} text(s) in ${Date.now() - startedAt}ms`);
      return embeddings;
    } catch (error) {
      if (error instanceof AiInterpretSearchClientError) {
        throw error;
      }

      if ((error as Error)?.name === 'AbortError' || (error as { code?: string })?.code === 'ABORT_ERR') {
        throw new AiInterpretSearchClientError('timeout', 'AI interpret search request timed out');
      }

      throw new AiInterpretSearchClientError('network_error', 'AI interpret search request failed');
    } finally {
      clearTimeout(timeout);
    }
  }
}
