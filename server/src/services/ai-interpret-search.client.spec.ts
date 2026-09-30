import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { AiInterpretSearchClient, AiInterpretSearchClientError } from 'src/services/ai-interpret-search.client.js';
import { newConfigRepositoryMock } from 'test/repositories/config.repository.mock.js';

const fetchMock = vi.hoisted(() => vi.fn());

vi.mock('undici', () => ({ Agent: class {}, fetch: fetchMock }));

const embedding = (values: number[]): number[] => values;

describe(AiInterpretSearchClient.name, () => {
  const configRepository = newConfigRepositoryMock();
  const logger = { debug: vi.fn(), warn: vi.fn() };
  const client = new AiInterpretSearchClient(configRepository, logger as never);

  beforeEach(() => {
    vi.clearAllMocks();
    fetchMock.mockReset();
    const env = configRepository.getEnv();
    configRepository.getEnv.mockReturnValue({
      ...env,
      aiInterpretSearch: {
        ...env.aiInterpretSearch,
        enabled: true,
        // eslint-disable-next-line unicorn/prefer-https -- the local host-gateway endpoint is HTTP by design
        url: 'http://host.docker.internal:8899',
        apiKey: 'secret-key',
        model: 'bge-m3-Q8_0',
      },
    });
  });

  afterEach(() => {
    vi.unstubAllGlobals();
  });

  it('posts the configured model and inputs to /v1/embeddings and returns ordered vectors', async () => {
    fetchMock.mockResolvedValue({
      ok: true,
      json: vi.fn().mockResolvedValue({
        data: [
          { index: 1, embedding: embedding([4, 5, 6]) },
          { index: 0, embedding: embedding([1, 2, 3]) },
        ],
      }),
    });

    await expect(client.embed(['first text', 'second text'])).resolves.toEqual([
      [1, 2, 3],
      [4, 5, 6],
    ]);

    const [url, request] = fetchMock.mock.calls[0] as [string, RequestInit];
    // eslint-disable-next-line unicorn/prefer-https -- the local host-gateway endpoint is HTTP by design
    expect(url).toBe('http://host.docker.internal:8899/v1/embeddings');
    expect(request.headers).toEqual({
      'Content-Type': 'application/json',
      Authorization: 'Bearer secret-key',
    });
    expect(JSON.parse(request.body as string)).toEqual({ model: 'bge-m3-Q8_0', input: ['first text', 'second text'] });
  });

  it('rejects with feature_disabled before making any request when disabled', async () => {
    const env = configRepository.getEnv();
    configRepository.getEnv.mockReturnValue({
      ...env,
      aiInterpretSearch: { ...env.aiInterpretSearch, enabled: false },
    });

    await expect(client.embed(['query'])).rejects.toMatchObject({
      code: 'feature_disabled',
    } satisfies Partial<AiInterpretSearchClientError>);
    expect(fetchMock).not.toHaveBeenCalled();
  });

  it('rejects with endpoint_error when the endpoint is not configured', async () => {
    const env = configRepository.getEnv();
    configRepository.getEnv.mockReturnValue({
      ...env,
      aiInterpretSearch: { ...env.aiInterpretSearch, enabled: true, url: undefined },
    });

    await expect(client.embed(['query'])).rejects.toMatchObject({
      code: 'endpoint_error',
    } satisfies Partial<AiInterpretSearchClientError>);
    expect(fetchMock).not.toHaveBeenCalled();
  });

  it('maps a non-200 response to endpoint_error', async () => {
    fetchMock.mockResolvedValue({ ok: false, status: 503, json: vi.fn() });

    await expect(client.embed(['query'])).rejects.toMatchObject({
      code: 'endpoint_error',
    } satisfies Partial<AiInterpretSearchClientError>);
  });

  it('maps an abort to timeout', async () => {
    fetchMock.mockRejectedValue(new DOMException('aborted', 'AbortError'));

    await expect(client.embed(['query'])).rejects.toMatchObject({
      code: 'timeout',
    } satisfies Partial<AiInterpretSearchClientError>);
  });

  it('maps a network failure to network_error', async () => {
    fetchMock.mockRejectedValue(new Error('connect ECONNREFUSED'));

    await expect(client.embed(['query'])).rejects.toMatchObject({
      code: 'network_error',
    } satisfies Partial<AiInterpretSearchClientError>);
  });

  it('rejects with invalid_output when the response count mismatches the input', async () => {
    fetchMock.mockResolvedValue({
      ok: true,
      json: vi.fn().mockResolvedValue({ data: [{ index: 0, embedding: [1, 2, 3] }] }),
    });

    await expect(client.embed(['one', 'two'])).rejects.toMatchObject({
      code: 'invalid_output',
    } satisfies Partial<AiInterpretSearchClientError>);
  });
});
