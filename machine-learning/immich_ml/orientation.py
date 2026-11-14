"""RightWayUp orientation inference for the rotation-suggestion pipeline.

Wraps the PyPI `rightwayup` Orienter (ONNX Runtime, CPU INT8) behind a lazy,
per-tier singleton. Preprocessing contract (must stay in sync with the
benchmark harness in ~/app/immich-app/orient-bench/):

- Input is a decoded PIL RGB image **as displayed** — the server sends the
  preview JPEG whose EXIF orientation is already baked in, so no
  exif_transpose is applied here (passing a PIL Image skips it in
  rightwayup.load_image by design).
- The library letterboxes to the tier's square canvas on ImageNet mean-colour
  padding and normalises; those are the exact frozen preprocessing values the
  benchmark evaluated.

Semantics (matching orient-bench scoring):
- `angle_cw`   = how far the image content is rotated CLOCKWISE from upright.
- `correction` = the CLOCKWISE rotation to apply to make it upright
                 ((360 - angle_cw) % 360), snapped to the nearest 90°.
"""

import logging
from threading import Lock

from immich_ml.config import settings

log = logging.getLogger(__name__)

_orienters: dict[str, object] = {}
_lock = Lock()


def _get_orienter(tier: str):
    with _lock:
        orienter = _orienters.get(tier)
        if orienter is None:
            # Imported lazily so the ML service boots without rightwayup when
            # the orientation endpoint is never used (e.g. upstream image).
            from rightwayup import Orienter

            log.info(f"Loading RightWayUp orientation model (tier={tier}, device={settings.orientation.device})")
            orienter = Orienter(tier=tier, device=settings.orientation.device)
            _orienters[tier] = orienter
            log.info(f"Loaded RightWayUp orientation model (tier={tier})")
        return orienter


def predict_orientation(image, tier: str | None = None) -> dict:
    """Run orientation inference on a decoded PIL image.

    Returns angleCw (snapped, bench semantics), correctionCw (snapped CW
    rotation to apply), confidence, abstain and routed flags.
    """
    from rightwayup.core import load_image

    orienter = _get_orienter(tier or settings.orientation.tier)
    result = orienter.predict(load_image(image))
    angle_cw = round(result.angle_cw / 90) % 4 * 90
    correction = (360 - angle_cw) % 360
    return {
        "angleCw": angle_cw,
        "correctionCw": correction,
        "confidence": float(result.confidence),
        "abstain": bool(result.abstain),
        "routed": bool(getattr(result, "routed", False)),
        "tier": orienter.tier,
    }
