import { Injectable } from '@nestjs/common';
import { Kysely, sql } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';
import {
  AiAudioEvent,
  AiAudioEventsDocument,
  AiAudioEventsDocumentSchema,
  AiAudioEventsError,
  AiAudioEventsMetrics,
  AiAudioEventsRun,
  AiAudioEventsTrigger,
} from 'src/dtos/ai-audio-events.dto.js';
import { AssetMetadataKey } from 'src/enum.js';
import { DB } from 'src/schema/index.js';

@Injectable()
export class AiAudioEventsRepository {
  constructor(@InjectKysely() private db: Kysely<DB>) {}

  async get(assetId: string): Promise<AiAudioEventsDocument | null> {
    const row = await this.db
      .selectFrom('asset_metadata')
      .select('value')
      .where('assetId', '=', assetId)
      .where('key', '=', AssetMetadataKey.VideoAudioEventsV1)
      .executeTakeFirst();

    return row ? this.parseDocument(row.value) : null;
  }

  /** Latest completed run — the context composer's view. */
  findLatestCompletedRun(document: AiAudioEventsDocument): AiAudioEventsRun | null {
    let latest: AiAudioEventsRun | null = null;
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
  Claim (creating or resetting) the run identified by runKey, mirroring the
  transcription repository: any previous status resets, so callers must check
  the current run status first when they only want a missing run filled in.
  */
  async claim(
    assetId: string,
    identity: {
      runKey: string;
      model: string;
      promptVersion: string;
      config: AiAudioEventsRun['config'];
      durationMs?: number;
      trigger: AiAudioEventsTrigger;
    },
    requestedAt = new Date(),
  ): Promise<AiAudioEventsRun> {
    return this.db.transaction().execute(async (tx) => {
      await this.lockFirstInsert(tx, assetId);
      const document = (await this.getLocked(tx, assetId)) ?? { schemaVersion: 1 as const, runs: {} };
      const run: AiAudioEventsRun = {
        model: identity.model,
        promptVersion: identity.promptVersion,
        status: 'queued',
        trigger: identity.trigger,
        requestedAt: requestedAt.toISOString(),
        config: identity.config,
        durationMs: identity.durationMs,
        events: [],
      };
      document.runs[identity.runKey] = run;
      await this.save(tx, assetId, document);
      return run;
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

  async appendEvents(assetId: string, runKey: string, events: AiAudioEvent[]): Promise<void> {
    await this.updateRun(assetId, runKey, (run) => ({ ...run, events: [...run.events, ...events] }));
  }

  async complete(
    assetId: string,
    runKey: string,
    options: {
      noAudio?: boolean;
      truncated?: boolean;
      speechSuppressed?: boolean;
      metrics?: AiAudioEventsMetrics;
    },
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
        noAudio: options.noAudio,
        truncated: options.truncated,
        speechSuppressed: options.speechSuppressed,
        metrics: options.metrics ?? run.metrics,
        error: undefined,
      };
    });
    return next !== null;
  }

  async fail(assetId: string, runKey: string, error: AiAudioEventsError, finishedAt = new Date()): Promise<void> {
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
    update: (run: AiAudioEventsRun) => AiAudioEventsRun | undefined,
  ): Promise<AiAudioEventsRun | null> {
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
    await sql`SELECT pg_advisory_xact_lock(hashtextextended(${`${assetId}:${AssetMetadataKey.VideoAudioEventsV1}`}, 0))`.execute(
      tx,
    );
  }

  private getLocked(tx: Kysely<DB>, assetId: string) {
    return tx
      .selectFrom('asset_metadata')
      .select('value')
      .where('assetId', '=', assetId)
      .where('key', '=', AssetMetadataKey.VideoAudioEventsV1)
      .forUpdate()
      .executeTakeFirst()
      .then((row) => (row ? this.parseDocument(row.value) : null));
  }

  private async save(tx: Kysely<DB>, assetId: string, document: AiAudioEventsDocument): Promise<void> {
    await tx
      .insertInto('asset_metadata')
      .values({ assetId, key: AssetMetadataKey.VideoAudioEventsV1, value: document })
      .onConflict((oc) => oc.columns(['assetId', 'key']).doUpdateSet((eb) => ({ value: eb.ref('excluded.value') })))
      .execute();
  }

  private parseDocument(value: unknown): AiAudioEventsDocument {
    return AiAudioEventsDocumentSchema.parse(value);
  }
}
