import { AssetMetadataKey } from 'src/enum.js';
import { AiInterpretSearchRepository } from 'src/repositories/ai-interpret-search.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { BaseService } from 'src/services/base.service.js';
import { newMediumService } from 'test/medium.factory.js';
import { getKyselyDB } from 'test/utils.js';

// count-sensitive assertions need isolation: each test gets its own database
// copied from the migrated template
const setup = async () => {
  const db = await getKyselyDB();
  const { ctx } = newMediumService(BaseService, {
    database: db,
    real: [],
    mock: [LoggingRepository],
  });
  return { ctx, sut: new AiInterpretSearchRepository(db) };
};

// 1024-dim unit vectors exercising specific cosine distances via the first two axes
const vector = (x: number, y: number): string => {
  const v = Array.from({ length: 1024 }).fill(0);
  v[0] = x;
  v[1] = y;
  return `[${v.join(',')}]`;
};

const interpretDocument = (runKey: string, status: 'completed' | 'queued' | 'failed' = 'completed') => ({
  schemaVersion: 1,
  runs: {
    [runKey]: {
      model: 'm',
      quant: 'q',
      promptVersion: 'p',
      status,
      trigger: 'upload',
      requestedAt: '2026-09-01T00:00:00.000Z',
      finishedAt: '2026-09-01T01:00:00.000Z',
    },
  },
});

