import { Injectable } from '@nestjs/common';
import { Kysely, sql } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';
import {
  AiVideoTranscriptionChunk,
  AiVideoTranscriptionCoverageInterval,
  AiVideoTranscriptionDocument,
  AiVideoTranscriptionDocumentSchema,
  AiVideoTranscriptionError,
  AiVideoTranscriptionMetrics,
  AiVideoTranscriptionProducer,
  AiVideoTranscriptionRun,
  AiVideoTranscriptionSegment,
  AiVideoTranscriptionTrigger,
  TranscriptionCoverageCounts,
} from 'src/dtos/ai-video-transcription.dto.js';
import { AssetMetadataKey } from 'src/enum.js';
import { DB } from 'src/schema/index.js';
import { createTranscriptionRevision } from 'src/utils/ai-video-transcription.js';

export type AiVideoTranscriptionClaim =
  | {
      alreadyExists: true;
      runKey: string;
      run: AiVideoTranscriptionRun;
      /** Why the claim was refused: valid completed work, or an active lease. */
      reason: 'completed' | 'active-lease';
    }
  | {
      alreadyExists: false;
      runKey: string;
      run: AiVideoTranscriptionRun;
      /** Completed chunks preserved from an interrupted attempt (resumable work). */
      resumedChunks: number;
    };

/** Worker lease for atomic run exclusion across processes and restarts. */
export interface AiVideoTranscriptionLease {
  ownerId: string;
  leaseMs: number;
}

/** Current on-disk document format; parses accept legacy schemaVersion 1. */
const DOCUMENT_SCHEMA_VERSION = 2 as const;

@Injectable()
export class AiVideoTranscriptionRepository {
  constructor(@InjectKysely() private db: Kysely<DB>) {}

  async get(assetId: string): Promise<AiVideoTranscriptionDocument | null> {
    const row = await this.db
      .selectFrom('asset_metadata')
      .select('value')
      .where('assetId', '=', assetId)
      .where('key', '=', AssetMetadataKey.VideoTranscriptsV1)
      .executeTakeFirst();

    return row ? this.parseDocument(row.value) : null;
  }

  /** Latest run by requestedAt, any status. */
  findLatestRun(document: AiVideoTranscriptionDocument): AiVideoTranscriptionRun | null {
    const runs = Object.values(document.runs);
    if (runs.length === 0) {
      return null;
    }
    let latest = runs[0];
    for (const run of runs) {
      if (run.requestedAt > latest.requestedAt) {
        latest = run;
      }
    }
    return latest;
  }

  /** Latest completed run — the context composer's view. */
  findLatestCompletedRun(document: AiVideoTranscriptionDocument): AiVideoTranscriptionRun | null {
    let latest: AiVideoTranscriptionRun | null = null;
    for (const run of Object.values(document.runs)) {
      if (run.status !== 'completed') {
        continue;
      }
      if (!latest || (run.finishedAt ?? run.requestedAt) > (latest.finishedAt ?? latest.requestedAt)) {
        latest = run;
      }
    }
    return latest;
  }

