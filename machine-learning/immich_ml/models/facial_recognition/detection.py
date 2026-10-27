from typing import Any

import cv2
import numpy as np
from immich_model.constants import FACE_DETECTION_SIZE as DET_SIZE
from numpy.typing import NDArray
from PIL import ExifTags, ImageOps
from PIL import Image as PilImage
from PIL.Image import Image

from immich_ml.config import log
from immich_ml.models.base import InferenceModel
from immich_ml.models.transforms import decode_pil, letterbox, normalize, widen
from immich_ml.schemas import (
    FaceDetectionOptions,
    FaceDetectionOutput,
    ModelSession,
    ModelSource,
    ModelTask,
    ModelType,
    Shape,
)
from immich_ml.sessions.ort import OrtSession
from immich_ml.sessions.policy import ShapePolicy

from ._ops import decode_scrfd, nms

# Verification re-runs the detector on a square crop centred on each face: the box plus
# VERIFY_PAD of its longer side on every side, resized to VERIFY_SIZE. A real face scores
# about as high as it did in the full image; texture a tile happened to fire on (walls,
# foliage, fabric) collapses towards zero. Calibrated against 200 hand-labelled faces.
VERIFY_SIZE = 256
VERIFY_PAD = 0.6
VERIFY_MIN_SCORE = 0.05
# how far (in crop pixels) a re-detected face's centre may sit from the crop centre
VERIFY_CENTER_TOLERANCE = 40


