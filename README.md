# sideline

A sports data engineering curriculum, built as one real monorepo: ingestion,
transformation, orchestration, batch/stream processing, data quality, ML,
and serving for NBA/NCAA data. Each ticket (`M<milestone>.<task>`) is a real
engineering task, built and reviewed like a pull request rather than a
throwaway exercise.

## Repo layout

| Folder | Purpose |
|---|---|
| [`ingestion/`](ingestion/README.md) | Extractors that pull raw data from external sources (e.g., `nba_api`) into the raw zone. |
| [`transform/`](transform/README.md) | dbt models and SQL transformations from raw to curated marts. |
| [`orchestration/`](orchestration/README.md) | Pipeline scheduling and DAGs that tie ingestion, transform, and quality jobs together. |
| [`spark/`](spark/README.md) | Spark jobs for large-scale batch processing and lakehouse (Iceberg) table maintenance. |
| [`streaming/`](streaming/README.md) | Streaming pipelines for near-real-time data (live game events, odds updates). |
| [`quality/`](quality/README.md) | Data quality checks and validation rules for pipeline inputs/outputs. |
| [`ml/`](ml/README.md) | Feature engineering, model training, and evaluation. |
| [`serving/`](serving/README.md) | APIs/services that serve curated data and predictions to consumers. |
| [`infra/`](infra/README.md) | Infrastructure as code (Terraform). |
| [`sql/`](sql/README.md) | Advanced SQL practice problems and solutions. |
| [`docs/`](docs/README.md) | ADRs, design docs, and incident postmortems. |

## Getting started

```bash
uv sync              # installs all dev tooling from uv.lock into .venv/
uv run pre-commit install   # wires up the git pre-commit hook
uv run pre-commit run --all-files   # lint/format/type-check everything
```

## Build log

What follows is a running record of each completed ticket: what it asked
for, what was actually built, and how/why. GitHub issues track the
checklist; this is the narrative.

### M0.1 — Create the sideline repo and monorepo layout

**Ask:** a public repo with the folder layout above, each folder holding a
one-line README, an OSS license, and a `.gitignore` covering Python, dbt,
Terraform, and `.env`.

**What was done:**
- Confirmed the repo was already public (`gh repo view`).
- Added an **MIT `LICENSE`**.
- Added a **`.gitignore`** with sections for Python (`__pycache__/`,
  `.venv/`, `.mypy_cache/`, `.ruff_cache/`, `.pytest_cache/`, `.env`), dbt
  (`target/`, `dbt_packages/`), and Terraform (`.terraform/`, `*.tfstate`,
  `*.tfvars`), plus editor/OS noise (`.DS_Store`, `.idea/`).
- Created every top-level folder from the curriculum
  (`ingestion/`, `transform/`, `orchestration/`, `spark/`, `streaming/`,
  `quality/`, `ml/`, `serving/`, `infra/`, `sql/`, `docs/adr/`,
  `docs/design/`, `docs/incidents/`), each with a one-line `README.md` —
  git doesn't track empty directories, so the README also makes the
  folder exist in the commit.
- Committed as the repo's root commit on `main` and pushed directly
  (no prior history existed to branch from).

**How/why:** MIT over Apache-2.0 because this is a personal learning/
portfolio project with no patent-grant need. Folders got only a one-liner
each (not full docs) because real content for ingestion/transform/etc.
belongs to the tickets that actually build those pieces.

Closes [#17](https://github.com/Dfscashline21/sideline/issues/17).

### M0.2 — Python tooling: uv, ruff, mypy, pre-commit

**Ask:** `pyproject.toml` wired up with uv, ruff (lint + format), mypy,
pytest, and pre-commit hooks, such that `uv sync` installs from a lockfile
and `pre-commit run --all-files` passes.

**What was done:**
- Installed `uv` and `pre-commit` locally via Homebrew (neither was
  present), so the acceptance criteria could actually be run, not just
  written and hoped for.
- **`pyproject.toml`**:
  - `[project]` requires `python>=3.12` and declares no runtime
    dependencies yet (the repo has no application code yet).
  - `[tool.uv] package = false` — tells uv this is a *virtual* project
    (a place to run scripts from), not a library to build and install
    itself. Without this, `uv sync` would try to build a `sideline`
    package and fail since there's no importable code behind it.
  - `[dependency-groups] dev` holds `ruff`, `mypy`, `pytest`,
    `pre-commit` — dev-only tools, kept out of `[project.dependencies]`
    since nothing ships them.
  - `[tool.ruff]` targets `py312`, 100-char lines, and selects rule
    groups `E`/`F` (pycodestyle/pyflakes core), `I` (isort), `UP`
    (pyupgrade), `B` (bugbear), `C4` (comprehensions), `SIM`
    (simplify) — plus `ruff format` for formatting.
  - `[tool.mypy]` uses explicit flags instead of one blanket
    `strict = true`, so each one is individually nameable:
    `disallow_untyped_defs`, `disallow_incomplete_defs`,
    `check_untyped_defs`, `no_implicit_optional`,
    `warn_redundant_casts`, `warn_unused_ignores`, `warn_return_any`,
    `warn_unused_configs`; `ignore_missing_imports = true` so
    third-party libs without type stubs don't fail the build.
  - `[tool.pytest.ini_options]` points `testpaths` at the top-level
    code folders.
- **`uv.lock`**: generated by `uv sync` and committed, so every
  contributor/CI run gets byte-identical dependency versions.
- **`.pre-commit-config.yaml`**:
  - `pre-commit/pre-commit-hooks` — generic file hygiene (trailing
    whitespace, EOF newline, YAML/TOML parse, large-file guard,
    merge-conflict markers, line-ending normalization).
  - `astral-sh/ruff-pre-commit` — `ruff --fix` then `ruff format`.
  - `pre-commit/mirrors-mypy` — type checking.
  - Deliberately **no pytest hook**: tests are slower and belong in CI/
    `make test`, not on every commit.
- Ran `uv run pre-commit install` to wire the git hook, then
  `uv run pre-commit run --all-files` — verified clean (had to `git add`
  the new config files first, since `--all-files` checks tracked files
  via `git ls-files`, not everything on disk).

**How/why:** uv over pip/poetry for speed and a single lockfile; ruff
over flake8+isort+black because it replaces all three with one fast tool;
mypy over pyright because the ticket's title names it first and the repo
has no editor-integration requirement that would favor pyright. Explicit
mypy flags over `strict = true` because the acceptance criteria asks that
every config option be explainable — a bundle of ~20 implicit flags is
harder to point at than a short explicit list.

Closes [#18](https://github.com/Dfscashline21/sideline/issues/18).
