import { Injectable } from '@nestjs/common';
import { MuseInterpretationResult } from 'src/dtos/ai-image-interpretation.dto.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';

const DISCORD_TITLE_LIMIT = 256;
const DISCORD_DESCRIPTION_LIMIT = 4096;
const DISCORD_FIELD_VALUE_LIMIT = 1024;
const DISCORD_REQUEST_TIMEOUT_MS = 10_000;

export type AiInterpretationDiscordThumbnail = {
  buffer: Buffer;
  contentType: 'image/gif' | 'image/jpeg' | 'image/png' | 'image/webp';
  filename: string;
};

export type AiInterpretationDiscordAlert = {
  accountName: string;
  assetId: string;
  externalDomain?: string;
  originalFileName: string;
  photoDate: string;
  waitingCount: number;
  eta: string;
  result: MuseInterpretationResult;
  thumbnail?: AiInterpretationDiscordThumbnail;
};

type DiscordEmbed = {
  title: string;
  description?: string;
  url?: string;
  timestamp?: string;
  color: number;
  fields: Array<{ name: string; value: string; inline: boolean }>;
  thumbnail?: { url: string };
};

type DiscordWebhookPayload = {
  allowed_mentions: { parse: string[] };
  embeds: DiscordEmbed[];
  attachments?: Array<{ id: number; filename: string; description: string }>;
};

type DiscordAlertErrorCode =
  'client_error' | 'network' | 'not_configured' | 'rate_limited' | 'server_error' | 'timeout';

export class AiInterpretationDiscordAlertError extends Error {
  constructor(
    message: string,
    public readonly code: DiscordAlertErrorCode,
    public readonly retryable: boolean,
    public readonly retryAfterMs?: number,
    options?: { cause?: unknown },
  ) {
    super(message, options);
  }
}

const truncate = (value: string, limit: number) => {
  const normalized = value.trim();
  return normalized.length <= limit ? normalized : `${normalized.slice(0, limit - 1)}…`;
};

const DISCORD_ERROR_DETAIL_LIMIT = 300;

// Never embed the raw webhook URL or response body in errors: the URL carries
// the webhook token and the body can echo requester-supplied content.
const getWebhookHost = (webhookUrl: string) => {
  try {
    return new URL(webhookUrl).host;
  } catch {
    return 'unknown host';
  }
};

const getNetworkCauseCode = (error: unknown) => {
  const cause = (error as { cause?: { code?: string; errors?: Array<{ code?: string }> } } | undefined)?.cause;
  if (!cause) {
    return;
  }
  return cause.code ?? cause.errors?.find((entry) => entry.code)?.code;
};

const getDiscordApiMessage = async (response: Response) => {
  try {
    const body = (await response.json()) as { message?: unknown };
    if (typeof body.message !== 'string' || !body.message.trim()) {
      return;
    }
    return truncate(body.message, DISCORD_ERROR_DETAIL_LIMIT);
  } catch {
    return;
  }
};

const getAssetUrl = (externalDomain: string | undefined, assetId: string) => {
  if (!externalDomain) {
    return;
  }

  const baseUrl = externalDomain.endsWith('/') ? externalDomain : `${externalDomain}/`;
  return new URL(`photos/${encodeURIComponent(assetId)}`, baseUrl).href;
};

export const buildAiInterpretationDiscordPayload = ({
  accountName,
  assetId,
  externalDomain,
  originalFileName,
  photoDate,
  result,
  thumbnail,
  waitingCount,
  eta,
}: AiInterpretationDiscordAlert): DiscordWebhookPayload => {
  const title = truncate(result.title, DISCORD_TITLE_LIMIT) || 'AI interpretation complete';
  const summary = truncate(result.archive_summary || result.interpretation, DISCORD_DESCRIPTION_LIMIT);
  const embed: DiscordEmbed = {
    title,
    color: 0x42_50_af,
    fields: [
      {
        name: 'Immich account',
        value: truncate(accountName, DISCORD_FIELD_VALUE_LIMIT) || 'Unknown account',
        inline: true,
      },
      {
        name: 'Filename',
        value: truncate(originalFileName, DISCORD_FIELD_VALUE_LIMIT) || 'Unknown filename',
        inline: true,
      },
      {
        name: 'AI interpretations waiting',
        value: String(waitingCount),
        inline: true,
      },
      {
        name: 'Queue ETA',
        value: truncate(eta, DISCORD_FIELD_VALUE_LIMIT) || 'Unknown',
        inline: true,
      },
    ],
  };

  if (summary) {
    embed.description = summary;
  }

  const assetUrl = getAssetUrl(externalDomain, assetId);
  if (assetUrl) {
    embed.url = assetUrl;
  }

  embed.timestamp = photoDate;

  const payload: DiscordWebhookPayload = {
    allowed_mentions: { parse: [] },
    embeds: [embed],
  };

  if (thumbnail) {
    embed.thumbnail = { url: `attachment://${thumbnail.filename}` };
    payload.attachments = [{ id: 0, filename: thumbnail.filename, description: 'Immich photo thumbnail' }];
  }

  return payload;
};

