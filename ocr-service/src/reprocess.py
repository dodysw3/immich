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
from src.reconcile import get_asset_owner, get_assets_by_ocr_date_range, validate_schema
from src.surya_engine import SuryaEngine

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

    default_api = (
        ImmichClient(config.immich_url, config.immich_api_key, config.ocr_model_revision, config.ocr_model_name)
        if config.immich_api_key
        else None
    )
    owner_api = {
        owner_id: ImmichClient(config.immich_url, api_key, config.ocr_model_revision, config.ocr_model_name)
        for owner_id, api_key in config.immich_api_keys.items()
    }

    surya_engine: SuryaEngine | None = None
    detector: PaddleDetector | None = None
    recognizer_router: RecognizerRouter | None = None

    if config.ocr_engine == "surya":
        surya_engine = SuryaEngine.create(
            min_confidence=config.ocr_recognition_threshold,
            recognition_batch_size=config.surya_recognition_batch_size,
            detection_batch_size=config.surya_detection_batch_size,
        )
    else:
        detector = PaddleDetector(
            min_score=config.ocr_detection_threshold,
            model_name=config.ocr_detector_model_name,
            max_resolution=min(config.ocr_max_resolution, 736),
        )
        recognizer_router = RecognizerRouter(config)

    metrics = Metrics()
    for asset_id in asset_ids:
        owner_id = get_asset_owner(config, asset_id)
        if owner_id is None:
            logger.debug("Skipping %s: owner not found", asset_id)
            continue

        # If owner-key routing is configured, process only mapped owners.
        if owner_api:
            api = owner_api.get(owner_id)
            if api is None:
                logger.debug("Skipping %s: ownerId=%s not mapped in IMMICH_API_KEYS_JSON", asset_id, owner_id)
                continue
        else:
            api = default_api

        if api is None:
            logger.debug("Skipping %s: missing default API key for ownerId=%s", asset_id, owner_id)
            continue

        safe_process(api, config, detector, recognizer_router, metrics, asset_id, surya_engine=surya_engine)

    logger.info("manual_reprocess_complete", extra=metrics.snapshot())


if __name__ == "__main__":
    main()
