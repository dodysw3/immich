import { MuseInterpretationResult } from 'src/dtos/ai-image-interpretation.dto.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import {
  AiImageInterpretationDiscordClient,
  AiInterpretationDiscordAlert,
  AiInterpretationDiscordAlertError,
  buildAiInterpretationDiscordPayload,
} from 'src/services/ai-image-interpretation-discord.client.js';

const webhookUrl = 'https://discord.com/api/webhooks/123456789/test_webhook-token';
const result: MuseInterpretationResult = {
  title: 'A quiet platform',
  literal_description: 'A person waits beside a train.',
  visual_analysis: 'The frame is balanced.',
  interpretation: 'The image suggests anticipation.',
  context_and_significance: 'A travel moment.',
  notable_details: [],
  identifications: [],
  alternative_interpretations: [],
  uncertainties: [],
  archive_summary: 'A traveler waits on a quiet station platform.',
  search_keywords: ['station'],
};

const makeAlert = (overrides: Partial<AiInterpretationDiscordAlert> = {}): AiInterpretationDiscordAlert => ({
  accountName: 'Cangka',
  assetId: 'asset-1',
  externalDomain: 'https://photos.example.com',
  originalFileName: 'IMG_1234.JPG',
  photoDate: '2020-04-05T06:07:08.000Z',
  waitingCount: 42,
  result,
  ...overrides,
});

const makeClient = () => {
  const configRepository = {
    getEnv: vi.fn().mockReturnValue({
      aiImageInterpretation: { discord: { webhookUrl, includeThumbnail: true } },
    }),
  };
  return {
    client: new AiImageInterpretationDiscordClient(configRepository as never as ConfigRepository),
    configRepository,
  };
};

