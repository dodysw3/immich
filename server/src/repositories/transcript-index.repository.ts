import { Injectable } from '@nestjs/common';
import { DeduplicateJoinsPlugin, Kysely, sql, type Selectable } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';
import { columns } from 'src/database.js';
import { AssetType } from 'src/enum.js';
import { applyAssetFilters, type AiInterpretAssetFilters } from 'src/repositories/ai-interpret-search.repository.js';
import { DB } from 'src/schema/index.js';
import { TranscriptIndexStateTable } from 'src/schema/tables/transcript-index-state.table.js';

export interface TranscriptPassageInsert {
  /** Contributing segment range id 'first:last' (window identity within the asset). */
  windowId: string;
  firstSegment: number;
  lastSegment: number;
  startMs: number;
  endMs: number;
  /** Original transcript text of the window (display/highlight source). */
  text: string;
  /** Normalized token text joined by spaces. */
  normalizedText: string;
  /** Distinct normalized tokens for the spelling-fallback candidate pool. */
  tokens: string[];
  /** UTF-16 offsets of each contributing segment within `text`. */
  segmentSpans: Array<{ start: number; end: number }>;
  /** Absolute start ms of each contributing segment. */
  segmentStartsMs: number[];
}

export interface TranscriptIndexReplace {
  revision: string;
  runKey: string;
  indexVersion: number;
  coverageState: string;
  segmentCount: number;
  passages: TranscriptPassageInsert[];
}

/**
Derived transcript search index (passages + tokens + per-video state).
Everything here is rebuildable from `asset_metadata` (`video-transcripts-v1`)
without inference; replacement is transactional per video so readers never
see mixed revisions and a failed sync leaves the previous revision searchable.
*/
@Injectable()
export class TranscriptIndexRepository {
  constructor(@InjectKysely() private db: Kysely<DB>) {}

  async getState(assetId: string): Promise<Selectable<TranscriptIndexStateTable> | undefined> {
    return await this.db
      .selectFrom('transcript_index_state')
      .selectAll()
      .where('assetId', '=', assetId)
      .executeTakeFirst();
  }

  /**
  Replace one video's passages and index state in a single transaction: the
  previous revision stays fully readable until commit, and a failure
  (constraint, disk, crash) rolls back to it. Source transcripts live in
  asset_metadata and are never touched here.
  */
  async replacePassages(assetId: string, replace: TranscriptIndexReplace): Promise<void> {
    await this.db.transaction().execute(async (tx) => {
      // Tokens cascade with their passages; delete first so window ids can be
      // reused by the incoming revision.
      await tx.deleteFrom('transcript_passage').where('assetId', '=', assetId).execute();

      if (replace.passages.length > 0) {
        const inserted = await tx
          .insertInto('transcript_passage')
          .values(
            replace.passages.map((passage) => ({
              assetId,
              revision: replace.revision,
              windowId: passage.windowId,
              firstSegment: passage.firstSegment,
              lastSegment: passage.lastSegment,
              startMs: passage.startMs,
              endMs: passage.endMs,
              text: passage.text,
              normalizedText: passage.normalizedText,
              segmentSpans: passage.segmentSpans,
              segmentStartsMs: passage.segmentStartsMs,
            })),
          )
          .returning(['id', 'windowId'])
          .execute();

        const tokens = inserted.flatMap((row) => {
          const passage = replace.passages.find((candidate) => candidate.windowId === row.windowId)!;
          return [...new Set(passage.tokens)].map((token) => ({ passageId: row.id, token }));
        });
        // Chunked: one video can yield tens of thousands of token rows.
        for (let i = 0; i < tokens.length; i += 1000) {
          await tx
            .insertInto('transcript_passage_token')
            .values(tokens.slice(i, i + 1000))
            .execute();
        }
      }

      await tx
        .insertInto('transcript_index_state')
        .values({
          assetId,
          revision: replace.revision,
          runKey: replace.runKey,
          indexVersion: replace.indexVersion,
          coverageState: replace.coverageState,
          segmentCount: replace.segmentCount,
          passageCount: replace.passages.length,
          error: null,
        })
        .onConflict((oc) =>
          oc.column('assetId').doUpdateSet({
            revision: replace.revision,
            runKey: replace.runKey,
            indexVersion: replace.indexVersion,
            coverageState: replace.coverageState,
            segmentCount: replace.segmentCount,
            passageCount: replace.passages.length,
            error: null,
            updatedAt: new Date(),
          }),
        )
        .execute();
    });
  }

