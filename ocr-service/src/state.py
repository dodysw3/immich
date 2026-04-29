from __future__ import annotations

from datetime import datetime, timezone

import psycopg2


def update_pending(db_url: str, asset_id: str, source_checksum: str, model_revision: str) -> None:
    query = """
        INSERT INTO ocr_external_state ("assetId", "sourceChecksum", "modelRevision", "status", "retryCount")
        VALUES (%s, %s, %s, 'pending', 0)
        ON CONFLICT ("assetId") DO UPDATE
        SET "sourceChecksum" = EXCLUDED."sourceChecksum",
            "modelRevision" = EXCLUDED."modelRevision",
            "status" = 'pending'
    """
    _execute(db_url, query, (asset_id, source_checksum, model_revision))


def update_success(db_url: str, asset_id: str, source_checksum: str, model_revision: str) -> None:
    processed_at = datetime.now(timezone.utc)
    query = """
        INSERT INTO ocr_external_state
            ("assetId", "sourceChecksum", "modelRevision", "processedAt", "status", "retryCount", "lastError")
        VALUES (%s, %s, %s, %s, 'success', 0, NULL)
        ON CONFLICT ("assetId") DO UPDATE
        SET "sourceChecksum" = EXCLUDED."sourceChecksum",
            "modelRevision" = EXCLUDED."modelRevision",
            "processedAt" = EXCLUDED."processedAt",
            "status" = 'success',
            "retryCount" = 0,
            "lastError" = NULL
    """
    _execute(db_url, query, (asset_id, source_checksum, model_revision, processed_at))


def update_failure(
    db_url: str,
    asset_id: str,
    source_checksum: str,
    model_revision: str,
    error_text: str,
    retriable: bool = True,
) -> None:
    status = "failed" if retriable else "terminal"
    query = """
        INSERT INTO ocr_external_state
            ("assetId", "sourceChecksum", "modelRevision", "status", "retryCount", "lastError")
        VALUES (%s, %s, %s, %s, 1, %s)
        ON CONFLICT ("assetId") DO UPDATE
        SET "sourceChecksum" = EXCLUDED."sourceChecksum",
            "modelRevision" = EXCLUDED."modelRevision",
            "status" = EXCLUDED."status",
            "retryCount" = ocr_external_state."retryCount" + 1,
            "lastError" = EXCLUDED."lastError"
    """
    _execute(db_url, query, (asset_id, source_checksum, model_revision, status, error_text[:4000]))


def _execute(db_url: str, query: str, params: tuple) -> None:
    conn = psycopg2.connect(db_url)
    try:
        with conn.cursor() as cur:
            cur.execute(query, params)
        conn.commit()
    finally:
        conn.close()
