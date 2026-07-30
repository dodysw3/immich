"""OCR engine backed by the baidu/Unlimited-OCR vision-language model.

Loaded lazily via :class:`src.engines.EngineRegistry`. The model is a HF
transformers model that uses custom code (``trust_remote_code=True``) and runs
in bf16 on CUDA. ``model.infer(...)`` writes the parsed text to
``<output_path>/result.md`` and returns ``None``; this engine reads that file and
returns the content as a single page-spanning :class:`OcrLine`.
"""

from __future__ import annotations

import logging
import os
import tempfile
from dataclasses import dataclass
from PIL import Image

from src.models import OcrBox, OcrLine

logger = logging.getLogger(__name__)


@dataclass(slots=True)
class UnlimitedOcrEngine:
    model: object
    tokenizer: object
    device: str
    max_length: int
    base_size: int = 1024
    image_size: int = 640
    crop_mode: bool = True
    prompt: str = "<image>document parsing."
    no_repeat_ngram_size: int = 35
    ngram_window: int = 128

    @classmethod
    def create(
        cls,
        model_name: str = "baidu/Unlimited-OCR",
        device: str = "cuda",
        max_length: int = 8192,
    ) -> UnlimitedOcrEngine:
        import torch
        from transformers import AutoModel, AutoTokenizer

        tokenizer = AutoTokenizer.from_pretrained(model_name, trust_remote_code=True)
        model = (
            AutoModel.from_pretrained(
                model_name,
                trust_remote_code=True,
                use_safetensors=True,
                dtype=torch.bfloat16,
            )
            .eval()
            .to(device)
        )
        logger.info("unlimited_ocr_loaded", extra={"model": model_name, "device": device})
        return cls(model=model, tokenizer=tokenizer, device=device, max_length=max_length)

    def process(self, image: Image.Image) -> list[OcrLine]:
        with tempfile.TemporaryDirectory(prefix="uocr_") as tmp:
            image_path = os.path.join(tmp, "page.png")
            image.convert("RGB").save(image_path)

            output_dir = os.path.join(tmp, "out")
            os.makedirs(output_dir, exist_ok=True)

            self.model.infer(
                self.tokenizer,
                prompt=self.prompt,
                image_file=image_path,
                output_path=output_dir,
                base_size=self.base_size,
                image_size=self.image_size,
                crop_mode=self.crop_mode,
                max_length=self.max_length,
                no_repeat_ngram_size=self.no_repeat_ngram_size,
                ngram_window=self.ngram_window,
                save_results=True,
            )

            text = ""
            result_path = os.path.join(output_dir, "result.md")
            if os.path.exists(result_path):
                with open(result_path, encoding="utf-8", errors="ignore") as handle:
                    text = handle.read().strip()

        if not text:
            return []

        # The VLM returns page-level text (no per-line boxes here). Emit one line
        # spanning the whole page so downstream code keeps a uniform shape.
        box = OcrBox(x1=0.0, y1=0.0, x2=1.0, y2=0.0, x3=1.0, y3=1.0, x4=0.0, y4=1.0, box_score=1.0)
        return [OcrLine(box=box, text=text, text_score=1.0)]
