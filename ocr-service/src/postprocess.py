from __future__ import annotations

import unicodedata

from src.models import OcrBox, OcrLine


def _top(line: OcrLine) -> float:
    return min(line.box.y1, line.box.y2, line.box.y3, line.box.y4)


def _left(line: OcrLine) -> float:
    return min(line.box.x1, line.box.x2, line.box.x3, line.box.x4)


def _right(line: OcrLine) -> float:
    return max(line.box.x1, line.box.x2, line.box.x3, line.box.x4)


def _bottom(line: OcrLine) -> float:
    return max(line.box.y1, line.box.y2, line.box.y3, line.box.y4)


def _height(line: OcrLine) -> float:
    return max(0.0, _bottom(line) - _top(line))


def _vertical_overlap_ratio(a: OcrLine, b: OcrLine) -> float:
    overlap = max(0.0, min(_bottom(a), _bottom(b)) - max(_top(a), _top(b)))
    denom = max(1e-6, min(_height(a), _height(b)))
    return overlap / denom


def _normalize_text(text: str) -> str:
    text = unicodedata.normalize("NFC", text)
    return " ".join(text.strip().split())


def _should_merge(current: OcrLine, candidate: OcrLine) -> bool:
    if _left(candidate) < _left(current):
        return False

    gap = _left(candidate) - _right(current)
    max_gap = max(0.02, 1.2 * ((_height(current) + _height(candidate)) / 2.0))
    return _vertical_overlap_ratio(current, candidate) >= 0.5 and gap <= max_gap


def _merge_pair(a: OcrLine, b: OcrLine) -> OcrLine:
    x1 = min(_left(a), _left(b))
    y1 = min(_top(a), _top(b))
    x2 = max(_right(a), _right(b))
    y2 = y1
    x3 = x2
    y3 = max(_bottom(a), _bottom(b))
    x4 = x1
    y4 = y3

    merged_score = max(0.0, min(1.0, (a.text_score + b.text_score) / 2.0))
    merged_box_score = max(0.0, min(1.0, (a.box.box_score + b.box.box_score) / 2.0))

    return OcrLine(
        box=OcrBox(x1=x1, y1=y1, x2=x2, y2=y2, x3=x3, y3=y3, x4=x4, y4=y4, box_score=merged_box_score),
        text=f"{a.text} {b.text}".strip(),
        text_score=merged_score,
    )


def _layout_order(lines: list[OcrLine], max_columns: int, column_gap: float) -> list[OcrLine]:
    if len(lines) < 3 or max_columns <= 1:
        return sorted(lines, key=lambda line: (_top(line), _left(line)))

    by_left = sorted(lines, key=lambda line: _left(line))
    left_values = [_left(line) for line in by_left]
    gaps = [(left_values[i + 1] - left_values[i], i) for i in range(len(left_values) - 1)]
    large_gaps = [(gap, idx) for gap, idx in gaps if gap >= column_gap]

    if not large_gaps:
        return sorted(lines, key=lambda line: (_top(line), _left(line)))

    large_gaps.sort(reverse=True)
    split_positions = sorted(idx + 1 for _, idx in large_gaps[: max_columns - 1])

    columns: list[list[OcrLine]] = []
    start = 0
    for split in split_positions:
        columns.append(by_left[start:split])
        start = split
    columns.append(by_left[start:])

    ordered: list[OcrLine] = []
    for column in columns:
        ordered.extend(sorted(column, key=lambda line: (_top(line), _left(line))))

    return ordered


def postprocess(
    lines: list[OcrLine],
    layout_analysis_enabled: bool = True,
    layout_max_columns: int = 3,
    layout_column_gap: float = 0.12,
) -> list[OcrLine]:
    normalized: list[OcrLine] = []
    for line in lines:
        text = _normalize_text(line.text)
        if not text:
            continue
        normalized.append(OcrLine(box=line.box, text=text, text_score=line.text_score))

    if not normalized:
        return []

    ordered = sorted(normalized, key=lambda line: (_top(line), _left(line)))

    merged: list[OcrLine] = []
    current = ordered[0]
    for candidate in ordered[1:]:
        if _should_merge(current, candidate):
            current = _merge_pair(current, candidate)
        else:
            merged.append(current)
            current = candidate
    merged.append(current)

    dedup: list[OcrLine] = []
    seen: set[tuple[str, int, int]] = set()
    for line in merged:
        key = (line.text, int(_top(line) * 1000), int(_left(line) * 1000))
        if key in seen:
            continue
        seen.add(key)
        dedup.append(line)

    if layout_analysis_enabled:
        return _layout_order(dedup, max_columns=layout_max_columns, column_gap=layout_column_gap)

    return sorted(dedup, key=lambda line: (_top(line), _left(line)))
