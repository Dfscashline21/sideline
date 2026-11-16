# M0 Study Guide: Foundations of the Sideline Repo

A beginner's walkthrough of everything built in milestone M0 (tickets
M0.1 to M0.5): what each piece **is**, **why** it exists, **how** it was
built, and how to **check that you understand it**.

You don't need prior experience with any of these tools. Read it top to
bottom once, then use the exercises and quiz at the end of each section
to learn by doing.

The root [`README.md`](../README.md) has the per-ticket build log. This
guide is the teaching version of the same material.

---

## Contents

0. [The big picture](#0-the-big-picture)
1. [M0.1 The monorepo](#1-m01-the-monorepo)
2. [M0.2 Python tooling](#2-m02-python-tooling)
3. [M0.3 Docker Compose stack](#3-m03-docker-compose-stack)
4. [M0.4 The Makefile](#4-m04-the-makefile)
5. [M0.5 Continuous integration](#5-m05-continuous-integration)
6. [How it all fits together](#6-how-it-all-fits-together)
7. [Problems we actually hit](#7-problems-we-actually-hit)
8. [Known limitations](#8-known-limitations)
9. [Glossary](#9-glossary)
10. [Verification status](#10-verification-status)

---

## 0. The big picture

Sideline is a data engineering project: pull sports data in, clean it,
store it, and serve it. Before writing any of that, M0 builds the
**workshop** you'll do the work in. M0 contains no sports logic. It
answers five questions:

| Question | Answer built in M0 |
|---|---|
| Where does the code live and how is it organised? | A monorepo with one folder per concern (M0.1) |
| How do I make sure my code is clean and consistent? | uv, ruff, mypy, pytest, pre-commit (M0.2) |
| Where do my services (storage, database) run? | Docker Compose (M0.3) |
| How do I run common tasks without remembering commands? | A Makefile (M0.4) |
| How do I stop broken code from reaching `main`? | CI plus branch protection (M0.5) |

Three layers of protection catch mistakes at different times:

```
 You type code
      |
      v
 [1] pre-commit   runs when you `git commit`   (seconds, on your laptop)
      |
      v
 [2] make lint/test   run whenever you choose  (same checks, on demand)
      |
      v
 [3] CI (GitHub)  runs on every push and PR    (on a clean machine)
```

Each layer runs the **same underlying tools**. That's deliberate:
"works on my machine" can't drift away from "works in CI".

---

## 1. M0.1 The monorepo

### What it is

A **monorepo** keeps many related projects in one git repository instead
of one repository per project. Sideline's ingestion code, dbt models,
Spark jobs and ML code all live together.

Why it suits a learning project:
- One clone, one set of tools, one CI pipeline.
- A change that touches ingestion *and* transform lands as one commit.
- Everything is visible in one place, which is good for a portfolio.

The trade-off is that a monorepo needs discipline about folder
boundaries, which is why every folder has a purpose statement.

### The layout

| Folder | Holds | Arrives in |
|---|---|---|
| `ingestion/` | Code that pulls raw data from outside sources | early modules |
| `transform/` | dbt/SQL that turns raw data into clean tables | M5 |
| `orchestration/` | Schedulers that run jobs in order (DAGs) | M6 |
| `spark/` | Large-scale batch jobs | M7 |
| `streaming/` | Near-real-time pipelines | M8 |
| `quality/` | Data validation rules | M9 |
| `ml/` | Model training | M12 |
| `serving/` | APIs that expose data | M11 |
| `infra/` | Infrastructure as code (Terraform), Dockerfiles | M10 |
| `sql/` | SQL practice problems | ongoing |
| `docs/` | ADRs, design docs, incident write-ups, this guide | ongoing |
| `tests/` | Cross-repo tests (currently one smoke test) | M0.5 |

Each folder has a one-line `README.md`. This isn't only documentation.
**Git cannot track an empty folder.** A file inside is the only way to
make the folder exist in the repository.

### Licence

`LICENSE` is the **MIT License**: anyone may use, copy and modify the
code, as long as they keep the copyright notice. MIT was chosen over
Apache-2.0 because a personal learning project doesn't need Apache's
patent grant.

### `.gitignore`

A `.gitignore` tells git which files to **never track**. This matters
for two reasons: keeping junk out of history, and keeping **secrets** out.

Our file has these sections:

```gitignore
.env              # real secrets: never commit
.env.*            # .env.local, .env.prod, ...
!.env.example     # ...EXCEPT the template, which IS committed
.venv/            # the virtual environment (machine-specific)
__pycache__/      # Python bytecode cache
target/           # dbt build output
dbt_packages/     # dbt downloaded dependencies
**/.terraform/*   # Terraform plugins, in any folder at any depth
*.tfstate         # Terraform state can contain secrets
*.tfvars          # Terraform variable values can contain secrets
*.duckdb          # local database files
```

Pattern syntax worth knowing:

| Pattern | Meaning |
|---|---|
| `foo/` | a directory named `foo` |
| `*.log` | any file ending in `.log` |
| `**/x` | `x` at any depth |
| `!pattern` | **negation**: un-ignore something an earlier rule ignored |

Order matters with negation. `!.env.example` only works because it comes
*after* `.env.*`. Reverse them and the template would be ignored.

### How it was done

1. Confirmed the repo was public (`gh repo view`).
2. Added `LICENSE` and `.gitignore`.
3. Created the folders, each with a README.
4. Committed to `main` as the root commit.

### Try it yourself

```bash
git check-ignore -v .env                # shows which rule ignores it
git check-ignore -v .env.example        # prints nothing: not ignored
git ls-files                            # everything git tracks
```

### Check your understanding

1. Why does every folder have a README? *(Git can't track empty folders.)*
2. Why is `.env.example` committed but `.env` isn't? *(One is a safe
   template; the other holds real secrets.)*
3. Why is `*.tfstate` ignored? *(It can contain sensitive values.)*

---

## 2. M0.2 Python tooling

### The problem this solves

Without shared tooling, every contributor formats code differently,
installs slightly different library versions, and catches different
bugs. M0.2 fixes all three with automation.

### The tools at a glance

| Tool | One-line job | Replaces |
|---|---|---|
| **uv** | Installs Python, creates the environment, installs packages | pip + venv + pip-tools |
| **pyproject.toml** | The single config file for the project | setup.py, setup.cfg, requirements.txt, tool dotfiles |
| **uv.lock** | The exact version of every package, pinned | (requirements.txt with `==` pins) |
| **ruff** | Lints (finds problems) and formats (fixes style) | flake8, isort, black |
| **mypy** | Checks type annotations are consistent | (none; optional discipline) |
| **pytest** | Finds and runs tests | unittest |
| **pre-commit** | Runs the checks automatically on `git commit` | manual discipline |

### uv

**uv** is one fast program (written in Rust, by the Ruff authors) that
does the jobs of several older tools:

- Reads `pyproject.toml` and works out which package versions satisfy it.
- Writes the answer to `uv.lock`.
- Creates and manages `.venv/` (you never run `python -m venv`).
- Downloads a suitable Python if yours is too old.
- Runs commands inside the environment: `uv run pytest`.

A **virtual environment** (`.venv/`) is a private folder of installed
packages for one project, so project A's libraries never clash with
project B's.

Commands you'll use:

| Command | Meaning |
|---|---|
| `uv sync` | Make `.venv/` match the lockfile |
| `uv sync --locked` | Same, but **fail** if the lockfile is out of date (used in CI) |
| `uv lock` | Re-resolve versions and rewrite `uv.lock` |
| `uv run <cmd>` | Run a command inside `.venv/` |
| `uv add <pkg>` | Add a dependency and update the lock |

### The lockfile

`pyproject.toml` says `ruff>=0.17`: **any** version from 0.17 up.
`uv.lock` says `ruff==0.17.5` plus hashes, and pins every package ruff
itself depends on.

Think of it as a recipe versus a shopping receipt. The recipe says "some
flour". The receipt says exactly which bag, so anyone repeating the shop
gets the same flour. Commit the lockfile so every machine and CI run
installs identical packages.

### `pyproject.toml`, section by section

```toml
[project]
name = "sideline"
requires-python = ">=3.12"     # refuse to run on older Pythons
dependencies = []              # runtime deps: none yet
```

`[project]` is the one standardised section (PEP 621) every Python tool
reads the same way.

```toml
[dependency-groups]
dev = ["ruff>=0.17", "mypy>=2.0", "pytest>=9.0",
       "pre-commit>=4.0", "duckdb>=1.4,<2"]
```

`[dependency-groups]` (PEP 735) holds dependencies that are **not
shipped**, only used for development. `duckdb>=1.4,<2` is capped below
2.0 because 2.0.0 had just been released when we resolved it, and a
brand-new major version is a risk we didn't need to take.

```toml
[tool.uv]
package = false
```

Tells uv this repo is a collection of scripts, not a library to build
and install. Without it, `uv sync` tries to build a `sideline` package
and fails because no importable package exists.

Everything under `[tool.X]` is config owned by tool `X`:

#### `[tool.ruff]`

| Option | Meaning |
|---|---|
| `target-version = "py312"` | Assume Python 3.12 features and syntax |
| `line-length = 100` | Wrap lines at 100 characters |
| `src = [...]` | Folders ruff treats as first-party code when sorting imports |

#### `[tool.ruff.lint] select`

Ruff has hundreds of rules, grouped by letter prefix. We enabled:

| Code | Name | Catches |
|---|---|---|
| `E` | pycodestyle errors | Style errors such as lines too long (`E501`) |
| `F` | pyflakes | Unused imports, undefined names |
| `I` | isort | Imports out of order |
| `UP` | pyupgrade | Outdated syntax (`List[int]` instead of `list[int]`) |
| `B` | bugbear | Likely bugs, such as a mutable default argument |
| `C4` | comprehensions | Needless `list(x for x in y)` wrapping |
| `SIM` | simplify | `if x: return True else: return False` |

#### `[tool.ruff.format]`

`quote-style = "double"` always uses `"` quotes. `docstring-code-format`
also formats code examples written inside docstrings.

#### `[tool.mypy]`

**Type hints** are optional labels like `def f(x: int) -> str`. They
don't change how Python runs, but **mypy** reads them and reports
mismatches before you run anything. We set explicit flags rather than
the blanket `strict = true`, so each one can be explained:

| Flag | Effect |
|---|---|
| `python_version = "3.12"` | Check against 3.12 semantics |
| `disallow_untyped_defs` | Every function needs annotations |
| `disallow_incomplete_defs` | No half-annotated functions |
| `check_untyped_defs` | Still check bodies of unannotated functions |
| `no_implicit_optional` | `x: int = None` is an error; write `int \| None` |
| `warn_redundant_casts` | Flag a `cast()` that changes nothing |
| `warn_unused_ignores` | Flag a `# type: ignore` that suppresses nothing |
| `warn_return_any` | Flag a typed function that secretly returns `Any` |
| `warn_unused_configs` | Flag config options that match no file |
| `ignore_missing_imports` | Don't fail on libraries that ship no type info |

#### `[tool.pytest.ini_options]`

| Option | Meaning |
|---|---|
| `testpaths` | Where pytest looks for tests |
| `python_files` | Which filenames count as tests (`test_*.py`, `*_test.py`) |

The `.ini_options` suffix is pytest's name for its section inside
`pyproject.toml`. It's historical: pytest's config used to live in
`pytest.ini`.

### pre-commit

Git has **hooks**: scripts that run at certain moments, such as just
before a commit is created. They live in `.git/hooks/`, which isn't
tracked, so a team can't share them.

The **pre-commit** tool solves that. Hooks are declared in a tracked
file, `.pre-commit-config.yaml`, and `pre-commit install` writes a small
shim into `.git/hooks/pre-commit`. From then on, `git commit` first runs
every hook on the files you're committing. If any hook fails, **the
commit is blocked**.

Our hooks:

| Hook | Does |
|---|---|
| `trailing-whitespace` | Strips spaces at line ends |
| `end-of-file-fixer` | Ensures files end with exactly one newline |
| `check-yaml` / `check-toml` | File parses |
| `check-added-large-files` | Blocks accidental data dumps |
| `check-merge-conflict` | Blocks leftover `<<<<<<<` markers |
| `mixed-line-ending` | Normalises to LF (Unix) line endings |
| `ruff` (shown as "legacy alias") | Lints, with `--fix` to auto-correct |
| `ruff-format` | Formats |
| `mypy` | Type checks |

Details:

- Each hook repo is pinned to an exact `rev:` tag, so everyone runs the
  same version.
- Hooks run in **their own isolated environments**, so mypy's
  dependencies never leak into your `.venv/`.
- There's deliberately **no pytest hook**. Tests are slower and belong
  in `make test` and CI, not blocking every commit.
- If a hook *modifies* a file (auto-fix), the commit still fails once.
  Review the change, `git add` it, and commit again.
- A hook shows `(no files to check)` or `Skipped` when none of the
  staged files match its type. That's normal, not a failure.

### How it was done

1. Installed `uv` and `pre-commit` with Homebrew.
2. Wrote `pyproject.toml`, ran `uv sync`, which generated `uv.lock`.
3. Wrote `.pre-commit-config.yaml`.
4. Ran `uv run pre-commit install`, then `pre-commit run --all-files`
   to check everything now, not only staged files.

### Try it yourself

```bash
uv sync --locked                       # install exactly what's locked
uv run ruff check                      # lint
uv run ruff format --check             # would formatting change anything?
uv run pre-commit run --all-files      # run every hook on every file
```

Break something on purpose, then run `uv run ruff check`:

```python
# scratch.py
import os  # F401: imported but unused
```

### Check your understanding

1. `pyproject.toml` vs `uv.lock`: which is a range, which is exact?
2. Why is `package = false` needed?
3. Why isn't pytest a pre-commit hook?
4. What does `E501` mean? *(Line longer than `line-length`.)*
5. A commit "failed" but a file changed. What do you do?
   *(Review the diff, `git add` it, recommit.)*

---

## 3. M0.3 Docker Compose stack

### Concepts first

| Term | Meaning |
|---|---|
| **Image** | A frozen, read-only template: an operating system plus software. Like a class. |
| **Container** | A running instance of an image. Like an object. Disposable. |
| **Volume** | Storage that **outlives** a container. Without one, data dies with the container. |
| **Bind mount** | A host folder made visible inside a container. |
| **Registry** | A server hosting images (Docker Hub, quay.io, ghcr.io). |
| **Docker Compose** | Describes several containers in one YAML file, so one command starts them all. |
| **Healthcheck** | A command Docker runs repeatedly to see whether a service is actually ready. |

A container being *started* is not the same as the service inside being
*ready*. Postgres can take seconds to accept connections after its
container starts. Healthchecks let Compose wait for real readiness.

### What each service is

#### MinIO / Silo: object storage

**Object storage** stores files ("objects") in flat containers called
**buckets**, addressed by key like `nba/2026/games.json`. Amazon S3 is
the famous example. It's cheap and scales hugely, which is why data
lakes use it.

**MinIO** is software that speaks the **S3 API** on your laptop, so code
written against local MinIO later runs against real AWS S3 unchanged.

**Important substitution:** the ticket says MinIO, but MinIO stopped
publishing images anyone can download without logging in (Docker Hub
returns 404, Quay returns 401). We use **`pgsty/silo`**, a
community-maintained, API-compatible MinIO fork. The environment
variables (`MINIO_ROOT_USER`...), the `mc` command-line client and the
health endpoints are the same. Service names in `compose.yaml` still say
`minio` so nothing else needs to change if you swap back.

Two ports: **9000** is the S3 API your code talks to, and **9001** is a
web console you can browse in a browser.

#### Postgres: relational database

**PostgreSQL** is a traditional database server holding tables you query
with SQL. It's reserved for the fantasy league database in a later
module. Sideline uses a **lakehouse** (files in object storage) for
analytics and Postgres for transactional app data.

#### DuckDB: "DuckDB-ready" explained

DuckDB is different: it's an **embedded** analytical database. There's
**no server**, so nothing to start. It's a library you import
(`import duckdb`) that runs inside your Python process, and it can query
files like Parquet directly.

So "DuckDB-ready dev container" means a container where DuckDB is
installed and a project is mounted, not a DuckDB service. That's the
`dev` service.

### `compose.yaml`, line by line

```yaml
name: sideline
```
Prefix for everything Compose creates (`sideline-minio-1`,
`sideline_default` network).

```yaml
services:
  minio:
    image: pgsty/silo:RELEASE.2026-10-26T00-00-00Z
```
The `RELEASE...` tag **pins** an exact version. `latest` would silently
change under you.

```yaml
    command: server /data --console-address ":9001"
```
Arguments passed to the image's program: serve data from `/data`, put
the web console on 9001.

```yaml
    env_file: .env
    environment:
      MINIO_ROOT_USER: ${MINIO_ROOT_USER}
```
Two separate mechanisms are in play, and they're easy to confuse:
- `env_file: .env` loads the file's variables **into the container**.
- `${MINIO_ROOT_USER}` inside the YAML is **Compose-time substitution**.
  Compose reads `.env` in the project folder automatically and fills it
  in before starting anything.

```yaml
    ports:
      - "${MINIO_API_PORT:-9000}:9000"
```
Format is `host:container`. `${VAR:-default}` uses `9000` if the
variable is unset.

```yaml
    volumes:
      - minio-data:/data
```
Mounts the **named volume** `minio-data` at `/data`, so stored objects
survive `make down`.

```yaml
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
      interval: 5s
      timeout: 3s
      retries: 12
```
Every 5s, request the health endpoint. `-f` makes curl fail on HTTP
errors. After 12 failures in a row, the container is "unhealthy".

#### `minio-init`: a one-shot job

```yaml
  minio-init:
    image: pgsty/mc:RELEASE.2026-10-26T00-00-00Z
    depends_on:
      minio:
        condition: service_healthy
    entrypoint: >
      /bin/sh -c "
      mc alias set local http://minio:9000 $${MINIO_ROOT_USER} $${MINIO_ROOT_PASSWORD} &&
      (mc ls local/sideline-raw >/dev/null 2>&1 || mc mb local/sideline-raw) &&
      mc anonymous set none local/sideline-raw
      "
```

Reading it:
- `mc` is MinIO's command-line client.
- `depends_on ... service_healthy` waits for MinIO's *healthcheck*, not
  merely its start.
- `$$` is how you write a literal `$` in Compose. Compose would
  otherwise try to substitute `$MINIO_ROOT_USER` itself, before the
  container exists. `$$` passes it through so the **shell inside the
  container** expands it.
- `mc ls ... || mc mb ...` means "create the bucket only if listing it
  fails". That makes the job **idempotent**: safe to run repeatedly.
- `mc anonymous set none` makes the bucket private.
- The container **exits** when the commands finish. That's intended: it
  is a task, not a server.

#### `postgres`

`pg_isready` is Postgres's own "can you accept connections" tool, so the
healthcheck uses it. Note `$${POSTGRES_USER}` again, with the same `$$`
reasoning. Data goes in the named volume `postgres-data`.

#### `dev`

Abridged excerpt (see `compose.yaml` for the exact formatting):

```yaml
  dev:
    build:
      context: .
      dockerfile: infra/Dockerfile.dev
    working_dir: /workspace
    volumes:
      - .:/workspace
      - uv-cache:/root/.cache/uv
    depends_on:
      minio:       { condition: service_healthy }
      postgres:    { condition: service_healthy }
      minio-init:  { condition: service_completed_successfully }
    command: ["sh", "-c", "uv sync --locked --dev && exec sleep infinity"]
```

- `build:` builds an image from a Dockerfile instead of downloading one.
- `.:/workspace` is a **bind mount**: your repo appears at `/workspace`,
  and edits on your Mac show up instantly inside.
- `service_completed_successfully` waits for the init job to **exit with
  code 0**. So the dev container starts only after the bucket exists.
- `sleep infinity` keeps the container alive so you can `exec` into it.
  Without a long-running command it would exit immediately.

### `infra/Dockerfile.dev`

```dockerfile
FROM python:3.12-slim
COPY --from=ghcr.io/astral-sh/uv:0.13.8 /uv /uvx /usr/local/bin/
WORKDIR /workspace
ENV UV_PROJECT_ENVIRONMENT=/opt/venv \
    UV_CACHE_DIR=/root/.cache/uv \
    PATH="/opt/venv/bin:$PATH"
CMD ["sleep", "infinity"]
```

- `FROM` picks the base image: Python 3.12 on a slim Debian.
- `COPY --from=<image>` grabs just the `uv` binary out of another image,
  rather than installing uv some other way.
- `UV_PROJECT_ENVIRONMENT=/opt/venv` is the **key trick**. By default uv
  puts the environment at `.venv/` inside the project, which here is the
  bind-mounted folder shared with your Mac. Linux packages written there
  would overwrite your Mac's `.venv/` and break local tooling. Putting
  the environment at `/opt/venv`, outside the mount, keeps them separate.
- `PATH=...` puts that environment's programs first, so `python` and
  `pytest` work without `uv run`.

### `.env` and `.env.example`

- **`.env.example`**: committed. Documents which variables exist, with
  placeholder values.
- **`.env`**: your real copy, gitignored. `make up` creates it from the
  example if it's missing.

The rule: **secrets never get committed; the template does.** The
example's passwords are deliberately obvious placeholders
(`change-me-local-only`), fine for a laptop and unacceptable anywhere
real.

### How it was done

1. Wrote `compose.yaml`, the Dockerfile and `.env.example`.
2. Added `duckdb` to the dev dependencies.
3. Installed Docker Desktop and ran `make up`.
4. First attempt **failed**: the MinIO images wouldn't download (see
   [section 7](#7-problems-we-actually-hit)). Swapped to Silo.
5. Verified: all services healthy, bucket created and private, DuckDB
   imports inside `dev`, Postgres answers `select version()`.

### Try it yourself

```bash
make up                                          # start everything
docker compose ps                                # see status/health
docker compose logs minio-init                   # see the bucket being made
docker compose exec dev python -c "import duckdb; print(duckdb.sql('select 42'))"
docker compose exec postgres psql -U sideline -d sideline -c "select 1"
open http://localhost:9001                       # S3 web console
make down                                        # stop (data kept)
```

Once you understand volumes, try this. It **deletes the data** in the
named volumes, so only do it on a stack you're happy to wipe:

```bash
docker compose down -v      # -v also removes volumes
```

### Check your understanding

1. Container vs image? *(Running instance vs template.)*
2. Why `service_healthy` rather than just starting in order? *(Started
   is not ready.)*
3. Why `$$` in the init script? *(Stop Compose substituting early; let
   the container's shell do it.)*
4. What happens to data on `make down`? On `down -v`? *(Kept; deleted.)*
5. Why is the venv at `/opt/venv`? *(Avoid Linux binaries clobbering the
   Mac `.venv/` through the bind mount.)*
6. Why is DuckDB not a service? *(It's an embedded library, no server.)*

---

## 4. M0.4 The Makefile

### What `make` is

`make` is a 1970s tool that runs named recipes from a file called
`Makefile`. It's no longer only for compiling code. It's a handy
**menu of project commands**, so you type `make test` instead of
remembering `uv run pytest`.

### Anatomy

```make
target: dependencies    ## description
<TAB>command
```

- The **target** is the name you type after `make`.
- The command line **must start with a real Tab character**, not spaces.
  This is the classic make gotcha.

### Our Makefile explained

```make
COMPOSE := docker compose
UV_RUN  := uv run
```
Variables. `:=` assigns once. Use them as `$(COMPOSE)`.

```make
.DEFAULT_GOAL := help
```
Plain `make` with no target runs `help`.

```make
.PHONY: help up down ...
```
Tells make these names are **actions, not files**. Without it, a file
called `test` in the folder would make `make test` say "nothing to do".

#### The self-documenting `help`

```make
help: ## Show this help
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'
```

It scans the Makefile for lines shaped `name: ... ## text` and prints
them as a table. The payoff: **documentation lives next to the command**,
so it can't go stale. Add a target with a `##` comment and it appears in
`make help` automatically.

Small symbols:
- `@` before a command hides the command itself from the output.
- `$$` is a literal `$` (make's version of the Compose trick).
- `$(MAKEFILE_LIST)` is the Makefile's own filename.

### The targets

| Target | Runs | Notes |
|---|---|---|
| `make up` | `docker compose up -d --wait` | Creates `.env` first if missing; `-d` runs in background; `--wait` blocks until healthy |
| `make down` | `docker compose down` | Removes containers, **keeps** volumes |
| `make ps` | `docker compose ps` | Status |
| `make logs` | `docker compose logs -f` | `-f` follows live |
| `make dev-shell` | `docker compose exec dev bash` | A shell inside the dev container |
| `make sync` | `uv sync --locked --dev` | Install from lockfile |
| `make test` | `uv run pytest` | |
| `make lint` | `ruff check` and `ruff format --check` | Check only, changes nothing |
| `make typecheck` | `mypy` on all `.py` files | See below |
| `make format` | `ruff check --fix` and `ruff format` | **Changes files** |
| `make hooks` | `pre-commit install` | One-time setup |

Two design choices to understand:

1. **`lint` checks; `format` fixes.** Separating them means CI can run
   `lint` safely (it never modifies code), while you run `format`
   locally to fix what `lint` complains about.
2. **The mypy command** is
   `uv run mypy $$(git ls-files -co --exclude-standard '*.py')`.
   Bare `mypy` crashes when a configured folder contains no `.py` files,
   and most of our folders are still empty. So we give it an explicit
   list. `git ls-files -c -o --exclude-standard` means "tracked files
   plus untracked-but-not-ignored files", so new work is checked too.

### Try it yourself

```bash
make help
make lint
make test
make -n up        # -n = dry run: print commands without running them
```

### Check your understanding

1. Why `.PHONY`? *(Names aren't files; avoid clashes.)*
2. What does `@` do? *(Hides the command from output.)*
3. Why do `lint` and `format` exist separately?
4. How does `make help` stay up to date by itself? *(It greps the `##`
   comments.)*

---

## 5. M0.5 Continuous integration

### What CI is

**Continuous Integration** means a robot automatically runs your checks
on a **clean machine** every time code is pushed. It exists because
"works on my laptop" isn't proof. Your laptop has stray files, old
installs and unpushed changes that hide problems.

**GitHub Actions** is GitHub's CI system. Vocabulary:

| Term | Meaning |
|---|---|
| **Workflow** | A YAML file in `.github/workflows/` describing automation |
| **Trigger (`on:`)** | The events that start it |
| **Job** | A group of steps that run on one machine |
| **Runner** | The machine (`ubuntu-latest`) |
| **Step** | One command (`run:`) or one reusable **action** (`uses:`) |
| **Action** | A packaged, reusable step written by someone else |

### `.github/workflows/ci.yml` explained

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
```
Run on every push to `main` and on every pull request.

```yaml
jobs:
  python:
    runs-on: ubuntu-latest
```
One job named `python`. **That name matters**: it's what branch
protection refers to.

```yaml
    steps:
      - uses: actions/checkout@v4
```
The runner starts empty. This action downloads your repository onto it.

```yaml
      - name: Install uv
        uses: astral-sh/setup-uv@v10.3.3
        with:
          enable-cache: true
```
Installs uv. `enable-cache` reuses downloads between runs for speed.

```yaml
      - run: uv sync --locked --dev
      - run: uv run ruff check
      - run: uv run ruff format --check
      - run: uv run mypy $(git ls-files -co --exclude-standard '*.py')
      - run: uv run pytest
```

Steps run top to bottom and **stop at the first failure**; a failing
step turns the job red. `--locked` makes the install fail if `uv.lock`
doesn't match `pyproject.toml`, which catches "I changed dependencies
and forgot to re-lock". These are the same commands as the Makefile, on
purpose.

**Pinning:** `setup-uv@v10.3.3` is an exact version. Pinning protects
you from an action changing unexpectedly. Our first attempt used `@v10`
and failed because that tag doesn't exist (see section 7).

### Branch protection

CI alone only *reports*. **Branch protection** is the rule that turns
the report into a gate. On `main` we configured:

- **Required status check: `python`**: a PR can't merge until the job
  with that name passes.
- **`strict: true`**: the branch must be up to date with `main` before
  merging, so CI tested what will actually land.
- **No force pushes, no deletion** of `main`.

This is configured in GitHub settings, not in a file in the repo. We set
it through the API.

### How it was done and proven

The ticket has three acceptance criteria, each proven differently:

1. **Passes on main**: pushed the workflow; run `43791427861` succeeded.
2. **A deliberately broken PR fails**: created branch `ci-test-break`
   containing a syntax error, opened PR #184, saw the `python` check
   fail, then closed the PR unmerged and deleted the branch.
3. **Branch protection requires CI**: configured via the API and read
   back to confirm.

### Try it yourself

```bash
gh run list                         # recent CI runs
gh run view --log-failed            # logs of the latest failure
gh api repos/Dfscashline21/sideline/branches/main/protection
```

The best exercise is to repeat the broken-PR experiment yourself: make a
branch, add a file with a lint error, push, open a PR, and watch the red
check appear.

### Check your understanding

1. Why does CI run on a fresh machine?
2. What does `--locked` protect against?
3. Why does the job name `python` matter?
4. CI fails; can the PR merge? *(No: required check.)* Can an admin
   push straight to `main`? *(Currently yes; see section 8.)*

---

## 6. How it all fits together

A change's life, from keyboard to `main`:

```
 edit code
    |
    |  make format        auto-fix style
    |  make lint test     check it your way
    v
 git commit  ---->  pre-commit hooks run (ruff, mypy, hygiene)
    |                   fail? fix and recommit
    v
 git push / open PR ---->  GitHub Actions runs the SAME checks on a clean box
    |                          red? fix and push again
    v
 branch protection: "python" must be green
    |
    v
 merge to main
```

And the local stack, independent of the code checks:

```
 make up
   |
   +--> minio (storage)  ---healthy--->  minio-init creates sideline-raw
   |                                          |
   +--> postgres (db)  ---healthy---+         | exits 0
                                    |         |
                                    +---> dev container starts
                                          (uv sync, DuckDB ready)
```

Dependency chain: **everything later builds on M0.** ingestion code
(M1+) will write into `sideline-raw`; every new `.py` file is checked by
ruff, mypy and CI automatically; the Makefile is where new commands get
added.

---

## 7. Problems we actually hit

Real bugs are the best teaching material. Each of these happened while
building M0.

| # | Symptom | Cause | Fix | Lesson |
|---|---|---|---|---|
| 1 | `uv lock` picked `duckdb 2.0.0` | A brand-new major version satisfied `>=1.4` | Capped at `<2` | An open-ended `>=` can pull in a surprise major release |
| 2 | `mypy` exited with "no .py files in directory" | Config listed folders that were still empty | Pass an explicit file list | Tools can behave differently on empty input |
| 3 | `mypy` with `$(git ls-files '*.py')` got no files | `git ls-files` ignores untracked files | Added `-co --exclude-standard` | Check your command's assumptions about what exists |
| 4 | First CI run failed instantly: `unable to find version v10` | The action publishes only exact tags, not a moving `v10` | Pinned `v10.3.3` | Verify a version tag exists before using it |
| 5 | `docker compose up` failed: `401 UNAUTHORIZED` pulling MinIO | MinIO stopped publishing public images | Swapped to `pgsty/silo` and `pgsty/mc` | Upstream can vanish; pin versions and know your alternatives |
| 6 | Commit blocked, pre-commit "Failed" | A hook modified a file, or a check genuinely failed | Review, `git add`, recommit | A failing hook is the system working |
| 7 | My own `docker` command not found after installing | Docker's CLI lives inside the app bundle and wasn't on `PATH` yet | Used `~/.docker/bin` | "Installed" and "on PATH" are different |

---

## 8. Known limitations

Be honest about what M0 does **not** do. These are worth knowing and
fixing later.

1. **Admins can bypass branch protection.** `enforce_admins` is `false`,
   so the repository owner can push straight to `main` (git even prints
   "Bypassed rule violations"). PRs are gated; direct admin pushes are
   not. Turn it on under Settings, Branches if you want CI to gate you
   too.
2. **Services listen on all network interfaces.** `ports: "9000:9000"`
   publishes to every interface, not just your laptop, and the default
   passwords are weak placeholders. On shared Wi-Fi, bind to localhost
   with `"127.0.0.1:9000:9000"`.
3. **`env_file: .env` over-shares.** Every container receives every
   variable, including credentials it doesn't need. Acceptable for local
   development; tighten when it matters.
4. **No Python version pin.** There's no `.python-version` file. The
   local `.venv` runs Python 3.15, the dev container runs 3.12, and
   ruff/mypy target 3.12. Code that passes locally could use a feature
   3.12 lacks. Pinning one version everywhere would close this gap.
5. **Silo is a community fork.** It's compatible today, but it isn't
   MinIO's own product. The ticket's wording says MinIO.
6. **CI doesn't run pre-commit.** CI runs the same tools directly but
   skips hygiene hooks such as trailing-whitespace.
7. **One trivial test.** `tests/test_smoke.py` only proves pytest runs
   and the layout exists. Real tests arrive with real code.
8. **`actions/checkout@v4`** triggers a Node 20 deprecation warning in
   CI. Harmless now; bump the version eventually.

---

## 9. Glossary

| Term | Plain meaning |
|---|---|
| **ADR** | Architecture Decision Record: a short note on why a technical choice was made |
| **Image tag** | A label such as `3.12-slim` identifying one version of an image |
| **Bind mount** | A host folder shared into a container |
| **Bucket** | A top-level container for objects in object storage |
| **CI** | Continuous Integration: automatic checks on every push |
| **Container** | A running, disposable instance of an image |
| **DAG** | Directed Acyclic Graph: tasks with dependencies and no loops (orchestration) |
| **dbt** | A tool that builds tables from SQL queries (arrives in M5) |
| **Embedded database** | A database that runs inside your program, with no server (DuckDB) |
| **Healthcheck** | A repeated test of whether a service is truly ready |
| **Hook (git)** | A script git runs at certain moments, such as before a commit |
| **Idempotent** | Safe to run many times with the same end result |
| **Image** | A read-only template that containers start from |
| **Lint** | Static analysis that flags likely mistakes and style issues |
| **Lockfile** | A file pinning the exact version of every dependency |
| **Monorepo** | Many projects in one repository |
| **Object storage** | File storage addressed by key, not by folder path (S3) |
| **Pin** | Fix to one exact version |
| **Pre-commit** | The tool, and the moment, that runs hooks before a commit |
| **PR** | Pull Request: a proposal to merge one branch into another |
| **Registry** | A server hosting container images |
| **Runner** | The machine that executes a CI job |
| **S3** | Amazon's object storage service and its de facto API standard |
| **Type hint** | An annotation such as `x: int`, checked by mypy |
| **Virtual environment** | A project-private folder of installed Python packages |
| **Volume** | Container storage that persists after the container is removed |

---

## 10. Verification status

Checked against each ticket's acceptance criteria, using a **fresh clone**
of the GitHub repo (not just the working copy).

| Ticket | Criterion | Result |
|---|---|---|
| **M0.1** | Repo public with MIT/Apache licence | Pass: `PUBLIC`, MIT |
| | All top-level folders with one-line README | Pass: 14 READMEs present |
| | `.gitignore` covers Python, dbt, Terraform, `.env` | Pass: verified with `git check-ignore` |
| **M0.2** | `uv sync` installs from a lockfile | Pass: `uv sync --locked` from fresh clone |
| | `pre-commit run --all-files` passes | Pass: all hooks green on fresh clone |
| | Can explain every config option | Pass: documented in root README and section 2 here |
| **M0.3** | `docker compose up` starts all services healthy | Pass: `make up` healthy; also after `down` then `up` again |
| | Bucket `sideline-raw` created on startup | Pass: init log shows created and private |
| | Secrets from `.env`; `.env.example` committed | Pass: `.env` ignored, never in history; example tracked |
| **M0.4** | `make up/down/test/lint` work | Pass: all run |
| | `make help` lists targets | Pass |
| **M0.5** | Workflow passes on main | Pass: run `43791427861`, and again after later pushes |
| | Deliberately broken PR fails CI | Pass: PR #184 failed |
| | Branch protection requires CI | Pass, with the admin-bypass caveat in section 8 |

Deviations from the ticket text: object storage runs **Silo, not MinIO**
(section 3), and the admin bypass on branch protection (section 8).
