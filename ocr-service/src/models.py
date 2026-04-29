from __future__ import annotations

from dataclasses import dataclass


@dataclass(slots=True)
class OcrBox:
    x1: float
    y1: float
    x2: float
    y2: float
    x3: float
    y3: float
    x4: float
    y4: float
    box_score: float


@dataclass(slots=True)
class OcrLine:
    box: OcrBox
    text: str
    text_score: float

    def to_api_dict(self) -> dict:
        return {
            "x1": self.box.x1,
            "y1": self.box.y1,
            "x2": self.box.x2,
            "y2": self.box.y2,
            "x3": self.box.x3,
            "y3": self.box.y3,
            "x4": self.box.x4,
            "y4": self.box.y4,
            "boxScore": self.box.box_score,
            "textScore": self.text_score,
            "text": self.text,
        }
