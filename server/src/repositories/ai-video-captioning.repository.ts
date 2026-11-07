import { Injectable } from '@nestjs/common';
import { Kysely, sql } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';
import {
  AiVideoCaptionDocument,
  AiVideoCaptionDocumentSchema,
  AiVideoCaptionError,
  AiVideoCaptionMetrics,
  AiVideoCaptionRun,
  AiVideoCaptionSegment,
  AiVideoCaptionTrigger,
} from 'src/dtos/ai-video-captioning.dto.js';
import { AssetMetadataKey } from 'src/enum.js';
import { DB } from 'src/schema/index.js';

export type AiVideoCaptionClaim =
  | { alreadyExists: true; runKey: string; run: AiVideoCaptionRun }
  | { alreadyExists: false; runKey: string; run: AiVideoCaptionRun };

@Injectable()
export class AiVideoCaptioningRepository {
  constructor(@InjectKysely() private db: Kysely<DB>) {}

  async get(assetId: string): Promise<AiVideoCaptionDocument | null> {
    const row = await this.db
      .selectFrom('asset_metadata')
      .select('value')
      .where('assetId', '=', assetId)
      .where('key', '=', AssetMetadataKey.VideoCaptionsV1)
      .executeTakeFirst();

    return row ? this.parseDocument(row.value) : null;
  }

  /** Latest run by requestedAt, any status — the sidebar's primary view. */
  findLatestRun(document: AiVideoCaptionDocument): AiVideoCaptionRun | null {
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

  /** Latest completed run, for the overlay. */
  findLatestCompletedRun(document: AiVideoCaptionDocument): AiVideoCaptionRun | null {
    let latest: AiVideoCaptionRun | null = null;
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
  Claim (creating or resetting) the run identified by runKey. Unlike
  interpretation, any previous status — failed, queued, running, completed —
  resets, so re-running the menu action re-captions with the same config and
  changing config keys starts a new run. Callers must check the current run
  status first when they only want a missing run filled in.
  */
  async claim(
    assetId: string,
    identity: {
      runKey: string;
      model: string;
      promptVersion: string;
      config: AiVideoCaptionRun['config'];
      durationMs?: number;
      trigger: AiVideoCaptionTrigger;
    },
    requestedAt = new Date(),
  ): Promise<AiVideoCaptionClaim> {
    return this.db.transaction().execute(async (tx) => {
      await this.lockFirstInsert(tx, assetId);
      const existing = await this.getLocked(tx, assetId);
      const document = existing ?? { schemaVersion: 1 as const, runs: {} };
      const run: AiVideoCaptionRun = {
        model: identity.model,
        promptVersion: identity.promptVersion,
        status: 'queued',
        trigger: identity.trigger,
        requestedAt: requestedAt.toISOString(),
        config: identity.config,
        durationMs: identity.durationMs,
        segments: [],
      };
      document.runs[identity.runKey] = run;
      await this.save(tx, assetId, document);
      return { alreadyExists: false, runKey: identity.runKey, run };
    });
  }

  async transitionToRunning(assetId: string, runKey: string, startedAt = new Date()): Promise<boolean> {
    const next = await this.updateRun(assetId, runKey, (run) => {
      if (run.status !== 'queued') {
        return;
      }
      return { ...run, status: 'running', startedAt: startedAt.toISOString() };
    });
    return next !== null;
  }

  /** Persist segments incrementally as each per-segment caption returns. */
  async appendSegments(assetId: string, runKey: string, segments: AiVideoCaptionSegment[]): Promise<void> {
    await this.updateRun(assetId, runKey, (run) => ({ ...run, segments: [...run.segments, ...segments] }));
  }

  async complete(
    assetId: string,
    runKey: string,
    options: { servedModel?: string; truncated?: boolean; metrics?: AiVideoCaptionMetrics },
    finishedAt = new Date(),
  ): Promise<boolean> {
    const next = await this.updateRun(assetId, runKey, (run) => {
      if (run.status !== 'running') {
        return;
      }
      return {
        ...run,
        status: 'completed',
        finishedAt: finishedAt.toISOString(),
        servedModel: options.servedModel,
        truncated: options.truncated,
        metrics: options.metrics ?? run.metrics,
        error: undefined,
      };
    });
    return next !== null;
  }

  async fail(assetId: string, runKey: string, error: AiVideoCaptionError, finishedAt = new Date()): Promise<void> {
    await this.updateRun(assetId, runKey, (run) => {
      if (run.status === 'completed' || run.status === 'failed') {
        return;
      }
      return { ...run, status: 'failed', finishedAt: finishedAt.toISOString(), error };
    });
  }

  private async updateRun(
    assetId: string,
    runKey: string,
    update: (run: AiVideoCaptionRun) => AiVideoCaptionRun | undefined,
  ): Promise<AiVideoCaptionRun | null> {
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
      await this.save(tx, assetId, document);
      return next;
    });
  }

  private async lockFirstInsert(tx: Kysely<DB>, assetId: string): Promise<void> {
    await sql`SELECT pg_advisory_xact_lock(hashtextextended(${`${assetId}:${AssetMetadataKey.VideoCaptionsV1}`}, 0))`.execute(
      tx,
    );
  }

  private getLocked(tx: Kysely<DB>, assetId: string) {
    return tx
      .selectFrom('asset_metadata')
      .select('value')
      .where('assetId', '=', assetId)
      .where('key', '=', AssetMetadataKey.VideoCaptionsV1)
      .forUpdate()
      .executeTakeFirst()
      .then((row) => (row ? this.parseDocument(row.value) : null));
  }

  private async save(tx: Kysely<DB>, assetId: string, document: AiVideoCaptionDocument): Promise<void> {
    await tx
      .insertInto('asset_metadata')
      .values({ assetId, key: AssetMetadataKey.VideoCaptionsV1, value: document })
      .onConflict((oc) => oc.columns(['assetId', 'key']).doUpdateSet((eb) => ({ value: eb.ref('excluded.value') })))
      .execute();
  }

  private parseDocument(value: unknown): AiVideoCaptionDocument {
    return AiVideoCaptionDocumentSchema.parse(value);
  }
}
