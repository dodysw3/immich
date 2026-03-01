from __future__ import annotations

import hashlib
import io
import logging

from PIL import Image

from src.client import ImmichClient
from src.config import Config
from src.detect import PaddleDetector
from src.model_policy import RecognizerRouter, select_model_for_asset
from src.models import OcrLine
from src.pdf_pages import extract_pdf_page_images
from src.postprocess import postprocess
from src.preprocess import preprocess, preprocess_light
from src.state import update_pending, update_success
from src.surya_engine import SuryaEngine
from src.tokenize import tokenize_for_search

logger = logging.getLogger(__name__)


def is_eligible_asset(asset: dict, config: Config) -> bool:
    if asset.get("deletedAt") is not None:
        return False
    if asset.get("visibility") == "hidden":
        return False

    asset_type = asset.get("type")
    if asset_type == "IMAGE":
        return True

    if config.ocr_pdf_enabled and _is_pdf_asset(asset):
        return True

    return False


def process_asset(
    api: ImmichClient,
    config: Config,
    detector: PaddleDetector | None,
    recognizer_router: RecognizerRouter | None,
    asset_id: str,
    surya_engine: SuryaEngine | None = None,
) -> tuple[str, int]:
    asset = api.get_asset(asset_id)
    if not is_eligible_asset(asset, config):
        logger.debug("Skipping %s: not eligible", asset_id)
        return "skipped", 0

    meta = api.get_asset_metadata(asset_id, "external.ocr.v1")
    is_edited = bool(asset.get("isEdited"))
    image_bytes = api.download_image(asset_id, is_edited)
    source_checksum = hashlib.sha256(image_bytes).hexdigest()

    if meta and meta.get("modelRevision") == config.ocr_model_revision and meta.get("sourceChecksum") == source_checksum:
        logger.debug("Skipping %s: already processed with revision %s", asset_id, config.ocr_model_revision)
        return "skipped", 0

    update_pending(config.db_url, asset_id, source_checksum, config.ocr_model_revision)

    if config.ocr_engine == "surya":
        assert surya_engine is not None
        if _is_pdf_asset(asset):
            lines = _process_pdf_asset_surya(image_bytes, config, surya_engine)
        else:
            image = Image.open(io.BytesIO(image_bytes))
            lines = _process_image_asset_surya(image, config, surya_engine)
        reason = "surya"
    else:
        assert detector is not None and recognizer_router is not None
        selection = select_model_for_asset(asset, config)
        recognizer = recognizer_router.get(selection.model_name)
        if _is_pdf_asset(asset):
            lines = _process_pdf_asset(image_bytes, config, detector, recognizer)
        else:
            image = Image.open(io.BytesIO(image_bytes))
            lines = _process_image_asset(image, config, detector, recognizer)
        reason = selection.reason

    if not lines:
        api.write_ocr_result(asset_id, lines=[], source_checksum=source_checksum, search_text="")
        update_success(config.db_url, asset_id, source_checksum, config.ocr_model_revision)
        logger.info("Processed %s: no text regions", asset_id)
        return "success", 0

    joined_text = " ".join(line.text for line in lines)
    search_text = tokenize_for_search(joined_text)
    api_lines = [line.to_api_dict() for line in lines]

    api.write_ocr_result(asset_id, lines=api_lines, source_checksum=source_checksum, search_text=search_text)
    update_success(config.db_url, asset_id, source_checksum, config.ocr_model_revision)

    logger.info("Processed %s: %s regions (%s)", asset_id, len(lines), reason)
    return "success", len(lines)


def _process_image_asset(
    image: Image.Image,
    config: Config,
    detector: PaddleDetector,
    recognizer,
) -> list[OcrLine]:
    image = preprocess(
        image,
        max_resolution=config.ocr_max_resolution,
        block_size=config.ocr_preprocess_block_size,
        threshold_c=config.ocr_preprocess_threshold_c,
        clahe_clip=config.ocr_preprocess_clahe_clip,
        unsharp_amount=config.ocr_preprocess_unsharp_amount,
    )

    boxes = detector.detect(image)
    if not boxes:
        return []

    lines: list[OcrLine] = recognizer.recognize(image, boxes)
    return postprocess(
        lines,
        layout_analysis_enabled=config.ocr_layout_analysis_enabled,
        layout_max_columns=config.ocr_layout_max_columns,
        layout_column_gap=config.ocr_layout_column_gap,
    )


def _process_pdf_asset(pdf_bytes: bytes, config: Config, detector: PaddleDetector, recognizer) -> list[OcrLine]:
    page_images = extract_pdf_page_images(pdf_bytes, max_pages=config.ocr_pdf_max_pages, dpi=config.ocr_pdf_dpi)
    merged: list[OcrLine] = []

    for page_index, page_image in enumerate(page_images, start=1):
        page_lines = _process_image_asset(page_image, config, detector, recognizer)
        if not page_lines:
            continue

        for line in page_lines:
            line.text = f"[p{page_index}] {line.text}"
            merged.append(line)

    return merged


def _process_image_asset_surya(
    image: Image.Image,
    config: Config,
    surya_engine: SuryaEngine,
) -> list[OcrLine]:
    image = preprocess_light(image, max_resolution=config.ocr_max_resolution)
    lines = surya_engine.process(image)
    if not lines:
        return []
    return postprocess(
        lines,
        layout_analysis_enabled=config.ocr_layout_analysis_enabled,
        layout_max_columns=config.ocr_layout_max_columns,
        layout_column_gap=config.ocr_layout_column_gap,
    )


def _process_pdf_asset_surya(pdf_bytes: bytes, config: Config, surya_engine: SuryaEngine) -> list[OcrLine]:
    page_images = extract_pdf_page_images(pdf_bytes, max_pages=config.ocr_pdf_max_pages, dpi=config.ocr_pdf_dpi)
    merged: list[OcrLine] = []

    for page_index, page_image in enumerate(page_images, start=1):
        page_lines = _process_image_asset_surya(page_image, config, surya_engine)
        if not page_lines:
            continue
        for line in page_lines:
            line.text = f"[p{page_index}] {line.text}"
            merged.append(line)

    return merged


def _is_pdf_asset(asset: dict) -> bool:
    file_name = str(asset.get("originalFileName") or "").lower()
    return asset.get("type") == "OTHER" and file_name.endswith(".pdf")
