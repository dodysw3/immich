import { Kysely, sql } from 'kysely';

export async function up(db: Kysely<any>): Promise<void> {
  await sql`ALTER TABLE "pdf_document" ADD COLUMN "status" text NOT NULL DEFAULT 'pending';`.execute(db);
  await sql`ALTER TABLE "pdf_document" ADD COLUMN "lastError" text;`.execute(db);
}

export async function down(db: Kysely<any>): Promise<void> {
  await sql`ALTER TABLE "pdf_document" DROP COLUMN IF EXISTS "lastError";`.execute(db);
  await sql`ALTER TABLE "pdf_document" DROP COLUMN IF EXISTS "status";`.execute(db);
}
