from __future__ import annotations

from dataclasses import dataclass, field

import torch
from PIL import Image
from transformers import TrOCRProcessor, VisionEncoderDecoderModel

from src.models import OcrBox, OcrLine


@dataclass(slots=True)
class TrOcrRecognizer:
    model_name: str
    batch_size: int = 16
    min_score: float = 0.6
    device: torch.device = field(init=False, repr=False)
    processor: TrOCRProcessor = field(init=False, repr=False)
    model: VisionEncoderDecoderModel = field(init=False, repr=False)

    def __post_init__(self) -> None:
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.processor = TrOCRProcessor.from_pretrained(self.model_name)
        self.model = VisionEncoderDecoderModel.from_pretrained(self.model_name).to(self.device)
        self.model.eval()

    def recognize(self, image: Image.Image, boxes: list[OcrBox]) -> list[OcrLine]:
        if not boxes:
            return []

        crops = [_crop(image, box) for box in boxes]
        results: list[OcrLine] = []

        for i in range(0, len(crops), self.batch_size):
            batch_crops = crops[i : i + self.batch_size]
            pixel_values = self.processor(batch_crops, return_tensors="pt", padding=True).pixel_values.to(self.device)
            with torch.no_grad():
                generated = self.model.generate(pixel_values, max_new_tokens=128)
            texts = self.processor.batch_decode(generated, skip_special_tokens=True)

            for idx, text in enumerate(texts):
                clean_text = text.strip()
                if not clean_text:
                    continue
                score = 1.0
                if score < self.min_score:
                    continue
                results.append(OcrLine(box=boxes[i + idx], text=clean_text, text_score=score))

        return results


def _crop(image: Image.Image, box: OcrBox) -> Image.Image:
    width, height = image.size
    xs = [box.x1, box.x2, box.x3, box.x4]
    ys = [box.y1, box.y2, box.y3, box.y4]

    left = max(int(min(xs) * width), 0)
    top = max(int(min(ys) * height), 0)
    right = min(int(max(xs) * width), width)
    bottom = min(int(max(ys) * height), height)

    if right <= left:
        right = min(left + 1, width)
    if bottom <= top:
        bottom = min(top + 1, height)

    return image.crop((left, top, right, bottom)).convert("RGB")
