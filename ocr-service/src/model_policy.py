from __future__ import annotations

import threading
from dataclasses import dataclass
from typing import TYPE_CHECKING

from src.config import Config

if TYPE_CHECKING:
    from src.recognize import TrOcrRecognizer


@dataclass(slots=True)
class ModelSelection:
    model_name: str
    reason: str


class RecognizerRouter:
    def __init__(self, config: Config) -> None:
        self.config = config
        self._lock = threading.Lock()
        self._cache: dict[str, "TrOcrRecognizer"] = {}

    def get(self, model_name: str | None = None) -> "TrOcrRecognizer":
        key = model_name or self.config.ocr_model_name
        with self._lock:
            recognizer = self._cache.get(key)
            if recognizer is None:
                from src.recognize import TrOcrRecognizer

                recognizer = TrOcrRecognizer(
                    model_name=key,
                    batch_size=self.config.ocr_batch_size,
                    min_score=self.config.ocr_recognition_threshold,
                )
                self._cache[key] = recognizer
            return recognizer


def select_model_for_asset(asset: dict, config: Config) -> ModelSelection:
    policy = config.ocr_model_policy
    tag_policy = policy.get("tag", {})
    library_policy = policy.get("library", {})

    tags = _extract_tag_names(asset)
    for tag_name in sorted(tags):
        model = tag_policy.get(tag_name)
        if model:
            return ModelSelection(model_name=model, reason=f"tag:{tag_name}")

    library_id = _extract_library_id(asset)
    if library_id:
        model = library_policy.get(library_id)
        if model:
            return ModelSelection(model_name=model, reason=f"library:{library_id}")

    default_policy_model = policy.get("default")
    if default_policy_model:
        return ModelSelection(model_name=default_policy_model, reason="policy-default")

    return ModelSelection(model_name=config.ocr_model_name, reason="config-default")


def _extract_tag_names(asset: dict) -> set[str]:
    tags: set[str] = set()
    for item in asset.get("tags") or []:
        if not isinstance(item, dict):
            continue
        name = item.get("name")
        if isinstance(name, str) and name.strip():
            tags.add(name.strip().lower())
    return tags


def _extract_library_id(asset: dict) -> str | None:
    value = asset.get("libraryId")
    if isinstance(value, str) and value:
        return value

    library = asset.get("library")
    if isinstance(library, dict):
        lib_id = library.get("id")
        if isinstance(lib_id, str) and lib_id:
            return lib_id

    return None
