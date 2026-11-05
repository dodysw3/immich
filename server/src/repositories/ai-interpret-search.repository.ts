import { Injectable } from '@nestjs/common';
import { DeduplicateJoinsPlugin, Kysely, SelectQueryBuilder, sql } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';
import { columns } from 'src/database.js';
import { DummyValue, GenerateSql } from 'src/decorators.js';
import { AssetMetadataKey, AssetType, AssetVisibility, VectorIndex } from 'src/enum.js';
import { probes } from 'src/repositories/database.repository.js';
import { DB } from 'src/schema/index.js';
import { completedAiInterpretations, hasPeople, hasTags } from 'src/utils/database.js';

export interface AiInterpretUpsert {
  assetId: string;
  text: string;
  embedding: string;
  runKey: string;
  model: string;
}

export interface AiInterpretStoredRow {
  assetId: string;
  runKey: string;
  model: string;
}

/**
 * Asset-level filters shared by both search branches. Semantics match
 * searchAssetBuilderLegacy: `undefined` means unfiltered, `null` (where
 * allowed) means an explicit "is null" (absent) filter.
 */
export interface AiInterpretAssetFilters {
  userIds: string[];
  visibility?: AssetVisibility | 'not-locked';
  takenBefore?: Date;
  takenAfter?: Date;
  type?: AssetType;
  isFavorite?: boolean;
  rating?: number | null;
  city?: string | null;
  state?: string | null;
  country?: string | null;
  make?: string | null;
  model?: string | null;
  lensModel?: string | null;
  personIds?: string[];
  tagIds?: string[] | null;
  isNotInAlbum?: boolean;
  hasAiInterpretation?: boolean;
  withStacked?: boolean;
}

export interface AiInterpretDenseSearch extends AiInterpretAssetFilters {
  embedding: string;
  minScore: number;
}

export interface AiInterpretLexicalSearch extends AiInterpretAssetFilters {
  q: string;
}

export interface AiInterpretBranchRow {
  assetId: string;
  distance: number;
}

/**
 * Applies the shared asset-level filters to a query whose driving table is
 * `asset` (with `ai_interpret_search` joined). Multiple exif filters each add
 * their own join, so the caller must attach the join-deduplication plugin.
 */
function applyAssetFilters<O>(
  qb: SelectQueryBuilder<DB, 'asset', O>,
  {
    userIds,
    visibility,
    takenAfter,
    takenBefore,
    type,
    isFavorite,
    rating,
    city,
    state,
    country,
    make,
    model,
    lensModel,
    personIds,
    tagIds,
    isNotInAlbum,
    hasAiInterpretation,
    withStacked,
  }: AiInterpretAssetFilters,
): SelectQueryBuilder<DB, 'asset', O> {
  return qb
    .where('asset.ownerId', 'in', userIds)
    .where('asset.deletedAt', 'is', null)
    .$if(visibility === 'not-locked', (qb) => qb.where('asset.visibility', '!=', AssetVisibility.Locked))
    .$if(visibility !== undefined && visibility !== 'not-locked', (qb) =>
      qb.where('asset.visibility', '=', visibility as AssetVisibility),
    )
    .$if(!!takenAfter, (qb) => qb.where('asset.fileCreatedAt', '>=', takenAfter!))
    .$if(!!takenBefore, (qb) => qb.where('asset.fileCreatedAt', '<=', takenBefore!))
    .$if(type !== undefined, (qb) => qb.where('asset.type', '=', type!))
    .$if(isFavorite !== undefined, (qb) => qb.where('asset.isFavorite', '=', isFavorite!))
    .$if(withStacked === false, (qb) => qb.where('asset.stackId', 'is', null))
    .$if(city !== undefined, (qb) =>
      qb
        .innerJoin('asset_exif', 'asset.id', 'asset_exif.assetId')
        .where('asset_exif.city', city === null ? 'is' : '=', city!),
    )
    .$if(state !== undefined, (qb) =>
      qb
        .innerJoin('asset_exif', 'asset.id', 'asset_exif.assetId')
        .where('asset_exif.state', state === null ? 'is' : '=', state!),
    )
    .$if(country !== undefined, (qb) =>
      qb
        .innerJoin('asset_exif', 'asset.id', 'asset_exif.assetId')
        .where('asset_exif.country', country === null ? 'is' : '=', country!),
    )
    .$if(make !== undefined, (qb) =>
      qb
        .innerJoin('asset_exif', 'asset.id', 'asset_exif.assetId')
        .where('asset_exif.make', make === null ? 'is' : '=', make!),
    )
    .$if(model !== undefined, (qb) =>
      qb
        .innerJoin('asset_exif', 'asset.id', 'asset_exif.assetId')
        .where('asset_exif.model', model === null ? 'is' : '=', model!),
    )
    .$if(lensModel !== undefined, (qb) =>
      qb
        .innerJoin('asset_exif', 'asset.id', 'asset_exif.assetId')
        .where('asset_exif.lensModel', lensModel === null ? 'is' : '=', lensModel!),
    )
    .$if(rating !== undefined, (qb) =>
      qb
        .innerJoin('asset_exif', 'asset.id', 'asset_exif.assetId')
        .where('asset_exif.rating', rating === null ? 'is' : '=', rating!),
    )
    .$if(!!personIds && personIds.length > 0, (qb) => hasPeople(qb, personIds!))
    .$if(!!tagIds && tagIds.length > 0, (qb) => hasTags(qb, tagIds!))
    .$if(tagIds === null, (qb) =>
      qb.where((eb) => eb.not(eb.exists((eb) => eb.selectFrom('tag_asset').whereRef('assetId', '=', 'asset.id')))),
    )
    .$if(!!isNotInAlbum, (qb) =>
      qb.where((eb) => eb.not(eb.exists((eb) => eb.selectFrom('album_asset').whereRef('assetId', '=', 'asset.id')))),
    )
    .$if(hasAiInterpretation !== undefined, (qb) =>
      qb.where((eb) => {
        const completed = eb.exists(completedAiInterpretations(eb));
        return hasAiInterpretation ? completed : eb.not(completed);
      }),
    );
}

