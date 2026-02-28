from __future__ import annotations


def is_cjk(c: int) -> bool:
    return (
        (0x4E00 <= c <= 0x9FFF)
        or (0x3400 <= c <= 0x4DBF)
        or (0x20000 <= c <= 0x2A6DF)
        or (0x2A700 <= c <= 0x2B73F)
        or (0x2B740 <= c <= 0x2B81F)
        or (0x2B820 <= c <= 0x2CEAF)
        or (0xF900 <= c <= 0xFAFF)
        or (0x2F800 <= c <= 0x2FA1F)
        or (0x3000 <= c <= 0x303F)
        or (0x3040 <= c <= 0x309F)
        or (0x30A0 <= c <= 0x30FF)
        or (0xAC00 <= c <= 0xD7AF)
    )


def tokenize_for_search(text: str) -> str:
    tokens: list[str] = []
    i = 0
    while i < len(text):
        c = ord(text[i])
        if c <= 32:
            i += 1
            continue

        start = i
        if is_cjk(c):
            while i < len(text) and is_cjk(ord(text[i])):
                i += 1
            run = text[start:i]
            if len(run) == 1:
                tokens.append(run)
            else:
                for k in range(len(run) - 1):
                    tokens.append(run[k : k + 2])
        else:
            while i < len(text) and ord(text[i]) > 32 and not is_cjk(ord(text[i])):
                i += 1
            tokens.append(text[start:i])

    return " ".join(tokens)
