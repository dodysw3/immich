import { LoggingRepository } from 'src/repositories/logging.repository.js';
import {
  TranscriptIndexRepository,
  type TranscriptPassageInsert,
} from 'src/repositories/transcript-index.repository.js';
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
  return { ctx, sut: new TranscriptIndexRepository(db) };
};

const revisionA = 'a'.repeat(64);
const revisionB = 'b'.repeat(64);
const runKey = 'k'.repeat(64);

const passage = (windowId: string, text: string, startMs: number): TranscriptPassageInsert => ({
  windowId,
  firstSegment: Number(windowId.split(':', 1)[0]),
  lastSegment: Number(windowId.split(':', 2)[1]),
  startMs,
  endMs: startMs + 2000,
  text,
  normalizedText: text.toLowerCase(),
  tokens: [...new Set(text.toLowerCase().split(' '))],
  segmentSpans: [{ start: 0, end: text.length }],
  segmentStartsMs: [startMs],
});

const replace = (revision: string, passages: TranscriptPassageInsert[]) => ({
  revision,
  runKey,
  indexVersion: 1,
  coverageState: 'complete',
  segmentCount: 3,
  passages,
});

describe(TranscriptIndexRepository.name, () => {
  it('replaces passages and index state transactionally, never mixing revisions', async () => {
    const { ctx, sut } = await setup();
    const { user } = await ctx.newUser();
    const { asset } = await ctx.newAsset({ ownerId: user.id });

    await sut.replacePassages(
      asset.id,
      replace(revisionA, [passage('0:0', 'satu dua', 0), passage('1:1', 'tiga', 3000)]),
    );

    let rows = await ctx.database
      .selectFrom('transcript_passage')
      .selectAll()
      .where('assetId', '=', asset.id)
      .execute();
    expect(rows.map((row) => row.revision)).toEqual([revisionA, revisionA]);
    let state = await sut.getState(asset.id);
    expect(state).toMatchObject({ revision: revisionA, passageCount: 2, segmentCount: 3, error: null });

    // Second replacement under the SAME runKey with different content: the
    // revision changes and old windows disappear atomically.
    await sut.replacePassages(asset.id, replace(revisionB, [passage('0:0', 'empat lima', 0)]));

    rows = await ctx.database.selectFrom('transcript_passage').selectAll().where('assetId', '=', asset.id).execute();
    expect(rows.map((row) => row.revision)).toEqual([revisionB]);
    state = await sut.getState(asset.id);
    expect(state).toMatchObject({ revision: revisionB, runKey, passageCount: 1 });

    const tokens = await ctx.database.selectFrom('transcript_passage_token').select('token').execute();
    // Old revision's tokens are gone; new ones are distinct.
    expect(tokens.map((row) => row.token).sort()).toEqual(['empat', 'lima']);
  });

  it('rolls back to the previous revision when the replacement fails mid-transaction', async () => {
    const { ctx, sut } = await setup();
    const { user } = await ctx.newUser();
    const { asset } = await ctx.newAsset({ ownerId: user.id });

    await sut.replacePassages(asset.id, replace(revisionA, [passage('0:0', 'satu dua', 0)]));

    // A row violating NOT NULL fails the insert after the delete; the whole
    // transaction (including the delete) must roll back.
    const broken = { ...passage('0:0', 'rusak', 0), text: undefined } as unknown as TranscriptPassageInsert;
    await expect(sut.replacePassages(asset.id, replace(revisionB, [broken]))).rejects.toThrow();

    const rows = await ctx.database
      .selectFrom('transcript_passage')
      .selectAll()
      .where('assetId', '=', asset.id)
      .execute();
    expect(rows).toHaveLength(1);
    expect(rows[0]!.revision).toBe(revisionA);
    expect(rows[0]!.text).toBe('satu dua');
    const state = await sut.getState(asset.id);
    expect(state?.revision).toBe(revisionA);
  });

  it('cascades index data away when the asset is deleted', async () => {
    const { ctx, sut } = await setup();
    const { user } = await ctx.newUser();
    const { asset } = await ctx.newAsset({ ownerId: user.id });
    await sut.replacePassages(asset.id, replace(revisionA, [passage('0:0', 'satu', 0)]));

    await ctx.database.deleteFrom('asset').where('id', '=', asset.id).execute();

    expect(await ctx.database.selectFrom('transcript_passage').selectAll().execute()).toHaveLength(0);
    expect(await ctx.database.selectFrom('transcript_passage_token').selectAll().execute()).toHaveLength(0);
    expect(await ctx.database.selectFrom('transcript_index_state').selectAll().execute()).toHaveLength(0);
  });

  it('records indexing failures without touching passages', async () => {
    const { ctx, sut } = await setup();
    const { user } = await ctx.newUser();
    const { asset } = await ctx.newAsset({ ownerId: user.id });
    await sut.replacePassages(asset.id, replace(revisionA, [passage('0:0', 'satu', 0)]));

    await sut.markFailed(asset.id, runKey, 1, 'boom');

    const state = await sut.getState(asset.id);
    expect(state).toMatchObject({ revision: revisionA, error: 'boom' });
    expect(await ctx.database.selectFrom('transcript_passage').selectAll().execute()).toHaveLength(1);
  });
});
