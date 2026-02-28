from src.models import OcrBox, OcrLine
from src.postprocess import postprocess


def _line(text: str, left: float, top: float, right: float, bottom: float) -> OcrLine:
    return OcrLine(
        box=OcrBox(x1=left, y1=top, x2=right, y2=top, x3=right, y3=bottom, x4=left, y4=bottom, box_score=0.9),
        text=text,
        text_score=0.8,
    )


def test_postprocess_merges_close_lines_on_same_row() -> None:
    lines = [
        _line("Hello", 0.10, 0.10, 0.20, 0.14),
        _line("World", 0.21, 0.10, 0.35, 0.14),
    ]
    result = postprocess(lines)
    assert len(result) == 1
    assert result[0].text == "Hello World"


def test_postprocess_removes_exact_duplicates() -> None:
    lines = [
        _line("Repeated", 0.10, 0.20, 0.30, 0.24),
        _line("Repeated", 0.10, 0.20, 0.30, 0.24),
    ]
    result = postprocess(lines)
    assert len(result) == 1
    assert result[0].text == "Repeated"


def test_postprocess_layout_orders_by_column_then_row() -> None:
    lines = [
        _line("L2", 0.10, 0.30, 0.20, 0.34),
        _line("R1", 0.70, 0.10, 0.80, 0.14),
        _line("L1", 0.10, 0.10, 0.20, 0.14),
        _line("R2", 0.70, 0.30, 0.80, 0.34),
    ]
    result = postprocess(lines, layout_analysis_enabled=True, layout_max_columns=2, layout_column_gap=0.2)
    assert [item.text for item in result] == ["L1", "L2", "R1", "R2"]
