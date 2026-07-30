"""Lazy, model-aware registry of OCR engines.

Engines are NOT loaded at startup. The first request for a given model id
triggers a one-time load (under a lock) and the instance is reused afterwards.

Supported models (the first entry is the default used when a caller omits the
model):

  * ``unlimited-ocr`` — the baidu/Unlimited-OCR vision-language model (default)
  * ``surya``         — the surya-ocr detection+recognition engine

Every engine implements ``process(PIL.Image) -> list[OcrLine]``.
"""

from __future__ import annotations

import logging
import threading
from src.config import Config

logger = logging.getLogger(__name__)

# Ordered list; the first entry is the default.
SUPPORTED_MODELS: list[dict] = [
    {"id": "unlimited-ocr", "default": True, "description": "baidu/Unlimited-OCR vision-language model"},
    {"id": "surya", "default": False, "description": "surya-ocr detection + recognition"},
]


class EngineRegistry:
    def __init__(self, config: Config) -> None:
        self.config = config
        self._engines: dict[str, object] = {}
        self._lock = threading.Lock()

    @staticmethod
    def supported_models() -> list[dict]:
        return [dict(model) for model in SUPPORTED_MODELS]

    @staticmethod
    def default_model() -> str:
        return SUPPORTED_MODELS[0]["id"]

    @staticmethod
    def resolve(model_id: str | None) -> str:
        """Normalise a caller-supplied model id, applying the default when empty."""
        if model_id is None or not model_id.strip():
            return EngineRegistry.default_model()
        normalised = model_id.strip().lower()
        valid = {model["id"] for model in SUPPORTED_MODELS}
        if normalised not in valid:
            raise ValueError(f"Unsupported model '{model_id}'. Supported: {sorted(valid)}")
        return normalised

    def get(self, model_id: str | None) -> object:
        """Return the (lazily created) engine for the model id.

        To keep GPU memory predictable only one model is resident at a time:
        requesting a different model evicts the previously loaded one before the
        new one is created. Callers must hold an inference lock around get()+use
        (see ``src.ocr_server``) so an evicted engine is never used concurrently.
        """
        model_id = self.resolve(model_id)
        with self._lock:
            if model_id in self._engines:
                return self._engines[model_id]
            self._evict_others(model_id)
            logger.info("loading_ocr_engine", extra={"model": model_id})
            self._engines[model_id] = self._create(model_id)
            return self._engines[model_id]

    def _evict_others(self, keep: str) -> None:
        to_remove = [model for model in self._engines if model != keep]
        if not to_remove:
            return
        for model in to_remove:
            logger.info("unloading_ocr_engine", extra={"model": model})
            self._engines.pop(model, None)
        import gc
        import torch

        gc.collect()
        if torch.cuda.is_available():
            torch.cuda.empty_cache()

    def _create(self, model_id: str) -> object:
        if model_id == "unlimited-ocr":
            from src.unlimitedocr_engine import UnlimitedOcrEngine

            return UnlimitedOcrEngine.create(
                model_name=self.config.unlimited_ocr_model,
                device=self.config.ocr_device,
                max_length=self.config.unlimited_ocr_max_length,
            )

        if model_id == "surya":
            from src.surya_engine import SuryaEngine

            return SuryaEngine.create(
                min_confidence=self.config.ocr_recognition_threshold,
                recognition_batch_size=self.config.surya_recognition_batch_size,
                detection_batch_size=self.config.surya_detection_batch_size,
            )

        raise ValueError(f"Unsupported model '{model_id}'")
