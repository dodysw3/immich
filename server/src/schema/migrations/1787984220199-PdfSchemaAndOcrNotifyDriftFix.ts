import { Kysely, sql } from 'kysely';

/**
 * Declares fork-specific schema that previously existed only out-of-band, so
 * `immich-admin schema-check` no longer reports drift:
 * - pdf_page FK index expected by sql-tools (`createForeignKeyIndexes`)
 * - `idx_pdf_search_text` gin index registered as a migration override
 * - `notify_ocr_complete()` + `trg_ocr_complete` (pg_notify channel consumed by
 *   the external OCR service) declared in code and registered as overrides
 */
export async function up(db: Kysely<any>): Promise<void> {
  await sql`CREATE INDEX IF NOT EXISTS "pdf_page_assetId_idx" ON "pdf_page" ("assetId");`.execute(db);

  await sql`DROP TRIGGER IF EXISTS "trg_ocr_complete" ON "asset_job_status";`.execute(db);
  await sql`CREATE OR REPLACE FUNCTION notify_ocr_complete()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS $$
    BEGIN
      IF OLD."ocrAt" IS NULL AND NEW."ocrAt" IS NOT NULL THEN
        PERFORM pg_notify('ocr_complete', NEW."assetId"::text);
      END IF;
      RETURN NEW;
    END
  $$;`.execute(db);
  await sql`CREATE OR REPLACE TRIGGER "trg_ocr_complete"
  AFTER UPDATE ON "asset_job_status"
  FOR EACH ROW
  EXECUTE FUNCTION notify_ocr_complete();`.execute(db);

  await sql`INSERT INTO "migration_overrides" ("name", "value") VALUES ('index_idx_pdf_search_text', '{"type":"index","name":"idx_pdf_search_text","sql":"CREATE INDEX \\"idx_pdf_search_text\\" ON \\"pdf_search\\" USING gin (f_unaccent(\\"text\\") gin_trgm_ops);"}'::jsonb);`.execute(db);
  await sql`INSERT INTO "migration_overrides" ("name", "value") VALUES ('function_notify_ocr_complete', '{"type":"function","name":"notify_ocr_complete","sql":"CREATE OR REPLACE FUNCTION notify_ocr_complete()\\n  RETURNS TRIGGER\\n  LANGUAGE PLPGSQL\\n  AS $$\\n    BEGIN\\n      IF OLD.\\"ocrAt\\" IS NULL AND NEW.\\"ocrAt\\" IS NOT NULL THEN\\n        PERFORM pg_notify(''ocr_complete'', NEW.\\"assetId\\"::text);\\n      END IF;\\n      RETURN NEW;\\n    END\\n  $$;"}'::jsonb);`.execute(db);
  await sql`INSERT INTO "migration_overrides" ("name", "value") VALUES ('trigger_trg_ocr_complete', '{"type":"trigger","name":"trg_ocr_complete","sql":"CREATE OR REPLACE TRIGGER \\"trg_ocr_complete\\"\\n  AFTER UPDATE ON \\"asset_job_status\\"\\n  FOR EACH ROW\\n  EXECUTE FUNCTION notify_ocr_complete();"}'::jsonb);`.execute(db);
}

export async function down(db: Kysely<any>): Promise<void> {
  await sql`DELETE FROM "migration_overrides" WHERE "name" IN ('index_idx_pdf_search_text', 'function_notify_ocr_complete', 'trigger_trg_ocr_complete');`.execute(db);
  await sql`DROP INDEX IF EXISTS "pdf_page_assetId_idx";`.execute(db);
  await sql`DROP TRIGGER IF EXISTS "trg_ocr_complete" ON "asset_job_status";`.execute(db);
  await sql`DROP FUNCTION IF EXISTS notify_ocr_complete;`.execute(db);
}