class FaceDetector(InferenceModel[FaceDetectionOptions]):
    depends = []
    identity = (ModelType.DETECTION, ModelTask.FACIAL_RECOGNITION)
    sources = (ModelSource.INSIGHTFACE,)
    shape_policy = ShapePolicy(dims=(Shape(batch=1, height=DET_SIZE, width=DET_SIZE),))

    def __init__(self, model_name: str, **model_kwargs: Any) -> None:
        self._cpu_session: OrtSession | None = None
        super().__init__(model_name, **model_kwargs)

    def _run_session(
        self, image: Image | NDArray[np.uint8], min_score: float, session: ModelSession
    ) -> tuple[NDArray[np.float32], NDArray[np.float32], NDArray[np.float32]]:
        graph = session.for_shape(self.shape_policy.dims[0])
        canvas, scale = letterbox(image, DET_SIZE)
        blob: NDArray[np.float32] | NDArray[np.uint8] = (
            canvas[None]
            if graph.normalizes_input
            else normalize(canvas.astype(np.float32), 127.5, 128).transpose(2, 0, 1)[None]
        )

        heads = [widen(head) for head in graph.run(None, {graph.get_inputs()[0].name: blob})]
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
            self._cpu_session = OrtSession(self.model_path, self.shape_policy, providers=["CPUExecutionProvider"])
        return self._cpu_session

    def _predict(self, inputs: NDArray[np.uint8] | bytes, options: FaceDetectionOptions) -> FaceDetectionOutput:
        image = decode_pil(inputs)
        gpu_fallback = False
        session = self.session

        if options.verify_boxes is not None:
            return self._verify_stored(image, options.verify_boxes, options.verify_image_size)

        if options.tiled:
            scores, boxes, kps = self._detect_tiled(
                image, options.min_score, options.tile_size, options.tile_overlap, options.max_tiles
            )
        else:
            scores, boxes, kps = self._run_session(image, options.min_score, self.session)

        if boxes.shape[0] == 0 and self._is_gpu_session():
            log.warning(
                "GPU returned 0 faces for %dx%d image (tiled=%s), trying CPU fallback",
                image.width,
                image.height,
                options.tiled,
            )
            cpu_scores, cpu_boxes, cpu_kps = self._run_session(image, options.min_score, self._ensure_cpu_session())
            if cpu_boxes.shape[0] > 0:
                log.warning(
                    "GPU face detection returned 0 faces but CPU found %d — GPU may be unhealthy",
                    cpu_boxes.shape[0],
                )
                scores, boxes, kps = cpu_scores, cpu_boxes, cpu_kps
                gpu_fallback = True
                session = self._ensure_cpu_session()

        keep = nms(boxes, scores)
        output: FaceDetectionOutput = {
            "boxes": boxes[keep].round(),
            "scores": scores[keep],
            "landmarks": kps[keep].reshape(-1, 5, 2),
            "gpuFallback": gpu_fallback,
        }
        if options.verify:
            output["verifyScores"] = self._verify_scores(image, output["boxes"], session)
        return output

    def _verify_scores(self, image: Image, boxes: NDArray[np.float32], session: ModelSession) -> NDArray[np.float32]:
        verify_scores = np.zeros(boxes.shape[0], dtype=np.float32)
        center = VERIFY_SIZE / 2
        for i, (x1, y1, x2, y2) in enumerate(boxes):
            side = max(x2 - x1, y2 - y1)
            half = side / 2 + VERIFY_PAD * side
            cx, cy = (x1 + x2) / 2, (y1 + y2) / 2
            # PIL pads a crop that runs past the image edge with black, as the calibration crops did
            crop = image.crop((int(cx - half), int(cy - half), int(cx + half), int(cy + half))).resize(
                (VERIFY_SIZE, VERIFY_SIZE), PilImage.Resampling.BICUBIC
            )
            scores, found, _ = self._run_session(crop, VERIFY_MIN_SCORE, session)
            if found.shape[0] == 0:
                continue
            centers = (found[:, :2] + found[:, 2:]) / 2
            near = np.all(np.abs(centers - center) < VERIFY_CENTER_TOLERANCE, axis=1)
            if near.any():
                verify_scores[i] = scores[near].max()
        return verify_scores

    def _verify_stored(
        self,
        image: Image,
        stored: tuple[tuple[float, float, float, float], ...],
        stored_size: tuple[int, int] | None,
    ) -> FaceDetectionOutput:
        """Re-score faces stored earlier, without detecting.

        Stored boxes are in the upright original, which PIL only yields after applying EXIF
        orientation. The decoded image is used as is or transposed, whichever has the stored
        aspect ratio; when both do (a 180° turn, or a square photo) both are scored and the
        better fit wins. `verifyScores` is left out when no orientation fits, or when nearly
        every box finds no face at its centre, which means the boxes do not line up with the
        image; the caller then must not act on the faces.
        """
        boxes = np.array(stored, dtype=np.float32).reshape(-1, 4)
        output: FaceDetectionOutput = {
            "boxes": boxes,
            "scores": np.zeros(boxes.shape[0], dtype=np.float32),
            "landmarks": np.zeros((boxes.shape[0], 5, 2), dtype=np.float32),
            "gpuFallback": False,
        }
        if boxes.shape[0] == 0 or stored_size is None:
            return output

        width, height = stored_size
        orientation = image.getexif().get(ExifTags.Base.Orientation, 1)
        candidates = [image] if orientation in (None, 1) else [ImageOps.exif_transpose(image), image]
        fitting = [c for c in candidates if abs(c.width / c.height - width / height) <= 0.02 * width / height]
        if not fitting:
            log.warning("Stored face boxes fit no orientation of the %dx%d image", image.width, image.height)
            return output

        best: NDArray[np.float32] | None = None
        for candidate in fitting:
            scale = np.array([candidate.width / width, candidate.height / height] * 2, dtype=np.float32)
            scores = self._verify_scores(candidate, boxes * scale, self.session)
            if best is None or scores.sum() > best.sum():
                best = scores
        assert best is not None

        if boxes.shape[0] >= 3 and (best == 0).mean() >= 0.8:
            log.warning(
                "Stored face boxes do not line up with the image: %d of %d find no face", (best == 0).sum(), len(best)
            )
            return output

        output["verifyScores"] = best
        return output

    def _detect_tiled(
        self,
        image: Image,
        min_score: float,
        tile_size: int,
        tile_overlap: float,
        max_tiles: int,
    ) -> tuple[NDArray[np.float32], NDArray[np.float32], NDArray[np.float32]]:
        img = np.asarray(image)
        orig_h, orig_w = img.shape[:2]
        h, w = orig_h, orig_w
        stride = int(tile_size * (1 - tile_overlap))

        ys, xs = self._tile_positions(h, w, tile_size, stride)
        total_tiles = len(ys) * len(xs)

        if total_tiles > max_tiles:
            scale = (max_tiles / total_tiles) ** 0.5
            new_w = max(tile_size, int(w * scale))
            new_h = max(tile_size, int(h * scale))
            log.warning(
                "Tiled face detection needs %d tiles for %dx%d image (tileSize=%d, tileOverlap=%.2f)"
                " but maxTiles=%d; pre-shrinking image to %dx%d (scale %.3f), small faces may be lost",
                total_tiles,
                orig_w,
                orig_h,
                tile_size,
                tile_overlap,
                max_tiles,
                new_w,
                new_h,
                scale,
            )
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

        boxes = np.concatenate(all_boxes)
        kps = np.concatenate(all_kps)
        # honoring max_tiles may have run the tiles on a downscaled copy of the image;
        # detections are in that copy's pixel space while callers expect the original's
        boxes[:, 0::2] *= orig_w / w
        boxes[:, 1::2] *= orig_h / h
        kps[:, 0::2] *= orig_w / w
        kps[:, 1::2] *= orig_h / h
        return np.concatenate(all_scores), boxes, kps

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
