import { AssetMetadataKey } from 'src/enum.js';
import {
  AiInterpretSearchRepository,
  MAX_EXACT_TIER_MATCHES,
} from 'src/repositories/ai-interpret-search.repository.js';
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
  const v = Array.from({ length: 1024 }, () => 0);
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

    it('should break distance ties deterministically by assetId across the ANN window', async () => {
      const { ctx, sut } = await setup();
      const { user } = await ctx.newUser();
      const ids: string[] = [];
      for (let i = 0; i < 4; i++) {
        const { asset } = await ctx.newAsset({ ownerId: user.id });
        // identical embeddings produce identical distances; the returned
        // window must still be ordered by assetId, not insertion order
        await sut.upsert({ assetId: asset.id, text: 't', embedding: vector(1, 0), runKey: 'r', model: 'bge' });
        ids.push(asset.id);
      }

      const rows = await sut.searchDense(
        { limit: 3 },
        { embedding: vector(1, 0), userIds: [user.id], visibility: 'not-locked', minScore: 0 },
      );

      const returned = rows.map(({ assetId }) => assetId);
      expect(returned).toHaveLength(3);
      // distinct assets, all from the tied group, in ascending assetId order
      expect(new Set(returned).size).toBe(3);
      for (const id of returned) {
        expect(ids).toContain(id);
      }
      expect(returned).toEqual([...returned].sort());

      // a larger window extends the same scan, so paging stays stable: every
      // asset on the smaller page also appears in the wider window
      const wider = await sut.searchDense(
        { limit: 4 },
        { embedding: vector(1, 0), userIds: [user.id], visibility: 'not-locked', minScore: 0 },
      );
      expect(wider.map(({ assetId }) => assetId)).toEqual(expect.arrayContaining(returned));
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

  describe('searchExactToken', () => {
    it('should rank contiguous word-bounded matches tier 2 above noncontiguous tier 1', async () => {
      const { ctx, sut } = await setup();
      const { user } = await ctx.newUser();
      const { asset: contiguous } = await ctx.newAsset({ ownerId: user.id });
      const { asset: noncontiguous } = await ctx.newAsset({ ownerId: user.id });
      const { asset: partialOnly } = await ctx.newAsset({ ownerId: user.id });

      // "nidia saleh" appears as one word-bounded sequence inside prose
      await sut.upsert({
        assetId: contiguous.id,
        text: 'dental receipt Doctor listed as drg NIDIA SALEH Sp KG',
        embedding: vector(1, 0),
        runKey: 'r',
        model: 'bge',
      });
      // both tokens are complete words but far apart
      await sut.upsert({
        assetId: noncontiguous.id,
        text: 'nidia visited the clinic saleh signed the form',
        embedding: vector(1, 0),
        runKey: 'r',
        model: 'bge',
      });
      // only one token as a complete word: never returned by this branch
      await sut.upsert({
        assetId: partialOnly.id,
        text: 'poster by mawardi m saleh with no other match',
        embedding: vector(1, 0),
        runKey: 'r',
        model: 'bge',
      });

      const rows = await sut.searchExactToken({
        q: 'NIDIA SALEH',
        tokens: ['nidia', 'saleh'],
        userIds: [user.id],
        visibility: 'not-locked',
      });

      expect(rows.map(({ assetId }) => assetId)).toEqual([contiguous.id, noncontiguous.id]);
      expect(rows.map(({ matchTier }) => matchTier)).toEqual([2, 1]);
    });

    it('should not mistake substrings or mixed-case text for exact tokens', async () => {
      const { ctx, sut } = await setup();
      const { user } = await ctx.newUser();
      const { asset: wordHit } = await ctx.newAsset({ ownerId: user.id });
      const { asset: substringOnly } = await ctx.newAsset({ ownerId: user.id });

      await sut.upsert({
        assetId: wordHit.id,
        text: 'receipt signed by SALEH',
        embedding: vector(1, 0),
        runKey: 'r',
        model: 'bge',
      });
      // "saleh" only appears inside a longer word: substring, not a token
      await sut.upsert({
        assetId: substringOnly.id,
        text: 'salehuddin mosque compound',
        embedding: vector(1, 0),
        runKey: 'r',
        model: 'bge',
      });

      const rows = await sut.searchExactToken({
        q: 'saleh',
        tokens: ['saleh'],
        userIds: [user.id],
        visibility: 'not-locked',
      });

      expect(rows.map(({ assetId }) => assetId)).toEqual([wordHit.id]);
      expect(rows[0]!.matchTier).toBe(2);
    });

    it('should match diacritic-stripped tokens against unaccented documents and skip unfilterable tokens', async () => {
      const { ctx, sut } = await setup();
      const { user } = await ctx.newUser();
      const { asset: accented } = await ctx.newAsset({ ownerId: user.id });

      await sut.upsert({
        assetId: accented.id,
        text: 'notarial deed by Nur Áisyah',
        embedding: vector(1, 0),
        runKey: 'r',
        model: 'bge',
      });

      const rows = await sut.searchExactToken({
        q: 'nur aisyah',
        tokens: ['nur', 'aisyah'],
        userIds: [user.id],
        visibility: 'not-locked',
      });
      expect(rows.map(({ assetId }) => assetId)).toEqual([accented.id]);
      expect(rows[0]!.matchTier).toBe(2);

      // every token too short to prefilter: the branch declines (empty), it
      // must not fall back to a whole-table scan
      const short = await sut.searchExactToken({
        q: 'ng bo',
        tokens: ['ng', 'bo'],
        userIds: [user.id],
        visibility: 'not-locked',
      });
      expect(short).toHaveLength(0);
    });

    it('should preserve token order and repetitions for the phrase but deduplicate tier-1 membership', async () => {
      const { ctx, sut } = await setup();
      const { user } = await ctx.newUser();
      const { asset: repeated } = await ctx.newAsset({ ownerId: user.id });
      const { asset: single } = await ctx.newAsset({ ownerId: user.id });

      await sut.upsert({
        assetId: repeated.id,
        text: 'Saleh Saleh brothers portrait',
        embedding: vector(1, 0),
        runKey: 'r',
        model: 'bge',
      });
      await sut.upsert({
        assetId: single.id,
        text: 'Saleh brothers portrait',
        embedding: vector(1, 0),
        runKey: 'r',
        model: 'bge',
      });

      const rows = await sut.searchExactToken({
        q: 'saleh saleh',
        tokens: ['saleh', 'saleh'],
        userIds: [user.id],
        visibility: 'not-locked',
      });

      // the phrase "saleh saleh" only matches the repeated doc (tier 2); the
      // single-token doc still qualifies for tier 1 via deduplicated membership
      expect(rows).toEqual([
        { assetId: repeated.id, matchTier: 2 },
        { assetId: single.id, matchTier: 1 },
      ]);
    });

    it('should apply ownership and visibility filters', async () => {
      const { ctx, sut } = await setup();
      const { user } = await ctx.newUser();
      const { user: otherUser } = await ctx.newUser();
      const { asset: mine } = await ctx.newAsset({ ownerId: user.id });
      const { asset: theirs } = await ctx.newAsset({ ownerId: otherUser.id });

      const doc = 'clinic record drg NIDIA SALEH Sp KG';
      await sut.upsert({ assetId: mine.id, text: doc, embedding: vector(1, 0), runKey: 'r', model: 'bge' });
      await sut.upsert({ assetId: theirs.id, text: doc, embedding: vector(1, 0), runKey: 'r', model: 'bge' });

      const rows = await sut.searchExactToken({
        q: 'NIDIA SALEH',
        tokens: ['nidia', 'saleh'],
        userIds: [user.id],
        visibility: 'not-locked',
      });

      expect(rows.map(({ assetId }) => assetId)).toEqual([mine.id]);
    });

    it('should retain tier 2 but drop tier 1 when tier 1 is over-selective', async () => {
      const { ctx, sut } = await setup();
      const { user } = await ctx.newUser();
      const { asset: exactPhrase } = await ctx.newAsset({ ownerId: user.id });
      await sut.upsert({
        assetId: exactPhrase.id,
        text: 'clinic record drg nidia saleh sp kg',
        embedding: vector(1, 0),
        runKey: 'r',
        model: 'bge',
      });
      for (let i = 0; i <= MAX_EXACT_TIER_MATCHES; i++) {
        const { asset } = await ctx.newAsset({ ownerId: user.id });
        // both tokens present as words, never as the contiguous phrase
        await sut.upsert({
          assetId: asset.id,
          text: `saleh referral note ${i} for nidia`,
          embedding: vector(1, 0),
          runKey: 'r',
          model: 'bge',
        });
      }

      const rows = await sut.searchExactToken({
        q: 'nidia saleh',
        tokens: ['nidia', 'saleh'],
        userIds: [user.id],
        visibility: 'not-locked',
      });

      // 101 noncontiguous matches exceed the bound: tier 1 is dropped, the
      // rare exact phrase survives
      expect(rows).toEqual([{ assetId: exactPhrase.id, matchTier: 2 }]);
    });

    it('should skip the entire branch when tier 2 is over-selective', async () => {
      const { ctx, sut } = await setup();
      const { user } = await ctx.newUser();
      const { asset: rareNoncontiguous } = await ctx.newAsset({ ownerId: user.id });
      await sut.upsert({
        assetId: rareNoncontiguous.id,
        text: 'dental referral for nidia from doctor saleh',
        embedding: vector(1, 0),
        runKey: 'r',
        model: 'bge',
      });
      for (let i = 0; i <= MAX_EXACT_TIER_MATCHES; i++) {
        const { asset } = await ctx.newAsset({ ownerId: user.id });
        await sut.upsert({
          assetId: asset.id,
          text: `clinic record nidia saleh visit ${i}`,
          embedding: vector(1, 0),
          runKey: 'r',
          model: 'bge',
        });
      }

      // 101 contiguous matches exceed the bound: the whole branch declines so
      // the original two-branch RRF ordering stands, even though a tier-1
      // match exists
      const rows = await sut.searchExactToken({
        q: 'nidia saleh',
        tokens: ['nidia', 'saleh'],
        userIds: [user.id],
        visibility: 'not-locked',
      });
      expect(rows).toHaveLength(0);
    });

    it('should retain all candidates and rank tier 2 first when both tiers are within the bound', async () => {
      const { ctx, sut } = await setup();
      const { user } = await ctx.newUser();
      const ids: { assetId: string; matchTier: number }[] = [];
      for (let i = 0; i < 3; i++) {
        const { asset } = await ctx.newAsset({ ownerId: user.id });
        await sut.upsert({
          assetId: asset.id,
          text: `dental record nidia saleh sp kg ${i}`,
          embedding: vector(1, 0),
          runKey: 'r',
          model: 'bge',
        });
        ids.push({ assetId: asset.id, matchTier: 2 });
      }
      for (let i = 0; i < 2; i++) {
        const { asset } = await ctx.newAsset({ ownerId: user.id });
        await sut.upsert({
          assetId: asset.id,
          text: `nidia met saleh at the clinic ${i}`,
          embedding: vector(1, 0),
          runKey: 'r',
          model: 'bge',
        });
        ids.push({ assetId: asset.id, matchTier: 1 });
      }

      const rows = await sut.searchExactToken({
        q: 'nidia saleh',
        tokens: ['nidia', 'saleh'],
        userIds: [user.id],
        visibility: 'not-locked',
      });

      expect(rows).toHaveLength(5);
      // tier 2 first; within each tier, deterministic assetId order
      const tier2 = rows.filter(({ matchTier }) => matchTier === 2);
      const tier1 = rows.filter(({ matchTier }) => matchTier === 1);
      expect(tier2.map(({ assetId }) => assetId)).toEqual(
        ids
          .filter(({ matchTier }) => matchTier === 2)
          .map(({ assetId }) => assetId)
          .sort(),
      );
      expect(tier1.map(({ assetId }) => assetId)).toEqual(
        ids
          .filter(({ matchTier }) => matchTier === 1)
          .map(({ assetId }) => assetId)
          .sort(),
      );
      expect(rows.slice(0, 3)).toEqual(tier2);
    });
  });
});
