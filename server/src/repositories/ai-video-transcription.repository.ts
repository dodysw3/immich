import { Injectable } from '@nestjs/common';
import { Kysely, sql } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';
import {
  AiVideoTranscriptionDocument,
  AiVideoTranscriptionDocumentSchema,
  AiVideoTranscriptionError,
  AiVideoTranscriptionMetrics,
  AiVideoTranscriptionRun,
  AiVideoTranscriptionSegment,
  AiVideoTranscriptionTrigger,
} from 'src/dtos/ai-video-transcription.dto.js';
import { AssetMetadataKey } from 'src/enum.js';
import { DB } from 'src/schema/index.js';

export type AiVideoTranscriptionClaim =
  | { alreadyExists: true; runKey: string; run: AiVideoTranscriptionRun }
  | { alreadyExists: false; runKey: string; run: AiVideoTranscriptionRun };

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
  Claim (creating or resetting) the run identified by runKey, mirroring the
  captioning repository: any previous status resets, so callers must check
  the current run status first when they only want a missing run filled in.
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
    },
    requestedAt = new Date(),
  ): Promise<AiVideoTranscriptionClaim> {
    return this.db.transaction().execute(async (tx) => {
      await this.lockFirstInsert(tx, assetId);
      const existing = await this.getLocked(tx, assetId);
      const document = existing ?? { schemaVersion: 1 as const, runs: {} };
      const run: AiVideoTranscriptionRun = {
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

  async appendSegments(assetId: string, runKey: string, segments: AiVideoTranscriptionSegment[]): Promise<void> {
    await this.updateRun(assetId, runKey, (run) => ({ ...run, segments: [...run.segments, ...segments] }));
  }

  async complete(
    assetId: string,
    runKey: string,
    options: {
      language?: string;
      languageProbability?: number;
      noAudio?: boolean;
      truncated?: boolean;
      metrics?: AiVideoTranscriptionMetrics;
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
        language: options.language ?? run.language,
        languageProbability: options.languageProbability ?? run.languageProbability,
        noAudio: options.noAudio,
        truncated: options.truncated,
        metrics: options.metrics ?? run.metrics,
        error: undefined,
      };
    });
    return next !== null;
  }

  async fail(assetId: string, runKey: string, error: AiVideoTranscriptionError, finishedAt = new Date()): Promise<void> {
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
    await tx
      .insertInto('asset_metadata')
      .values({ assetId, key: AssetMetadataKey.VideoTranscriptsV1, value: document })
      .onConflict((oc) => oc.columns(['assetId', 'key']).doUpdateSet((eb) => ({ value: eb.ref('excluded.value') })))
      .execute();
  }

  private parseDocument(value: unknown): AiVideoTranscriptionDocument {
    return AiVideoTranscriptionDocumentSchema.parse(value);
  }
}
