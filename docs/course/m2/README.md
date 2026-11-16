# M2 · Python ingestion (NBA first): module overview

> **Epic:** [#3](https://github.com/Dfscashline21/sideline/issues/3) ·
> **Weeks:** 3 to 4 · **Ready when:** you can kill the job mid-run, restart
> it, and end with exactly the right data and no duplicates.

> **Written ahead of time.** These labs were drafted before your M0 and M1
> code existed. Where a lab names a file, function or path, treat it as a
> suggestion and adapt it to what you actually built.

## The path

```
M2.1 study ───────────┐
                      ├──► M2.3 extractor ──► M2.4 watermarks ──► M2.5 validation ──┐
M2.2 raw zone design ─┘                                                             │
                                                                                    ▼
             M2.9 closed-book check ◄── M2.8 ADR-001 ◄── M2.7 kill-and-restart ◄── M2.6 tests

M2.10 STAR story: any time in the two weeks
```

M2.1 and M2.2 don't depend on each other. Do both before writing
extractor code: M2.3 needs the retry theory from M2.1 and the key layout
from M2.2. M2.6 (tests) sits after M2.5 in the issue order, but **write
tests as you go** from M2.3 onwards. M2.6 is where you fill the gaps and
wire coverage into CI. M2.8 can be drafted any time after M2.2, since the
decision it records is made there.

| Lab | Core idea | Interview frequency |
|---|---|---|
| M2.1 study | Backoff with jitter, idempotency, watermarks | Very high |
| M2.2 raw zone | Immutable landing, partitioning, re-run safety | High |
| M2.3 extractor | Retries that only retry what's retryable | High |
| M2.4 watermarks | Incremental loads and backfills | Very high |
| M2.5 validation | Validate at the edge, quarantine, don't drop | High |
| M2.7 restart test | Proving idempotency, not claiming it | Very high |

## Where your work goes

```
ingestion/
├── README.md                     # raw zone layout (M2.2)
├── sideline_ingestion/
│   ├── __init__.py
│   ├── http.py                   # fetch with retries + jitter (M2.3)
│   ├── raw_store.py              # key builder + ObjectStore protocol (M2.2, M2.3)
│   ├── s3_store.py               # MinIO/S3 implementation (M2.3)
│   ├── nba.py                    # the extractor (M2.3, M2.4)
│   ├── watermark.py              # watermark state (M2.4)
│   ├── validate.py               # Pydantic models + quarantine (M2.5)
│   └── cli.py                    # --start/--end entry point (M2.4)
└── tests/
    ├── fixtures/                 # recorded API responses (M2.6)
    └── test_*.py
docs/adr/001-raw-data-unchanged.md   # M2.8
docs/notes/m2.md                     # study notes (M2.1) + closed-book check (M2.9)
```

`ingestion` is already listed under ruff's `src` (so imports sort as
first-party) and pytest's `testpaths` (so tests are found). Neither puts
`ingestion/` on the import path, though: without one more line, every
test fails with `ModuleNotFoundError: No module named
'sideline_ingestion'`. M2.3 step 2 adds it:

```toml
[tool.pytest.ini_options]
pythonpath = ["ingestion"]
```

Dependencies you'll add with `uv add` (runtime) or `uv add --dev` (tests):

| Package | Why | Group |
|---|---|---|
| `nba_api` | Endpoint names, parameters and request headers for stats.nba.com | runtime |
| `requests` | The HTTP client you wrap with retries | runtime |
| `boto3` | Talks to MinIO through the S3 API | runtime |
| `pydantic` | Edge validation (M2.5) | runtime |
| `responses` | Fakes `requests` in unit tests (M2.6) | dev |
| `pytest-cov` | Coverage reporting and the 80% gate (M2.6) | dev |
| `types-requests`, `boto3-stubs[s3]` | Type stubs so mypy can check your calls | dev |

## Contract defaults used in examples

| Thing | Default in these labs |
|---|---|
| League key | `nba` |
| Source key | `nba_api` (or `espn` if you use the fallback in M2.3) |
| Raw bucket | `sideline-raw` (exists since M0.3) |
| Raw key | `nba/nba_api/<entity>/ingest_date=YYYY-MM-DD/<run_id>/<name>.json` |
| Entities | `game_log`, `boxscore`, `playbyplay` |
| Watermark | `_state/nba/nba_api/watermark.json` in the same bucket |
| Quarantine | `_quarantine/nba/nba_api/<entity>/ingest_date=…/<run_id>/…` |

M2.2 teaches you to choose these yourself. If you choose differently,
later labs (M4 onwards) refer to "your layout from M2.2".

## Know these before you write any code

| Fact | Why it bites |
|---|---|
| stats.nba.com often **hangs** instead of refusing unknown clients, especially from cloud IPs and some home networks | Without a `timeout`, a request waits forever. Always set one. Check reachability first (M2.3 step 1) |
| `nba_api` endpoint classes don't raise on HTTP errors: a 429 surfaces as a `JSONDecodeError` from parsing the error page | Retrying "on any exception" hides the real status. Do the HTTP call yourself and inspect `status_code` |
| NBA game IDs are 10-digit strings with leading zeros (`0022400061`) | Store them as strings. `int("0022400061")` loses the zeros |
| An NBA season spans two calendar years (`2024-25`) | A date range across the summer needs two `Season` values |
| S3/MinIO `PUT` of one object is atomic: readers see the old object or the new one, never half | It's what makes "skip objects that already exist" safe after a crash |
| `.env` holds MinIO credentials | Load them from the environment; never hard-code or commit them |
