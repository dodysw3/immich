from PIL import Image

from src.preprocess import preprocess, preprocess_light


def test_preprocess_resizes_when_needed() -> None:
    image = Image.new("RGB", (5000, 3000), color="white")
    result = preprocess(image, max_resolution=1000)
    assert max(result.size) == 1000


def test_preprocess_returns_rgb_image() -> None:
    image = Image.new("RGB", (640, 480), color="white")
    result = preprocess(image, max_resolution=2000)
    assert result.mode == "RGB"


def test_preprocess_light_resizes_when_needed() -> None:
    image = Image.new("RGB", (5000, 3000), color="red")
    result = preprocess_light(image, max_resolution=1000)
    assert max(result.size) == 1000
    assert result.mode == "RGB"


def test_preprocess_light_preserves_small_image() -> None:
    image = Image.new("RGB", (640, 480), color="blue")
    result = preprocess_light(image, max_resolution=2000)
    assert result.size == (640, 480)
    assert result.mode == "RGB"


def test_preprocess_light_converts_rgba_to_rgb() -> None:
    image = Image.new("RGBA", (100, 100), color=(255, 0, 0, 128))
    result = preprocess_light(image, max_resolution=2000)
    assert result.mode == "RGB"
