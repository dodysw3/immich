from __future__ import annotations

from dataclasses import dataclass
from unittest.mock import patch

from PIL import Image

from src.surya_engine import SuryaEngine, _polygon_to_normalized_box


def test_polygon_to_normalized_box_basic() -> None:
    polygon = [[0, 0], [100, 0], [100, 50], [0, 50]]
    box = _polygon_to_normalized_box(polygon, width=200, height=100, confidence=0.9)

    assert box.x1 == 0.0
    assert box.y1 == 0.0
    assert box.x2 == 0.5
    assert box.y2 == 0.0
    assert box.x3 == 0.5
    assert box.y3 == 0.5
    assert box.x4 == 0.0
    assert box.y4 == 0.5
    assert box.box_score == 0.9


def test_polygon_to_normalized_box_full_image() -> None:
    polygon = [[0, 0], [800, 0], [800, 600], [0, 600]]
    box = _polygon_to_normalized_box(polygon, width=800, height=600, confidence=0.75)

    assert box.x1 == 0.0
    assert box.y1 == 0.0
    assert box.x2 == 1.0
    assert box.y2 == 0.0
    assert box.x3 == 1.0
    assert box.y3 == 1.0
    assert box.x4 == 0.0
    assert box.y4 == 1.0


def test_polygon_to_normalized_box_center_region() -> None:
    polygon = [[100, 50], [300, 50], [300, 150], [100, 150]]
    box = _polygon_to_normalized_box(polygon, width=400, height=200, confidence=0.85)

    assert box.x1 == 0.25
    assert box.y1 == 0.25
    assert box.x2 == 0.75
    assert box.y2 == 0.25
    assert box.x3 == 0.75
    assert box.y3 == 0.75
    assert box.x4 == 0.25
    assert box.y4 == 0.75


@dataclass
class FakeTextLine:
    text: str
    confidence: float
    polygon: list[list[float]]


@dataclass
class FakePage:
    text_lines: list[FakeTextLine]


def _make_engine(min_confidence: float = 0.3) -> SuryaEngine:
    """Create a SuryaEngine with mock predictors (no GPU required)."""
    return SuryaEngine(
        recognition_predictor=None,
        detection_predictor=None,
        min_confidence=min_confidence,
    )


def test_process_filters_low_confidence() -> None:
    engine = _make_engine(min_confidence=0.5)

    fake_pages = [
        FakePage(
            text_lines=[
                FakeTextLine(text="high conf", confidence=0.9, polygon=[[0, 0], [100, 0], [100, 50], [0, 50]]),
                FakeTextLine(text="low conf", confidence=0.2, polygon=[[0, 60], [100, 60], [100, 110], [0, 110]]),
                FakeTextLine(text="medium conf", confidence=0.5, polygon=[[0, 120], [100, 120], [100, 170], [0, 170]]),
            ]
        )
    ]

    def mock_predict(images, det_predictor=None):
        return fake_pages

    engine.recognition_predictor = mock_predict
    image = Image.new("RGB", (200, 200), color="white")
    lines = engine.process(image)

    assert len(lines) == 2
    assert lines[0].text == "high conf"
    assert lines[0].text_score == 0.9
    assert lines[1].text == "medium conf"
    assert lines[1].text_score == 0.5


def test_process_skips_empty_text() -> None:
    engine = _make_engine(min_confidence=0.0)

    fake_pages = [
        FakePage(
            text_lines=[
                FakeTextLine(text="", confidence=0.9, polygon=[[0, 0], [100, 0], [100, 50], [0, 50]]),
                FakeTextLine(text="   ", confidence=0.9, polygon=[[0, 60], [100, 60], [100, 110], [0, 110]]),
                FakeTextLine(text="valid", confidence=0.9, polygon=[[0, 120], [100, 120], [100, 170], [0, 170]]),
            ]
        )
    ]

    engine.recognition_predictor = lambda images, det_predictor=None: fake_pages
    image = Image.new("RGB", (200, 200), color="white")
    lines = engine.process(image)

    assert len(lines) == 1
    assert lines[0].text == "valid"


def test_process_zero_size_image_returns_empty() -> None:
    engine = _make_engine()
    image = Image.new("RGB", (0, 0))
    lines = engine.process(image)
    assert lines == []


def test_process_normalizes_coordinates() -> None:
    engine = _make_engine(min_confidence=0.0)

    fake_pages = [
        FakePage(
            text_lines=[
                FakeTextLine(text="hello", confidence=0.8, polygon=[[50, 25], [150, 25], [150, 75], [50, 75]]),
            ]
        )
    ]

    engine.recognition_predictor = lambda images, det_predictor=None: fake_pages
    image = Image.new("RGB", (200, 100), color="white")
    lines = engine.process(image)

    assert len(lines) == 1
    box = lines[0].box
    assert box.x1 == 0.25
    assert box.y1 == 0.25
    assert box.x2 == 0.75
    assert box.y2 == 0.25
    assert box.x3 == 0.75
    assert box.y3 == 0.75
    assert box.x4 == 0.25
    assert box.y4 == 0.75
