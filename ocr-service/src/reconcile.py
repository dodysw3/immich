from __future__ import annotations

import logging
import time
from datetime import datetime
from pathlib import Path

import psycopg2

from src.config import Config

logger = logging.getLogger(__name__)


def apply_init_sql(db_url: str, init_sql_path: str) -> None:
    path = Path(init_sql_path)
    if not path.exists():
        raise FileNotFoundError(f"init.sql not found at {path}")

    sql_text = path.read_text(encoding="utf-8")
    conn = psycopg2.connect(db_url)
    try:
        with conn.cursor() as cur:
            cur.execute(sql_text)
        conn.commit()
    finally:
        conn.close()


def validate_schema(db_url: str) -> None:
    required = {"asset_ocr", "ocr_search", "asset_job_status", "asset"}
    conn = psycopg2.connect(db_url)
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT tablename FROM pg_tables WHERE schemaname = 'public'")
            names = {row[0] for row in cur.fetchall()}
        missing = sorted(required - names)
        if missing:
            raise RuntimeError(f"Required tables missing: {', '.join(missing)}")
    finally:
        conn.close()


def get_unprocessed_assets(config: Config, limit: int = 500) -> list[str]:
    return [asset_id for asset_id, _ in get_unprocessed_assets_with_owner(config, limit=limit)]


def get_unprocessed_assets_with_owner(config: Config, limit: int = 500) -> list[tuple[str, str]]:
    conn = psycopg2.connect(config.db_url)
    try:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT ajs."assetId", a."ownerId"
                FROM asset_job_status ajs
                JOIN asset a ON a.id = ajs."assetId"
                LEFT JOIN ocr_external_state oes ON oes."assetId" = ajs."assetId"
                WHERE ajs."ocrAt" IS NOT NULL
                  AND a."deletedAt" IS NULL
                  AND a.visibility != 'hidden'
                  AND (
                    a.type = 'IMAGE'
                    OR (%s AND a.type = 'OTHER' AND lower(a."originalFileName") LIKE '%%.pdf')
                  )
                  AND (
                    oes."assetId" IS NULL
                    OR oes."status" IN ('pending', 'failed')
                    OR oes."modelRevision" != %s
                  )
                ORDER BY ajs."ocrAt" DESC
                LIMIT %s
                """,
                (config.ocr_pdf_enabled, config.ocr_model_revision, limit),
            )
            return [(row[0], row[1]) for row in cur.fetchall()]
    finally:
        conn.close()


def get_drift_count(config: Config) -> int:
    conn = psycopg2.connect(config.db_url)
    try:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT COUNT(*)
                FROM asset_job_status ajs
                JOIN asset a ON a.id = ajs."assetId"
                LEFT JOIN ocr_external_state oes ON oes."assetId" = ajs."assetId"
                WHERE ajs."ocrAt" IS NOT NULL
                  AND a."deletedAt" IS NULL
                  AND a.visibility != 'hidden'
                  AND (
                    a.type = 'IMAGE'
                    OR (%s AND a.type = 'OTHER' AND lower(a."originalFileName") LIKE '%%.pdf')
                  )
                  AND (
                    oes."assetId" IS NULL
                    OR oes."status" IN ('pending', 'failed')
                    OR oes."modelRevision" != %s
                  )
                """,
                (config.ocr_pdf_enabled, config.ocr_model_revision),
            )
            return int(cur.fetchone()[0])
    finally:
        conn.close()


def get_assets_by_ocr_date_range(config: Config, date_from: datetime, date_to: datetime, limit: int = 5000) -> list[str]:
    conn = psycopg2.connect(config.db_url)
    try:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT ajs."assetId"
                FROM asset_job_status ajs
                JOIN asset a ON a.id = ajs."assetId"
                WHERE ajs."ocrAt" IS NOT NULL
                  AND ajs."ocrAt" >= %s
                  AND ajs."ocrAt" < %s
                  AND a."deletedAt" IS NULL
                  AND a.visibility != 'hidden'
                  AND (
                    a.type = 'IMAGE'
                    OR (%s AND a.type = 'OTHER' AND lower(a."originalFileName") LIKE '%%.pdf')
                  )
                ORDER BY ajs."ocrAt" ASC
                LIMIT %s
                """,
                (date_from, date_to, config.ocr_pdf_enabled, limit),
            )
            return [row[0] for row in cur.fetchall()]
    finally:
        conn.close()


def get_asset_owner(config: Config, asset_id: str) -> str | None:
    conn = psycopg2.connect(config.db_url)
    try:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT a."ownerId"
                FROM asset a
                WHERE a.id = %s
                  AND a."deletedAt" IS NULL
                """,
                (asset_id,),
            )
            row = cur.fetchone()
            return row[0] if row else None
    finally:
        conn.close()


class Reconciler:
    def __init__(self, config: Config, process_asset_fn):
        self.config = config
        self.process_asset_fn = process_asset_fn

    def run(self) -> None:
        if self.config.ocr_reconcile_interval <= 0:
            logger.info("Reconcile disabled")
            return

        while True:
            time.sleep(self.config.ocr_reconcile_interval)
            try:
                missed = get_unprocessed_assets_with_owner(self.config)
                if missed:
                    logger.info("Reconcile found %s assets", len(missed))
                for asset_id, owner_id in missed:
                    self.process_asset_fn(asset_id, owner_id)
            except Exception as error:
                logger.exception("Reconcile cycle failed: %s", error)
