from __future__ import annotations

import argparse
import io
import json
import logging
from difflib import SequenceMatcher

from PIL import Image

from src.client import ImmichClient
from src.config import Config
from src.detect import PaddleDetector
from src.model_policy import RecognizerRouter, select_model_for_asset
from src.observability import configure_logging
from src.pdf_pages import extract_pdf_page_images
from src.postprocess import postprocess
from src.preprocess import preprocess
from src.tokenize import tokenize_for_search

logger = logging.getLogger(__name__)


def _collect_asset_ids(args: argparse.Namespace) -> list[str]:
    ids = list(args.asset_id or [])
    if args.asset_file:
        with open(args.asset_file, "r", encoding="utf-8") as f:
            for line in f:
                value = line.strip()
                if value:
                    ids.append(value)
    return list(dict.fromkeys(ids))[: args.limit]


def _text_stats(text: str) -> dict[str, int]:
    words = [w for w in text.split() if w]
    return {
        "chars": len(text),
        "words": len(words),
        "uniqueWords": len(set(words)),
    }


def _simulate_external_text(
    api: ImmichClient,
    config: Config,
    detector: PaddleDetector,
    recognizer_router: RecognizerRouter,
    asset_id: str,
    asset: dict,
) -> tuple[str, int, str, str]:
    selection = select_model_for_asset(asset, config)
    recognizer = recognizer_router.get(selection.model_name)
    source_bytes = api.download_original(asset_id)

    images: list[Image.Image] = []
    if _is_pdf_asset(asset):
        images = extract_pdf_page_images(source_bytes, max_pages=config.ocr_pdf_max_pages, dpi=config.ocr_pdf_dpi)
    else:
        images = [Image.open(io.BytesIO(source_bytes))]

    merged_lines = []
    for image in images:
        processed_image = preprocess(
            image,
            max_resolution=config.ocr_max_resolution,
            block_size=config.ocr_preprocess_block_size,
            threshold_c=config.ocr_preprocess_threshold_c,
            clahe_clip=config.ocr_preprocess_clahe_clip,
            unsharp_amount=config.ocr_preprocess_unsharp_amount,
        )
        boxes = detector.detect(processed_image)
        if not boxes:
            continue
        page_lines = recognizer.recognize(processed_image, boxes)
        page_lines = postprocess(
            page_lines,
            layout_analysis_enabled=config.ocr_layout_analysis_enabled,
            layout_max_columns=config.ocr_layout_max_columns,
            layout_column_gap=config.ocr_layout_column_gap,
        )
        merged_lines.extend(page_lines)

    if not merged_lines:
        return "", 0, selection.model_name, f"{selection.reason}:no-text"

    text = " ".join(line.text for line in merged_lines)
    return text, len(merged_lines), selection.model_name, selection.reason


def _is_pdf_asset(asset: dict) -> bool:
    file_name = str(asset.get("originalFileName") or "").lower()
    return asset.get("type") == "OTHER" and file_name.endswith(".pdf")


def main() -> None:
    parser = argparse.ArgumentParser(description="A/B compare existing OCR text with external OCR simulation")
    parser.add_argument("--asset-id", action="append", default=[], help="Asset ID to evaluate (repeatable)")
    parser.add_argument("--asset-file", help="Text file containing one asset ID per line")
    parser.add_argument("--limit", type=int, default=100, help="Maximum number of assets")
    parser.add_argument("--output", help="Write JSON report to file")
    args = parser.parse_args()

    config = Config.from_env()
    config.validate()
    configure_logging(config.log_level)

    asset_ids = _collect_asset_ids(args)
    if not asset_ids:
        raise ValueError("No asset IDs provided")

    api = ImmichClient(config.immich_url, config.immich_api_key, config.ocr_model_revision)
    detector = PaddleDetector(min_score=config.ocr_detection_threshold)
    recognizer_router = RecognizerRouter(config)

    items: list[dict] = []
    for asset_id in asset_ids:
        asset = api.get_asset(asset_id)
        existing_rows = api.get_asset_ocr(asset_id)
        existing_text = " ".join(row.get("text", "") for row in existing_rows if row.get("text"))

        external_text, external_lines, model_name, model_reason = _simulate_external_text(
            api, config, detector, recognizer_router, asset_id, asset
        )
        similarity = SequenceMatcher(a=existing_text, b=external_text).ratio()

        items.append(
            {
                "assetId": asset_id,
                "existing": {
                    **_text_stats(existing_text),
                    "lines": len(existing_rows),
                    "tokenizedChars": len(tokenize_for_search(existing_text)),
                },
                "external": {
                    **_text_stats(external_text),
                    "lines": external_lines,
                    "tokenizedChars": len(tokenize_for_search(external_text)),
                    "modelName": model_name,
                    "modelReason": model_reason,
                },
                "similarity": round(similarity, 4),
            }
        )

    summary = {
        "count": len(items),
        "avgSimilarity": round(sum(item["similarity"] for item in items) / len(items), 4),
        "items": items,
    }

    output = json.dumps(summary, ensure_ascii=True, indent=2)
    if args.output:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(output)
    else:
        print(output)


if __name__ == "__main__":
    main()
