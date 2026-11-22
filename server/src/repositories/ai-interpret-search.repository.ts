import { Injectable } from '@nestjs/common';
import { DeduplicateJoinsPlugin, Kysely, RawBuilder, SelectQueryBuilder, sql } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';
import { columns } from 'src/database.js';
import { DummyValue, GenerateSql } from 'src/decorators.js';
import { AssetMetadataKey, AssetType, AssetVisibility } from 'src/enum.js';
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
Asset-level filters shared by both search branches. Semantics match
searchAssetBuilderLegacy: `undefined` means unfiltered, `null` (where
allowed) means an explicit "is null" (absent) filter.
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

export interface AiInterpretExactTokenSearch extends AiInterpretAssetFilters {
  /** Raw query, carried for provenance/logging; the probes operate on tokens. */
  q: string;
  /** Normalized (lowercased, diacritic-stripped) query tokens, in order. */
  tokens: string[];
}

export interface AiInterpretBranchRow {
  assetId: string;
  distance: number;
}

/**
Exact-token branch result. `matchTier` is 2 when the whole query appears as a
contiguous word-bounded sequence in the normalized document, 1 when every
query token appears as a complete word (noncontiguous allowed).
*/
export interface AiInterpretExactTokenRow {
  assetId: string;
  /** 2 = whole query contiguous word-bounded; 1 = every token word-bounded. */
  matchTier: number;
}

/**
vchordrq probes for the dense branch. vchordrq clamps the value to the index's
list count (currently 512 for this table), so this always probes every list:
the ordered index scan stays an exact kNN while keeping its early exit at the
candidate window (44-79ms p50 vs 1.5-3.2s for the exact parallel seq scan the
planner used before). Partial probing was benchmarked and rejected: at 24 of
512 lists recall@100 was 31-88% against an exact sequential scan, which is
below the floor the search quality requires. Keep this >= the index list count
if the table ever grows past a reindex threshold.
*/
const AI_INTERPRET_DENSE_PROBES = 65_536;

/**
Upper bound per tier on exact-token matches. A tier whose matches exceed this
is treated as over-selective: its candidates would flood the fusion window and
push every partial match down, so the tier is dropped instead. Probes fetch
one extra row (MAX_EXACT_TIER_MATCHES + 1) to distinguish "at the bound" from
"beyond it".
*/
export const MAX_EXACT_TIER_MATCHES = 100;

/** Tokens shorter than this cannot extract trigrams, so they cannot prefilter via the GIN trigram index. */
export const TRIGRAM_MIN_TOKEN_LENGTH = 3;

