from PIL import Image

from src.preprocess import preprocess


def test_preprocess_resizes_when_needed() -> None:
    image = Image.new("RGB", (5000, 3000), color="white")
    result = preprocess(image, max_resolution=1000)
    assert max(result.size) == 1000


def test_preprocess_returns_rgb_image() -> None:
    image = Image.new("RGB", (640, 480), color="white")
    result = preprocess(image, max_resolution=2000)
    assert result.mode == "RGB"
