from __future__ import annotations

from PIL import Image, ImageOps

try:
    import cv2
    import numpy as np

    HAS_CV2 = True
except ImportError:
    HAS_CV2 = False


def preprocess_light(image: Image.Image, max_resolution: int) -> Image.Image:
    image = ImageOps.exif_transpose(image)
    image = _resize_for_max_edge(image, max_resolution)
    return image.convert("RGB")


def preprocess(
    image: Image.Image,
    max_resolution: int,
    block_size: int = 15,
    threshold_c: int = 9,
    clahe_clip: float = 2.0,
    unsharp_amount: float = 1.4,
) -> Image.Image:
    image = _resize_for_max_edge(image, max_resolution)

    if not HAS_CV2:
        return image.convert("RGB")

    image_rgb = image.convert("RGB")

    bgr = cv2.cvtColor(np.array(image_rgb), cv2.COLOR_RGB2BGR)
    gray = cv2.cvtColor(bgr, cv2.COLOR_BGR2GRAY)

    deskewed = _deskew(gray)
    thresholded = cv2.adaptiveThreshold(
        deskewed,
        255,
        cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
        cv2.THRESH_BINARY,
        block_size,
        threshold_c,
    )

    clahe = cv2.createCLAHE(clipLimit=clahe_clip, tileGridSize=(8, 8))
    contrast = clahe.apply(thresholded)

    sharpened = _unsharp_mask(contrast, unsharp_amount=unsharp_amount)
    rgb = cv2.cvtColor(sharpened, cv2.COLOR_GRAY2RGB)
    return Image.fromarray(rgb)


def _resize_for_max_edge(image: Image.Image, max_resolution: int) -> Image.Image:
    width, height = image.size
    long_edge = max(width, height)
    if long_edge <= max_resolution:
        return image

    scale = max_resolution / float(long_edge)
    resized = image.resize((int(width * scale), int(height * scale)), Image.Resampling.LANCZOS)
    return resized


def _deskew(gray: "np.ndarray") -> "np.ndarray":
    inverted = cv2.bitwise_not(gray)
    _, bw = cv2.threshold(inverted, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)

    coords = np.column_stack(np.where(bw > 0))
    if coords.shape[0] < 100:
        return gray

    angle = cv2.minAreaRect(coords)[-1]
    if angle < -45:
        angle = 90 + angle
    angle = -angle

    if abs(angle) < 0.1:
        return gray

    h, w = gray.shape[:2]
    center = (w // 2, h // 2)
    matrix = cv2.getRotationMatrix2D(center, angle, 1.0)
    return cv2.warpAffine(gray, matrix, (w, h), flags=cv2.INTER_CUBIC, borderMode=cv2.BORDER_REPLICATE)


def _unsharp_mask(gray: "np.ndarray", unsharp_amount: float) -> "np.ndarray":
    blurred = cv2.GaussianBlur(gray, (0, 0), 1.0)
    amount = max(0.0, unsharp_amount)
    return cv2.addWeighted(gray, 1.0 + amount, blurred, -amount, 0)
