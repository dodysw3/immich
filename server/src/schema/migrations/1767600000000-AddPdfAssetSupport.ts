import { Kysely, sql } from 'kysely';

export async function up(db: Kysely<any>): Promise<void> {
  // Add parentId column to assets table
  await sql`ALTER TABLE "asset" ADD COLUMN "parentId" uuid;`.execute(db);

  // Add FK constraint with CASCADE delete (when parent is deleted, children are deleted too)
  await sql`ALTER TABLE "asset"
    ADD CONSTRAINT "FK_asset_parentId"
    FOREIGN KEY ("parentId")
    REFERENCES "asset"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE;`.execute(db);

  // Add index for efficient parent-child lookups
  await sql`CREATE INDEX "IDX_asset_parentId" ON "asset" ("parentId");`.execute(db);
}

export async function down(db: Kysely<any>): Promise<void> {
  await sql`DROP INDEX IF EXISTS "IDX_asset_parentId";`.execute(db);
  await sql`ALTER TABLE "asset" DROP CONSTRAINT IF EXISTS "FK_asset_parentId";`.execute(db);
  await sql`ALTER TABLE "asset" DROP COLUMN IF EXISTS "parentId";`.execute(db);
}