  /**
  Atomically become the active producer of the run identified by runKey, or
  learn why that is not allowed. Never resets valid completed work. A queued
  run (no lease yet) or a running run whose lease has expired is abandoned
  work and is reclaimed with its durable chunk progress intact; a failed run
  is reclaimed as a retry. Chunked producers pass their producer identity,
  target duration, and pending chunk plan so progress survives interruptions.
  */
  async claim(
    assetId: string,
    identity: {
      runKey: string;
      model: string;
      promptVersion: string;
      config: AiVideoTranscriptionRun['config'];
      durationMs?: number;
      trigger: AiVideoTranscriptionTrigger;
      producer?: AiVideoTranscriptionProducer;
      targetDurationMs?: number;
      chunks?: AiVideoTranscriptionChunk[];
    },
    lease: AiVideoTranscriptionLease,
    requestedAt = new Date(),
  ): Promise<AiVideoTranscriptionClaim> {
    return this.db.transaction().execute(async (tx) => {
      await this.lockFirstInsert(tx, assetId);
      const existing = await this.getLocked(tx, assetId);
      const document = existing ?? { schemaVersion: DOCUMENT_SCHEMA_VERSION, runs: {} };
      const nextLease = {
        ownerId: lease.ownerId,
        expiresAt: new Date(requestedAt.getTime() + lease.leaseMs).toISOString(),
      };
      const current = document.runs[identity.runKey];

      if (current) {
        if (current.status === 'completed') {
          return { alreadyExists: true, runKey: identity.runKey, run: current, reason: 'completed' };
        }
        const leaseLive =
          current.status === 'running' &&
          current.lease !== undefined &&
          Date.parse(current.lease.expiresAt) > requestedAt.getTime();
        if (leaseLive) {
          return { alreadyExists: true, runKey: identity.runKey, run: current, reason: 'active-lease' };
        }

        // Reclaim abandoned or failed work: keep durable chunk progress and
        // segments, refresh attempt metadata, and take the lease.
        const resumedChunks = current.chunks?.filter((chunk) => chunk.status === 'completed').length ?? 0;
        const run: AiVideoTranscriptionRun = {
          ...current,
          status: 'running',
          trigger: identity.trigger,
          startedAt: requestedAt.toISOString(),
          error: undefined,
          lease: nextLease,
          chunks: current.chunks ?? identity.chunks,
        };
        document.runs[identity.runKey] = run;
        document.schemaVersion = DOCUMENT_SCHEMA_VERSION;
        await this.save(tx, assetId, document);
        return { alreadyExists: false, runKey: identity.runKey, run, resumedChunks };
      }

      const run: AiVideoTranscriptionRun = {
        model: identity.model,
        promptVersion: identity.promptVersion,
        status: 'running',
        trigger: identity.trigger,
        requestedAt: requestedAt.toISOString(),
        startedAt: requestedAt.toISOString(),
        config: identity.config,
        durationMs: identity.durationMs,
        segments: [],
        lease: nextLease,
        ...(identity.producer && { producer: identity.producer }),
        ...(identity.targetDurationMs !== undefined && { targetDurationMs: identity.targetDurationMs }),
        ...(identity.chunks && { chunks: identity.chunks }),
      };
      document.runs[identity.runKey] = run;
      document.schemaVersion = DOCUMENT_SCHEMA_VERSION;
      await this.save(tx, assetId, document);
      return { alreadyExists: false, runKey: identity.runKey, run, resumedChunks: 0 };
    });
  }

  /**
  Heartbeat for the active producer: extends the lease while work is in
  flight so long sidecar calls are not stolen. Only the lease owner on a
  running run may renew.
  */
  async renewLease(
    assetId: string,
    runKey: string,
    ownerId: string,
    leaseMs: number,
    now = new Date(),
  ): Promise<boolean> {
    const next = await this.updateRun(assetId, runKey, (run) => {
      if (run.status !== 'running' || run.lease?.ownerId !== ownerId) {
        return;
      }
      return { ...run, lease: { ownerId, expiresAt: new Date(now.getTime() + leaseMs).toISOString() } };
    });
    return next !== null;
  }

  /** Append segments to the active run; completed/failed runs are immutable. */
  async appendSegments(assetId: string, runKey: string, segments: AiVideoTranscriptionSegment[]): Promise<void> {
    await this.updateRun(assetId, runKey, (run) => {
      if (run.status !== 'running') {
        return;
      }
      return { ...run, segments: [...run.segments, ...segments] };
    });
  }

  async complete(
    assetId: string,
    runKey: string,
    options: {
      language?: string;
      languageProbability?: number;
      noAudio?: boolean;
      noSpeech?: boolean;
      truncated?: boolean;
      coverage?: { intervals: AiVideoTranscriptionCoverageInterval[] };
      metrics?: AiVideoTranscriptionMetrics;
    },
    finishedAt = new Date(),
  ): Promise<boolean> {
    const next = await this.updateRun(assetId, runKey, (run) => {
      if (run.status !== 'running') {
        return;
      }
      const updated: AiVideoTranscriptionRun = {
        ...run,
        status: 'completed',
        finishedAt: finishedAt.toISOString(),
        language: options.language ?? run.language,
        languageProbability: options.languageProbability ?? run.languageProbability,
        noAudio: options.noAudio,
        noSpeech: options.noSpeech,
        truncated: options.truncated,
        coverage: options.coverage ?? run.coverage,
        metrics: options.metrics ?? run.metrics,
        error: undefined,
        lease: undefined,
      };
      // Stamp the content revision on every completed run so indexed search
      // data can detect replaced transcripts under the same runKey.
      return { ...updated, revision: createTranscriptionRevision(updated) };
    });
    return next !== null;
  }

