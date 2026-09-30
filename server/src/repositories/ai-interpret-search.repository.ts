import { Injectable } from '@nestjs/common';
import { Kysely, sql } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';
import { columns } from 'src/database.js';
import { DummyValue, GenerateSql } from 'src/decorators.js';
import { AssetMetadataKey, AssetVisibility, VectorIndex } from 'src/enum.js';
import { probes } from 'src/repositories/database.repository.js';
import { DB } from 'src/schema/index.js';

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

interface AiInterpretVisibility {
  visibility?: AssetVisibility | 'not-locked';
}

export interface AiInterpretDenseSearch extends AiInterpretVisibility {
  embedding: string;
  userIds: string[];
  minScore: number;
}

export interface AiInterpretLexicalSearch extends AiInterpretVisibility {
  q: string;
  userIds: string[];
}

export interface AiInterpretBranchRow {
  assetId: string;
  distance: number;
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
      { embedding: DummyValue.VECTOR, userIds: [DummyValue.UUID], visibility: 'not-locked', minScore: 0.4 },
    ],
  })
  async searchDense(
    { limit }: { limit: number },
    { embedding, userIds, visibility, minScore }: AiInterpretDenseSearch,
  ): Promise<AiInterpretBranchRow[]> {
    return this.db.transaction().execute(async (trx) => {
      await sql`set local vchordrq.probes = ${sql.lit(probes[VectorIndex.AiInterpret])}`.execute(trx);
      return trx
        .selectFrom('ai_interpret_search')
        .innerJoin('asset', 'asset.id', 'ai_interpret_search.assetId')
        .select([
          'ai_interpret_search.assetId',
          sql<number>`ai_interpret_search.embedding <=> ${embedding}`.as('distance'),
        ])
        .where('asset.ownerId', 'in', userIds)
        .where('asset.deletedAt', 'is', null)
        .$if(visibility === 'not-locked', (qb) => qb.where('asset.visibility', '!=', AssetVisibility.Locked))
        .$if(visibility !== undefined && visibility !== 'not-locked', (qb) =>
          qb.where('asset.visibility', '=', visibility as AssetVisibility),
        )
        .where(() => sql`1 - (ai_interpret_search.embedding <=> ${embedding}) >= ${minScore}`)
        .orderBy('distance', 'asc')
        .orderBy('ai_interpret_search.assetId', 'asc')
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
    params: [{ limit: 101 }, { q: DummyValue.STRING, userIds: [DummyValue.UUID], visibility: 'not-locked' }],
  })
  async searchLexical(
    { limit }: { limit: number },
    { q, userIds, visibility }: AiInterpretLexicalSearch,
  ): Promise<AiInterpretBranchRow[]> {
    return this.db
      .selectFrom('ai_interpret_search')
      .innerJoin('asset', 'asset.id', 'ai_interpret_search.assetId')
      .select([
        'ai_interpret_search.assetId',
        sql<number>`f_unaccent(ai_interpret_search.text) <->>> f_unaccent(${q})`.as('distance'),
      ])
      .where('asset.ownerId', 'in', userIds)
      .where('asset.deletedAt', 'is', null)
      .$if(visibility === 'not-locked', (qb) => qb.where('asset.visibility', '!=', AssetVisibility.Locked))
      .$if(visibility !== undefined && visibility !== 'not-locked', (qb) =>
        qb.where('asset.visibility', '=', visibility as AssetVisibility),
      )
      .where(() => sql`f_unaccent(ai_interpret_search.text) %>> f_unaccent(${q})`)
      .orderBy('distance', 'asc')
      .orderBy('ai_interpret_search.assetId', 'asc')
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
