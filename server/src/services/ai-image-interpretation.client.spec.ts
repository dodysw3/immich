import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { AiImageInterpretationClient } from 'src/services/ai-image-interpretation.client.js';
import { newConfigRepositoryMock } from 'test/repositories/config.repository.mock.js';

const fetchMock = vi.hoisted(() => vi.fn());

vi.mock('undici', () => ({ Agent: class {}, fetch: fetchMock }));

const result = {
  title: 'A quiet room',
  literal_description: 'A room with a window and a table.',
  interpretation: 'The image suggests a pause in an otherwise active day.',
  notable_details: [{ detail: 'Soft light', significance: 'It establishes the mood.', confidence: 'high' as const }],
  identifications: [],
  archive_summary: 'A softly lit room with a table and a window.',
  search_keywords: ['room', 'window', 'interior'],
};

type ContractResult = {
  title: string;
  literal_description: string;
  interpretation: string;
  notable_details: Array<{ detail: string; significance: string; confidence: string }>;
  identifications: Array<{ name: string; type: string; confidence: string; basis: string }>;
  archive_summary: string;
  search_keywords: string[];
};

const IDENTIFICATION_CODES = {
  person: 'PERS',
  place: 'PLACE',
  artwork: 'ART',
  object: 'OBJ',
  organization: 'ORG',
  other: 'OTH',
} as const;

const lineContract = (value: ContractResult): string =>
  [
    `T ${value.title}`,
    `D ${value.literal_description}`,
    `I ${value.interpretation}`,
    ...value.notable_details.map((n) => `N ${n.confidence[0].toUpperCase()}|${n.detail}|${n.significance}`),
    ...value.identifications.map(
      (i) =>
        `X ${i.confidence[0].toUpperCase()}|${IDENTIFICATION_CODES[i.type as keyof typeof IDENTIFICATION_CODES]}|${i.name}|${i.basis}`,
    ),
    `A ${value.archive_summary}`,
    `K ${value.search_keywords.join('|')}`,
  ].join('\n');

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

  it('sends the pinned model, prompt, line-format instruction, and preview without metadata', async () => {
    fetchMock.mockResolvedValue({
      ok: true,
      json: vi.fn().mockResolvedValue({
        choices: [{ message: { content: lineContract(result) } }],
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
    expect(body.chat_template_kwargs).toEqual({ reasoning_strength: 'low' });
    expect(body.response_format.json_schema.strict).toBe(true);
    expect(body.messages[0].content).toContain('Do not guess or invent');
    expect(body.messages[0].content).not.toMatch(/filename|GPS|EXIF/i);
    expect(body.messages[1].content).toEqual([
      { type: 'image_url', image_url: { url: 'data:image/jpeg;base64,cHJldmlldw==' } },
      expect.objectContaining({ type: 'text', text: expect.stringContaining('no blank lines, no markdown') }),
    ]);
  });

  it('decodes code drift and folds stray pipes back into text fields', async () => {
    // Observed in the 1.2.0 benchmark: confidence codes arrive lowercase or as
    // full words, and detail/significance/basis text legitimately contains '|'.
    const content = [
      'T Market scene',
      'D People selling vegetables at a covered market.',
      'I Informal daily commerce, likely a family-run stall.',
      'N m|Hand-written price signs|Signals informal| household-run retail',
      'X L|PERS|a vendor|The apron and cash box suggest| the stall keeper',
      'A Covered market stall with hand-written prices.',
      'K market|vegetables',
    ].join('\n');
    fetchMock.mockResolvedValue({
      ok: true,
      json: vi.fn().mockResolvedValue({
        choices: [{ message: { content }, finish_reason: 'stop' }],
        usage: { prompt_tokens: 12, completion_tokens: 34 },
      }),
    });

    await expect(client.interpret(Buffer.from('preview'))).resolves.toEqual({
      result: {
        title: 'Market scene',
        literal_description: 'People selling vegetables at a covered market.',
        interpretation: 'Informal daily commerce, likely a family-run stall.',
        notable_details: [
          {
            detail: 'Hand-written price signs',
            significance: 'Signals informal|household-run retail',
            confidence: 'medium',
          },
        ],
        identifications: [
          {
            name: 'a vendor',
            type: 'person',
            confidence: 'low',
            basis: 'The apron and cash box suggest|the stall keeper',
          },
        ],
        archive_summary: 'Covered market stall with hand-written prices.',
        search_keywords: ['market', 'vegetables'],
      },
      promptTokens: 12,
      completionTokens: 34,
    });
  });

  it('tolerates markdown fences and an omitted keyword line', async () => {
    const content = [
      '```text',
      'T A quiet room',
      'D A room with a window and a table.',
      'I The image suggests a pause in an otherwise active day.',
      'A A softly lit room with a table and a window.',
      '```',
    ].join('\n');
    fetchMock.mockResolvedValue({
      ok: true,
      json: vi.fn().mockResolvedValue({ choices: [{ message: { content } }] }),
    });

    await expect(client.interpret(Buffer.from('preview'))).resolves.toMatchObject({
      result: { ...result, notable_details: [], search_keywords: [] },
    });
  });

  it('rejects malformed line output as invalid_json, logging the defect for triage', async () => {
    // Garbage, JSON remnants of the 1.1.0 format, and structural violations
    // (duplicate or missing singles) all fail the same way.
    const contents = ['not json at all', '{}', 'K only|keywords', `${lineContract(result)}\nT a second title`];
    for (const content of contents) {
      fetchMock.mockReset().mockResolvedValue({
        ok: true,
        json: vi.fn().mockResolvedValue({
          choices: [{ message: { content }, finish_reason: 'stop' }],
          usage: { prompt_tokens: 500, completion_tokens: 1000 },
        }),
      });
      await expect(client.interpret(Buffer.from('preview'))).rejects.toMatchObject({ code: 'invalid_json' });
      expect(logger.warn).toHaveBeenCalledWith(
        expect.stringContaining('unparseable content (finish_reason: stop, completion tokens: 1000'),
      );
      expect(logger.warn).toHaveBeenCalledWith(expect.stringContaining(JSON.stringify(content).slice(0, 40)));
    }

    // An undecodable confidence code fails the same way — enum drift is
    // tolerated only within the pinned code table.
    fetchMock.mockReset().mockResolvedValue({
      ok: true,
      json: vi.fn().mockResolvedValue({
        choices: [{ message: { content: 'T t\nD d\nI i\nN X|a|b\nA a' } }],
      }),
    });
    await expect(client.interpret(Buffer.from('preview'))).rejects.toMatchObject({
      code: 'invalid_json',
      message: expect.stringContaining('unknown confidence code'),
    });
  });

  it('keeps empty content an invalid_output defect', async () => {
    fetchMock.mockResolvedValue({
      ok: true,
      json: vi.fn().mockResolvedValue({ choices: [{ message: { content: '' }, finish_reason: 'stop' }] }),
    });
    await expect(client.interpret(Buffer.from('preview'))).rejects.toMatchObject({ code: 'invalid_output' });
  });
});