  /** Record an indexing failure against the current state without touching passages. */
  async markFailed(assetId: string, runKey: string, indexVersion: number, error: string): Promise<void> {
    await this.db
      .insertInto('transcript_index_state')
      .values({
        assetId,
        revision: '',
        runKey,
        indexVersion,
        coverageState: 'unknown',
        segmentCount: 0,
        passageCount: 0,
        error,
      })
      .onConflict((oc) => oc.column('assetId').doUpdateSet({ runKey, indexVersion, error, updatedAt: new Date() }))
      .execute();
  }

  async deleteAll(assetIds: string[]): Promise<void> {
    if (assetIds.length === 0) {
      return;
    }
    await this.db.deleteFrom('transcript_index_state').where('assetId', 'in', assetIds).execute();
    // Passages/tokens cascade from the index-state row only if FKs say so —
    // they cascade from the ASSET, not from the state row, so delete directly.
    await this.db.deleteFrom('transcript_passage').where('assetId', 'in', assetIds).execute();
  }
}

export interface TranscriptCandidateRow {
  passageId: string;
  assetId: string;
  revision: string;
  runKey: string;
  windowId: string;
  firstSegment: number;
  lastSegment: number;
  startMs: number;
  endMs: number;
  text: string;
  segmentSpans: Array<{ start: number; end: number }>;
  segmentStartsMs: number[];
}

export interface TranscriptMomentRow extends TranscriptCandidateRow {
  runKey: string;
  coverageState: string;
}

/**
Lexical transcript search retrieval. Access filters live IN the candidate
SQL (never applied after a limited fetch), and candidates are returned
UNLIMITED: verification and grouping happen in the service, which must fail
explicitly rather than silently truncate.
*/
@Injectable()
export class TranscriptSearchRepository {
  constructor(@InjectKysely() private db: Kysely<DB>) {}

  /** Exact-token candidates: every query token present (AND semantics) via the GIN full-text index. */
  async searchExactCandidates(filters: AiInterpretAssetFilters, tokens: string[]): Promise<TranscriptCandidateRow[]> {
    const tsquery = tokens.join(' & ');
    const rows = await applyAssetFilters(
      this.db
        .selectFrom('asset')
        .innerJoin('transcript_passage', 'transcript_passage.assetId', 'asset.id')
        .leftJoin('transcript_index_state', 'transcript_index_state.assetId', 'asset.id')
        .select([
          'transcript_passage.id as passageId',
          'transcript_passage.assetId',
          'transcript_passage.revision',
          'transcript_index_state.runKey as runKey',
          'transcript_passage.windowId',
          'transcript_passage.firstSegment',
          'transcript_passage.lastSegment',
          'transcript_passage.startMs',
          'transcript_passage.endMs',
          'transcript_passage.text',
          'transcript_passage.segmentSpans',
          'transcript_passage.segmentStartsMs',
        ])
        .where('asset.type', '=', AssetType.Video)
        .where(
          sql<boolean>`to_tsvector('simple', ${sql.ref('transcript_passage.normalizedText')}) @@ to_tsquery('simple', ${tsquery})`,
        ),
      { ...filters, type: AssetType.Video },
    )
      .withPlugin(new DeduplicateJoinsPlugin())
      .execute();
    return rows as unknown as TranscriptCandidateRow[];
  }

