"""HTTP OCR endpoint exposing one or more lazily-loaded OCR engines.

Endpoints
---------
``GET  /models`` (also ``/v1/models``)
    List supported models and the default. Clients use this to pick the value
    of the ``model`` parameter for ``POST /ocr``.

``POST /ocr`` (any path is accepted)
    Accepts ``multipart/form-data`` with a ``file`` part (an image, e.g. PNG) and
    an optional ``model`` field. The model may also be passed as a ``?model=``
    query parameter. When omitted, the default model
    (:func:`src.engines.EngineRegistry.default_model`) is used — currently
    ``unlimited-ocr``.

    Responds with ``{"text": "...", "model": "...", "lines": N}`` matching the
    Immich Unlimited-OCR provider contract.

Engines are loaded lazily on first use and shared across requests. Inference is
serialized with a lock so GPU memory stays predictable.
"""

from __future__ import annotations

import io
import json
import logging
import re
import threading
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse, parse_qs
from PIL import Image

from src.engines import EngineRegistry

logger = logging.getLogger(__name__)

MAX_IMAGE_BYTES = 32 * 1024 * 1024


def _extract_multipart(content_type: str, body: bytes) -> dict[str, bytes]:
    """Parse a multipart/form-data body into ``{field_name: value_bytes}``."""
    fields: dict[str, bytes] = {}
    match = re.search(r'boundary=("?)([^";]+)\1', content_type or "")
    if not match:
        return fields

    delimiter = b"--" + match.group(2).encode()
    for part in body.split(delimiter):
        if not part or part.startswith(b"--"):
            continue
        if part.startswith(b"\r\n"):
            part = part[2:]
        if part.endswith(b"\r\n"):
            part = part[:-2]
        header_blob, sep, value = part.partition(b"\r\n\r\n")
        if not sep:
            continue
        name_match = re.search(rb'name="([^"]+)"', header_blob)
        if not name_match:
            continue
        fields[name_match.group(1).decode("utf-8", "replace")] = value
    return fields


class OcrHandler(BaseHTTPRequestHandler):
    registry: EngineRegistry = None  # type: ignore[assignment]
    max_resolution: int = 4032
    # Serializes model selection (which may load/evict) and inference so that an
    # evicted engine is never used by a concurrent request.
    _handler_lock = threading.Lock()
    protocol_version = "HTTP/1.1"

    # --- helpers -----------------------------------------------------------

    def _send_json(self, status: int, payload: dict) -> None:
        data = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def _read_body(self) -> bytes:
        length = int(self.headers.get("Content-Length", "0"))
        if length <= 0:
            return b""
        return self.rfile.read(length)

    def _select_model(self, form_fields: dict[str, bytes]) -> str:
        query = parse_qs(urlparse(self.path).query)
        model = query.get("model", [None])[0]
        if model is None:
            raw = form_fields.get("model")
            if raw is not None:
                model = raw.decode("utf-8", "replace")
        return self.registry.resolve(model)

    # --- routes ------------------------------------------------------------

    def do_GET(self) -> None:  # noqa: N802
        path = urlparse(self.path).path
        if path in ("/", "/healthz", "/health"):
            self._send_json(200, {"status": "ok"})
            return
        if path in ("/models", "/v1/models"):
            models = self.registry.supported_models()
            self._send_json(200, {"default": self.registry.default_model(), "models": models})
            return
        self._send_json(404, {"error": "not found"})

    def do_POST(self) -> None:  # noqa: N802
        try:
            body = self._read_body()
            if len(body) > MAX_IMAGE_BYTES:
                self._send_json(400, {"error": "request too large"})
                return

            fields = _extract_multipart(self.headers.get("Content-Type", ""), body)
            file_bytes = fields.get("file")
            if file_bytes is None:
                # Allow a raw image body as a fallback.
                file_bytes = body
            if not file_bytes:
                self._send_json(400, {"error": "no image payload"})
                return

            image = Image.open(io.BytesIO(file_bytes)).convert("RGB")
            if self.max_resolution and max(image.size) > self.max_resolution:
                # Downscale very large inputs; engines handle their own resizing
                # below this ceiling.
                ratio = self.max_resolution / max(image.size)
                image = image.resize((max(1, int(image.width * ratio)), max(1, int(image.height * ratio))))

            # Model selection may load a (different) model and evict the previous
            # one; hold the lock across load + inference so no other request uses
            # an engine that is being evicted.
            with self._handler_lock:
                model_id = self._select_model(fields)
                engine = self.registry.get(model_id)
                lines = engine.process(image)
            text = "\n".join(line.text for line in lines if line.text).strip()

            logger.info("ocr_request_ok", extra={"model": model_id, "chars": len(text), "lines": len(lines)})
            self._send_json(200, {"text": text, "markdown": text, "model": model_id, "lines": len(lines)})
        except ValueError as error:
            logger.warning("ocr_request_bad_model", extra={"error": str(error)})
            self._send_json(400, {"error": str(error)})
        except Exception as error:  # pylint: disable=broad-except
            logger.exception("ocr_request_failed", extra={"error": str(error)})
            self._send_json(500, {"error": str(error)})

    def log_message(self, format: str, *args) -> None:  # noqa: A002
        logger.debug("ocr_http_request", extra={"request": format % args})


def start_ocr_server(host: str, port: int, registry: EngineRegistry, max_resolution: int = 4032) -> ThreadingHTTPServer:
    handler = type(
        "BoundOcrHandler",
        (OcrHandler,),
        {"registry": registry, "max_resolution": max_resolution},
    )
    server = ThreadingHTTPServer((host, port), handler)
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    logger.info("ocr_server_started", extra={"host": host, "port": port})
    return server
