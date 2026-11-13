import { BadRequestException } from '@nestjs/common';
import { describe, expect, it, vi } from 'vitest';
import type { TranscriptCandidateRow } from 'src/repositories/transcript-index.repository.js';
import { TranscriptSearchService } from 'src/services/transcript-search.service.js';
import {
  AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
  AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
  createVideoTranscriptionRunKey,
} from 'src/utils/ai-video-transcription.js';

// Unit tests exercise ranking/grouping/pagination; asset mapping is covered by
// controller and medium tests with real rows.
vi.mock('src/dtos/asset-response.dto.js', async (importOriginal) => ({
  ...(await importOriginal()),
  mapAsset: (asset: { id: string }) => ({ id: asset.id, mapped: true }),
}));

const runKey = createVideoTranscriptionRunKey({
  model: 'faster-whisper-large-v3',
  producerVersion: AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
  language: '',
  coveragePolicy: AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
});

const systemConfig = {
  transcriptionSearch: {
    coverageWeight: 0.5,
    proximityWeight: 0.3,
    similarityWeight: 0.2,
    minimumCoverage: 1,
    fuzzyThreshold: 0.5,
    minimumFuzzyLength: 4,
    additionalMoments: 3,
  },
};

const auth = { user: { id: 'user-a' }, session: {} } as never;

const candidate = (
  overrides: Partial<TranscriptCandidateRow> & { assetId: string; windowId: string },
): TranscriptCandidateRow => ({
  passageId: `${overrides.assetId}:${overrides.windowId}`,
  revision: 'a'.repeat(64),
  runKey,
  firstSegment: Number(overrides.windowId.split(':', 1)[0]),
  lastSegment: Number(overrides.windowId.split(':', 2)[1]),
  startMs: 0,
  endMs: 3000,
  text: 'boarding announcement',
  segmentSpans: [{ start: 0, end: 20 }],
  segmentStartsMs: [overrides.startMs ?? 0],
  ...overrides,
});

const makeService = (
  options: {
    candidates?: TranscriptCandidateRow[];
    assets?: Array<{ id: string }>;
    sims?: Array<{ qtoken: string; token: string; sim: number }>;
  } = {},
) => {
  const dependencies = {
    logger: { setContext: vi.fn(), debug: vi.fn(), log: vi.fn(), warn: vi.fn() },
    configRepository: { getEnv: vi.fn().mockReturnValue({ configFile: undefined }), getWorker: vi.fn() },
    systemMetadataRepository: { get: vi.fn().mockResolvedValue(systemConfig) },
    partnerRepository: { getAll: vi.fn().mockResolvedValue([]) },
    searchRepository: {
      searchExactCandidates: vi.fn().mockResolvedValue(options.candidates ?? []),
      searchFuzzyCandidates: vi.fn().mockResolvedValue([]),
      searchTokenSimilarities: vi.fn().mockResolvedValue(options.sims ?? []),
      getAssetsByIds: vi.fn().mockResolvedValue(options.assets ?? []),
      getScopedCoverage: vi
        .fn()
        .mockResolvedValue({ totalVideos: 3, indexedVideos: 2, pendingIndex: 1, indexErrors: 0 }),
    },
    indexRepository: {},
  };
  const service = new TranscriptSearchService(
    dependencies.logger as never,
    dependencies.configRepository as never,
    dependencies.systemMetadataRepository as never,
    dependencies.partnerRepository as never,
    dependencies.searchRepository as never,
    dependencies.indexRepository as never,
  );
  return { service, dependencies };
};

