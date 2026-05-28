from typing import Any

import cv2
import numpy as np
from insightface.model_zoo import RetinaFace
from numpy.typing import NDArray

from immich_ml.config import log
from immich_ml.models.base import InferenceModel
from immich_ml.models.transforms import decode_cv2
from immich_ml.schemas import FaceDetectionOutput, ModelSession, ModelTask, ModelType
from immich_ml.sessions.ort import OrtSession


class FaceDetector(InferenceModel):
    depends = []
    identity = (ModelType.DETECTION, ModelTask.FACIAL_RECOGNITION)

    def __init__(self, model_name: str, min_score: float = 0.7, **model_kwargs: Any) -> None:
        self.min_score = model_kwargs.pop("minScore", min_score)
        self._tiled = False
        self._tile_size = 640
        self._tile_overlap = 0.25
        self._max_tiles = 64
        self._cpu_model: RetinaFace | None = None
        super().__init__(model_name, **model_kwargs)

    def _load(self) -> ModelSession:
        session = self._make_session(self.model_path)
        self.model = RetinaFace(session=session)
        self.model.prepare(ctx_id=0, det_thresh=self.min_score, input_size=(640, 640))

        return session

    def _ensure_cpu_model(self) -> None:
        if self._cpu_model is not None:
            return
        cpu_session = OrtSession(self.model_path, providers=["CPUExecutionProvider"])
        self._cpu_model = RetinaFace(session=cpu_session)
        self._cpu_model.prepare(ctx_id=-1, det_thresh=self.min_score, input_size=(640, 640))

    def _detect_cpu(self, inputs: NDArray[np.uint8]) -> tuple[NDArray[np.float32], NDArray[np.float32]]:
        self._ensure_cpu_model()
        return self._cpu_model.detect(inputs)

    def _is_gpu_session(self) -> bool:
        try:
            providers = self.session.session.get_providers()
            return "CUDAExecutionProvider" in providers
        except (AttributeError, RuntimeError):
            return False

    def _predict(self, inputs: NDArray[np.uint8] | bytes) -> FaceDetectionOutput:
        inputs = decode_cv2(inputs)

        if self._tiled:
            bboxes, landmarks = self._detect_tiled(inputs)
        else:
            bboxes, landmarks = self._detect(inputs)

        if bboxes.shape[0] == 0 and self._is_gpu_session():
            bboxes_cpu, landmarks_cpu = self._detect_cpu(inputs)
            if bboxes_cpu.shape[0] > 0:
                log.warning(
                    "GPU face detection returned 0 faces but CPU found %d — GPU may be unhealthy",
                    bboxes_cpu.shape[0],
                )
                bboxes, landmarks = bboxes_cpu, landmarks_cpu

        return {
            "boxes": bboxes[:, :4].round(),
            "scores": bboxes[:, 4],
            "landmarks": landmarks,
        }

    def _detect(self, inputs: NDArray[np.uint8] | bytes) -> tuple[NDArray[np.float32], NDArray[np.float32]]:
        return self.model.detect(inputs)  # type: ignore

    def _detect_tiled(self, image: NDArray[np.uint8]) -> tuple[NDArray[np.float32], NDArray[np.float32]]:
        h, w = image.shape[:2]
        tile_size = self._tile_size
        overlap = self._tile_overlap
        max_tiles = self._max_tiles
        stride = int(tile_size * (1 - overlap))

        ys, xs = self._tile_positions(h, w, tile_size, stride)
        total_tiles = len(ys) * len(xs)

        if total_tiles > max_tiles:
            scale = (max_tiles / total_tiles) ** 0.5
            new_w = max(tile_size, int(w * scale))
            new_h = max(tile_size, int(h * scale))
            image = cv2.resize(image, (new_w, new_h))
            h, w = new_h, new_w
            ys, xs = self._tile_positions(h, w, tile_size, stride)

        all_bboxes: list[NDArray[np.float32]] = []
        all_landmarks: list[NDArray[np.float32]] = []

        for y0 in ys:
            for x0 in xs:
                x1 = min(x0 + tile_size, w)
                y1 = min(y0 + tile_size, h)
                tile = image[y0:y1, x0:x1]

                bboxes, landmarks = self._detect(tile)

                if bboxes.shape[0] > 0:
                    bboxes[:, 0] += x0
                    bboxes[:, 1] += y0
                    bboxes[:, 2] += x0
                    bboxes[:, 3] += y0
                    for i in range(landmarks.shape[1]):
                        landmarks[:, i, 0] += x0
                        landmarks[:, i, 1] += y0
                    all_bboxes.append(bboxes)
                    all_landmarks.append(landmarks)

        if not all_bboxes:
            return (
                np.zeros((0, 5), dtype=np.float32),
                np.zeros((0, 5, 2), dtype=np.float32),
            )

        merged_bboxes = np.concatenate(all_bboxes, axis=0)
        merged_landmarks = np.concatenate(all_landmarks, axis=0)

        keep = self._nms(merged_bboxes, iou_threshold=0.4)
        return merged_bboxes[keep], merged_landmarks[keep]

    def _tile_positions(self, h: int, w: int, tile_size: int, stride: int) -> tuple[list[int], list[int]]:
        def positions(length: int) -> list[int]:
            if length <= tile_size:
                return [0]
            pos = list(range(0, length - tile_size + 1, stride))
            if pos[-1] + tile_size < length:
                pos.append(length - tile_size)
            return pos

        return positions(h), positions(w)

    def _nms(self, bboxes: NDArray[np.float32], iou_threshold: float = 0.4) -> list[int]:
        if bboxes.shape[0] == 0:
            return []

        scores = bboxes[:, 4]
        order = scores.argsort()[::-1]

        keep: list[int] = []
        suppressed: set[int] = set()

        for i in order:
            if i in suppressed:
                continue
            keep.append(int(i))
            for j in order:
                if j in suppressed or j == i:
                    continue
                if self._iou(bboxes[i], bboxes[j]) > iou_threshold:
                    suppressed.add(int(j))

        return keep

    @staticmethod
    def _iou(box1: NDArray[np.float32], box2: NDArray[np.float32]) -> float:
        x1 = max(box1[0], box2[0])
        y1 = max(box1[1], box2[1])
        x2 = min(box1[2], box2[2])
        y2 = min(box1[3], box2[3])

        intersection = max(0, x2 - x1) * max(0, y2 - y1)
        area1 = (box1[2] - box1[0]) * (box1[3] - box1[1])
        area2 = (box2[2] - box2[0]) * (box2[3] - box2[1])
        union = area1 + area2 - intersection

        return float(intersection / union) if union > 0 else 0.0

    def configure(self, **kwargs: Any) -> None:
        min_score = kwargs.pop("minScore", None)
        if min_score is not None:
            self.min_score = min_score
            self.model.det_thresh = min_score
            if self._cpu_model is not None:
                self._cpu_model.det_thresh = min_score
        self._tiled = kwargs.pop("tiled", self._tiled)
        self._tile_size = int(kwargs.pop("tileSize", self._tile_size))
        self._tile_overlap = float(kwargs.pop("tileOverlap", self._tile_overlap))
        self._max_tiles = int(kwargs.pop("maxTiles", self._max_tiles))
