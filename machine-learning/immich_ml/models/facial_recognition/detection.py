from typing import Any

import cv2
import numpy as np
from numpy.typing import NDArray
from PIL.Image import Image

from immich_ml.config import log
from immich_ml.models.base import InferenceModel
from immich_ml.models.transforms import decode_pil, letterbox, normalize
from immich_ml.schemas import FaceDetectionOutput, ModelTask, ModelType
from immich_ml.sessions.ort import OrtSession

from ._ops import DET_SIZE, decode_scrfd, nms


class FaceDetector(InferenceModel):
    depends = []
    identity = (ModelType.DETECTION, ModelTask.FACIAL_RECOGNITION)

    def __init__(self, model_name: str, **model_kwargs: Any) -> None:
        self._tiled = False
        self._tile_size = 640
        self._tile_overlap = 0.25
        self._max_tiles = 64
        self._cpu_session: OrtSession | None = None
        super().__init__(model_name, **model_kwargs)

    def configure(self, **kwargs: Any) -> None:
        self._tiled = bool(kwargs.pop("tiled", self._tiled))
        self._tile_size = int(kwargs.pop("tileSize", self._tile_size))
        self._tile_overlap = float(kwargs.pop("tileOverlap", self._tile_overlap))
        self._max_tiles = int(kwargs.pop("maxTiles", self._max_tiles))

    def _run_session(
        self, image: Image | NDArray[np.uint8], min_score: float, session: OrtSession
    ) -> tuple[NDArray[np.float32], NDArray[np.float32], NDArray[np.float32]]:
        canvas, scale = letterbox(image, DET_SIZE)
        blob = normalize(canvas.astype(np.float32), mean=127.5, std=128).transpose(2, 0, 1)[None]

        input_name = session.get_inputs()[0].name
        heads = session.run(None, {input_name: blob})
        scores, boxes, kps = decode_scrfd(heads, DET_SIZE)

        candidates = scores >= min_score
        return scores[candidates], boxes[candidates] / scale, kps[candidates] / scale

    def _is_gpu_session(self) -> bool:
        try:
            providers = self.session.providers
        except AttributeError:
            return False
        return any(p in ("CUDAExecutionProvider", "ROCMExecutionProvider") for p in providers)

    def _ensure_cpu_session(self) -> OrtSession:
        if self._cpu_session is None:
            self._cpu_session = OrtSession(self.model_path, providers=["CPUExecutionProvider"])
        return self._cpu_session

    def _predict(self, inputs: NDArray[np.uint8] | bytes, minScore: float) -> FaceDetectionOutput:
        image = decode_pil(inputs)
        gpu_fallback = False

        if self._tiled:
            scores, boxes, kps = self._detect_tiled(image, minScore)
        else:
            scores, boxes, kps = self._run_session(image, minScore, self.session)

        if boxes.shape[0] == 0 and self._is_gpu_session():
            log.warning(
                "GPU returned 0 faces for %dx%d image (tiled=%s), trying CPU fallback",
                image.width,
                image.height,
                self._tiled,
            )
            cpu_scores, cpu_boxes, cpu_kps = self._run_session(image, minScore, self._ensure_cpu_session())
            if cpu_boxes.shape[0] > 0:
                log.warning(
                    "GPU face detection returned 0 faces but CPU found %d — GPU may be unhealthy",
                    cpu_boxes.shape[0],
                )
                scores, boxes, kps = cpu_scores, cpu_boxes, cpu_kps
                gpu_fallback = True

        keep = nms(boxes, scores)
        return {
            "boxes": boxes[keep].round(),
            "scores": scores[keep],
            "landmarks": kps[keep].reshape(-1, 5, 2),
            "gpuFallback": gpu_fallback,
        }

    def _detect_tiled(
        self, image: Image, min_score: float
    ) -> tuple[NDArray[np.float32], NDArray[np.float32], NDArray[np.float32]]:
        img = np.asarray(image)
        h, w = img.shape[:2]
        tile_size = self._tile_size
        stride = int(tile_size * (1 - self._tile_overlap))

        ys, xs = self._tile_positions(h, w, tile_size, stride)
        total_tiles = len(ys) * len(xs)

        if total_tiles > self._max_tiles:
            scale = (self._max_tiles / total_tiles) ** 0.5
            new_w = max(tile_size, int(w * scale))
            new_h = max(tile_size, int(h * scale))
            img = cv2.resize(img, (new_w, new_h))
            h, w = new_h, new_w
            ys, xs = self._tile_positions(h, w, tile_size, stride)

        all_scores: list[NDArray[np.float32]] = []
        all_boxes: list[NDArray[np.float32]] = []
        all_kps: list[NDArray[np.float32]] = []

        for y0 in ys:
            for x0 in xs:
                tile = img[y0 : y0 + tile_size, x0 : x0 + tile_size]
                scores, boxes, kps = self._run_session(tile, min_score, self.session)

                if boxes.shape[0] > 0:
                    boxes[:, 0::2] += x0
                    boxes[:, 1::2] += y0
                    kps[:, 0::2] += x0
                    kps[:, 1::2] += y0
                    all_scores.append(scores)
                    all_boxes.append(boxes)
                    all_kps.append(kps)

        if not all_boxes:
            empty_scores = np.zeros(0, dtype=np.float32)
            return empty_scores, np.zeros((0, 4), dtype=np.float32), np.zeros((0, 10), dtype=np.float32)

        return np.concatenate(all_scores), np.concatenate(all_boxes), np.concatenate(all_kps)

    @staticmethod
    def _tile_positions(h: int, w: int, tile_size: int, stride: int) -> tuple[list[int], list[int]]:
        def positions(length: int) -> list[int]:
            if length <= tile_size:
                return [0]
            pos = list(range(0, length - tile_size + 1, stride))
            if pos[-1] + tile_size < length:
                pos.append(length - tile_size)
            return pos

        return positions(h), positions(w)
