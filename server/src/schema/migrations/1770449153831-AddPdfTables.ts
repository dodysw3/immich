import { Kysely, sql } from 'kysely';
import { DB } from 'src/schema';

export const up = async (db: Kysely<DB>) => {
  // Create pdf_asset table
  await db.schema
    .createTable('pdf_asset')
    .addColumn('assetId', 'text', (col) => col.notNull().primaryKey())
    .addColumn('pageCount', 'integer', (col) => col.notNull())
    .addColumn('hasText', 'boolean', (col) => col.notNull().defaultTo(false))
    .addColumn('isOCRProcessed', 'boolean', (col) => col.notNull().defaultTo(false))
    .addColumn('fileSizeInByte', 'bigint', (col) => col.notNull())
    .addColumn('author', 'text')
    .addColumn('title', 'text')
    .addColumn('subject', 'text')
    .addColumn('keywords', 'text')
    .addColumn('creator', 'text')
    .addColumn('producer', 'text')
    .addColumn('createdAt', 'timestamp', (col) => col.notNull().defaultTo(sql`now()`))
    .addColumn('updatedAt', 'timestamp', (col) => col.notNull().defaultTo(sql`now()`))
    .execute();

  // Create foreign key to asset table
  await sql`
    ALTER TABLE pdf_asset
    ADD CONSTRAINT pdf_asset_assetId_fkey
    FOREIGN KEY ("assetId")
    REFERENCES asset(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
  `.execute(db);

  // Create pdf_page table
  await db.schema
    .createTable('pdf_page')
    .addColumn('id', 'text', (col) => col.primaryKey())
    .addColumn('assetId', 'text', (col) => col.notNull())
    .addColumn('pageNumber', 'integer', (col) => col.notNull())
    .addColumn('width', 'integer')
    .addColumn('height', 'integer')
    .addColumn('textContent', 'text')
    .addColumn('thumbnailPath', 'text', (col) => col.notNull())
    .addColumn('searchableText', 'text', (col) => col.notNull())
    .addColumn('createdAt', 'timestamp', (col) => col.notNull().defaultTo(sql`now()`))
    .execute();

  // Create foreign key to asset table
  await sql`
    ALTER TABLE pdf_page
    ADD CONSTRAINT pdf_page_assetId_fkey
    FOREIGN KEY ("assetId")
    REFERENCES asset(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
  `.execute(db);

  // Create pdf_page_ocr table
  await db.schema
    .createTable('pdf_page_ocr')
    .addColumn('id', 'text', (col) => col.primaryKey())
    .addColumn('pdfPageId', 'text', (col) => col.notNull())
    .addColumn('pageNumber', 'integer', (col) => col.notNull())
    .addColumn('x1', 'real', (col) => col.notNull())
    .addColumn('y1', 'real', (col) => col.notNull())
    .addColumn('x2', 'real', (col) => col.notNull())
    .addColumn('y2', 'real', (col) => col.notNull())
    .addColumn('x3', 'real', (col) => col.notNull())
    .addColumn('y3', 'real', (col) => col.notNull())
    .addColumn('x4', 'real', (col) => col.notNull())
    .addColumn('y4', 'real', (col) => col.notNull())
    .addColumn('text', 'text', (col) => col.notNull())
    .addColumn('confidence', 'real', (col) => col.notNull())
    .execute();

  // Create foreign key to pdf_page table
  await sql`
    ALTER TABLE pdf_page_ocr
    ADD CONSTRAINT pdf_page_ocr_pdfPageId_fkey
    FOREIGN KEY ("pdfPageId")
    REFERENCES pdf_page(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
  `.execute(db);

  // Create pdf_search table with GIN index for full-text search
  await db.schema
    .createTable('pdf_search')
    .addColumn('assetId', 'text', (col) => col.primaryKey())
    .addColumn('text', 'text', (col) => col.notNull())
    .execute();

  // Create foreign key to asset table
  await sql`
    ALTER TABLE pdf_search
    ADD CONSTRAINT pdf_search_assetId_fkey
    FOREIGN KEY ("assetId")
    REFERENCES asset(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
  `.execute(db);

  // Create GIN index for full-text search on pdf_search
  await sql`
    CREATE INDEX idx_pdf_search_text
    ON pdf_search
    USING GIN (f_unaccent(text) gin_trm_ops)
  `.execute(db);
};

export const down = async (db: Kysely<DB>) => {
  await db.schema.dropTable('pdf_search').execute();
  await db.schema.dropTable('pdf_page_ocr').execute();
  await db.schema.dropTable('pdf_page').execute();
  await db.schema.dropTable('pdf_asset').execute();
};
