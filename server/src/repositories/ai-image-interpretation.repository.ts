import { Injectable } from '@nestjs/common';
import { Kysely, sql } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';
import {
  AiInterpretationDocument,
  AiInterpretationDocumentSchema,
  AiInterpretationError,
  AiInterpretationInput,
  AiInterpretationMetrics,
  AiInterpretationRun,
  MuseInterpretationResult,
} from 'src/dtos/ai-image-interpretation.dto';
import { AssetMetadataKey } from 'src/enum';
import { DB } from 'src/schema';
import { createAiInterpretationRunKey, interpretationRetryDelayMs } from 'src/utils/ai-image-interpretation';

export type AiInterpretationIdentity = {
  model: string;
  quant: string;
  promptVersion: string;
};

export type AiInterpretationClaim =
  | { alreadyExists: true; runKey: string; run: AiInterpretationRun }
  | { alreadyExists: false; runKey: string; run: AiInterpretationRun };

@Injectable()
export class AiImageInterpretationRepository {
  constructor(@InjectKysely() private db: Kysely<DB>) {}

  async get(assetId: string): Promise<AiInterpretationDocument | null> {
    const row = await this.db
      .selectFrom('asset_metadata')
      .select('value')
      .where('assetId', '=', assetId)
      .where('key', '=', AssetMetadataKey.AiInterpretationV1)
      .executeTakeFirst();

    return row ? this.parseDocument(row.value) : null;
  }

  async claim(
    assetId: string,
    identity: AiInterpretationIdentity,
    requestedAt = new Date(),
  ): Promise<AiInterpretationClaim> {
    const runKey = createAiInterpretationRunKey(identity.model, identity.quant, identity.promptVersion);
    const run: AiInterpretationRun = {
      ...identity,
      status: 'queued',
      trigger: 'upload',
      requestedAt: requestedAt.toISOString(),
    };

    return this.db.transaction().execute(async (tx) => {
      await this.lockFirstInsert(tx, assetId);
      const existing = await this.getLocked(tx, assetId);
      const document = existing ?? { schemaVersion: 1 as const, runs: {} };
      const existingRun = document.runs[runKey];
      if (existingRun) {
        // A failed run never blocks a new trigger: the claim resets it to
        // `queued` (preserving the attempt history) so manual interpretations
        // and upload-driven retries stay possible. Queued, running, and
        // completed runs remain single-delivery.
        if (existingRun.status !== 'failed') {
          return { alreadyExists: true, runKey, run: existingRun };
        }

        const requeued: AiInterpretationRun = {
          ...existingRun,
          status: 'queued',
          requestedAt: requestedAt.toISOString(),
          startedAt: undefined,
          nextAttemptAt: undefined,
        };
        document.runs[runKey] = requeued;
        await this.save(tx, assetId, document);
        return { alreadyExists: false, runKey, run: requeued };
      }

      document.runs[runKey] = run;
      await this.save(tx, assetId, document);
      return { alreadyExists: false, runKey, run };
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

  async complete(
    assetId: string,
    runKey: string,
    input: AiInterpretationInput,
    result: MuseInterpretationResult,
    metrics: AiInterpretationMetrics,
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
        input,
        result,
        metrics,
        error: undefined,
        nextAttemptAt: undefined,
      };
    });
    return next !== null;
  }

  async fail(
    assetId: string,
    runKey: string,
    error: AiInterpretationError,
    metrics?: AiInterpretationMetrics,
    input?: AiInterpretationInput,
    finishedAt = new Date(),
  ): Promise<AiInterpretationRun | null> {
    return this.updateRun(assetId, runKey, (run) => {
      if (run.status === 'completed' || run.status === 'failed') {
        return;
      }

      const attempts = (run.attempts ?? 0) + 1;
      return {
        ...run,
        status: 'failed',
        finishedAt: finishedAt.toISOString(),
        input,
        error,
        metrics,
        result: undefined,
        attempts,
        nextAttemptAt: new Date(finishedAt.getTime() + interpretationRetryDelayMs(attempts)).toISOString(),
      };
    });
  }

