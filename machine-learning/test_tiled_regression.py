"""Regression tests for the tiled face-detection request path.

Incident: every pass-2 (tiled) detection request raised
`TypeError: FaceDetector._predict() got an unexpected keyword argument 'tiled'`
because `InferenceModel.predict()` forwards all request kwargs to `_predict()`,
which only accepted `minScore`. Worse, `predict()` calls `configure(**kwargs)`
*first*, so the shared, cached FaceDetector instance was left with
`_tiled = True` after every failed pass-2 request. Because pass 1 (preview)
and pass 2 (tiled) resolve to the same model_cache entry (keyed only by
name+type+task), all later pass-1 requests on that worker silently ran tiled
detection on the preview. A face too large to fit inside a single 640px tile
then straddles tile boundaries, its SCRFD score collapses below `minScore`
(observed 0.81 -> 0.362), and a prominently visible face is not detected at
all. Worker restarts temporarily cleared the state, which is why the bug
"came and went".

These tests pin the contract: tiled requests must not raise, and tiled state
must never leak into subsequent requests.
"""

import contextlib
import os
from typing import Callable
from unittest import mock

import numpy as np
import pytest
from PIL import Image

from immich_ml.models.facial_recognition.detection import FaceDetector

TILED_KWARGS = {"tiled": True, "tileSize": 640, "tileOverlap": 0.25, "maxTiles": 64}


def make_scrfd_heads(detections: list[tuple[int, int, float]]) -> list[np.ndarray]:
    """Build the 9 head tensors a SCRFD keypoint model emits at 640x640 (see test_main.py)."""
    heads: list[np.ndarray] = []
    counts = [(640 // stride) ** 2 * 2 for stride in (8, 16, 32)]
    for channels in (1, 4, 10):
        for n in counts:
            heads.append(np.zeros((n, channels), dtype=np.float32))
    for cell_x, cell_y, score in detections:
        i = 2 * (cell_y * 80 + cell_x)  # anchor-major, 2 anchors per cell
        heads[0][i] = score
        heads[3][i] = [1, 2, 3, 4]
        heads[6][i] = np.arange(10)
    return heads


@pytest.fixture
def detector(stub_session: Callable[..., mock.Mock], mocker: mock.Mock) -> FaceDetector:
    mocker.patch.object(FaceDetector, "load")
    face_detector = FaceDetector("buffalo_s", cache_dir="test_cache")
    session = stub_session((1, 3, 640, 640), outputs=make_scrfd_heads([(10, 10, 0.9)]))
    session.providers = ["CPUExecutionProvider"]
    face_detector.session = session
    return face_detector


class TestTiledRequestContract:
    def test_pass2_tiled_request_does_not_raise(self, detector: FaceDetector) -> None:
        # This is the exact kwargs set the server sends for pass 2 (tiled) detection;
        # it must be accepted by predict() rather than raise TypeError -> HTTP 500.
        faces = detector.predict(Image.new("RGB", (1280, 640)), minScore=0.5, **TILED_KWARGS)

        assert set(faces) == {"boxes", "scores", "landmarks", "gpuFallback"}

    def test_tiled_request_runs_tiled_and_pass1_runs_single_pass(
        self, detector: FaceDetector, stub_session: Callable[..., mock.Mock]
    ) -> None:
        # 1280x640 with tile 640, stride 480 -> 3 tiles, vs 1 single-pass inference.
        image = Image.new("RGB", (1280, 640))

        detector.predict(image, minScore=0.5, **TILED_KWARGS)
        assert detector.session.run.call_count == 3

        detector.session.run.reset_mock()
        detector.predict(image, minScore=0.5)  # pass 1: no tiled kwargs
        assert detector.session.run.call_count == 1, (
            "pass-1 request must run single-pass detection, not inherit tiled mode"
        )


class TestNoStatePoisoning:
    def test_failed_tiled_request_does_not_poison_later_pass1_requests(self, detector: FaceDetector) -> None:
        # Production: the pass-2 request 500s (pre-fix: TypeError after configure
        # already ran). Whatever happens during the tiled request, a worker that
        # handled it must not flip every later pass-1 into tiled mode.
        with contextlib.suppress(Exception):
            detector.predict(Image.new("RGB", (1280, 640)), minScore=0.5, **TILED_KWARGS)

        detector.session.run.reset_mock()
        detector.predict(Image.new("RGB", (1280, 640)), minScore=0.5)

        assert detector.session.run.call_count == 1, (
            "a failed tiled request leaked _tiled=True into the cached model instance"
        )

    def test_interleaved_tiled_and_single_pass_requests_are_isolated(self, detector: FaceDetector) -> None:
        image = Image.new("RGB", (1280, 640))

        detector.predict(image, minScore=0.5, **TILED_KWARGS)
        detector.predict(image, minScore=0.5)
        detector.predict(image, minScore=0.5, **TILED_KWARGS)

        assert detector.session.run.call_count == 3 + 1 + 3


class TestLargeFaceIncident:
    @pytest.mark.skipif(
        os.environ.get("FACE_REGRESSION_IMAGE") is None,
        reason="set FACE_REGRESSION_IMAGE to a preview image whose face is large relative to the frame",
    )
    def test_score_collapse_under_tiled_mode(self, mocker: mock.Mock) -> None:
        """Reproduces the incident geometry end-to-end with the real model.

        On the incident photos (e.g. asset 5ebd65ea preview, 2160x2880), single-pass
        detection scores the face 0.81 while tiled detection on the same image scores
        the same face 0.362 — below the deployed minScore of 0.5, so zero faces are
        stored. Tiled mode exists to find small faces, so a collapse for one huge
        face is expected; the contract is that pass 1 (single-pass) still finds it.
        """
        from immich_ml.models.transforms import decode_pil

        image = decode_pil(open(os.environ["FACE_REGRESSION_IMAGE"], "rb").read())

        detector = FaceDetector("buffalo_l")
        detector.load()
        single = detector._predict(image, minScore=0.0)
        single_best = float(single["scores"].max()) if single["scores"].size else 0.0
        tiled = detector._predict(image, minScore=0.0, tiled=True)
        tiled_best = float(tiled["scores"].max()) if tiled["scores"].size else 0.0

        assert single_best >= 0.5, "the face must clear the deployed minScore in single-pass mode"
        assert tiled_best < 0.5, (
            f"expected the incident's score collapse in tiled mode (got {tiled_best:.3f}); "
            "if this now passes, the image no longer exhibits the straddle geometry"
        )