/**
Applies the shared asset-level filters to a query whose driving table is
`asset` (with `ai_interpret_search` joined). Multiple exif filters each add
their own join, so the caller must attach the join-deduplication plugin.
Shared with the transcript search (transcription results obey the same
authorization semantics).
*/
export function applyAssetFilters<O>(
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
  Pages through assets that have at least one completed AI interpretation
  run, ordered by assetId for keyset pagination. Returns the raw metadata
  document so the caller can pick the latest completed run itself.
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
  Dense branch: cosine kNN over indexed interpretations, restricted to the
  caller's asset universe and the configured minimum cosine similarity.
  Returns the top `limit` rows ordered best-match first.

  The inner query orders by the bare distance expression so the planner uses
  the vchordrq ordered index scan (with exhaustive probing this yields the
  exact nearest neighbors, exiting at `limit` rows). The deterministic assetId
  tie-break and the similarity floor are applied to that window afterwards:
  floor-passing rows always outrank sub-floor rows in distance order, so the
  result set equals a full exact scan's.
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
    const distance = sql<number>`ai_interpret_search.embedding <=> ${embedding}`;
    return this.db.transaction().execute(async (trx) => {
      await sql`set local vchordrq.probes = ${sql.lit(AI_INTERPRET_DENSE_PROBES)}`.execute(trx);
      return trx
        .withPlugin(new DeduplicateJoinsPlugin())
        .selectFrom((eb) =>
          applyAssetFilters(
            eb
              .selectFrom('asset')
              .innerJoin('ai_interpret_search', 'asset.id', 'ai_interpret_search.assetId')
              .select(['ai_interpret_search.assetId', distance.as('distance')]),
            filters,
          )
            .orderBy(distance, 'asc')
            .limit(limit)
            .as('knn'),
        )
        .select(['knn.assetId', 'knn.distance'])
        .where(() => sql`1 - knn.distance >= ${minScore}`)
        .orderBy('knn.distance', 'asc')
        .orderBy(sql`"knn"."assetId"`, 'asc')
        .limit(limit)
        .execute();
    });
  }

  /**
  Lexical branch: pg_trgm strict word similarity over the curated text,
  ranked best-match first via the word similarity distance operator.
  Returns the top `limit` rows ordered best-match first.
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

  /**
  Exact-token branch: bounded candidate stages over the tokenized lexical
  document, classified without trigram similarity — the document is a
  single-space-joined token stream (see buildAiInterpretLexicalDoc), so
  space-padded strpos() checks are deterministic word-boundary and
  contiguous-phrase tests, and both sides are normalized with
  lower(f_unaccent(...)) so tokenization matches Postgres's unaccent table.

  Stage 1 (tier 2): the complete query-token sequence, in order, as one
  contiguous run of words. Stage 2 (tier 1): every query token as a complete
  word (tokens deduplicated for membership), excluding stage-1 matches.
  Each stage probes with LIMIT MAX_EXACT_TIER_MATCHES + 1 and no ordering —
  a cheap eligibility check with early exit. If a stage over-selects, its
  candidates would flood the fusion window and suppress rarer matches, so:
  more than MAX_EXACT_TIER_MATCHES tier-2 matches skip the entire branch
  (two-branch behavior), more than MAX_EXACT_TIER_MATCHES tier-1 matches drop
  tier 1 while keeping tier 2.

  Candidates are prefiltered through the GIN trigram index with per-token
  ILIKE (a complete-word occurrence is always a substring occurrence, so no
  exact match is lost; tokens shorter than TRIGRAM_MIN_TOKEN_LENGTH cannot
  extract trigrams and are verified but cannot prefilter). ILIKE patterns
  carry the TS-normalized token; the authoritative strpos verification
  re-normalizes both sides in Postgres, so exotic non-decomposable characters
  can at worst miss the boost, never produce a wrong match.

  The probes stay unordered so Postgres can exit at the probe limit; the
  returned rows are sorted in memory (tier first, then assetId) so fusion
  ranks stay deterministic.
  */
  @GenerateSql({
    params: [
      {
        q: DummyValue.STRING,
        tokens: [DummyValue.STRING],
        userIds: [DummyValue.UUID],
        visibility: 'not-locked',
        takenBefore: DummyValue.DATE,
        type: AssetType.Image,
      },
    ],
  })
  async searchExactToken({
    q: _q,
    tokens,
    ...filters
  }: AiInterpretExactTokenSearch): Promise<AiInterpretExactTokenRow[]> {
    const prefilterTokens = tokens.filter((token) => token.length >= TRIGRAM_MIN_TOKEN_LENGTH);
    // Without an indexable token the word-boundary verification would scan the
    // whole table; callers keep the two-branch behavior instead.
    if (prefilterTokens.length === 0) {
      return [];
    }

    // Space-padded haystack and needles turn strpos into exact word-boundary
    // checks against the single-space-joined token stream. The ILIKE prefilter
    // deliberately wraps the bare indexed expression (no padding, no lower) so
    // it matches the GIN trigram index exactly; padding it would silently drop
    // the plan back to a sequential scan.
    const indexedDoc = sql`f_unaccent(ai_interpret_search.text)`;
    const haystack = sql`' ' || lower(${indexedDoc}) || ' '`;
    const needle = (text: string) => sql`' ' || lower(f_unaccent(${text})) || ' '`;
    // Tier 2 keeps the original token order and repetitions verbatim.
    const phrase = tokens.join(' ');
    const isTier2 = sql<boolean>`strpos(${haystack}, ${needle(phrase)}) > 0`;
    // Tier 1 membership only needs each distinct token present as a word.
    const tokenMembership = [...new Set(tokens)].map((token) => sql<boolean>`strpos(${haystack}, ${needle(token)}) > 0`);

    const probe = async (verification: RawBuilder<boolean>): Promise<string[]> => {
      let qb = applyAssetFilters(
        this.db
          .withPlugin(new DeduplicateJoinsPlugin())
          .selectFrom('asset')
          .innerJoin('ai_interpret_search', 'asset.id', 'ai_interpret_search.assetId')
          .select(['ai_interpret_search.assetId']),
        filters,
      );
      for (const token of prefilterTokens) {
        qb = qb.where(() => sql`${indexedDoc} ilike ${`%${token}%`}`);
      }
      qb = qb.where(() => verification);
      const rows = await qb.limit(MAX_EXACT_TIER_MATCHES + 1).execute();
      return rows.map((row) => row.assetId);
    };

    const tier2Ids = await probe(isTier2);
    // A common contiguous phrase (e.g. a stock phrase many receipts share)
    // must not flood the window: skip the whole branch.
    if (tier2Ids.length > MAX_EXACT_TIER_MATCHES) {
      return [];
    }

    const tier1Ids = await probe(sql`not (${isTier2}) and ${sql.join(tokenMembership, sql` and `)}`);
    // Common noncontiguous word pairs are handled by the lexical branch;
    // only a bounded tier-1 set earns a fusion slot.
    const boundedTier1 = tier1Ids.length > MAX_EXACT_TIER_MATCHES ? [] : tier1Ids;

    return [
      ...tier2Ids.map((assetId) => ({ assetId, matchTier: 2 })),
      ...boundedTier1.map((assetId) => ({ assetId, matchTier: 1 })),
    ].sort((a, b) => b.matchTier - a.matchTier || (a.assetId < b.assetId ? -1 : 1));
  }

  async getAssetsByIds(assetIds: string[]) {
    if (assetIds.length === 0) {
      return [];
    }

    return this.db.selectFrom('asset').select(columns.searchAsset).where('asset.id', 'in', assetIds).execute();
  }
}
