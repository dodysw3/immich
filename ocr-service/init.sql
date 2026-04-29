-- Trigger notification when Immich OCR completes
CREATE OR REPLACE FUNCTION notify_ocr_complete()
RETURNS trigger AS $$
BEGIN
  IF OLD."ocrAt" IS NULL AND NEW."ocrAt" IS NOT NULL THEN
    PERFORM pg_notify('ocr_complete', NEW."assetId"::text);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_trigger
    WHERE tgname = 'trg_ocr_complete'
  ) THEN
    CREATE TRIGGER trg_ocr_complete
    AFTER UPDATE OF "ocrAt" ON asset_job_status
    FOR EACH ROW
    EXECUTE FUNCTION notify_ocr_complete();
  END IF;
END;
$$;

-- Track external OCR status and model provenance
CREATE TABLE IF NOT EXISTS ocr_external_state (
  "assetId" uuid PRIMARY KEY REFERENCES asset(id) ON DELETE CASCADE,
  "sourceChecksum" text NOT NULL,
  "modelRevision" text NOT NULL,
  "processedAt" timestamptz,
  "status" text NOT NULL DEFAULT 'pending',
  "retryCount" integer NOT NULL DEFAULT 0,
  "lastError" text
);

CREATE INDEX IF NOT EXISTS idx_ocr_external_state_status ON ocr_external_state ("status");
CREATE INDEX IF NOT EXISTS idx_ocr_external_state_model ON ocr_external_state ("modelRevision");
