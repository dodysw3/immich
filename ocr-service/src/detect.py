from __future__ import annotations

from dataclasses import dataclass
from typing import Any

import numpy as np
from paddleocr import PaddleOCR
from PIL import Image

from src.models import OcrBox


@dataclass(slots=True)
class PaddleDetector:
    min_score: float = 0.3

    def __post_init__(self) -> None:
        self._ocr = PaddleOCR(use_angle_cls=True, lang="en", use_gpu=False, det=True, rec=False, cls=True)

    def detect(self, image: Image.Image) -> list[OcrBox]:
        width, height = image.size
        image_array = np.array(image.convert("RGB"))
        result = self._ocr.ocr(image_array, det=True, rec=False, cls=True)

        page = result[0] if result and isinstance(result[0], list) else []
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