describe(AiImageInterpretationDiscordClient.name, () => {
  const fetchMock = vi.fn();

  beforeEach(() => {
    fetchMock.mockReset().mockResolvedValue(new Response(null, { status: 204 }));
    vi.stubGlobal('fetch', fetchMock);
  });

  afterEach(() => {
    vi.unstubAllGlobals();
  });

  it('sends a confirmed JSON embed with mentions disabled and an authenticated asset link', async () => {
    const { client } = makeClient();

    await client.send(makeAlert());

    const [url, options] = fetchMock.mock.calls[0] as [URL, RequestInit];
    expect(url.origin + url.pathname).toBe(webhookUrl);
    expect(url.searchParams.get('wait')).toBe('true');
    expect(options).toMatchObject({
      method: 'POST',
      redirect: 'error',
      headers: { 'content-type': 'application/json' },
    });
    const payload = JSON.parse(options.body as string);
    expect(payload.allowed_mentions).toEqual({ parse: [] });
    expect(payload.embeds[0]).toMatchObject({
      title: result.title,
      description: result.archive_summary,
      url: 'https://photos.example.com/photos/asset-1',
      timestamp: '2020-04-05T06:07:08.000Z',
      fields: [
        { name: 'Immich account', value: 'Cangka', inline: true },
        { name: 'Filename', value: 'IMG_1234.JPG', inline: true },
        { name: 'AI interpretations waiting', value: '42', inline: true },
      ],
    });
  });

  it('omits an invented link and uses stable text fallbacks', () => {
    const payload = buildAiInterpretationDiscordPayload(
      makeAlert({
        externalDomain: undefined,
        waitingCount: 0,
        result: { ...result, title: ' ', archive_summary: '', interpretation: 'Fallback interpretation' },
      }),
    );

    expect(payload.embeds[0]).toMatchObject({
      title: 'AI interpretation complete',
      description: 'Fallback interpretation',
    });
    expect(payload.embeds[0]).not.toHaveProperty('url');
    expect(payload.embeds[0].fields[2]).toEqual({
      name: 'AI interpretations waiting',
      value: '0',
      inline: true,
    });
  });

  it('keeps fields at Discord boundaries and truncates overlong values', () => {
    const exact = buildAiInterpretationDiscordPayload(
      makeAlert({
        accountName: 'a'.repeat(1024),
        originalFileName: 'f'.repeat(1024),
        result: { ...result, title: 't'.repeat(256), archive_summary: 's'.repeat(4096) },
      }),
    );
    expect(exact.embeds[0].title).toHaveLength(256);
    expect(exact.embeds[0].description).toHaveLength(4096);
    expect(exact.embeds[0].fields[0].value).toHaveLength(1024);
    expect(exact.embeds[0].fields[1].value).toHaveLength(1024);

    const over = buildAiInterpretationDiscordPayload(
      makeAlert({
        accountName: '@everyone'.repeat(200),
        originalFileName: '@here'.repeat(300),
        result: { ...result, title: '@everyone'.repeat(100), archive_summary: '@here'.repeat(1000) },
      }),
    );
    expect(over.embeds[0].title).toHaveLength(256);
    expect(over.embeds[0].title.endsWith('…')).toBe(true);
    expect(over.embeds[0].description).toHaveLength(4096);
    expect(over.embeds[0].fields[0].value).toHaveLength(1024);
    expect(over.embeds[0].fields[1].value).toHaveLength(1024);
    expect(over.embeds[0].fields[1].value.endsWith('…')).toBe(true);
    expect(over.allowed_mentions).toEqual({ parse: [] });
  });

  it('uploads a generated thumbnail through multipart form data', async () => {
    const { client } = makeClient();

    await client.send(
      makeAlert({
        thumbnail: {
          buffer: Buffer.from('thumbnail-bytes'),
          contentType: 'image/webp',
          filename: 'ai-interpretation-thumbnail.webp',
        },
      }),
    );

    const options = fetchMock.mock.calls[0][1] as RequestInit;
    expect(options.headers).toBeUndefined();
    expect(options.body).toBeInstanceOf(FormData);
    const form = options.body as FormData;
    const payload = JSON.parse(String(form.get('payload_json')));
    expect(payload.embeds[0].thumbnail).toEqual({ url: 'attachment://ai-interpretation-thumbnail.webp' });
    expect(payload.attachments).toEqual([
      { id: 0, filename: 'ai-interpretation-thumbnail.webp', description: 'Immich photo thumbnail' },
    ]);
    expect(form.get('files[0]')).toMatchObject({ name: 'ai-interpretation-thumbnail.webp', type: 'image/webp' });
  });

  it('classifies rate limits, server errors, and permanent client errors without response bodies', async () => {
    const { client } = makeClient();
    fetchMock.mockResolvedValueOnce(
      new Response('do not log this response', { status: 429, headers: { 'retry-after': '0.25' } }),
    );
    await expect(client.send(makeAlert())).rejects.toMatchObject({
      code: 'rate_limited',
      retryable: true,
      retryAfterMs: 250,
    });

    fetchMock.mockResolvedValueOnce(new Response('server secret', { status: 503 }));
    await expect(client.send(makeAlert())).rejects.toMatchObject({ code: 'server_error', retryable: true });

    fetchMock.mockResolvedValueOnce(new Response('client secret', { status: 400 }));
    const error = await client.send(makeAlert()).catch((error: AiInterpretationDiscordAlertError) => error);
    if (!(error instanceof AiInterpretationDiscordAlertError)) {
      throw new TypeError('Expected a Discord alert error');
    }
    expect(error).toMatchObject({ code: 'client_error', retryable: false });
    expect(error.message).not.toContain('client secret');
    expect(error.message).not.toContain('test_webhook-token');
  });

  it('classifies timeouts and network failures as retryable', async () => {
    const { client } = makeClient();
    fetchMock.mockRejectedValueOnce(new DOMException('timed out', 'TimeoutError'));
    await expect(client.send(makeAlert())).rejects.toMatchObject({ code: 'timeout', retryable: true });

    fetchMock.mockRejectedValueOnce(new TypeError('network failed at secret URL'));
    const error = await client.send(makeAlert()).catch((error: AiInterpretationDiscordAlertError) => error);
    if (!(error instanceof AiInterpretationDiscordAlertError)) {
      throw new TypeError('Expected a Discord alert error');
    }
    expect(error).toMatchObject({ code: 'network', retryable: true });
    expect(error.message).not.toContain('secret URL');
  });

  it('rejects delivery after the integration is disabled', async () => {
    const { client, configRepository } = makeClient();
    configRepository.getEnv.mockReturnValue({ aiImageInterpretation: { discord: { includeThumbnail: true } } });

    await expect(client.send(makeAlert())).rejects.toMatchObject({ code: 'not_configured', retryable: false });
    expect(fetchMock).not.toHaveBeenCalled();
  });
});