describe(AiInterpretSearchRepository.name, () => {
  describe('upsert + get', () => {
    it('should create then update the row idempotently', async () => {
      const { ctx, sut } = await setup();
      const { user } = await ctx.newUser();
      const { asset } = await ctx.newAsset({ ownerId: user.id });

      await expect(sut.get(asset.id)).resolves.toBeUndefined();

      await sut.upsert({ assetId: asset.id, text: 'first', embedding: vector(1, 0), runKey: 'run-a', model: 'bge' });
      await expect(sut.get(asset.id)).resolves.toEqual({ assetId: asset.id, runKey: 'run-a', model: 'bge' });

      await sut.upsert({ assetId: asset.id, text: 'second', embedding: vector(0, 1), runKey: 'run-b', model: 'bge2' });
      await expect(sut.get(asset.id)).resolves.toEqual({ assetId: asset.id, runKey: 'run-b', model: 'bge2' });

      const rows = await ctx.database.selectFrom('ai_interpret_search').selectAll().execute();
      expect(rows).toHaveLength(1);
      expect(rows[0]!.text).toBe('second');
    });
  });

  describe('pageAssetsWithRuns', () => {
    it('should page only assets with a completed run, in assetId order', async () => {
      const { ctx, sut } = await setup();
      const { user } = await ctx.newUser();
      const { asset: withCompleted } = await ctx.newAsset({ ownerId: user.id });
      const { asset: withQueued } = await ctx.newAsset({ ownerId: user.id });
      const { asset: withoutDoc } = await ctx.newAsset({ ownerId: user.id });

      await ctx.newMetadata({
        assetId: withCompleted.id,
        key: AssetMetadataKey.AiInterpretationV1,
        value: interpretDocument('run-a'),
      });
      await ctx.newMetadata({
        assetId: withQueued.id,
        key: AssetMetadataKey.AiInterpretationV1,
        value: interpretDocument('run-b', 'queued'),
      });
      void withoutDoc;

      const page = await sut.pageAssetsWithRuns({ limit: 500 });
      expect(page.items.map(({ assetId }) => assetId)).toEqual([withCompleted.id]);
      expect(page.nextCursor).toBeNull();
    });

    it('should support keyset pagination via nextCursor', async () => {
      const { ctx, sut } = await setup();
      const { user } = await ctx.newUser();
      const assets = [];
      for (let i = 0; i < 3; i++) {
        const { asset } = await ctx.newAsset({ ownerId: user.id });
        await ctx.newMetadata({
          assetId: asset.id,
          key: AssetMetadataKey.AiInterpretationV1,
          value: interpretDocument(`run-${i}`),
        });
        assets.push(asset);
      }

      const firstPage = await sut.pageAssetsWithRuns({ limit: 2 });
      expect(firstPage.items).toHaveLength(2);
      expect(firstPage.nextCursor).toBe(firstPage.items[1]!.assetId);

      const secondPage = await sut.pageAssetsWithRuns({ limit: 2, cursor: firstPage.nextCursor! });
      expect(secondPage.items).toHaveLength(1);
      expect(secondPage.nextCursor).toBeNull();

      const seen = [...firstPage.items, ...secondPage.items].map(({ assetId }) => assetId).sort();
      expect(seen).toEqual(assets.map(({ id }) => id).sort());
    });
  });

  describe('searchDense', () => {
    it('should order by cosine distance and apply minScore, ownership, and deletion filters', async () => {
      const { ctx, sut } = await setup();
      const { user } = await ctx.newUser();
      const { user: otherUser } = await ctx.newUser();
      const { asset: exact } = await ctx.newAsset({ ownerId: user.id });
      const { asset: angled } = await ctx.newAsset({ ownerId: user.id });
      const { asset: orthogonal } = await ctx.newAsset({ ownerId: user.id });
      const { asset: otherOwner } = await ctx.newAsset({ ownerId: otherUser.id });
      const { asset: deleted } = await ctx.newAsset({ ownerId: user.id });

      await sut.upsert({ assetId: exact.id, text: 't', embedding: vector(1, 0), runKey: 'r', model: 'bge' });
      await sut.upsert({
        assetId: angled.id,
        text: 't',
        embedding: vector(Math.SQRT1_2, Math.SQRT1_2),
        runKey: 'r',
        model: 'bge',
      });
      await sut.upsert({ assetId: orthogonal.id, text: 't', embedding: vector(0, 1), runKey: 'r', model: 'bge' });
      await sut.upsert({ assetId: otherOwner.id, text: 't', embedding: vector(1, 0), runKey: 'r', model: 'bge' });
      await sut.upsert({ assetId: deleted.id, text: 't', embedding: vector(1, 0), runKey: 'r', model: 'bge' });
      await ctx.database.deleteFrom('asset').where('id', '=', deleted.id).execute();

      const rows = await sut.searchDense(
        { limit: 10 },
        { embedding: vector(1, 0), userIds: [user.id], visibility: 'not-locked', minScore: 0.4 },
      );

      // orthogonal (similarity 0) falls below the minScore floor; the other
      // user's asset and the deleted asset are excluded
      expect(rows.map(({ assetId }) => assetId)).toEqual([exact.id, angled.id]);
    });
  });

  describe('searchLexical', () => {
    it('should match trigram text and rank exact words first', async () => {
      const { ctx, sut } = await setup();
      const { user } = await ctx.newUser();
      const { user: otherUser } = await ctx.newUser();
      const { asset: exact } = await ctx.newAsset({ ownerId: user.id });
      const { asset: approximate } = await ctx.newAsset({ ownerId: user.id });
      const { asset: otherOwner } = await ctx.newAsset({ ownerId: otherUser.id });

      await sut.upsert({
        assetId: exact.id,
        text: 'blocks on the floor',
        embedding: vector(1, 0),
        runKey: 'r',
        model: 'bge',
      });
      await sut.upsert({
        assetId: approximate.id,
        text: 'wooden block',
        embedding: vector(1, 0),
        runKey: 'r',
        model: 'bge',
      });
      await sut.upsert({
        assetId: otherOwner.id,
        text: 'blocks on the floor',
        embedding: vector(1, 0),
        runKey: 'r',
        model: 'bge',
      });

      const rows = await sut.searchLexical(
        { limit: 10 },
        { q: 'blocks', userIds: [user.id], visibility: 'not-locked' },
      );

      expect(rows.map(({ assetId }) => assetId)).toEqual([exact.id, approximate.id]);
    });

    it('should exclude rows that do not similarity-match', async () => {
      const { ctx, sut } = await setup();
      const { user } = await ctx.newUser();
      const { asset } = await ctx.newAsset({ ownerId: user.id });

      await sut.upsert({
        assetId: asset.id,
        text: 'sunset over the ocean',
        embedding: vector(1, 0),
        runKey: 'r',
        model: 'bge',
      });

      const rows = await sut.searchLexical({ limit: 10 }, { q: 'blockchain', userIds: [user.id] });
      expect(rows).toHaveLength(0);
    });
  });
});
