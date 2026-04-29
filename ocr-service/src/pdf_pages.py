from __future__ import annotations

import logging

from PIL import Image

logger = logging.getLogger(__name__)


def extract_pdf_page_images(pdf_bytes: bytes, max_pages: int, dpi: int) -> list[Image.Image]:
    try:
        import pypdfium2 as pdfium
    except ImportError as error:
        raise RuntimeError("pypdfium2 is required for OCR_PDF_ENABLED=true") from error

    images: list[Image.Image] = []
    doc = pdfium.PdfDocument(pdf_bytes)
    try:
        page_count = min(len(doc), max_pages)
        scale = max(float(dpi) / 72.0, 1.0)
        for page_index in range(page_count):
            page = doc[page_index]
            bitmap = page.render(scale=scale)
            images.append(bitmap.to_pil().convert("RGB"))
    finally:
        doc.close()

    return images