@Injectable()
export class AiInterpretSearchRepository {
  constructor(@InjectKysely() private db: Kysely<DB>) {}

  @GenerateSql({
    params: [
      DummyValue.UUID,
      { text: DummyValue.STRING, embedding: DummyValue.VECTOR, runKey: DummyValue.STRING, model: DummyValue.STRING },
    ],
  })
  async upsert({ assetId, text, embedding, runKey, model }: AiInterpretUpsert): Promise<void> {
    await this.db
      .insertInto('ai_interpret_search')
      .values({ assetId, text, embedding, runKey, model, updatedAt: new Date() })
      .onConflict((oc) =>
        oc.column('assetId').doUpdateSet((eb) => ({
          text: eb.ref('excluded.text'),
          embedding: eb.ref('excluded.embedding'),
          runKey: eb.ref('excluded.runKey'),
          model: eb.ref('excluded.model'),
          updatedAt: eb.ref('excluded.updatedAt'),
        })),
      )
      .execute();
  }

  @GenerateSql({ params: [DummyValue.UUID] })
  async get(assetId: string): Promise<AiInterpretStoredRow | undefined> {
    return this.db
      .selectFrom('ai_interpret_search')
      .select(['assetId', 'runKey', 'model'])
      .where('assetId', '=', assetId)
      .executeTakeFirst();
  }

  @GenerateSql({ params: [[DummyValue.UUID]] })
  async getStoredByAssetIds(assetIds: string[]): Promise<Map<string, AiInterpretStoredRow>> {
    if (assetIds.length === 0) {
      return new Map();
    }

    const rows = await this.db
      .selectFrom('ai_interpret_search')
      .select(['assetId', 'runKey', 'model'])
      .where('assetId', 'in', assetIds)
      .execute();
    return new Map(rows.map((row) => [row.assetId, row]));
  }

