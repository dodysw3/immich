from __future__ import annotations

from dataclasses import dataclass, field
import logging
import re
from typing import Any

import numpy as np
from paddleocr import PaddleOCR
from PIL import Image

from src.models import OcrBox

logger = logging.getLogger(__name__)
_UNKNOWN_ARGUMENT_PATTERN = re.compile(r"Unknown argument:\s*([A-Za-z_]\w*)")
_UNEXPECTED_KEYWORD_PATTERN = re.compile(r"unexpected keyword argument ['\"]([A-Za-z_]\w*)['\"]")


@dataclass(slots=True)
class PaddleDetector:
    min_score: float = 0.3
    _ocr: Any = field(init=False, repr=False)
    _ocr_call_kwargs: dict[str, Any] = field(init=False, repr=False)

    def __post_init__(self) -> None:
        self._ocr = _create_ocr_engine(
            use_angle_cls=True,
            lang="en",
            use_gpu=False,
            det=True,
            rec=False,
            cls=True,
        )
        self._ocr_call_kwargs = {"det": True, "rec": False, "cls": True}

    def detect(self, image: Image.Image) -> list[OcrBox]:
        width, height = image.size
        image_array = np.array(image.convert("RGB"))
        try:
            result, self._ocr_call_kwargs = _run_ocr(self._ocr, image_array, self._ocr_call_kwargs)
            page = _extract_page(result)
        except ValueError as error:
            if not _is_ambiguous_truth_value(error):
                raise
            logger.warning("PaddleOCR.ocr failed with numpy truth-value error; falling back to text_detector")
            page = _run_text_detector(self._ocr, image_array)

        boxes: list[OcrBox] = []
        for item in page:
            polygon, score = _extract_polygon_and_score(item)
            if not polygon or score < self.min_score:
                continue

            normalized = _normalize_quad(polygon, width, height)
            area = _quad_area(normalized)
            if area < 0.001:
                continue
            boxes.append(OcrBox(*normalized, box_score=score))

        boxes.sort(key=lambda box: (min(box.y1, box.y2, box.y3, box.y4), min(box.x1, box.x2, box.x3, box.x4)))
        return boxes


def _extract_polygon_and_score(item: Any) -> tuple[list[list[float]] | None, float]:
    if not isinstance(item, (list, tuple)) or not item:
        return None, 0.0

    polygon = item[0] if isinstance(item[0], (list, tuple)) else None
    score = 1.0

    if len(item) > 1:
        second = item[1]
        if isinstance(second, (int, float)):
            score = float(second)
        elif isinstance(second, (list, tuple)) and len(second) > 1 and isinstance(second[1], (int, float)):
            score = float(second[1])

    return list(polygon) if polygon else None, score


def _extract_page(result: Any) -> list[Any]:
    if isinstance(result, list) and result and isinstance(result[0], list):
        return result[0]
    return []


def _normalize_quad(polygon: list[list[float]], width: int, height: int) -> tuple[float, float, float, float, float, float, float, float]:
    if len(polygon) < 4:
        raise ValueError("expected 4-point polygon")

    points = []
    for x, y in polygon[:4]:
        nx = min(max(float(x) / width, 0.0), 1.0)
        ny = min(max(float(y) / height, 0.0), 1.0)
        points.append((nx, ny))

    return (
        points[0][0],
        points[0][1],
        points[1][0],
        points[1][1],
        points[2][0],
        points[2][1],
        points[3][0],
        points[3][1],
    )


def _quad_area(coords: tuple[float, float, float, float, float, float, float, float]) -> float:
    x = [coords[0], coords[2], coords[4], coords[6]]
    y = [coords[1], coords[3], coords[5], coords[7]]
    area = 0.0
    for i in range(4):
        j = (i + 1) % 4
        area += x[i] * y[j] - x[j] * y[i]
    return abs(area) / 2.0


def _create_ocr_engine(**kwargs: Any) -> PaddleOCR:
    engine_kwargs = dict(kwargs)
    while True:
        try:
            return PaddleOCR(**engine_kwargs)
        except ValueError as error:
            unknown_key = _extract_unknown_keyword(error)
            if unknown_key and unknown_key in engine_kwargs:
                removed = engine_kwargs.pop(unknown_key)
                logger.warning("PaddleOCR init ignored unsupported arg %s=%r", unknown_key, removed)
                continue
            raise


def _run_ocr(ocr_engine: PaddleOCR, image_array: np.ndarray, kwargs: dict[str, Any]) -> tuple[Any, dict[str, Any]]:
    call_kwargs = dict(kwargs)
    while True:
        try:
            return ocr_engine.ocr(image_array, **call_kwargs), call_kwargs
        except (TypeError, ValueError) as error:
            unknown_key = _extract_unknown_keyword(error)
            if unknown_key and unknown_key in call_kwargs:
                removed = call_kwargs.pop(unknown_key)
                logger.warning("PaddleOCR.ocr ignored unsupported arg %s=%r", unknown_key, removed)
                continue
            raise


def _run_text_detector(ocr_engine: PaddleOCR, image_array: np.ndarray) -> list[Any]:
    detector = getattr(ocr_engine, "text_detector", None)
    if detector is None:
        return []

    detected = detector(image_array)
    dt_boxes = detected[0] if isinstance(detected, tuple) else detected
    if dt_boxes is None:
        return []

    if isinstance(dt_boxes, np.ndarray):
        polygons = dt_boxes.tolist()
    else:
        polygons = list(dt_boxes)

    page: list[Any] = []
    for polygon in polygons:
        if isinstance(polygon, np.ndarray):
            polygon = polygon.tolist()
        page.append([polygon, 1.0])
    return page


def _extract_unknown_keyword(error: Exception) -> str | None:
    text = str(error)
    for pattern in (_UNKNOWN_ARGUMENT_PATTERN, _UNEXPECTED_KEYWORD_PATTERN):
        match = pattern.search(text)
        if match:
            return match.group(1)
    return None


def _is_ambiguous_truth_value(error: ValueError) -> bool:
    return "truth value of an array with more than one element is ambiguous" in str(error)
