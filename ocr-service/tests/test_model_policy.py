from src.config import Config
from src.model_policy import select_model_for_asset


def test_select_model_by_tag() -> None:
    cfg = Config(db_url='x', immich_url='y', immich_api_key='z')
    cfg.ocr_model_name = 'default-model'
    cfg.ocr_model_policy = {
        'tag': {'manga': 'tag-model'},
        'library': {'lib-1': 'lib-model'},
    }

    selected = select_model_for_asset({'tags': [{'name': 'Manga'}]}, cfg)
    assert selected.model_name == 'tag-model'
    assert selected.reason == 'tag:manga'


def test_select_model_by_library_when_no_tag_match() -> None:
    cfg = Config(db_url='x', immich_url='y', immich_api_key='z')
    cfg.ocr_model_name = 'default-model'
    cfg.ocr_model_policy = {
        'tag': {'manga': 'tag-model'},
        'library': {'lib-1': 'lib-model'},
    }

    selected = select_model_for_asset({'libraryId': 'lib-1', 'tags': []}, cfg)
    assert selected.model_name == 'lib-model'
    assert selected.reason == 'library:lib-1'