  /**
   * Pages through assets that have at least one completed AI interpretation
   * run, ordered by assetId for keyset pagination. Returns the raw metadata
   * document so the caller can pick the latest completed run itself.
   */
  @GenerateSql({ params: [{ cursor: DummyValue.UUID, limit: 500 }] })
  async pageAssetsWithRuns({
    cursor,
    limit,
  }: {
    cursor?: string;
    limit: number;
  }): Promise<{ items: Array<{ assetId: string; value: Record<string, unknown> }>; nextCursor: string | null }> {
    const rows = await this.db
      .selectFrom('asset_metadata')
      .select(['assetId', 'value'])
      .where('key', '=', AssetMetadataKey.AiInterpretationV1)
      .$if(!!cursor, (qb) => qb.where('assetId', '>', cursor!))
      .where(
        () =>
          sql`exists (select 1 from jsonb_each(asset_metadata.value -> 'runs') as run where run.value ->> 'status' = 'completed')`,
      )
      .orderBy('assetId', 'asc')
      .limit(limit)
      .execute();

    return {
      items: rows.map(({ assetId, value }) => ({ assetId, value: value as Record<string, unknown> })),
      nextCursor: rows.length === limit ? rows.at(-1)!.assetId : null,
    };
  }

  /**
   * Dense branch: cosine kNN over indexed interpretations, restricted to the
   * caller's asset universe and the configured minimum cosine similarity.
   * Returns the top `limit` rows ordered best-match first.
   */
  @GenerateSql({
    params: [
      { limit: 101 },
      {
        embedding: DummyValue.VECTOR,
        userIds: [DummyValue.UUID],
        visibility: 'not-locked',
        minScore: 0.4,
        takenAfter: DummyValue.DATE,
        takenBefore: DummyValue.DATE,
        type: AssetType.Image,
        isFavorite: true,
        personIds: [DummyValue.UUID],
        tagIds: [DummyValue.UUID],
        isNotInAlbum: true,
        hasAiInterpretation: true,
        withStacked: false,
        city: DummyValue.STRING,
        state: null,
        country: DummyValue.STRING,
        make: DummyValue.STRING,
        model: DummyValue.STRING,
        lensModel: null,
        rating: 5,
      },
    ],
  })
  async searchDense(
    { limit }: { limit: number },
    { embedding, minScore, ...filters }: AiInterpretDenseSearch,
  ): Promise<AiInterpretBranchRow[]> {
    return this.db.transaction().execute(async (trx) => {
      await sql`set local vchordrq.probes = ${sql.lit(probes[VectorIndex.AiInterpret])}`.execute(trx);
      return applyAssetFilters(
        trx
          .withPlugin(new DeduplicateJoinsPlugin())
          .selectFrom('asset')
          .innerJoin('ai_interpret_search', 'asset.id', 'ai_interpret_search.assetId')
          .select([
            'ai_interpret_search.assetId',
            sql<number>`ai_interpret_search.embedding <=> ${embedding}`.as('distance'),
          ]),
        filters,
      )
        .where(() => sql`1 - (ai_interpret_search.embedding <=> ${embedding}) >= ${minScore}`)
        .orderBy('distance', 'asc')
        .orderBy(sql`"ai_interpret_search"."assetId"`, 'asc')
        .limit(limit)
        .execute();
    });
  }

  /**
   * Lexical branch: pg_trgm strict word similarity over the curated text,
   * ranked best-match first via the word similarity distance operator.
   * Returns the top `limit` rows ordered best-match first.
   */
  @GenerateSql({
    params: [
      { limit: 101 },
      {
        q: DummyValue.STRING,
        userIds: [DummyValue.UUID],
        visibility: 'not-locked',
        takenBefore: DummyValue.DATE,
        type: AssetType.Image,
      },
    ],
  })
  async searchLexical(
    { limit }: { limit: number },
    { q, ...filters }: AiInterpretLexicalSearch,
  ): Promise<AiInterpretBranchRow[]> {
    return applyAssetFilters(
      this.db
        .withPlugin(new DeduplicateJoinsPlugin())
        .selectFrom('asset')
        .innerJoin('ai_interpret_search', 'asset.id', 'ai_interpret_search.assetId')
        .select([
          'ai_interpret_search.assetId',
          sql<number>`f_unaccent(ai_interpret_search.text) <->>> f_unaccent(${q})`.as('distance'),
        ]),
      filters,
    )
      .where(() => sql`f_unaccent(ai_interpret_search.text) %>> f_unaccent(${q})`)
      .orderBy('distance', 'asc')
      .orderBy(sql`"ai_interpret_search"."assetId"`, 'asc')
      .limit(limit)
      .execute();
  }

  async getAssetsByIds(assetIds: string[]) {
    if (assetIds.length === 0) {
      return [];
    }

    return this.db.selectFrom('asset').select(columns.searchAsset).where('asset.id', 'in', assetIds).execute();
  }
}