  /**
  Spelling-fallback candidates: per-token trigram similarity against the
  distinct passage-token pool (short transcript tokens, not whole
  transcripts). `thresholds[i]` applies to `tokens[i]`.
  */
  async searchFuzzyCandidates(
    filters: AiInterpretAssetFilters,
    tokens: string[],
    threshold: number,
  ): Promise<TranscriptCandidateRow[]> {
    if (tokens.length === 0) {
      return [];
    }
    // Per-token trigram candidates: the `%` operator drives the GIN trigram
    // index and the explicit similarity() recheck enforces the configured
    // threshold exactly.
    const perToken = tokens.map(
      (token) => sql<boolean>`exists (
        select 1 from transcript_passage_token pt
        where pt."passageId" = transcript_passage.id
          and pt.token % ${token}
          and strict_word_similarity(pt.token, ${token}) >= ${threshold}
      )`,
    );
    const rows = await applyAssetFilters(
      this.db
        .selectFrom('asset')
        .innerJoin('transcript_passage', 'transcript_passage.assetId', 'asset.id')
        .leftJoin('transcript_index_state', 'transcript_index_state.assetId', 'asset.id')
        .select([
          'transcript_passage.id as passageId',
          'transcript_passage.assetId',
          'transcript_passage.revision',
          'transcript_index_state.runKey as runKey',
          'transcript_passage.windowId',
          'transcript_passage.firstSegment',
          'transcript_passage.lastSegment',
          'transcript_passage.startMs',
          'transcript_passage.endMs',
          'transcript_passage.text',
          'transcript_passage.segmentSpans',
          'transcript_passage.segmentStartsMs',
        ])
        .where('asset.type', '=', AssetType.Video)
        .where(sql<boolean>`${sql.join(perToken, sql` or `)}`)
        .distinct(),
      { ...filters, type: AssetType.Video },
    )
      .withPlugin(new DeduplicateJoinsPlugin())
      .execute();
    return rows as unknown as TranscriptCandidateRow[];
  }

  /** Per-pair trigram similarities for fuzzy verification (bounded per-token indexed probes). */
  async searchTokenSimilarities(
    tokens: string[],
    threshold: number,
  ): Promise<Array<{ qtoken: string; token: string; sim: number }>> {
    const rows: Array<{ qtoken: string; token: string; sim: number }> = [];
    for (const qtoken of tokens) {
      const result = await sql`select token, strict_word_similarity(token, ${qtoken}) as sim
        from transcript_passage_token
        where token % ${qtoken} and strict_word_similarity(token, ${qtoken}) >= ${threshold}`.execute(this.db);
      for (const row of result.rows as Array<{ token: string; sim: number }>) {
        rows.push({ qtoken, token: row.token, sim: Number(row.sim) });
      }
    }
    return rows;
  }

  /** Server-side passage resolution for frame delivery (opaque id -> revision + segment start). */
  async getPassage(passageId: string) {
    return await this.db
      .selectFrom('transcript_passage')
      .select(['id', 'assetId', 'revision', 'startMs', 'endMs'])
      .where('id', '=', passageId)
      .executeTakeFirst();
  }

  /** Hydrate page assets with the same columns the other search modes use. */
  async getAssetsByIds(assetIds: string[]) {
    if (assetIds.length === 0) {
      return [];
    }
    return this.db.selectFrom('asset').select(columns.searchAsset).where('asset.id', 'in', assetIds).execute();
  }

  /** Scoped index-coverage counts for the authorized universe (no cross-user leakage). */
  async getScopedCoverage(
    filters: AiInterpretAssetFilters,
    indexVersion: number,
  ): Promise<{
    totalVideos: number;
    indexedVideos: number;
    pendingIndex: number;
    indexErrors: number;
  }> {
    const rows = await applyAssetFilters(
      this.db
        .selectFrom('asset')
        .leftJoin('transcript_index_state', 'transcript_index_state.assetId', 'asset.id')
        .select([
          sql<number>`count(*)::int`.as('totalVideos'),
          sql<number>`count(*) filter (where ${sql.ref('transcript_index_state.assetId')} is not null and ${sql.ref('transcript_index_state.error')} is null and ${sql.ref('transcript_index_state.indexVersion')} = ${indexVersion})::int`.as(
            'indexedVideos',
          ),
          sql<number>`count(*) filter (where ${sql.ref('transcript_index_state.assetId')} is null)::int`.as(
            'pendingIndex',
          ),
          sql<number>`count(*) filter (where ${sql.ref('transcript_index_state.error')} is not null)::int`.as(
            'indexErrors',
          ),
        ])
        .where('asset.type', '=', AssetType.Video),
      { ...filters, type: AssetType.Video },
    )
      .withPlugin(new DeduplicateJoinsPlugin())
      .execute();
    const row = rows[0] as unknown as {
      totalVideos: number;
      indexedVideos: number;
      pendingIndex: number;
      indexErrors: number;
    };
    return {
      totalVideos: row.totalVideos ?? 0,
      indexedVideos: row.indexedVideos ?? 0,
      pendingIndex: row.pendingIndex ?? 0,
      indexErrors: row.indexErrors ?? 0,
    };
  }
}
