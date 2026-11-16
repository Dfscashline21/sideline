# M4 · Storage and Apache Iceberg: module overview

> **Written ahead of time.** These labs were drafted before M2 and M3
> existed in your repo. Names and paths follow the course's suggested
> defaults (catalog `sideline`, table `raw.pbp`, code under
> `ingestion/sideline_ingestion/lakehouse/`). If you built something
> different, adapt the names and keep the steps.

> **Epic:** [#5](https://github.com/Dfscashline21/sideline/issues/5) ·
> **Weeks:** 6 to 7 · **Ready when:** you can draw Iceberg's metadata tree
> from memory and explain how a query skips files.

## The path

```
M4.1 study (Parquet + Iceberg metadata) ──┐
                                          ├──► M4.3 load pbp ──► M4.4 partition evolution ──► M4.7 compaction ──┐
M4.2 REST catalog in Compose (agent) ─────┘          │                                                            │
                                                     ├──► M4.5 schema evolution ─────────────────────────────────┤
                                                     └──► M4.6 stat correction + time travel ────────────────────┤
                                                                                                                  ▼
                                                                         M4.8 benchmark harness (agent) ──► M4.9 blog post

M4.10 ADR-003: any time after M4.2 (it records your catalog choice)
M4.11 closed-book check: last
M4.12 STAR story: any time
```

M4.1 and M4.2 don't depend on each other: study while the agent drafts the
Compose changes. M4.5 and M4.6 only need the loaded table, so do them in
any order. M4.7 comes after M4.4 on purpose: bucketing creates the small
files that compaction then fixes.

| Lab | Core idea | Interview frequency |
|---|---|---|
| M4.1 study | Row groups and stats; metadata → manifest list → manifests → data files | Very high |
| M4.3 load | Hidden partitioning with `month(game_date)` | High |
| M4.4 partition evolution | Specs are versioned; old files keep their old spec | High |
| M4.5 schema evolution | Columns have IDs, not positions; old files read new columns as NULL | High |
| M4.6 time travel | Every commit is a snapshot; read any of them | High |
| M4.7 compaction | Small files: why they hurt and how to fix them | Very high |

## Where your work goes

```
compose.yaml                                  # M4.2: + catalog service (and its init job)
ingestion/sideline_ingestion/lakehouse/
├── catalog.py                                # M4.2/M4.3: load_catalog("sideline") helper
├── load_pbp.py                               # M4.3: one season at a time into raw.pbp
├── evolve_partitions.py                      # M4.4
├── evolve_schema.py                          # M4.5
├── correct_play.py                           # M4.6
└── compact.py                                # M4.7
ingestion/benchmarks/m4/                      # M4.8: harness, results CSV
docs/blog/m4-iceberg/                         # M4.8 charts, M4.9 post
docs/adr/003-iceberg-over-delta.md            # M4.10
docs/notes/m4.md                              # timings from every lab, M4.11
```

## The stack

| Piece | Default in examples | Notes |
|---|---|---|
| Object storage | MinIO (Silo) from M0.3, bucket `sideline-lake` | Raw JSON stays in `sideline-raw` |
| REST catalog | Your M4.2 choice, at `http://localhost:8181/...` | Lakekeeper, Apache Polaris, or the Iceberg REST fixture |
| Writes | PyIceberg 0.12 (`pyiceberg[pyarrow,pyiceberg-core]`) | Python, no JVM |
| Reads and timings | DuckDB 1.5 `iceberg` extension, `ATTACH`ed to the catalog | Same engine as M1, so timings compare |
| Data | ESPN play-by-play, `espn_nba_pbp` release, seasons 2002 to 2026 | ~14.2M rows, ~440 MB of Parquet to download |

## Know these before you start

| Fact | Why it bites |
|---|---|
| The pbp schema drifts: `wallclock` appears in 2013, `points_attempted` and `short_description` in 2021, and `lag_game_half` was renamed `lag_half` in 2020 | Load an explicit column list, not `select *` |
| Season 2002 covers only ~528 games, 2012 is the lockout season, 2020 the bubble season | "Row count verified" means matching the **source files**, not 82 × 15 games |
| Non-shot events have shot coordinates of about ±214,748,000 (a sentinel), and free throws have `coordinate_y = 0` | Averages over coordinates are garbage unless you filter to real shots (M4.5) |
| DuckDB 1.5's `.arrow()` returns a `RecordBatchReader`; PyIceberg can't write a reader to a partitioned table | Use `.to_arrow_table()` |
| PyIceberg needs the `pyiceberg-core` extra to write with `month`/`bucket` transforms | `NotInstalledError: pyiceberg_core needs to be installed` |
| `expire_snapshots` in PyIceberg removes snapshots from metadata but **doesn't delete data files** from storage | Disk usage doesn't drop after compaction (M4.7) |

Measured numbers quoted in these labs come from a test run on three
seasons with a local SQL catalog. Treat them as "the right order of
magnitude", not targets: your laptop and your MinIO setup will differ.
