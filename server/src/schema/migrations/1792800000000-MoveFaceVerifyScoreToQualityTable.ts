import { Kysely, sql } from 'kysely';

// verifyScore moves off asset_face: writing it there bumps the face's sync updateId through
// asset_face_updatedAt, so backfilling scores would make every client re-download its faces.
export async function up(db: Kysely<any>): Promise<void> {
  await sql`CREATE TABLE "asset_face_quality" (
  "faceId" uuid NOT NULL,
  "verifyScore" real NOT NULL,
  CONSTRAINT "asset_face_quality_pkey" PRIMARY KEY ("faceId"),
  CONSTRAINT "asset_face_quality_faceId_fkey" FOREIGN KEY ("faceId") REFERENCES "asset_face" ("id") ON UPDATE NO ACTION ON DELETE CASCADE
);`.execute(db);
  await sql`INSERT INTO "asset_face_quality" ("faceId", "verifyScore")
SELECT "id", "verifyScore" FROM "asset_face" WHERE "verifyScore" IS NOT NULL;`.execute(db);
  await sql`ALTER TABLE "asset_face" DROP COLUMN "verifyScore";`.execute(db);
}

export async function down(db: Kysely<any>): Promise<void> {
  await sql`ALTER TABLE "asset_face" ADD COLUMN "verifyScore" real;`.execute(db);
  await sql`UPDATE "asset_face" SET "verifyScore" = "asset_face_quality"."verifyScore"
FROM "asset_face_quality" WHERE "asset_face"."id" = "asset_face_quality"."faceId";`.execute(db);
  await sql`DROP TABLE "asset_face_quality";`.execute(db);
}
