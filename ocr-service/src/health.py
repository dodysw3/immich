from __future__ import annotations

import json
import logging
import threading
from datetime import datetime, timezone
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

from src.observability import Metrics

logger = logging.getLogger(__name__)


class HealthState:
    def __init__(self, metrics: Metrics, model_revision: str) -> None:
        self._lock = threading.Lock()
        self.started_at = datetime.now(timezone.utc)
        self.ready = False
        self.model_revision = model_revision
        self.metrics = metrics

    def set_ready(self, ready: bool) -> None:
        with self._lock:
            self.ready = ready

    def payload(self) -> dict[str, object]:
        with self._lock:
            return {
                "status": "ok" if self.ready else "starting",
                "ready": self.ready,
                "startedAt": self.started_at.isoformat(),
                "modelRevision": self.model_revision,
                "metrics": self.metrics.snapshot(),
            }


class HealthHandler(BaseHTTPRequestHandler):
    state: HealthState

    def do_GET(self) -> None:  # noqa: N802
        if self.path in {"/healthz", "/health"}:
            self._send_json(200, self.state.payload())
            return

        if self.path in {"/metrics", "/metrics.json"}:
            self._send_json(200, self.state.metrics.snapshot())
            return

        self._send_json(404, {"error": "not found"})

    def log_message(self, format: str, *args) -> None:  # noqa: A003
        logger.debug("health_request", extra={"request": format % args})

    def _send_json(self, status: int, payload: dict[str, object]) -> None:
        body = json.dumps(payload, ensure_ascii=True).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


def start_health_server(host: str, port: int, state: HealthState) -> ThreadingHTTPServer:
    handler = type("BoundHealthHandler", (HealthHandler,), {"state": state})
    server = ThreadingHTTPServer((host, port), handler)

    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    logger.info("Health server started", extra={"host": host, "port": port})
    return server
