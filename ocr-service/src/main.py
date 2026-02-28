from __future__ import annotations

import logging
import threading
import time

import torch

from src.client import ImmichClient
from src.config import Config
from src.detect import PaddleDetector
from src.health import HealthState, start_health_server
from src.listener import PgListener
from src.model_policy import RecognizerRouter
from src.observability import Metrics, configure_logging
from src.pipeline import process_asset
from src.reconcile import Reconciler, apply_init_sql, get_drift_count, get_unprocessed_assets, validate_schema
from src.state import update_failure

logger = logging.getLogger(__name__)


def safe_process(
    api: ImmichClient,
    config: Config,
    detector: PaddleDetector,
    recognizer_router: RecognizerRouter,
    metrics: Metrics,
    asset_id: str,
) -> None:
    attempts = config.max_retries + 1
    started = time.monotonic()

    for attempt in range(attempts):
        try:
            status, lines = process_asset(api, config, detector, recognizer_router, asset_id)
            duration = time.monotonic() - started
            metrics.observe(asset_id, status=status, lines=lines, duration_s=duration, retries=attempt)
            logger.info(
                "asset_processed",
                extra={
                    "assetId": asset_id,
                    "status": status,
                    "lines": lines,
                    "retries": attempt,
                    "durationSeconds": round(duration, 3),
                },
            )
            return
        except torch.cuda.OutOfMemoryError as error:
            torch.cuda.empty_cache()
            logger.error("gpu_oom", extra={"assetId": asset_id, "attempt": attempt + 1, "error": str(error)})
            metrics.set_last_error(str(error))
            if attempt == config.max_retries:
                _mark_failure(api, config, asset_id, str(error), attempt + 1, retriable=False)
                duration = time.monotonic() - started
                metrics.observe(asset_id, status="failed", lines=0, duration_s=duration, retries=attempt)
                return
        except Exception as error:  # pylint: disable=broad-except
            logger.exception("asset_processing_failed", extra={"assetId": asset_id, "attempt": attempt + 1})
            metrics.set_last_error(str(error))
            if attempt == config.max_retries:
                _mark_failure(api, config, asset_id, str(error), attempt + 1, retriable=True)
                duration = time.monotonic() - started
                metrics.observe(asset_id, status="failed", lines=0, duration_s=duration, retries=attempt)
                return

        backoff = 1 * (4**attempt)
        time.sleep(backoff)


def _mark_failure(api: ImmichClient, config: Config, asset_id: str, error: str, retry_count: int, retriable: bool) -> None:
    try:
        update_failure(config.db_url, asset_id, "", config.ocr_model_revision, error)
    except Exception as update_error:  # pylint: disable=broad-except
        logger.exception("state_update_failed", extra={"assetId": asset_id, "error": str(update_error)})

    try:
        api.report_failure(asset_id, error, retry_count, retriable=retriable)
    except Exception as report_error:  # pylint: disable=broad-except
        logger.exception("failure_report_failed", extra={"assetId": asset_id, "error": str(report_error)})


def _metrics_reporter(metrics: Metrics, config: Config) -> None:
    while True:
        time.sleep(config.metrics_log_interval)
        try:
            metrics.set_drift_count(get_drift_count(config))
        except Exception as error:  # pylint: disable=broad-except
            logger.warning("drift_count_failed", extra={"error": str(error)})
        logger.info("metrics", extra=metrics.snapshot())


def main() -> None:
    config = Config.from_env()
    config.validate()
    configure_logging(config.log_level)

    metrics = Metrics()
    health_state = HealthState(metrics=metrics, model_revision=config.ocr_model_revision)
    start_health_server(config.health_host, config.health_port, health_state)

    if config.metrics_log_interval > 0:
        metrics_thread = threading.Thread(
            target=_metrics_reporter,
            args=(metrics, config),
            daemon=True,
        )
        metrics_thread.start()

    logger.info(
        "starting_external_ocr_service",
        extra={
            "modelName": config.ocr_model_name,
            "modelRevision": config.ocr_model_revision,
            "mode": config.external_ocr_mode,
            "channel": config.ocr_channel,
        },
    )

    validate_schema(config.db_url)
    apply_init_sql(config.db_url, config.init_sql_path)
    try:
        metrics.set_drift_count(get_drift_count(config))
    except Exception as error:  # pylint: disable=broad-except
        logger.warning("initial_drift_count_failed", extra={"error": str(error)})

    api = ImmichClient(config.immich_url, config.immich_api_key, config.ocr_model_revision)
    detector = PaddleDetector(min_score=config.ocr_detection_threshold)
    recognizer_router = RecognizerRouter(config)

    def process_one(asset_id: str) -> None:
        safe_process(api, config, detector, recognizer_router, metrics, asset_id)

    reconciler = Reconciler(config=config, process_asset_fn=process_one)
    reconcile_thread = threading.Thread(target=reconciler.run, daemon=True)
    reconcile_thread.start()

    missed = get_unprocessed_assets(config)
    if missed:
        logger.info("catchup", extra={"count": len(missed)})
    for asset_id in missed:
        process_one(asset_id)

    health_state.set_ready(True)

    listener = PgListener(config.db_url, channel=config.ocr_channel)
    logger.info("listener_ready", extra={"channel": config.ocr_channel})
    for asset_id in listener:
        process_one(asset_id)


if __name__ == "__main__":
    main()
