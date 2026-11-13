import { Kysely, sql } from 'kysely';

export async function up(db: Kysely<any>): Promise<void> {
  await sql`CREATE TABLE "transcript_index_state" (
  "assetId" uuid NOT NULL,
  "revision" text NOT NULL,
  "runKey" text NOT NULL,
  "indexVersion" integer NOT NULL,
  "coverageState" text NOT NULL,
  "segmentCount" integer NOT NULL,
  "passageCount" integer NOT NULL,
  "error" text,
  "updatedAt" timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "transcript_index_state_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "asset" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "transcript_index_state_pkey" PRIMARY KEY ("assetId")
);`.execute(db);
  await sql`CREATE TABLE "transcript_passage" (
  "id" uuid NOT NULL DEFAULT immich_uuid_v7(),
  "assetId" uuid NOT NULL,
  "revision" text NOT NULL,
  "windowId" text NOT NULL,
  "firstSegment" integer NOT NULL,
  "lastSegment" integer NOT NULL,
  "startMs" integer NOT NULL,
  "endMs" integer NOT NULL,
  "text" text NOT NULL,
  "normalizedText" text NOT NULL,
  "segmentSpans" jsonb NOT NULL,
  "segmentStartsMs" jsonb NOT NULL,
  "updatedAt" timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "transcript_passage_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "asset" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "transcript_passage_pkey" PRIMARY KEY ("id")
);`.execute(db);
  await sql`CREATE INDEX "idx_transcript_passage_fts" ON "transcript_passage" USING gin (to_tsvector('simple', "normalizedText"));`.execute(db);
  await sql`CREATE INDEX "transcript_passage_assetId_idx" ON "transcript_passage" ("assetId");`.execute(db);
  await sql`CREATE TABLE "transcript_passage_token" (
  "passageId" uuid NOT NULL,
  "token" text NOT NULL,
  CONSTRAINT "transcript_passage_token_passageId_fkey" FOREIGN KEY ("passageId") REFERENCES "transcript_passage" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "transcript_passage_token_pkey" PRIMARY KEY ("passageId", "token")
);`.execute(db);
  await sql`CREATE INDEX "idx_transcript_passage_token_trgm" ON "transcript_passage_token" USING gin ("token" gin_trgm_ops);`.execute(db);
  await sql`CREATE INDEX "transcript_passage_token_passageId_idx" ON "transcript_passage_token" ("passageId");`.execute(db);
}

export async function down(db: Kysely<any>): Promise<void> {
  await sql`DROP TABLE "transcript_index_state";`.execute(db);
  await sql`DROP TABLE "transcript_passage_token";`.execute(db);
  await sql`DROP TABLE "transcript_passage";`.execute(db);
}
