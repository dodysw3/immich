from src.tokenize import tokenize_for_search


def test_tokenize_latin() -> None:
    assert tokenize_for_search("Hello World") == "Hello World"


def test_tokenize_cjk() -> None:
    assert tokenize_for_search("機器學習") == "機器 器學 學習"
