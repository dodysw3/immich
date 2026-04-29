from __future__ import annotations

from dataclasses import dataclass, field
import logging
import os
from pathlib import Path
import threading

import cv2
import numpy as np
import onnxruntime as ort
from numpy.typing import NDArray
from PIL import Image
from rapidocr.ch_ppocr_det.utils import DBPostProcess
from rapidocr.inference_engine.base import FileInfo, InferSession
from rapidocr.utils.download_file import DownloadFile, DownloadFileInput
from rapidocr.utils.typings import EngineType, LangDet, OCRVersion, TaskType
from rapidocr.utils.typings import ModelType as RapidModelType

from src.models import OcrBox

logger = logging.getLogger(__name__)


@dataclass(slots=True)
class PaddleDetector:
    min_score: float = 0.3
    model_name: str = "PP-OCRv5_mobile"
    max_resolution: int = 736
    _postprocess: DBPostProcess = field(init=False, repr=False)
    _mean: NDArray[np.float32] = field(init=False, repr=False)
    _std_inv: NDArray[np.float32] = field(init=False, repr=False)
    _sessions: dict[str, ort.InferenceSession] = field(init=False, repr=False)
    _lock: threading.Lock = field(init=False, repr=False)

    def __post_init__(self) -> None:
        self._postprocess = DBPostProcess(
            thresh=0.3,
            box_thresh=self.min_score,
            max_candidates=1000,
            unclip_ratio=1.6,
            use_dilation=True,
            score_mode="fast",
        )
        self._mean = np.array([0.5, 0.5, 0.5], dtype=np.float32)
        self._std_inv = np.float32(1.0) / (np.array([0.5, 0.5, 0.5], dtype=np.float32) * 255.0)
        self._sessions = {}
        self._lock = threading.Lock()
        # Preload default detector so first request does not block.
        self._session_for(self.model_name)

    def detect(self, image: Image.Image, model_name: str | None = None) -> list[OcrBox]:
        if image.width < 32 or image.height < 32:
            return []

        session = self._session_for(model_name or self.model_name)
        original_w, original_h = image.size
        transformed = self._transform(image)
        output = session.run(None, {"x": transformed})[0]
        boxes, scores = self._postprocess(output, (original_h, original_w))
        if len(boxes) == 0:
            return []

        sorted_boxes = _sorted_boxes(np.array(boxes, dtype=np.float32))
        score_values = np.array(scores, dtype=np.float32)

        results: list[OcrBox] = []
        for polygon, score in zip(sorted_boxes, score_values, strict=False):
            if score < self.min_score:
                continue
            if polygon.shape != (4, 2):
                continue
            normalized = _normalize_polygon(polygon, original_w, original_h)
            results.append(OcrBox(*normalized, box_score=float(score)))
        return results

    def _transform(self, image: Image.Image) -> NDArray[np.float32]:
        if image.height < image.width:
            ratio = float(self.max_resolution) / image.height
        else:
            ratio = float(self.max_resolution) / image.width
        ratio = min(ratio, 1.0)

        resize_h = int(round((image.height * ratio) / 32) * 32)
        resize_w = int(round((image.width * ratio) / 32) * 32)
        resized = image.resize((max(32, resize_w), max(32, resize_h)), resample=Image.Resampling.LANCZOS)

        img_np: NDArray[np.float32] = cv2.cvtColor(np.array(resized, dtype=np.float32), cv2.COLOR_RGB2BGR)  # type: ignore
        img_np -= self._mean
        img_np *= self._std_inv
        img_np = np.transpose(img_np, (2, 0, 1))
        return np.expand_dims(img_np, axis=0)

    def _session_for(self, model_name: str) -> ort.InferenceSession:
        key = _det_model_key(model_name)
        with self._lock:
            session = self._sessions.get(key)
            if session is not None:
                return session

            model_path = _download_detection_model(key)
            providers = _providers()
            logger.info("loading_detection_model", extra={"model": key, "providers": providers})
            session = ort.InferenceSession(model_path.as_posix(), providers=providers)
            self._sessions[key] = session
            return session


def _normalize_polygon(polygon: NDArray[np.float32], width: int, height: int) -> tuple[float, float, float, float, float, float, float, float]:
    p = []
    for x, y in polygon.tolist():
        nx = min(max(float(x) / max(width, 1), 0.0), 1.0)
        ny = min(max(float(y) / max(height, 1), 0.0), 1.0)
        p.append((nx, ny))
    return (p[0][0], p[0][1], p[1][0], p[1][1], p[2][0], p[2][1], p[3][0], p[3][1])


def _det_model_key(model_name: str) -> str:
    if "__" in model_name:
        _, suffix = model_name.split("__", 1)
        return suffix
    return model_name


def _model_cache_dir() -> Path:
    return Path(os.getenv("OCR_MODEL_CACHE_DIR", "/root/.cache/rapidocr"))


def _download_detection_model(model_key: str) -> Path:
    model_type = RapidModelType.MOBILE if "mobile" in model_key.lower() else RapidModelType.SERVER
    model_info = InferSession.get_model_url(
        FileInfo(
            engine_type=EngineType.ONNXRUNTIME,
            ocr_version=OCRVersion.PPOCRV5,
            task_type=TaskType.DET,
            lang_type=LangDet.CH,
            model_type=model_type,
        )
    )

    model_path = _model_cache_dir() / "det" / f"{model_key}.onnx"
    model_path.parent.mkdir(parents=True, exist_ok=True)
    DownloadFile.run(
        DownloadFileInput(
            file_url=model_info["model_dir"],
            sha256=model_info["SHA256"],
            save_path=model_path,
            logger=logger,
        )
    )
    return model_path


def _providers() -> list[str]:
    available = set(ort.get_available_providers())
    preferred = ["CUDAExecutionProvider", "CPUExecutionProvider"]
    ordered = [provider for provider in preferred if provider in available]
    if ordered:
        return ordered
    return list(available)


def _sorted_boxes(dt_boxes: NDArray[np.float32]) -> NDArray[np.float32]:
    if len(dt_boxes) == 0:
        return dt_boxes

    y_order = np.argsort(dt_boxes[:, 0, 1], kind="stable")
    sorted_y = dt_boxes[y_order, 0, 1]

    line_ids = np.empty(len(dt_boxes), dtype=np.int32)
    line_ids[0] = 0
    np.cumsum(np.abs(np.diff(sorted_y)) >= 10, out=line_ids[1:])

    sort_key = line_ids[y_order] * 1e6 + dt_boxes[y_order, 0, 0]
    final_order = np.argsort(sort_key, kind="stable")
    return dt_boxes[y_order[final_order]]
