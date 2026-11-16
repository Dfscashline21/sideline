# Smoke test: proves pytest is wired up and the repo layout is intact.
# Real tests arrive with the curriculum modules that own each folder.
from pathlib import Path


def test_repo_layout() -> None:
    root = Path(__file__).resolve().parent.parent
    assert (root / "pyproject.toml").is_file()
    assert (root / "compose.yaml").is_file()
    folders = (
        "ingestion",
        "transform",
        "orchestration",
        "spark",
        "streaming",
        "quality",
        "ml",
        "serving",
    )
    for folder in folders:
        assert (root / folder).is_dir()