  /**
  Durable chunk progress: append one chunk's segments (absolute timestamps),
  mark the chunk completed, and grow the run's covered intervals in the same
  locked update so an interrupted worker resumes from real completed work.
  */
  async completeChunk(
    assetId: string,
    runKey: string,
    chunkIndex: number,
    segments: AiVideoTranscriptionSegment[],
    covered: AiVideoTranscriptionCoverageInterval,
    completedAt = new Date(),
  ): Promise<boolean> {
    const next = await this.updateRun(assetId, runKey, (run) => {
      if (run.status !== 'running' || !run.chunks) {
        return;
      }
      const chunks = run.chunks.map((chunk) =>
        chunk.index === chunkIndex
          ? { ...chunk, status: 'completed' as const, completedAt: completedAt.toISOString(), error: undefined }
          : chunk,
      );
      const intervals = [...(run.coverage?.intervals ?? []), covered];
      return {
        ...run,
        chunks,
        segments: [...run.segments, ...segments],
        coverage: { intervals },
      };
    });
    return next !== null;
  }

  /** Mark one chunk failed with its error; the run stays running for retry. */
  async failChunk(
    assetId: string,
    runKey: string,
    chunkIndex: number,
    error: AiVideoTranscriptionError,
  ): Promise<boolean> {
    const next = await this.updateRun(assetId, runKey, (run) => {
      if (run.status !== 'running' || !run.chunks) {
        return;
      }
      return {
        ...run,
        chunks: run.chunks.map((chunk) =>
          chunk.index === chunkIndex ? { ...chunk, status: 'failed' as const, error } : chunk,
        ),
      };
    });
    return next !== null;
  }

  async fail(
    assetId: string,
    runKey: string,
    error: AiVideoTranscriptionError,
    finishedAt = new Date(),
  ): Promise<void> {
    await this.updateRun(assetId, runKey, (run) => {
      if (run.status === 'completed' || run.status === 'failed') {
        return;
      }
      return { ...run, status: 'failed', finishedAt: finishedAt.toISOString(), error, lease: undefined };
    });
  }

  private async updateRun(
    assetId: string,
    runKey: string,
    update: (run: AiVideoTranscriptionRun) => AiVideoTranscriptionRun | undefined,
  ): Promise<AiVideoTranscriptionRun | null> {
    return this.db.transaction().execute(async (tx) => {
      const document = await this.getLocked(tx, assetId);
      const current = document?.runs[runKey];
      if (!document || !current) {
        return null;
      }

      const next = update(current);
      if (!next) {
        return null;
      }

      document.runs[runKey] = next;
      document.schemaVersion = DOCUMENT_SCHEMA_VERSION;
      await this.save(tx, assetId, document);
      return next;
    });
  }

  private async lockFirstInsert(tx: Kysely<DB>, assetId: string): Promise<void> {
    await sql`SELECT pg_advisory_xact_lock(hashtextextended(${`${assetId}:${AssetMetadataKey.VideoTranscriptsV1}`}, 0))`.execute(
      tx,
    );
  }

  private getLocked(tx: Kysely<DB>, assetId: string) {
    return tx
      .selectFrom('asset_metadata')
      .select('value')
      .where('assetId', '=', assetId)
      .where('key', '=', AssetMetadataKey.VideoTranscriptsV1)
      .forUpdate()
      .executeTakeFirst()
      .then((row) => (row ? this.parseDocument(row.value) : null));
  }

  private async save(tx: Kysely<DB>, assetId: string, document: AiVideoTranscriptionDocument): Promise<void> {
    // Lazy migration: legacy schemaVersion 1 documents upgrade to the current
    // format the first time any writer touches them.
    const normalized =
      document.schemaVersion === DOCUMENT_SCHEMA_VERSION
        ? document
        : { ...document, schemaVersion: DOCUMENT_SCHEMA_VERSION };
    await tx
      .insertInto('asset_metadata')
      .values({ assetId, key: AssetMetadataKey.VideoTranscriptsV1, value: normalized })
      .onConflict((oc) => oc.columns(['assetId', 'key']).doUpdateSet((eb) => ({ value: eb.ref('excluded.value') })))
      .execute();
  }

  private parseDocument(value: unknown): AiVideoTranscriptionDocument {
    return AiVideoTranscriptionDocumentSchema.parse(value);
  }

