from __future__ import annotations

import argparse
import logging
from datetime import datetime, timedelta, timezone

from src.client import ImmichClient
from src.config import Config
from src.detect import PaddleDetector
from src.main import safe_process
from src.model_policy import RecognizerRouter
from src.observability import Metrics, configure_logging
from src.reconcile import get_assets_by_ocr_date_range, validate_schema

logger = logging.getLogger(__name__)


def _parse_iso_date(value: str) -> datetime:
    dt = datetime.fromisoformat(value)
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)
    return dt.astimezone(timezone.utc)


def _collect_asset_ids(config: Config, args: argparse.Namespace) -> list[str]:
    ids = list(args.asset_id or [])

    if args.date_from:
        date_from = _parse_iso_date(args.date_from)
        if args.date_to:
            date_to = _parse_iso_date(args.date_to)
        else:
            date_to = date_from + timedelta(days=1)

        if date_to <= date_from:
            raise ValueError("--date-to must be greater than --date-from")

        ids.extend(get_assets_by_ocr_date_range(config, date_from, date_to, limit=args.limit))

    deduped = list(dict.fromkeys(ids))
    return deduped[: args.limit]


def main() -> None:
    parser = argparse.ArgumentParser(description="Manual external OCR reprocess by asset IDs or OCR date range")
    parser.add_argument("--asset-id", action="append", default=[], help="Asset ID to reprocess (repeatable)")
    parser.add_argument("--date-from", help="OCR date range start (ISO date/date-time, UTC if tz omitted)")
    parser.add_argument("--date-to", help="OCR date range end (ISO date/date-time, UTC if tz omitted)")
    parser.add_argument("--limit", type=int, default=500, help="Maximum assets to process")
    parser.add_argument("--dry-run", action="store_true", help="Only print selected asset IDs")
    args = parser.parse_args()

    config = Config.from_env()
    config.validate()
    configure_logging(config.log_level)

    if args.limit <= 0:
        raise ValueError("--limit must be > 0")

    validate_schema(config.db_url)
    asset_ids = _collect_asset_ids(config, args)

    logger.info("manual_reprocess_selected", extra={"count": len(asset_ids), "dryRun": args.dry_run})
    if not asset_ids:
        return

    if args.dry_run:
        for asset_id in asset_ids:
            print(asset_id)
        return

    api = ImmichClient(config.immich_url, config.immich_api_key, config.ocr_model_revision)
    detector = PaddleDetector(min_score=config.ocr_detection_threshold)
    recognizer_router = RecognizerRouter(config)

    metrics = Metrics()
    for asset_id in asset_ids:
        safe_process(api, config, detector, recognizer_router, metrics, asset_id)

    logger.info("manual_reprocess_complete", extra=metrics.snapshot())


if __name__ == "__main__":
    main()
