import { Injectable } from '@nestjs/common';
import { Kysely, sql } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';
import {
  RotationSuggestionDocument,
  RotationSuggestionDocumentSchema,
  RotationSuggestionRun,
  RotationSuggestionStatus,
} from 'src/dtos/rotation-suggestion.dto.js';
import { AssetMetadataKey } from 'src/enum.js';
import { DB } from 'src/schema/index.js';

export type RotationSuggestionLatestRun = { runKey: string; run: RotationSuggestionRun };

export type RotationSuggestionRecordResult = { runKey: string; run: RotationSuggestionRun; preserved: boolean };

@Injectable()
export class RotationSuggestionRepository {
  constructor(@InjectKysely() private db: Kysely<DB>) {}

  async get(assetId: string): Promise<RotationSuggestionDocument | null> {
    const row = await this.db
      .selectFrom('asset_metadata')
      .select('value')
      .where('assetId', '=', assetId)
      .where('key', '=', AssetMetadataKey.RotationSuggestionV1)
      .executeTakeFirst();

    return row ? this.parseDocument(row.value) : null;
  }

  /**
  Append (or refresh) a run under its identity runKey. `applied`/`dismissed`
  runs are user decisions tied to this exact identity, so a re-run with the
  same model/tier/pipelineVersion never resurrects them — the user's verdict
  stands until a *new* runKey (model, tier, or pipeline change) re-suggests.
  A pending run is simply refreshed with the latest inference.
  */
  async recordRun(assetId: string, runKey: string, run: RotationSuggestionRun): Promise<RotationSuggestionRecordResult> {
    return this.db.transaction().execute(async (tx) => {
      await this.lockFirstInsert(tx, assetId);
      const document = (await this.getLocked(tx, assetId)) ?? { schemaVersion: 1 as const, runs: {} };
      const existing = document.runs[runKey];
      if (existing && existing.status !== 'pending') {
        return { runKey, run: existing, preserved: true };
      }

      document.runs[runKey] = run;
      await this.save(tx, assetId, document);
      return { runKey, run, preserved: false };
    });
  }

  async setStatus(
    assetId: string,
    runKey: string,
    status: Extract<RotationSuggestionStatus, 'applied' | 'dismissed'>,
  ): Promise<RotationSuggestionRun | null> {
    return this.updateRun(assetId, runKey, (run) => {
      if (run.status !== 'pending') {
        return;
      }

      return { ...run, status };
    });
  }

  async getLatestRun(assetId: string): Promise<RotationSuggestionLatestRun | null> {
    const document = await this.get(assetId);
    if (!document) {
      return null;
    }

    let latest: RotationSuggestionLatestRun | null = null;
    for (const [runKey, run] of Object.entries(document.runs)) {
      const finishedAt = run.finishedAt ?? '';
      const current = latest ? (latest.run.finishedAt ?? '') : '';
      if (!latest || finishedAt > current) {
        latest = { runKey, run };
      }
    }

    return latest;
  }

  // Pending-suggestion listing scans every suggestion document joined to its
  // asset (owner scoping + skip-deleted happen here; the pending/abstain
  // filtering lives in the service so access checks stay centralized).
  async listDocuments(): Promise<Array<{ assetId: string; ownerId: string; document: RotationSuggestionDocument }>> {
    const rows = await this.db
      .selectFrom('asset_metadata')
      .innerJoin('asset', 'asset.id', 'asset_metadata.assetId')
      .select(['asset_metadata.assetId', 'asset_metadata.value', 'asset.ownerId'])
      .where('asset_metadata.key', '=', AssetMetadataKey.RotationSuggestionV1)
      .where('asset.deletedAt', 'is', null)
      .execute();

    const result: Array<{ assetId: string; ownerId: string; document: RotationSuggestionDocument }> = [];
    for (const row of rows) {
      try {
        result.push({ assetId: row.assetId, ownerId: row.ownerId, document: this.parseDocument(row.value) });
      } catch {
        // A malformed document must not break the whole listing.
        continue;
      }
    }

    return result;
  }

  private async updateRun(
    assetId: string,
    runKey: string,
    update: (run: RotationSuggestionRun) => RotationSuggestionRun | undefined,
  ): Promise<RotationSuggestionRun | null> {
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
    await sql`SELECT pg_advisory_xact_lock(hashtextextended(${`${assetId}:${AssetMetadataKey.RotationSuggestionV1}`}, 0))`.execute(
      tx,
    );
  }

  private getLocked(tx: Kysely<DB>, assetId: string) {
    return tx
      .selectFrom('asset_metadata')
      .select('value')
      .where('assetId', '=', assetId)
      .where('key', '=', AssetMetadataKey.RotationSuggestionV1)
      .forUpdate()
      .executeTakeFirst()
      .then((row) => (row ? this.parseDocument(row.value) : null));
  }

  private async save(tx: Kysely<DB>, assetId: string, document: RotationSuggestionDocument): Promise<void> {
    await tx
      .insertInto('asset_metadata')
      .values({ assetId, key: AssetMetadataKey.RotationSuggestionV1, value: document })
      .onConflict((oc) => oc.columns(['assetId', 'key']).doUpdateSet((eb) => ({ value: eb.ref('excluded.value') })))
      .execute();
  }

  private parseDocument(value: unknown): RotationSuggestionDocument {
    return RotationSuggestionDocumentSchema.parse(value);
  }
}
