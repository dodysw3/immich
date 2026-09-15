import { Injectable } from '@nestjs/common';
import { MuseInterpretationResult } from 'src/dtos/ai-image-interpretation.dto';
import { ConfigRepository } from 'src/repositories/config.repository';

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
    public readonly code: DiscordAlertErrorCode,
    public readonly retryable: boolean,
    public readonly retryAfterMs?: number,
  ) {
    super(`Discord interpretation alert failed (${code})`);
  }
}

const truncate = (value: string, limit: number) => {
  const normalized = value.trim();
  return normalized.length <= limit ? normalized : `${normalized.slice(0, limit - 1)}…`;
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
      throw new AiInterpretationDiscordAlertError('not_configured', false);
    }

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
      throw new AiInterpretationDiscordAlertError(isTimeout ? 'timeout' : 'network', true);
    }

    if (response.ok) {
      return;
    }

    if (response.status === 429) {
      throw new AiInterpretationDiscordAlertError('rate_limited', true, getRetryAfterMs(response));
    }

    if (response.status >= 500) {
      throw new AiInterpretationDiscordAlertError('server_error', true);
    }

    throw new AiInterpretationDiscordAlertError('client_error', false);
  }
}