  async requeue(assetId: string, runKey: string, requestedAt = new Date()): Promise<boolean> {
    const next = await this.updateRun(assetId, runKey, (run) => {
      if (run.status !== 'failed') {
        return;
      }

      return {
        ...run,
        status: 'queued',
        requestedAt: requestedAt.toISOString(),
        startedAt: undefined,
        nextAttemptAt: undefined,
      };
    });
    return next !== null;
  }

  async findDueRetries(cutoff: Date): Promise<Array<{ assetId: string; runKey: string }>> {
    const rows = await this.db
      .selectFrom('asset_metadata')
      .select(['assetId', 'value'])
      .where('key', '=', AssetMetadataKey.AiInterpretationV1)
      .execute();

    const due: Array<{ assetId: string; runKey: string }> = [];
    for (const row of rows) {
      const document = this.parseDocument(row.value);
      for (const [runKey, run] of Object.entries(document.runs)) {
        if (run.status === 'failed' && run.nextAttemptAt && new Date(run.nextAttemptAt) <= cutoff) {
          due.push({ assetId: row.assetId, runKey });
        }
      }
    }

    return due;
  }

  async failStale(
    runningCutoff: Date,
    hasPendingJob: (assetId: string, runKey: string) => Promise<boolean>,
    finishedAt = new Date(),
  ): Promise<number> {
    const rows = await this.db
      .selectFrom('asset_metadata')
      .select(['assetId', 'value'])
      .where('key', '=', AssetMetadataKey.AiInterpretationV1)
      .execute();

    let count = 0;
    for (const row of rows) {
      const document = this.parseDocument(row.value);
      for (const [runKey, run] of Object.entries(document.runs)) {
        // Running runs hang only when the worker died mid-inference. Queued
        // runs legitimately wait behind a busy queue however long the backlog
        // takes, so they are only failed once their BullMQ job is actually
        // gone (e.g. queue state wiped) — nothing else would ever deliver them.
        const isStale = run.status === 'running' && new Date(run.startedAt ?? run.requestedAt) < runningCutoff;
        const isOrphaned = !isStale && run.status === 'queued' && !(await hasPendingJob(row.assetId, runKey));
        if (isStale || isOrphaned) {
          const updated = await this.fail(
            row.assetId,
            runKey,
            isStale
              ? { code: 'stale_run', message: 'Interpretation run expired before completion' }
              : { code: 'job_lost', message: 'Interpretation job was lost before delivery' },
            undefined,
            undefined,
            finishedAt,
          );
          count += updated ? 1 : 0;
        }
      }
    }

    return count;
  }

  private async updateRun(
    assetId: string,
    runKey: string,
    update: (run: AiInterpretationRun) => AiInterpretationRun | undefined,
  ): Promise<AiInterpretationRun | null> {
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
    await sql`SELECT pg_advisory_xact_lock(hashtextextended(${`${assetId}:${AssetMetadataKey.AiInterpretationV1}`}, 0))`.execute(
      tx,
    );
  }

  private getLocked(tx: Kysely<DB>, assetId: string) {
    return tx
      .selectFrom('asset_metadata')
      .select('value')
      .where('assetId', '=', assetId)
      .where('key', '=', AssetMetadataKey.AiInterpretationV1)
      .forUpdate()
      .executeTakeFirst()
      .then((row) => (row ? this.parseDocument(row.value) : null));
  }

  private async save(tx: Kysely<DB>, assetId: string, document: AiInterpretationDocument): Promise<void> {
    await tx
      .insertInto('asset_metadata')
      .values({ assetId, key: AssetMetadataKey.AiInterpretationV1, value: document })
      .onConflict((oc) => oc.columns(['assetId', 'key']).doUpdateSet((eb) => ({ value: eb.ref('excluded.value') })))
      .execute();
  }

  private parseDocument(value: unknown): AiInterpretationDocument {
    return AiInterpretationDocumentSchema.parse(value);
  }
}
