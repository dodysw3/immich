import { Kysely, sql } from 'kysely';

export async function up(db: Kysely<any>): Promise<void> {
  // pdf_document table
  await sql`CREATE TABLE "pdf_document" (
    "assetId" uuid NOT NULL,
    "pageCount" integer NOT NULL,
    "title" text,
    "author" text,
    "subject" text,
    "creator" text,
    "producer" text,
    "creationDate" timestamp with time zone,
    "processedAt" timestamp with time zone
  );`.execute(db);
  await sql`ALTER TABLE "pdf_document" ADD CONSTRAINT "pdf_document_pkey" PRIMARY KEY ("assetId");`.execute(db);
  await sql`ALTER TABLE "pdf_document" ADD CONSTRAINT "pdf_document_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "asset" ("id") ON UPDATE CASCADE ON DELETE CASCADE;`.execute(
    db,
  );

  // pdf_page table
  await sql`CREATE TABLE "pdf_page" (
    "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
    "assetId" uuid NOT NULL,
    "pageNumber" integer NOT NULL,
    "text" text NOT NULL DEFAULT '',
    "textSource" text NOT NULL DEFAULT 'embedded',
    "width" real,
    "height" real
  );`.execute(db);
  await sql`ALTER TABLE "pdf_page" ADD CONSTRAINT "pdf_page_pkey" PRIMARY KEY ("id");`.execute(db);
  await sql`ALTER TABLE "pdf_page" ADD CONSTRAINT "pdf_page_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "asset" ("id") ON UPDATE CASCADE ON DELETE CASCADE;`.execute(
    db,
  );
  await sql`ALTER TABLE "pdf_page" ADD CONSTRAINT "pdf_page_assetId_pageNumber_unique" UNIQUE ("assetId", "pageNumber");`.execute(
    db,
  );
  await sql`CREATE INDEX "pdf_page_assetId_idx" ON "pdf_page" ("assetId");`.execute(db);

  // pdf_search table
  await sql`CREATE TABLE "pdf_search" (
    "assetId" uuid NOT NULL,
    "text" text NOT NULL
  );`.execute(db);
  await sql`ALTER TABLE "pdf_search" ADD CONSTRAINT "pdf_search_pkey" PRIMARY KEY ("assetId");`.execute(db);
  await sql`ALTER TABLE "pdf_search" ADD CONSTRAINT "pdf_search_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "asset" ("id") ON UPDATE CASCADE ON DELETE CASCADE;`.execute(
    db,
  );
  await sql`CREATE INDEX "idx_pdf_search_text" ON "pdf_search" USING gin (f_unaccent("text") gin_trgm_ops);`.execute(
    db,
  );
  await sql`INSERT INTO "migration_overrides" ("name", "value") VALUES ('index_idx_pdf_search_text', '{"type":"index","name":"idx_pdf_search_text","sql":"CREATE INDEX \\"idx_pdf_search_text\\" ON \\"pdf_search\\" USING gin (f_unaccent(\\"text\\") gin_trgm_ops);"}'::jsonb);`.execute(
    db,
  );
}

export async function down(db: Kysely<any>): Promise<void> {
  await sql`DROP TABLE "pdf_search";`.execute(db);
  await sql`DROP TABLE "pdf_page";`.execute(db);
  await sql`DROP TABLE "pdf_document";`.execute(db);
  await sql`DELETE FROM "migration_overrides" WHERE "name" = 'index_idx_pdf_search_text';`.execute(db);
}
