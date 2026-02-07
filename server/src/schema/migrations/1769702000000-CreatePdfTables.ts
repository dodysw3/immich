import { Kysely, sql } from 'kysely';

export async function up(db: Kysely<any>): Promise<void> {
  await sql`
    CREATE TABLE "pdf_document" (
      "assetId" uuid NOT NULL,
      "pageCount" integer NOT NULL DEFAULT 0,
      "title" text,
      "author" text,
      "subject" text,
      "creator" text,
      "producer" text,
      "creationDate" timestamp with time zone,
      "processedAt" timestamp with time zone,
      "createdAt" timestamp with time zone NOT NULL DEFAULT now(),
      "updatedAt" timestamp with time zone NOT NULL DEFAULT now(),
      CONSTRAINT "pdf_document_pkey" PRIMARY KEY ("assetId"),
      CONSTRAINT "pdf_document_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "asset" ("id") ON UPDATE CASCADE ON DELETE CASCADE
    );
  `.execute(db);

  await sql`
    CREATE TABLE "pdf_page" (
      "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
      "assetId" uuid NOT NULL,
      "pageNumber" integer NOT NULL,
      "text" text NOT NULL DEFAULT '',
      "textSource" text NOT NULL DEFAULT 'embedded',
      "width" real,
      "height" real,
      CONSTRAINT "pdf_page_pkey" PRIMARY KEY ("id"),
      CONSTRAINT "pdf_page_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "pdf_document" ("assetId") ON UPDATE CASCADE ON DELETE CASCADE
    );
  `.execute(db);

  await sql`CREATE UNIQUE INDEX "pdf_page_assetId_pageNumber_idx" ON "pdf_page" ("assetId", "pageNumber");`.execute(db);

  await sql`
    CREATE TABLE "pdf_search" (
      "assetId" uuid NOT NULL,
      "text" text NOT NULL,
      CONSTRAINT "pdf_search_pkey" PRIMARY KEY ("assetId"),
      CONSTRAINT "pdf_search_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "asset" ("id") ON UPDATE CASCADE ON DELETE CASCADE
    );
  `.execute(db);

  await sql`CREATE INDEX "idx_pdf_search_text" ON "pdf_search" USING gin (f_unaccent("text") gin_trgm_ops);`.execute(db);
}

export async function down(db: Kysely<any>): Promise<void> {
  await sql`DROP TABLE IF EXISTS "pdf_page";`.execute(db);
  await sql`DROP TABLE IF EXISTS "pdf_search";`.execute(db);
  await sql`DROP TABLE IF EXISTS "pdf_document";`.execute(db);
}
