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

#### What each tool actually is

**uv** — a single Rust-based tool (by Astral, the same team behind Ruff)
that replaces `pip` + `venv` + `pip-tools`/Poetry. One binary does all of:
reads `pyproject.toml` and resolves a dependency graph; writes the exact
resolved versions to `uv.lock`; creates and manages the `.venv/` virtual
environment automatically (you never run `python -m venv` yourself); can
even download a managed CPython build if your system Python doesn't match
`requires-python` (it fetched 3.15.2 for us); and runs commands inside
that environment via `uv run <cmd>`. The payoff over pip+venv: one tool,
one lockfile, and it's dramatically faster because it's written in Rust
and downloads/installs packages in parallel.

**`pyproject.toml`** — the standardized config file for a Python project
(TOML format, defined by PEP 517/518/621). Before it existed, a project's
config was scattered across `setup.py` (actual Python code that ran to
define packaging), `setup.cfg`, `requirements.txt`, plus one dotfile per
tool (`.flake8`, `mypy.ini`, `pytest.ini`...). `pyproject.toml` puts all
of it in one declarative file, split into named sections ("tables"):
- `[project]` — the one standardized section every packaging tool reads
  the same way: name, version, required Python, dependencies.
- `[dependency-groups]` — the current (PEP 735) standard for deps that
  aren't shipped with the package (dev/test tools), replacing the old
  pattern of a separate `requirements-dev.txt` or Poetry's
  `dev-dependencies`.
- `[tool.X]` — everything under `[tool.*]` is config owned by one
  specific tool (`uv`, `ruff`, `mypy`, `pytest`...), which reads only its
  own namespace. This is why we have one file instead of five.

**pre-commit** — a framework for managing *git hooks*. Git has built-in
hook points (`pre-commit`, `pre-push`, ...) but the scripts for them live
in the untracked `.git/hooks/` folder, so they can't normally be shared
with a team. The `pre-commit` tool fixes that: hooks are declared in a
tracked file (`.pre-commit-config.yaml`), and `pre-commit install` writes
a small shim into `.git/hooks/pre-commit` that, on every `git commit`,
runs all the declared hooks against the files about to be committed —
*before* the commit is created. If a hook edits a file (e.g. auto-fixes
formatting) or fails, the commit is blocked so you can look at the diff
first. Each hook repo is pinned to an exact tag (`rev:`) and cloned once
into its own isolated cached environment, so a hook's own dependencies
(e.g. mypy's) never leak into your project's `.venv/`.

**`uv.lock`** — the fully resolved, exact-version snapshot of the entire
dependency tree (direct *and* transitive) plus content hashes, generated
by `uv sync`/`uv lock`. `pyproject.toml` says `"ruff>=0.17"` (a range);
`uv.lock` pins `ruff==0.17.5` — and every package *ruff* itself depends
on — so `uv sync` installs byte-identical packages on any machine or CI
run. Without a committed lockfile, two installs months apart could
silently resolve to different versions.

#### What was done

- Installed `uv` and `pre-commit` locally via Homebrew (neither was
  present), so the acceptance criteria could actually be run and
  verified, not just written and hoped for.
- **`pyproject.toml`**, section by section:
  - `[project]` — `requires-python = ">=3.12"`, `dependencies = []`
    (no runtime deps yet; there's no application code yet).
  - `[tool.uv] package = false` — tells uv this is a *virtual* project
    (somewhere to run scripts from), not a library to build and install
    itself. Without this, `uv sync` would try to build an installable
    `sideline` wheel and fail, since there's no importable package
    behind the name.
  - `[dependency-groups] dev = [ruff, mypy, pytest, pre-commit]` — the
    four dev-only tools, kept out of `[project.dependencies]` since
    nothing in the repo ships them to a user.
  - `[tool.ruff]` — `target-version = "py312"`, `line-length = 100`.
  - `[tool.ruff.lint] select = [...]` — turns on specific rule groups
    (Ruff ships dozens, off by default): `E`/`F` (pycodestyle + pyflakes
    — the baseline: unused imports, undefined names, syntax style),
    `I` (isort — import ordering), `UP` (pyupgrade — flags old syntax
    when a newer Python feature does the same job), `B` (bugbear —
    patterns that are usually bugs, e.g. mutable default arguments),
    `C4` (comprehensions — unnecessary `list()`/`dict()` wrapping),
    `SIM` (simplify — e.g. collapsing `if x: return True else: return
    False` into `return x`).
  - `[tool.ruff.format]` — Ruff's formatter (a drop-in Black
    replacement); `quote-style = "double"` picks `"` consistently.
  - `[tool.mypy]` — explicit flags instead of one blanket
    `strict = true`, so each one can be pointed at individually:
    `disallow_untyped_defs` / `disallow_incomplete_defs` (every function
    needs type annotations), `check_untyped_defs` (still check bodies of
    any function that slips through without annotations),
    `no_implicit_optional` (a default of `None` must be spelled
    `Optional[...]`, not inferred), `warn_redundant_casts` (flags a
    `cast()` that doesn't actually change the inferred type),
    `warn_unused_ignores` (flags a `# type: ignore` suppressing nothing),
    `warn_return_any` (flags a typed function secretly returning `Any`),
    `warn_unused_configs` (flags mypy options that don't match any
    file); `ignore_missing_imports = true` so third-party libraries that
    ship no type stubs don't fail the build.
  - `[tool.pytest.ini_options]` — `testpaths` points at the top-level
    code folders; note the `.ini_options` suffix, which is pytest's own
    adapter name for reading its config back out of `pyproject.toml`.
- **`uv.lock`** generated by `uv sync` and committed.
- **`.pre-commit-config.yaml`** — three hook repos:
  - `pre-commit/pre-commit-hooks` (generic file hygiene):
    `trailing-whitespace` (strips trailing spaces), `end-of-file-fixer`
    (ensures exactly one trailing newline), `check-yaml`/`check-toml`
    (the file actually parses), `check-added-large-files` (blocks
    accidentally committing a big data dump), `check-merge-conflict`
    (blocks unresolved `<<<<<<<` markers), `mixed-line-ending`
    (normalizes to LF so CRLF from a Windows editor doesn't creep in).
  - `astral-sh/ruff-pre-commit` — runs `ruff --fix` then `ruff format`
    on every Python file about to be committed.
  - `pre-commit/mirrors-mypy` — runs mypy on the same files.
  - Deliberately **no pytest hook**: tests are slower and belong in
    CI/`make test`, not blocking every single commit.
- Ran `uv run pre-commit install` to wire the git hook, then
  `uv run pre-commit run --all-files` to check everything right now
  (not just staged files) — verified clean. Had to `git add` the new
  config files first, since `--all-files` checks files tracked by
  `git ls-files`, not everything sitting on disk.

**How/why:** uv over pip/poetry for speed and one lockfile; ruff over
flake8+isort+black because it replaces all three with one fast tool;
mypy over pyright because the ticket title names it first and nothing
here needs pyright's editor-integration strengths. Explicit mypy flags
over `strict = true` because the acceptance criteria asks that every
config option be explainable — a bundle of ~20 implicit flags is harder
to point at than a short explicit list.

Closes [#18](https://github.com/Dfscashline21/sideline/issues/18).
