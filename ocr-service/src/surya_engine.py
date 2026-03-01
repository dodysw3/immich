from __future__ import annotations

import logging
import os
from dataclasses import dataclass

from PIL import Image

from src.models import OcrBox, OcrLine

logger = logging.getLogger(__name__)


def _set_batch_env(recognition_batch_size: int, detection_batch_size: int) -> None:
    """Set batch-size env vars before importing surya (it reads them at import time)."""
    os.environ.setdefault("RECOGNITION_BATCH_SIZE", str(recognition_batch_size))
    os.environ.setdefault("DETECTOR_BATCH_SIZE", str(detection_batch_size))


@dataclass(slots=True)
class SuryaEngine:
    recognition_predictor: object
    detection_predictor: object
    min_confidence: float

    @classmethod
    def create(
        cls,
        min_confidence: float = 0.3,
        recognition_batch_size: int = 4,
        detection_batch_size: int = 2,
    ) -> SuryaEngine:
        _set_batch_env(recognition_batch_size, detection_batch_size)

        from surya.detection import DetectionPredictor
        from surya.foundation import FoundationPredictor
        from surya.recognition import RecognitionPredictor

        foundation_predictor = FoundationPredictor()
        detection_predictor = DetectionPredictor()
        recognition_predictor = RecognitionPredictor(foundation_predictor)

        logger.info(
            "surya_models_loaded",
            extra={
                "recognitionBatchSize": recognition_batch_size,
                "detectionBatchSize": detection_batch_size,
            },
        )
        return cls(
            recognition_predictor=recognition_predictor,
            detection_predictor=detection_predictor,
            min_confidence=min_confidence,
        )

    def process(self, image: Image.Image) -> list[OcrLine]:
        width, height = image.size
        if width == 0 or height == 0:
            return []

        predictions = self.recognition_predictor(
            [image],
            det_predictor=self.detection_predictor,
        )

        lines: list[OcrLine] = []
        for page in predictions:
            for text_line in page.text_lines:
                text = (text_line.text or "").strip()
                if not text:
                    continue

                confidence = getattr(text_line, "confidence", 0.0)
                if confidence < self.min_confidence:
                    continue

                polygon = text_line.polygon
                box = _polygon_to_normalized_box(polygon, width, height, confidence)
                lines.append(OcrLine(box=box, text=text, text_score=confidence))

        return lines


def _polygon_to_normalized_box(
    polygon: list[list[float]],
    width: int,
    height: int,
    confidence: float,
) -> OcrBox:
    """Convert Surya pixel-coordinate polygon (4 points) to normalized 0-1 OcrBox."""
    # polygon is [[x1,y1], [x2,y2], [x3,y3], [x4,y4]] in pixel coords
    # Pad to 4 points if needed (shouldn't happen, but defensive)
    while len(polygon) < 4:
        polygon.append(polygon[-1])

    return OcrBox(
        x1=polygon[0][0] / width,
        y1=polygon[0][1] / height,
        x2=polygon[1][0] / width,
        y2=polygon[1][1] / height,
        x3=polygon[2][0] / width,
        y3=polygon[2][1] / height,
        x4=polygon[3][0] / width,
        y4=polygon[3][1] / height,
        box_score=confidence,
    )
