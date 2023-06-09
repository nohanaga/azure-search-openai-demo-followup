def nonewlines(s: str) -> str:
    # 引用のための括弧と混ざるのを防ぐため、Wikipedia の引用[]は<>に置き換える
    return s.replace('\n', ' ').replace('\r', ' ').replace("[", "<").replace("]", ">")
