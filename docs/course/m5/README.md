# M5 · Transformation with dbt: module overview

> **Epic:** [#6](https://github.com/Dfscashline21/sideline/issues/6) ·
> **Weeks:** 8 to 10 · **Ready when:** you can explain when an incremental
> model silently produces wrong numbers, and how you'd catch it.

> **Written ahead of time.** These labs were drafted before M2 to M4
> existed, so they use the suggested names from the course (bucket
> `sideline-raw`, Iceberg namespace `raw`, models like `fact_play`). Where
> your M2.2 layout, M3 designs or M4 tables differ, adapt the names. The
> patterns don't change.

## The path

```
M5.1 study ───────────────────────────────────────────────┐
                                                           ▼
M5.2 init + sources ──► M5.3 staging by hand ──► M5.4 remaining staging
                                                           │
                    ┌──────────────────────┬───────────────┼──────────────────┐
                    ▼                      ▼               ▼                  ▼
            M5.5 dim_player SCD2   M5.8 conformed dims   M5.6 fact_play   M5.11 slim CI
                    │                      │               │ (incremental)
                    │                      │               ├──► M5.13 ADR-004
                    └──────────┬───────────┘               │
                               ▼                           │
                        M5.7 fact_shot + fact_player_game ◄┘
                               │
                               ▼
                        M5.9 metrics ──► M5.12 docs site

M5.10 tests: start in M5.3, keep adding in every lab, finish once the facts exist.
M5.14 closed-book check: last. M5.15 STAR story: any time.
```

M5.1 (reading) and M5.2 (the agent's scaffolding) can run in parallel.
The three branches after M5.4 are independent; M5.7 needs the dims and
the `fact_play` pattern.

## What you build, and where

```
transform/
├── dbt_project.yml            # project name: sideline
├── profiles.yml               # profile: sideline, targets: dev, ci
├── packages.yml               # dbt_utils, dbt_expectations
├── models/
│   ├── staging/               # stg_<league>__<entity>: rename, cast, dedupe. Views.
│   │   ├── _sources.yml       # sources + freshness
│   │   └── _stg_nba.yml       # docs + tests per model
│   ├── intermediate/          # int_*: reusable joins/logic, not exposed
│   └── marts/                 # dim_*, fact_*, metrics. Tables / incremental.
├── snapshots/                 # snp_player_roster (SCD2)
├── tests/                     # singular tests (*.sql)
└── macros/
```

Run everything from `transform/`. Add Make targets so you don't have to:
`make dbt-build`, `make dbt-docs`.

## Tool versions (checked November 2026)

| Package | Version tested | Notes |
|---|---|---|
| `dbt-core` | 1.12.7 | dbt v1. The CLI prints a banner that "dbt v2 is available". Stay on v1 unless you've checked v2 supports DuckDB |
| `dbt-duckdb` | 1.11.1 | Adapter. Supports `append`, `delete+insert`, `merge` and `microbatch` incremental strategies |
| `dbt-metricflow` | 0.15.0 | For M5.9. **Requires Python < 3.15** |
| `dbt_utils` (hub) | 1.4.1 | |
| `dbt_expectations` (hub) | 0.10.10 | Now published as `metaplane/dbt_expectations`; the old `calogica` namespace redirects |

**Python version gotcha.** M0's study guide notes that your host `.venv`
may run Python 3.15. `dbt-metricflow` won't install there. Pin the repo
to 3.12 (a `.python-version` file, which also fixes M0 known limitation
#4) before adding dbt.

## Concepts to know cold

| Concept | One line | Lab |
|---|---|---|
| Materialization | How a model is persisted: view, table, incremental, ephemeral | M5.1 |
| Incremental strategy | How new rows meet old ones: append, delete+insert, merge, microbatch | M5.1, M5.6 |
| Lookback window | Reprocess the last N days every run so late corrections land | M5.6 |
| Snapshot | dbt's SCD2: records how a row changed *as observed over time* | M5.5 |
| Grain | What one row means. Test it with a unique key | M5.7 |
| Conformed dimension | One dim shared by every fact and league | M5.8 |
| Semantic layer | Metrics defined once, queried many ways | M5.9 |
| State selection | `state:modified+` builds only what a PR changed, plus children | M5.11 |

## Gotchas found while testing these labs

| Fact | Why it bites |
|---|---|
| A DuckDB file named `raw.duckdb` becomes a *catalog* called `raw`, which clashes with a *schema* called `raw` | "Ambiguous reference to catalog or schema". Name files and schemas differently |
| Snapshot `strategy: check` stamps validity with the **run time**, not the business date | A trade on Jan 17 gets `dbt_valid_from` = whenever you ran dbt. M5.5 uses `timestamp` with an effective-date column |
| Microbatch needs `event_time` on the **upstream** model too, and a bounded range | Without it dbt warns, and from `begin` it schedules one batch per day up to today (over 1,000 batches in testing) |
| MetricFlow ratio metrics take **metrics**, not measures, as numerator and denominator | Parse error: "The metric `points` does not exist" |
| `mf query --group-by` names dimensions through an entity: `player_game__player_name` | Plain `player_name` fails to resolve |
