import pytest

from src.config import Config, _parse_api_keys


def test_parse_api_keys_json() -> None:
    parsed = _parse_api_keys('{"owner-1":"key-1","owner-2":"key-2"}')
    assert parsed == {"owner-1": "key-1", "owner-2": "key-2"}


def test_validate_accepts_multi_owner_api_keys_without_single_fallback() -> None:
    cfg = Config(
        db_url="postgresql://db",
        immich_url="http://immich",
        immich_api_key="",
        immich_api_keys={"owner-1": "key-1"},
    )

    cfg.validate()


def test_validate_requires_any_api_key_source() -> None:
    cfg = Config(
        db_url="postgresql://db",
        immich_url="http://immich",
        immich_api_key="",
        immich_api_keys={},
    )

    with pytest.raises(ValueError, match="IMMICH_API_KEY or IMMICH_API_KEYS_JSON"):
        cfg.validate()
