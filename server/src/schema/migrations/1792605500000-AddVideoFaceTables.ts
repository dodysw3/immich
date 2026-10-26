import { Kysely, sql } from 'kysely';

export async function up(db: Kysely<any>): Promise<void> {
  await sql`ALTER TABLE "asset_face" ADD COLUMN "frameTimeMs" integer;`.execute(db);

  await sql`CREATE TABLE "video_face_run" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "assetId" uuid NOT NULL,
  "configHash" text NOT NULL,
  "config" jsonb NOT NULL,
  "modelVersions" text NOT NULL,
  "outcome" text NOT NULL,
  "extractions" integer NOT NULL DEFAULT 0,
  "framesAnalyzed" integer NOT NULL DEFAULT 0,
  "detections" integer NOT NULL DEFAULT 0,
  "embeddings" integer NOT NULL DEFAULT 0,
  "identities" integer NOT NULL DEFAULT 0,
  "durationMs" integer NOT NULL DEFAULT 0,
  "firstSampledMs" integer NOT NULL DEFAULT 0,
  "lastSampledMs" integer NOT NULL DEFAULT 0,
  "deadlineBudgetMs" integer NOT NULL DEFAULT 0,
  "error" text,
  "createdAt" timestamp with time zone NOT NULL DEFAULT now(),
  "updatedAt" timestamp with time zone NOT NULL DEFAULT now(),
  "updateId" uuid NOT NULL DEFAULT immich_uuid_v7(),
  CONSTRAINT "video_face_run_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "video_face_run_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "asset" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);`.execute(db);
  await sql`CREATE INDEX "video_face_run_assetId_idx" ON "video_face_run" ("assetId");`.execute(db);
  await sql`CREATE TRIGGER "video_face_run_updatedAt"
  BEFORE UPDATE ON "video_face_run"
  FOR EACH ROW
  EXECUTE FUNCTION updated_at();`.execute(db);
  await sql`INSERT INTO "migration_overrides" ("name", "value") VALUES ('trigger_video_face_run_updatedAt', '{"type":"trigger","name":"video_face_run_updatedAt","sql":"CREATE OR REPLACE TRIGGER \\"video_face_run_updatedAt\\"\\n  BEFORE UPDATE ON \\"video_face_run\\"\\n  FOR EACH ROW\\n  EXECUTE FUNCTION updated_at();"}'::jsonb);`.execute(db);

  await sql`CREATE TABLE "video_face" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "assetId" uuid NOT NULL,
  "runId" uuid NOT NULL,
  "identityKey" text NOT NULL,
  "firstObservedMs" integer NOT NULL,
  "lastObservedMs" integer NOT NULL,
  "sightingCount" integer NOT NULL,
  "bestFrameMs" integer NOT NULL,
  "bestScore" real NOT NULL,
  "bestSizePx" integer NOT NULL,
  "embedding" jsonb NOT NULL,
  "flagged" boolean NOT NULL DEFAULT false,
  "assetFaceId" uuid,
  "createdAt" timestamp with time zone NOT NULL DEFAULT now(),
  "updatedAt" timestamp with time zone NOT NULL DEFAULT now(),
  "updateId" uuid NOT NULL DEFAULT immich_uuid_v7(),
  CONSTRAINT "video_face_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "video_face_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "asset" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "video_face_runId_fkey" FOREIGN KEY ("runId") REFERENCES "video_face_run" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "video_face_assetFaceId_fkey" FOREIGN KEY ("assetFaceId") REFERENCES "asset_face" ("id") ON UPDATE CASCADE ON DELETE SET NULL
);`.execute(db);
  await sql`CREATE UNIQUE INDEX "video_face_assetId_identityKey_idx" ON "video_face" ("assetId", "identityKey");`.execute(db);
  await sql`CREATE INDEX "video_face_assetId_idx" ON "video_face" ("assetId");`.execute(db);
  await sql`CREATE INDEX "video_face_assetFaceId_idx" ON "video_face" ("assetFaceId");`.execute(db);
  await sql`CREATE INDEX "video_face_runId_idx" ON "video_face" ("runId");`.execute(db);
  await sql`CREATE TRIGGER "video_face_updatedAt"
  BEFORE UPDATE ON "video_face"
  FOR EACH ROW
  EXECUTE FUNCTION updated_at();`.execute(db);
  await sql`INSERT INTO "migration_overrides" ("name", "value") VALUES ('trigger_video_face_updatedAt', '{"type":"trigger","name":"video_face_updatedAt","sql":"CREATE OR REPLACE TRIGGER \\"video_face_updatedAt\\"\\n  BEFORE UPDATE ON \\"video_face\\"\\n  FOR EACH ROW\\n  EXECUTE FUNCTION updated_at();"}'::jsonb);`.execute(db);

  await sql`CREATE TABLE "video_face_sighting" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "videoFaceId" uuid NOT NULL,
  "runId" uuid NOT NULL,
  "timeMs" integer NOT NULL,
  "x1" integer NOT NULL,
  "y1" integer NOT NULL,
  "x2" integer NOT NULL,
  "y2" integer NOT NULL,
  "imageWidth" integer NOT NULL,
  "imageHeight" integer NOT NULL,
  "score" real NOT NULL,
  "quality" real,
  "createdAt" timestamp with time zone NOT NULL DEFAULT now(),
  "updateId" uuid NOT NULL DEFAULT immich_uuid_v7(),
  CONSTRAINT "video_face_sighting_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "video_face_sighting_videoFaceId_fkey" FOREIGN KEY ("videoFaceId") REFERENCES "video_face" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "video_face_sighting_runId_fkey" FOREIGN KEY ("runId") REFERENCES "video_face_run" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);`.execute(db);
  await sql`CREATE INDEX "video_face_sighting_videoFaceId_timeMs_idx" ON "video_face_sighting" ("videoFaceId", "timeMs");`.execute(db);
  await sql`CREATE INDEX "video_face_sighting_runId_idx" ON "video_face_sighting" ("runId");`.execute(db);
}

export async function down(db: Kysely<any>): Promise<void> {
  await sql`DROP TABLE "video_face_sighting";`.execute(db);
  await sql`DROP TRIGGER "video_face_updatedAt" ON "video_face";`.execute(db);
  await sql`DELETE FROM "migration_overrides" WHERE "name" = 'trigger_video_face_updatedAt';`.execute(db);
  await sql`DROP TABLE "video_face";`.execute(db);
  await sql`DROP TRIGGER "video_face_run_updatedAt" ON "video_face_run";`.execute(db);
  await sql`DELETE FROM "migration_overrides" WHERE "name" = 'trigger_video_face_run_updatedAt';`.execute(db);
  await sql`DROP TABLE "video_face_run";`.execute(db);
  await sql`ALTER TABLE "asset_face" DROP COLUMN "frameTimeMs";`.execute(db);
}
