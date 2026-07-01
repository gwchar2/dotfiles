import pytest

from python_template import normalize_text


@pytest.mark.parametrize(
    ("value", "expected"),
    [
        (" Hello ", "hello"),
        ("PYTHON", "python"),
        ("\tTemplate\n", "template"),
    ],
)
def test_normalize_text(value: str, expected: str) -> None:
    assert normalize_text(value) == expected