  /**
  Admin coverage totals over every non-deleted video, classified in SQL with
  the same precedence as `classifyTranscriptionRun` (status → noAudio →
  noSpeech → truncated → coverage-vs-target). Coverage completeness uses the
  min-start / max-end approximation of the union check; scheduling decisions
  still use the exact TypeScript rule.
  */
  async getCoverageCounts(
    currentRunKey: string,
    legacyRunKey: string,
    indexVersion: number,
  ): Promise<TranscriptionCoverageCounts> {
    const { rows } = await sql`
      with documents as (
        select
          a.id as asset_id,
          coalesce(m.value -> 'runs' -> ${currentRunKey}, null) as current_run,
          coalesce(m.value -> 'runs' -> ${legacyRunKey}, null) as legacy_run,
          s.error as index_error,
          s.indexVersion as index_version,
          s.revision as index_revision
        from asset a
        left join asset_metadata m on m."assetId" = a.id and m.key = ${AssetMetadataKey.VideoTranscriptsV1}
        left join transcript_index_state s on s."assetId" = a.id
        where a.type = 'VIDEO' and a."deletedAt" is null
      ),
      states as (
        select
          case
            when current_run is not null then
              case
                when current_run ->> 'status' in ('queued', 'running') then 'in-progress'
                when current_run ->> 'status' = 'failed' then 'failed'
                when current_run ->> 'noAudio' = 'true' then 'no-audio'
                when current_run ->> 'noSpeech' = 'true' then 'no-speech'
                when current_run ->> 'truncated' = 'true' then 'partial'
                when current_run -> 'coverage' -> 'intervals' is not null
                     and jsonb_array_length(current_run -> 'coverage' -> 'intervals') > 0
                     and current_run ->> 'targetDurationMs' is not null
                     and (select max((i ->> 'endMs')::bigint) from jsonb_array_elements(current_run -> 'coverage' -> 'intervals') i)
                           >= (current_run ->> 'targetDurationMs')::bigint - 1000
                     and (select min((i ->> 'startMs')::bigint) from jsonb_array_elements(current_run -> 'coverage' -> 'intervals') i)
                           <= 1000
                  then 'complete'
                else 'partial'
              end
            when legacy_run is not null then
              case
                when legacy_run ->> 'status' in ('queued', 'running') then 'in-progress'
                when legacy_run ->> 'status' = 'failed' then 'failed'
                when legacy_run ->> 'noAudio' = 'true' then 'partial'
                when legacy_run ->> 'noSpeech' = 'true' then 'no-speech'
                when legacy_run ->> 'truncated' = 'true' then 'partial'
                else 'complete'
              end
            else 'missing'
          end as state,
          index_error,
          index_version,
          index_revision,
          current_run
        from documents
      ),
      indexed as (
        -- Index-side classification (separate lifecycle from transcription):
        -- failed rows surface the error; current rows have no error, the
        -- running index version, and (for chunked runs) a revision equal to
        -- the source document's. Legacy-only documents cannot recompute
        -- their revision in SQL — their version match counts as current,
        -- and the TS reconcile sweep does the exact revision check.
        select
          state,
          case
            when index_error is not null then 'failed'
            -- Only videos with a usable completed transcript have an index
            -- expectation; missing/failed/in-progress transcription has none.
            when state in ('complete', 'partial', 'no-audio', 'no-speech') and index_version is null then 'pending'
            when state in ('complete', 'partial', 'no-audio', 'no-speech')
                 and index_version = ${indexVersion}
                 and (current_run ->> 'revision' is null or index_revision = current_run ->> 'revision')
              then 'current'
            when state in ('complete', 'partial', 'no-audio', 'no-speech') then 'pending'
            else 'none'
          end as index_state
        from states
      )
      select
        count(*) filter (where state = 'missing')::int as "missing",
        count(*) filter (where state = 'in-progress')::int as "inProgress",
        count(*) filter (where state = 'failed')::int as "failed",
        count(*) filter (where state = 'partial')::int as "partial",
        count(*) filter (where state = 'complete')::int as "complete",
        count(*) filter (where state = 'no-audio')::int as "noAudio",
        count(*) filter (where state = 'no-speech')::int as "noSpeech",
        count(*) filter (where index_state = 'current')::int as "indexCurrent",
        count(*) filter (where index_state = 'pending')::int as "indexPending",
        count(*) filter (where index_state = 'failed')::int as "indexFailed"
      from indexed
    `.execute(this.db);
    const row = rows[0] as Record<string, number | null>;
    return {
      missing: row['missing'] ?? 0,
      inProgress: row['inProgress'] ?? 0,
      failed: row['failed'] ?? 0,
      partial: row['partial'] ?? 0,
      complete: row['complete'] ?? 0,
      noAudio: row['noAudio'] ?? 0,
      noSpeech: row['noSpeech'] ?? 0,
      indexCurrent: row['indexCurrent'] ?? 0,
      indexPending: row['indexPending'] ?? 0,
      indexFailed: row['indexFailed'] ?? 0,
    };
  }
}
