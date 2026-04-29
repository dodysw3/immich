from __future__ import annotations

import json
import logging
import threading
import time
from dataclasses import dataclass, field
from datetime import datetime, timezone


class JsonFormatter(logging.Formatter):
    _BASE_KEYS = {
        "name",
        "msg",
        "args",
        "levelname",
        "levelno",
        "pathname",
        "filename",
        "module",
        "exc_info",
        "exc_text",
        "stack_info",
        "lineno",
        "funcName",
        "created",
        "msecs",
        "relativeCreated",
        "thread",
        "threadName",
        "processName",
        "process",
        "taskName",
    }

    def format(self, record: logging.LogRecord) -> str:
        payload: dict[str, object] = {
            "timestamp": datetime.fromtimestamp(record.created, tz=timezone.utc).isoformat(),
            "level": record.levelname,
            "logger": record.name,
            "message": record.getMessage(),
        }

        extras = {k: v for k, v in record.__dict__.items() if k not in self._BASE_KEYS}
        if extras:
            payload.update(extras)

        if record.exc_info:
            payload["exception"] = self.formatException(record.exc_info)

        return json.dumps(payload, ensure_ascii=True)


def configure_logging(level: str) -> None:
    root = logging.getLogger()
    root.handlers.clear()
    root.setLevel(getattr(logging, level.upper(), logging.INFO))

    handler = logging.StreamHandler()
    handler.setFormatter(JsonFormatter())
    root.addHandler(handler)


@dataclass(slots=True)
class Metrics:
    lock: threading.Lock = field(default_factory=threading.Lock)
    started_at: float = field(default_factory=time.time)
    processed_total: int = 0
    success_total: int = 0
    failed_total: int = 0
    skipped_total: int = 0
    retries_total: int = 0
    lines_total: int = 0
    processing_seconds_total: float = 0.0
    drift_count: int = 0
    last_processed_asset_id: str | None = None
    last_error: str | None = None

    def observe(self, asset_id: str, status: str, lines: int, duration_s: float, retries: int = 0) -> None:
        with self.lock:
            self.processed_total += 1
            self.processing_seconds_total += max(duration_s, 0.0)
            self.lines_total += max(lines, 0)
            self.retries_total += max(retries, 0)
            self.last_processed_asset_id = asset_id
            if status == "success":
                self.success_total += 1
            elif status == "failed":
                self.failed_total += 1
            elif status == "skipped":
                self.skipped_total += 1

    def set_last_error(self, text: str | None) -> None:
        with self.lock:
            self.last_error = text

    def set_drift_count(self, count: int) -> None:
        with self.lock:
            self.drift_count = max(0, count)

    def snapshot(self) -> dict[str, object]:
        with self.lock:
            processed = self.processed_total
            avg_latency = self.processing_seconds_total / processed if processed else 0.0
            uptime = max(0.0, time.time() - self.started_at)
            return {
                "uptimeSeconds": round(uptime, 3),
                "processedTotal": processed,
                "successTotal": self.success_total,
                "failedTotal": self.failed_total,
                "skippedTotal": self.skipped_total,
                "retriesTotal": self.retries_total,
                "linesTotal": self.lines_total,
                "processingSecondsTotal": round(self.processing_seconds_total, 3),
                "averageLatencySeconds": round(avg_latency, 3),
                "driftCount": self.drift_count,
                "lastProcessedAssetId": self.last_processed_asset_id,
                "lastError": self.last_error,
            }
