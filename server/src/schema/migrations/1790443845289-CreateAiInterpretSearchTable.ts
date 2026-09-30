import { Kysely, sql } from 'kysely';
import { getVectorExtension } from 'src/repositories/database.repository.js';
import { vectorIndexQuery } from 'src/utils/database.js';

export async function up(db: Kysely<any>): Promise<void> {
  const vectorExtension = await getVectorExtension(db);

  await sql`CREATE TABLE "ai_interpret_search" ("assetId" uuid NOT NULL, "text" text NOT NULL, "embedding" vector(1024) NOT NULL, "runKey" text NOT NULL, "model" text NOT NULL, "updatedAt" timestamp with time zone NOT NULL DEFAULT now());`.execute(
    db,
  );
  await sql`ALTER TABLE "ai_interpret_search" ALTER COLUMN "embedding" SET STORAGE EXTERNAL;`.execute(db);
  await sql`ALTER TABLE "ai_interpret_search" ADD CONSTRAINT "ai_interpret_search_pkey" PRIMARY KEY ("assetId");`.execute(
    db,
  );
  await sql`ALTER TABLE "ai_interpret_search" ADD CONSTRAINT "ai_interpret_search_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "asset" ("id") ON UPDATE CASCADE ON DELETE CASCADE;`.execute(
    db,
  );
  await sql
    .raw(vectorIndexQuery({ vectorExtension, table: 'ai_interpret_search', indexName: 'ai_interpret_index' }))
    .execute(db);
  await sql`CREATE INDEX "idx_ai_interpret_search_text" ON "ai_interpret_search" USING gin (f_unaccent("text") gin_trgm_ops);`.execute(
    db,
  );
  await sql`INSERT INTO "migration_overrides" ("name", "value") VALUES ('index_idx_ai_interpret_search_text', '{"type":"index","name":"idx_ai_interpret_search_text","sql":"CREATE INDEX \\"idx_ai_interpret_search_text\\" ON \\"ai_interpret_search\\" USING gin (f_unaccent(\\"text\\") gin_trgm_ops);"}'::jsonb);`.execute(
    db,
  );
}

export async function down(db: Kysely<any>): Promise<void> {
  await sql`DROP TABLE "ai_interpret_search";`.execute(db);
  await sql`DELETE FROM "migration_overrides" WHERE "name" = 'index_idx_ai_interpret_search_text';`.execute(db);
}
