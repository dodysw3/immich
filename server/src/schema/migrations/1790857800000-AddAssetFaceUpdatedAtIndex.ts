import { Kysely, sql } from 'kysely';

export async function up(db: Kysely<any>): Promise<void> {
  await sql`CREATE INDEX "asset_face_updatedAt_notDeleted_isVisible_idx" ON "asset_face" ("updatedAt") WHERE "deletedAt" IS NULL AND "isVisible" IS TRUE;`.execute(db);
  await sql`INSERT INTO "migration_overrides" ("name", "value") VALUES ('index_asset_face_updatedAt_notDeleted_isVisible_idx', '{"type":"index","name":"asset_face_updatedAt_notDeleted_isVisible_idx","sql":"CREATE INDEX \\"asset_face_updatedAt_notDeleted_isVisible_idx\\" ON \\"asset_face\\" (\\"updatedAt\\") WHERE (\\"deletedAt\\" IS NULL AND \\"isVisible\\" IS TRUE);"}'::jsonb);`.execute(db);
}

export async function down(db: Kysely<any>): Promise<void> {
  await sql`DROP INDEX "asset_face_updatedAt_notDeleted_isVisible_idx";`.execute(db);
  await sql`DELETE FROM "migration_overrides" WHERE "name" = 'index_asset_face_updatedAt_notDeleted_isVisible_idx';`.execute(db);
}
