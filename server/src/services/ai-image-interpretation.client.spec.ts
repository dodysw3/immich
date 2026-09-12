import { AiImageInterpretationClient } from 'src/services/ai-image-interpretation.client';
import { newConfigRepositoryMock } from 'test/repositories/config.repository.mock';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

const fetchMock = vi.hoisted(() => vi.fn());

vi.mock('undici', () => ({ Agent: class {}, fetch: fetchMock }));

const result = {
  title: 'A quiet room',
  literal_description: 'A room with a window and a table.',
  visual_analysis: 'Muted colors and soft light create a calm composition.',
  interpretation: 'The image suggests a pause in an otherwise active day.',
  context_and_significance: 'The scene is useful as a record of an ordinary interior.',
  notable_details: [{ detail: 'Soft light', significance: 'It establishes the mood.', confidence: 'high' as const }],
  identifications: [],
  alternative_interpretations: [],
  uncertainties: ['The location cannot be determined from the image alone.'],
  archive_summary: 'A softly lit room with a table and a window.',
  search_keywords: ['room', 'window', 'interior'],
};

describe(AiImageInterpretationClient.name, () => {
  const configRepository = newConfigRepositoryMock();
  const logger = { debug: vi.fn(), warn: vi.fn() };
  const client = new AiImageInterpretationClient(configRepository, logger as never);

  beforeEach(() => {
    vi.clearAllMocks();
    fetchMock.mockReset();
    const env = configRepository.getEnv();
    configRepository.getEnv.mockReturnValue({
      ...env,
      aiImageInterpretation: {
        ...env.aiImageInterpretation,
        // eslint-disable-next-line unicorn/prefer-https -- the local host-gateway endpoint is HTTP by design
        url: 'http://host.docker.internal:8888/v1',
        apiKey: 'secret-key',
      },
    });
  });

  afterEach(() => {
    vi.unstubAllGlobals();
  });

  it('sends the pinned model, prompt, JSON schema, and preview without metadata', async () => {
    fetchMock.mockResolvedValue({
      ok: true,
      json: vi.fn().mockResolvedValue({
        choices: [{ message: { content: JSON.stringify(result) } }],
        usage: { prompt_tokens: 12, completion_tokens: 34 },
      }),
    });

    await expect(client.interpret(Buffer.from('preview'))).resolves.toEqual({
      result,
      promptTokens: 12,
      completionTokens: 34,
    });

    const [url, request] = fetchMock.mock.calls[0] as [string, RequestInit];
    const body = JSON.parse(request.body as string);
    // eslint-disable-next-line unicorn/prefer-https -- the local host-gateway endpoint is HTTP by design
    expect(url).toBe('http://host.docker.internal:8888/v1/chat/completions');
    expect(request.headers).toEqual({
      'Content-Type': 'application/json',
      Authorization: 'Bearer secret-key',
    });
    expect(body.model).toBe('unsloth/Muse-Glimmer-30B-GGUF');
    expect(body.max_tokens).toBe(6400);
    expect(body.response_format.json_schema.strict).toBe(true);
    expect(body.messages[0].content).toContain('Do not guess or invent');
    expect(body.messages[0].content).not.toMatch(/filename|GPS|EXIF/i);
    expect(body.messages[1].content).toEqual([
      { type: 'image_url', image_url: { url: 'data:image/jpeg;base64,cHJldmlldw==' } },
      expect.objectContaining({ type: 'text', text: expect.stringContaining('Do not omit any key') }),
    ]);
  });

  it('rejects output that does not match the pinned result contract', async () => {
    fetchMock.mockResolvedValue({
      ok: true,
      json: vi.fn().mockResolvedValue({ choices: [{ message: { content: '{}' } }] }),
    });

    await expect(client.interpret(Buffer.from('preview'))).rejects.toMatchObject({
      code: 'invalid_output',
    });
  });

  it('sanitizes malformed JSON, endpoint, and timeout failures', async () => {
    fetchMock.mockResolvedValueOnce({
      ok: true,
      json: vi.fn().mockRejectedValue(new SyntaxError('response body')),
    });
    await expect(client.interpret(Buffer.from('preview'))).rejects.toMatchObject({ code: 'invalid_json' });

    fetchMock.mockReset().mockResolvedValue({ ok: false, status: 502, json: vi.fn() });
    await expect(client.interpret(Buffer.from('preview'))).rejects.toMatchObject({ code: 'endpoint_error' });
    expect(logger.warn).toHaveBeenCalledWith(expect.stringContaining('502'));

    fetchMock.mockReset().mockRejectedValue(new DOMException('aborted', 'AbortError'));
    await expect(client.interpret(Buffer.from('preview'))).rejects.toMatchObject({ code: 'timeout' });
  });

  it('repairs a stray quote after the final bracket without another request', async () => {
    // Observed 2026-09-11: complete object, finish=stop, single extra `"` (`..."]"}`).
    const content = JSON.stringify(result).replaceAll(/\}$/g, '"}');
    fetchMock.mockResolvedValue({
      ok: true,
      json: vi.fn().mockResolvedValue({
        choices: [{ message: { content } }],
        usage: { prompt_tokens: 12, completion_tokens: 34 },
      }),
    });

    await expect(client.interpret(Buffer.from('preview'))).resolves.toEqual({
      result,
      promptTokens: 12,
      completionTokens: 34,
    });
    expect(fetchMock).toHaveBeenCalledTimes(1);
  });

  it('extracts JSON wrapped in prose and repairs trailing commas', async () => {
    const wrapped = `Here is the analysis:\n${JSON.stringify(result).replaceAll(']}', '] , }')} \nDone.`;
    fetchMock.mockResolvedValue({
      ok: true,
      json: vi.fn().mockResolvedValue({ choices: [{ message: { content: wrapped } }] }),
    });

    await expect(client.interpret(Buffer.from('preview'))).resolves.toMatchObject({ result });
  });

  it('still rejects content that no repair can parse', async () => {
    for (const content of ['not json at all', '{"title": "unterminated', ' '.repeat(3)]) {
      fetchMock.mockReset().mockResolvedValue({
        ok: true,
        json: vi.fn().mockResolvedValue({ choices: [{ message: { content } }] }),
      });
      await expect(client.interpret(Buffer.from('preview'))).rejects.toMatchObject({ code: 'invalid_json' });
    }
  });
});