describe(TranscriptSearchService.name, () => {
  it('groups repeated matches per video: one result, distinct additional moments', async () => {
    const repeated = ['0:0', '1:1', '2:2'].map((windowId, i) =>
      candidate({ assetId: 'video-1', windowId, startMs: i * 10_000, text: 'terima kasih telah menonton' }),
    );
    const { service, dependencies } = makeService({
      candidates: repeated,
      assets: [{ id: 'video-1' } as never],
    });

    const response = await service.searchTranscription(auth, {
      q: 'telah menonton',
      size: 20,
    } as never);

    expect(response.items).toHaveLength(1);
    expect(response.items[0]!.matchCount).toBe(3);
    expect(response.items[0]!.bestMatch.tier).toBe('exact-phrase');
    expect(response.items[0]!.additionalMatches).toHaveLength(2);
    expect(response.items[0]!.additionalMatches.map((match) => match.startMs)).toEqual([10_000, 20_000]);
    // Candidate SQL sees the access-filtered universe (userIds injected).
    expect(dependencies.searchRepository.searchExactCandidates).toHaveBeenCalledWith(
      expect.objectContaining({ userIds: ['user-a'] }),
      ['telah', 'menonton'],
    );
  });

  it('orders videos by best match deterministically and paginates with cursors', async () => {
    const { service, dependencies } = makeService({
      candidates: [
        candidate({ assetId: 'video-b', windowId: '0:0', text: 'bording anouncement', startMs: 0 }),
        candidate({ assetId: 'video-a', windowId: '0:0', text: 'boarding announcement', startMs: 0 }),
      ],
      assets: [{ id: 'video-a' } as never, { id: 'video-b' } as never],
    });
    // Give the fuzzy video a real similarity so both tiers coexist.
    dependencies.searchRepository.searchFuzzyCandidates.mockResolvedValue([
      candidate({ assetId: 'video-b', windowId: '0:0', text: 'bording anouncement', startMs: 0 }),
    ]);
    dependencies.searchRepository.searchTokenSimilarities.mockResolvedValue([
      { qtoken: 'boarding', token: 'bording', sim: 0.8 },
      { qtoken: 'announcement', token: 'anouncement', sim: 0.8 },
    ]);

    const first = await service.searchTranscription(auth, { q: 'boarding announcement', size: 1 } as never);

    expect(first.items.map((item) => item.asset.id)).toEqual(['video-a']);
    expect(first.items[0]!.bestMatch.tier).toBe('exact-phrase');
    expect(first.nextCursor).not.toBeNull();

    const second = await service.searchTranscription(auth, {
      q: 'boarding announcement',
      size: 1,
      cursor: first.nextCursor!,
    } as never);

    expect(second.items.map((item) => item.asset.id)).toEqual(['video-b']);
    expect(second.items[0]!.bestMatch.tier).toBe('fuzzy');
    expect(second.nextCursor).toBeNull();
  });

  it('rejects cursors minted under a different ranking configuration', async () => {
    const { service } = makeService();
    const response = await service.searchTranscription(auth, { q: 'x', size: 20 } as never);
    const otherVersion = `${response.configVersion.slice(0, 14)}0`;

    await expect(
      service.searchTranscription(auth, {
        q: 'x',
        size: 20,
        cursor: Buffer.from(JSON.stringify({ k: '[]', v: otherVersion }), 'utf8').toString('base64url'),
      } as never),
    ).rejects.toBeInstanceOf(BadRequestException);
  });

  it('includes score components and scoped coverage only with explain', async () => {
    const { service } = makeService({
      candidates: [candidate({ assetId: 'video-1', windowId: '0:0' })],
      assets: [{ id: 'video-1' } as never],
    });

    const plain = await service.searchTranscription(auth, { q: 'boarding', size: 20 } as never);
    expect(plain.items[0]!.bestMatch.components).toBeUndefined();
    expect(plain.coverage).toBeUndefined();

    const explained = await service.searchTranscription(auth, { q: 'boarding', size: 20, explain: true } as never);
    expect(explained.items[0]!.bestMatch.components).toEqual({ coverage: 1, proximity: 1, similarity: 1 });
    expect(explained.coverage).toEqual({ totalVideos: 3, indexedVideos: 2, pendingIndex: 1, indexErrors: 0 });
  });

  it('locks searches to personal assets without elevated permission', async () => {
    const { service, dependencies } = makeService();
    const elevatedAuth = { user: { id: 'user-a' }, session: { hasElevatedPermission: true } } as never;

    await service.searchTranscription(elevatedAuth, { q: 'boarding', size: 20, visibility: 'locked' } as never);

    expect(dependencies.searchRepository.searchExactCandidates).toHaveBeenCalledWith(
      expect.objectContaining({ userIds: ['user-a'], visibility: 'locked' }),
      ['boarding'],
    );
    // Partner sharing is irrelevant for locked personal assets.
    expect(dependencies.partnerRepository.getAll).not.toHaveBeenCalled();
  });

  it('fails explicitly when candidates exceed the retrieval cap', async () => {
    const many = Array.from({ length: 20_001 }, (_, i) => candidate({ assetId: `v${i}`, windowId: '0:0' }));
    const { service } = makeService({ candidates: many });

    await expect(service.searchTranscription(auth, { q: 'boarding', size: 20 } as never)).rejects.toThrow(
      /narrow the query/,
    );
  });

  it('paginates additional moments per video with the same access rules', async () => {
    const moments = ['0:0', '1:1', '2:2'].map((windowId, i) =>
      candidate({ assetId: 'video-1', windowId, startMs: i * 10_000, text: 'terima kasih telah menonton' }),
    );
    const { service } = makeService({ candidates: moments });

    const first = await service.searchMoments(auth, { assetId: 'video-1', q: 'telah menonton', size: 2 } as never);
    expect(first.count).toBe(2);
    expect(first.nextCursor).not.toBeNull();

    const second = await service.searchMoments(auth, {
      assetId: 'video-1',
      q: 'telah menonton',
      size: 2,
      cursor: first.nextCursor!,
    } as never);
    expect(second.count).toBe(1);
    expect(second.nextCursor).toBeNull();
  });

  it('never returns moments from inaccessible videos', async () => {
    const { service } = makeService({
      candidates: [
        candidate({ assetId: 'video-1', windowId: '0:0', text: 'satu' }),
        candidate({ assetId: 'video-9', windowId: '0:0', text: 'rahasia' }),
      ],
    });

    const response = await service.searchMoments(auth, { assetId: 'video-1', q: 'satu', size: 10 } as never);
    // SQL candidates are already access-filtered; the assetId filter applies on top.
    expect(response.moments.every((match) => match.snippet !== 'rahasia')).toBe(true);
  });
});