const getRetryAfterMs = (response: Response) => {
  const value = response.headers.get('retry-after');
  if (!value) {
    return;
  }

  const seconds = Number(value);
  return Number.isFinite(seconds) && seconds >= 0 ? Math.ceil(seconds * 1000) : undefined;
};

@Injectable()
export class AiImageInterpretationDiscordClient {
  constructor(private configRepository: ConfigRepository) {}

  async send(alert: AiInterpretationDiscordAlert): Promise<void> {
    const webhookUrl = this.configRepository.getEnv().aiImageInterpretation.discord.webhookUrl;
    if (!webhookUrl) {
      throw new AiInterpretationDiscordAlertError(
        'Discord webhook URL is not configured; set IMMICH_AI_IMAGE_INTERPRETATION_DISCORD_WEBHOOK_URL',
        'not_configured',
        false,
      );
    }

    const host = getWebhookHost(webhookUrl);
    const url = new URL(webhookUrl);
    url.searchParams.set('wait', 'true');

    const payload = buildAiInterpretationDiscordPayload(alert);
    let body: BodyInit;
    let headers: HeadersInit | undefined;
    if (alert.thumbnail) {
      const form = new FormData();
      form.append('payload_json', JSON.stringify(payload));
      form.append(
        'files[0]',
        new Blob([new Uint8Array(alert.thumbnail.buffer)], { type: alert.thumbnail.contentType }),
        alert.thumbnail.filename,
      );
      body = form;
    } else {
      body = JSON.stringify(payload);
      headers = { 'content-type': 'application/json' };
    }

    let response: Response;
    try {
      response = await fetch(url, {
        method: 'POST',
        body,
        headers,
        redirect: 'error',
        signal: AbortSignal.timeout(DISCORD_REQUEST_TIMEOUT_MS),
      });
    } catch (error) {
      const isTimeout = error instanceof DOMException && error.name === 'TimeoutError';
      if (isTimeout) {
        throw new AiInterpretationDiscordAlertError(
          `Discord webhook request to ${host} timed out after ${DISCORD_REQUEST_TIMEOUT_MS / 1000}s (no response; check container network egress)`,
          'timeout',
          true,
          undefined,
          { cause: error },
        );
      }

      const causeCode = getNetworkCauseCode(error);
      throw new AiInterpretationDiscordAlertError(
        `Discord webhook request to ${host} failed${causeCode ? ` (${causeCode})` : ''}`,
        'network',
        true,
        undefined,
        { cause: error },
      );
    }

    if (response.ok) {
      return;
    }

    if (response.status === 429) {
      const retryAfterMs = getRetryAfterMs(response);
      throw new AiInterpretationDiscordAlertError(
        `Discord webhook is rate limited${retryAfterMs ? ` (retry after ${retryAfterMs}ms)` : ''}`,
        'rate_limited',
        true,
        retryAfterMs,
      );
    }

    if (response.status >= 500) {
      throw new AiInterpretationDiscordAlertError(
        `Discord webhook returned HTTP ${response.status} from ${host}`,
        'server_error',
        true,
      );
    }

    const apiMessage = await getDiscordApiMessage(response);
    throw new AiInterpretationDiscordAlertError(
      `Discord webhook rejected the request with HTTP ${response.status}${apiMessage ? `: ${apiMessage}` : ''}`,
      'client_error',
      false,
    );
  }
}
