import { BadRequestException } from '@nestjs/common';
import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AiInterpretationDocument } from 'src/dtos/ai-image-interpretation.dto.js';
import { JobName, JobStatus } from 'src/enum.js';
import { AiInterpretSearchService } from 'src/services/ai-interpret-search.service.js';
import { createAiInterpretationRunKey } from 'src/utils/ai-image-interpretation.js';
import { newConfigRepositoryMock } from 'test/repositories/config.repository.mock.js';

const interpretResult = {
  title: 'Children playing',
  literal_description: 'Two children play on the floor.',
  visual_analysis: 'Warm light.',
  interpretation: 'A family moment.',
  context_and_significance: 'Everyday life.',
  notable_details: [{ detail: 'Blocks', significance: 'Interrupted play.', confidence: 'high' as const }],
  identifications: [{ name: 'Ria', type: 'person' as const, confidence: 'low' as const, basis: 'Profile.' }],
  alternative_interpretations: [],
  uncertainties: [],
  archive_summary: 'Family scene.',
  search_keywords: ['family', 'blocks'],
};

const runKeyOf = (seed: string): string => createAiInterpretationRunKey(seed, 'q', 'p');

const document = (seed = 'run-a'): AiInterpretationDocument => ({
  schemaVersion: 1,
  runs: {
    [runKeyOf(seed)]: {
      model: 'm',
      quant: 'q',
      promptVersion: 'p',
      status: 'completed',
      trigger: 'upload',
      requestedAt: '2026-09-01T00:00:00.000Z',
      finishedAt: '2026-09-01T01:00:00.000Z',
      result: interpretResult,
    },
  },
});

const denseRow = (assetId: string, distance: number) => ({ assetId, distance });

const assetRow = (id: string) => ({
  id,
  originalPath: '/x/test.jpg',
  originalFileName: 'test.jpg',
  checksum: Buffer.from('checksum'),
});

