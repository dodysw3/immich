import { AssetType, AssetVisibility } from 'src/enum.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { TranscriptIndexRepository, TranscriptSearchRepository } from 'src/repositories/transcript-index.repository.js';
import { BaseService } from 'src/services/base.service.js';
import { normalizeTranscript } from 'src/utils/video-transcription-search.js';
import { newMediumService } from 'test/medium.factory.js';
import { getKyselyDB } from 'test/utils.js';

const setup = async () => {
  const db = await getKyselyDB();
  const { ctx } = newMediumService(BaseService, {
    database: db,
    real: [],
    mock: [LoggingRepository],
  });
  return {
    ctx,
    index: new TranscriptIndexRepository(db),
    sut: new TranscriptSearchRepository(db),
  };
};

const revision = 'a'.repeat(64);
const runKey = 'k'.repeat(64);

const passage = (windowId: string, text: string, startMs: number) => {
  const tokens = [...new Set(normalizeTranscript(text).tokens.map((token) => token.text))];
  return {
    windowId,
    firstSegment: Number(windowId.split(':', 1)[0]),
    lastSegment: Number(windowId.split(':', 2)[1]),
    startMs,
    endMs: startMs + 2000,
    text,
    normalizedText: tokens.join(' '),
    tokens,
    segmentSpans: [{ start: 0, end: text.length }],
    segmentStartsMs: [startMs],
  };
};

describe(TranscriptSearchRepository.name, () => {
  it('retrieves exact candidates through the full-text index with access filters applied in SQL', async () => {
    const { ctx, index, sut } = await setup();
    const { user } = await ctx.newUser();
    const { user: stranger } = await ctx.newUser();
    const mine = await ctx.newAsset({ ownerId: user.id, type: AssetType.Video });
    const theirs = await ctx.newAsset({ ownerId: stranger.id, type: AssetType.Video });
    const image = await ctx.newAsset({ ownerId: user.id, type: AssetType.Image });

    for (const asset of [mine.asset, theirs.asset, image.asset]) {
      await index.replacePassages(asset.id, {
        revision,
        runKey,
        indexVersion: 1,
        coverageState: 'complete',
        segmentCount: 1,
        passages: [passage('0:0', 'boarding announcement for the flight', 0)],
      });
    }

    const mineOnly = await sut.searchExactCandidates({ userIds: [user.id] }, ['boarding', 'announcement']);
    expect(mineOnly.map((row) => row.assetId)).toEqual([mine.asset.id]);
    expect(mineOnly[0]!.runKey).toBe(runKey);

    // Partner sharing widens the universe.
    const shared = await sut.searchExactCandidates({ userIds: [user.id, stranger.id] }, ['boarding']);
    expect(shared.map((row) => row.assetId).sort()).toEqual([mine.asset.id, theirs.asset.id].sort());
  });

  it('returns spelling-fallback candidates from the token pool with configured thresholds', async () => {
    const { ctx, index, sut } = await setup();
    const { user } = await ctx.newUser();
    const { asset } = await ctx.newAsset({ ownerId: user.id, type: AssetType.Video });

    await index.replacePassages(asset.id, {
      revision,
      runKey,
      indexVersion: 1,
      coverageState: 'complete',
      segmentCount: 1,
      passages: [passage('0:0', 'bording anouncement untuk penerbangan', 0), passage('1:1', 'dua tiga empat', 2000)],
    });

    // Measured on pg_trgm: single-character typos in 5+ char words score
    // ~0.5-0.79 (bording/boarding 0.545, anouncement/announcement 0.786),
    // weak pairs ~0.375 — hence the 0.5 default threshold.
    const loose = await sut.searchFuzzyCandidates({ userIds: [user.id] }, ['boarding'], 0.5);
    expect(loose.map((row) => row.windowId)).toEqual(['0:0']);

    const strict = await sut.searchFuzzyCandidates({ userIds: [user.id] }, ['boarding'], 0.95);
    expect(strict).toHaveLength(0);

    // Unrelated tokens never surface unrelated passages.
    const none = await sut.searchFuzzyCandidates({ userIds: [user.id] }, ['zebra'], 0.5);
    expect(none).toHaveLength(0);
  });

  it('excludes deleted and locked assets from candidates unless elevation is expressed via visibility', async () => {
    const { ctx, index, sut } = await setup();
    const { user } = await ctx.newUser();
    const { asset: locked } = await ctx.newAsset({
      ownerId: user.id,
      type: AssetType.Video,
      visibility: AssetVisibility.Locked,
    });
    const { asset: visible } = await ctx.newAsset({ ownerId: user.id, type: AssetType.Video });

    for (const asset of [locked, visible]) {
      await index.replacePassages(asset.id, {
        revision,
        runKey,
        indexVersion: 1,
        coverageState: 'complete',
        segmentCount: 1,
        passages: [passage('0:0', 'rahasia tersembunyi di dalam', 0)],
      });
    }

    const notLocked = await sut.searchExactCandidates({ userIds: [user.id], visibility: 'not-locked' }, ['rahasia']);
    expect(notLocked.map((row) => row.assetId)).toEqual([visible.id]);

    const withLocked = await sut.searchExactCandidates({ userIds: [user.id], visibility: AssetVisibility.Locked }, [
      'rahasia',
    ]);
    expect(withLocked.map((row) => row.assetId)).toEqual([locked.id]);
  });

  it('reports scoped coverage counts over the authorized universe', async () => {
    const { ctx, index, sut } = await setup();
    const { user } = await ctx.newUser();
    const { user: stranger } = await ctx.newUser();
    const mine = await ctx.newAsset({ ownerId: user.id, type: AssetType.Video });
    const other = await ctx.newAsset({ ownerId: stranger.id, type: AssetType.Video });

    await index.replacePassages(mine.asset.id, {
      revision,
      runKey,
      indexVersion: 1,
      coverageState: 'complete',
      segmentCount: 1,
      passages: [passage('0:0', 'satu dua', 0)],
    });
    await index.markFailed(other.asset.id, runKey, 1, 'boom');

    const scoped = await sut.getScopedCoverage({ userIds: [user.id] }, 1);
    // The stranger's failed row must not leak into the user's counts.
    expect(scoped).toEqual({ totalVideos: 1, indexedVideos: 1, pendingIndex: 0, indexErrors: 0 });
  });
});