describe(AiInterpretSearchService.name, () => {
  let configRepository: ReturnType<typeof newConfigRepositoryMock>;
  let jobRepository: { queue: ReturnType<typeof vi.fn>; jobExists: ReturnType<typeof vi.fn> };
  let interpretationRepository: { get: ReturnType<typeof vi.fn> };
  let partnerRepository: { getAll: ReturnType<typeof vi.fn> };
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let embeddingClient: { embed: ReturnType<typeof vi.fn> };
  let logger: {
    setContext: ReturnType<typeof vi.fn>;
    log: ReturnType<typeof vi.fn>;
    debug: ReturnType<typeof vi.fn>;
    warn: ReturnType<typeof vi.fn>;
    error: ReturnType<typeof vi.fn>;
  };
  let sut: AiInterpretSearchService;

  const enable = (overrides: Record<string, unknown> = {}) => {
    const env = configRepository.getEnv();
    configRepository.getEnv.mockReturnValue({
      ...env,
      aiInterpretSearch: {
        ...env.aiInterpretSearch,
        enabled: true,
        url: 'http://localhost:8899',
        model: 'bge-m3-Q8_0',
        minScore: 0.4,
        ...overrides,
      },
    });
  };

  beforeEach(() => {
    vi.clearAllMocks();
    configRepository = newConfigRepositoryMock();
    jobRepository = { queue: vi.fn().mockResolvedValue(undefined), jobExists: vi.fn() };
    interpretationRepository = { get: vi.fn() };
    partnerRepository = { getAll: vi.fn().mockResolvedValue([]) };
    repository = {
      upsert: vi.fn(),
      get: vi.fn(),
      getStoredByAssetIds: vi.fn().mockResolvedValue(new Map()),
      pageAssetsWithRuns: vi.fn().mockResolvedValue({ items: [], nextCursor: null }),
      searchDense: vi.fn().mockResolvedValue([]),
      searchLexical: vi.fn().mockResolvedValue([]),
      getAssetsByIds: vi.fn().mockResolvedValue([]),
    };
    embeddingClient = { embed: vi.fn().mockResolvedValue([[0.1, 0.2]]) };
    logger = {
      setContext: vi.fn(),
      log: vi.fn(),
      debug: vi.fn(),
      warn: vi.fn(),
      error: vi.fn(),
    };

    sut = new AiInterpretSearchService(
      logger as never,
      configRepository as never,
      jobRepository as never,
      interpretationRepository as never,
      partnerRepository as never,
      repository as never,
      embeddingClient as never,
    );
  });

  describe('handleSync', () => {
    it('embeds the dense doc and upserts the row with runKey and model', async () => {
      enable();
      interpretationRepository.get.mockResolvedValue(document());

      await expect(sut.handleSync({ id: 'asset-1' })).resolves.toBe(JobStatus.Success);

      expect(embeddingClient.embed).toHaveBeenCalledWith([
        [
          'Children playing',
          'Two children play on the floor.',
          'A family moment.',
          'Blocks',
          'Interrupted play.',
          'family',
          'blocks',
        ].join('\n'),
      ]);
      expect(repository.upsert).toHaveBeenCalledWith({
        assetId: 'asset-1',
        text: 'Children playing family blocks Ria',
        embedding: '[0.1,0.2]',
        runKey: runKeyOf('run-a'),
        model: 'bge-m3-Q8_0',
      });
    });

    it('skips when the feature is disabled without calling the endpoint', async () => {
      await expect(sut.handleSync({ id: 'asset-1' })).resolves.toBe(JobStatus.Skipped);
      expect(embeddingClient.embed).not.toHaveBeenCalled();
      expect(repository.upsert).not.toHaveBeenCalled();
    });

    it('skips when there is no completed interpretation run', async () => {
      enable();
      interpretationRepository.get.mockResolvedValue(null);

      await expect(sut.handleSync({ id: 'asset-1' })).resolves.toBe(JobStatus.Skipped);
      expect(embeddingClient.embed).not.toHaveBeenCalled();
    });
  });

  describe('handleReconcile', () => {
    it('enqueues sync jobs for missing and stale rows only', async () => {
      enable();
      const fresh = { assetId: 'fresh', value: document('run-a') };
      const stale = { assetId: 'stale', value: document('run-b') };
      const missing = { assetId: 'missing', value: document('run-c') };
      repository.pageAssetsWithRuns.mockResolvedValue({ items: [fresh, stale, missing], nextCursor: null });
      repository.getStoredByAssetIds.mockResolvedValue(
        new Map([
          ['fresh', { assetId: 'fresh', runKey: runKeyOf('run-a'), model: 'bge-m3-Q8_0' }],
          ['stale', { assetId: 'stale', runKey: 'run-old', model: 'bge-m3-Q8_0' }],
          ['missing', { assetId: 'missing', runKey: runKeyOf('run-c'), model: 'old-model' }],
        ]),
      );

      await expect(sut.handleReconcile()).resolves.toBe(JobStatus.Success);

      expect(jobRepository.queue).toHaveBeenCalledTimes(2);
      expect(jobRepository.queue).toHaveBeenCalledWith({ name: JobName.AiInterpretSearchSync, data: { id: 'stale' } });
      expect(jobRepository.queue).toHaveBeenCalledWith({
        name: JobName.AiInterpretSearchSync,
        data: { id: 'missing' },
      });
    });

    it('skips when the feature is disabled', async () => {
      await expect(sut.handleReconcile()).resolves.toBe(JobStatus.Skipped);
      expect(repository.pageAssetsWithRuns).not.toHaveBeenCalled();
    });
  });

  describe('searchAiInterpret', () => {
    const auth = {
      user: { id: 'user-1' },
      session: { hasElevatedPermission: false },
    } as never;

    it('throws bad request and skips embedding when disabled', async () => {
      await expect(sut.searchAiInterpret(auth, { q: 'family', size: 100 })).rejects.toThrow(BadRequestException);
      expect(embeddingClient.embed).not.toHaveBeenCalled();
    });

    it('fuses dense and lexical branches with reciprocal rank fusion (k=60)', async () => {
      enable();
      repository.searchDense.mockResolvedValue([denseRow('a', 0.05), denseRow('b', 0.2)]);
      repository.searchLexical.mockResolvedValue([denseRow('c', 0.1), denseRow('b', 0.3)]);
      repository.getAssetsByIds.mockResolvedValue(['a', 'b', 'c'].map((id) => assetRow(id)));

      const response = await sut.searchAiInterpret(auth, { q: 'family', size: 10 });

      expect(embeddingClient.embed).toHaveBeenCalledWith(['family']);
      // b is ranked by both branches (1/61 + 1/62), so it leads; the a/c tie is
      // broken deterministically by assetId
      expect(response.items.map(({ asset }) => asset.id)).toEqual(['b', 'a', 'c']);
      expect(response.items[0]!.score).toBeCloseTo(1 / 61 + 1 / 62);
      expect(response.items[0]!.branch).toBe('dense');
      expect(response.items[1]!.branch).toBe('dense');
      expect(response.items[2]!.branch).toBe('lexical');
      expect(response.nextPage).toBeNull();
    });

    it('passes the configured minScore and scoped userIds to the branches', async () => {
      enable({ minScore: 0.55 });
      partnerRepository.getAll.mockResolvedValue([
        { sharedById: 'partner-1', sharedWithId: 'user-1', inTimeline: true, sharedBy: {}, sharedWith: {} },
      ]);
      repository.getAssetsByIds.mockResolvedValue([]);

      await sut.searchAiInterpret(auth, { q: 'family', size: 100 });

      const denseArgs = repository.searchDense.mock.calls[0][1] as { minScore: number; userIds: string[] };
      expect(denseArgs.minScore).toBe(0.55);
      expect(denseArgs.userIds).toEqual(['user-1', 'partner-1']);
    });

    it('paginates with a page-growing fusion window', async () => {
      enable();
      const rows = Array.from({ length: 15 }, (_, i) => denseRow(`asset-${i}`, i / 100));
      // respect the limit contract: the extra row past the window signals depth
      repository.searchDense.mockImplementation(({ limit }: { limit: number }) => rows.slice(0, limit));
      repository.searchLexical.mockResolvedValue([]);
      repository.getAssetsByIds.mockImplementation((ids: string[]) =>
        ids.map((id) => ({
          id,
          originalPath: '/x/test.jpg',
          originalFileName: 'test.jpg',
          checksum: Buffer.from('checksum'),
        })),
      );

      const page1 = await sut.searchAiInterpret(auth, { q: 'family', size: 10 });
      expect(page1.items).toHaveLength(10);
      expect(page1.nextPage).toBe('2');

      const page2 = await sut.searchAiInterpret(auth, { q: 'family', page: 2, size: 10 });
      // window grows with the page so deeper pages stay consistent
      expect(repository.searchDense.mock.calls[1]?.[0]).toEqual({ limit: 21 });
      expect(page2.items.map(({ asset }) => asset.id)).toEqual([
        'asset-10',
        'asset-11',
        'asset-12',
        'asset-13',
        'asset-14',
      ]);
      expect(page2.nextPage).toBeNull();
    });
  });
});
