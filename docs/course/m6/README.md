# M6 · Orchestration (WNBA joins): module overview

> **Epic:** [#7](https://github.com/Dfscashline21/sideline/issues/7) ·
> **Weeks:** 11 to 12 · **Ready when:** you can backfill a month of data
> while daily runs continue, without duplicates or conflicts.

> **Written ahead of time.** These labs were drafted before M2 to M5
> existed. Names like `raw_games`, `stg_nba__games` or `fact_team_game`
> are examples from the course's shared conventions. Swap in whatever
> you actually built, and if a lab assumes something your code doesn't
> do, note it in the PR and adapt.

## What changes in this module

Until now, every pipeline step ran because **you** typed a command. M6
makes the platform run itself:

- a second league (WNBA) with a **different calendar**: May to October,
  and a season named after one calendar year rather than the year it ends
- **partitioned assets**: one partition per date × league, so a day can
  be rebuilt on its own
- **schedule awareness**: no runs on days with no games, and an extra run
  after the last game
- **backfills** that run alongside daily runs without stepping on them
- **alerts** someone can act on, with a runbook for each

Dagster is the primary orchestrator. You port one league to Airflow 3
(M6.8) so ADR-005 compares two tools you've actually used.

## The path

```
M6.1 study ─────────────────────────────────────────────┐
                                                        ▼
M6.2 WNBA extractor ──► M6.3 WNBA staging + dims ──► M6.4 Dagster partitioned assets
                                                        │
                    ┌───────────────────┬───────────────┼─────────────────┐
                    ▼                   ▼               ▼                 ▼
          M6.5 calendar sensor   M6.6 alerts +    M6.7 backfill     M6.8 Airflow port
                                     runbooks      NBA 2015-2025          │
                    └───────────────────┴───────────────┴─────────────────┘
                                                        ▼
                                              M6.9 ADR-005 ──► M6.10 closed-book check

M6.11 STAR story: any time
```

- M6.1 and M6.2 can run in parallel: study while the agent drafts the
  WNBA extractor.
- M6.5, M6.6, M6.7 and M6.8 each need M6.4's asset graph, but not each
  other. M6.7 is easier once M6.6's alerts exist, because a long
  backfill is when failures show up.
- M6.9 needs hands-on notes from M6.4 to M6.8.

| Lab | Core skill | Interview frequency |
|---|---|---|
| M6.1 study | Assets vs tasks, partitions, sensors, idempotent writes | Very high |
| M6.4 partitioned assets | Modelling a pipeline as data assets, blocking checks | High |
| M6.5 calendar sensor | Event-driven scheduling, de-duplicated triggers | Medium |
| M6.6 alerting | Actionable alerts, runbooks, lateness vs failure | High, senior roles |
| M6.7 backfill | Safe concurrent reprocessing, idempotency under load | Very high |
| M6.9 ADR | Tool comparison from evidence | High |

## Where your work goes

```
orchestration/
├── sideline_orchestration/
│   ├── definitions.py          # dg.Definitions: the entry point Dagster loads
│   ├── partitions.py           # date × league partitions (M6.4)
│   ├── assets/
│   │   ├── ingest.py           # wraps your M2 / M6.2 extractors
│   │   ├── dbt.py              # dagster-dbt assets over transform/ (M5)
│   │   └── publish.py          # the "publish" step gated by checks
│   ├── checks.py               # asset checks (M6.4)
│   ├── sensors.py              # league calendar + post-game sensor (M6.5)
│   └── alerts.py               # failure + lateness alerting (M6.6)
├── tests/                      # pytest for sensors, partitions, checks
└── airflow/                    # M6.8 only: the WNBA port
docs/
├── runbooks/                   # one page per alert (M6.6)
├── adr/005-dagster-vs-airflow.md
└── notes/m6.md
```

## Versions checked when these labs were written

| Package | Version | Note |
|---|---|---|
| `dagster`, `dagster-webserver` | 1.13.x | Declares support for Python 3.11 to 3.14 |
| `dagster-dbt` | 0.29.x | Versioned separately from `dagster` |
| `apache-airflow` | 3.4.x | Airflow 3: task SDK in `airflow.sdk`, first-class backfills |
| `dbt-duckdb` | 1.11.x | |

M0's known limitation #4 matters here: the host `.venv` may be on a newer
Python than these packages declare. Pin one version (a `.python-version`
file with `3.12`) before adding Dagster.

## Know these before you start

| Fact | Why it bites |
|---|---|
| ESPN timestamps are **UTC**. A 10 p.m. Eastern WNBA tip-off on 15 July shows as `2025-07-16T02:00Z` | Partitioning by the UTC date puts the game on the wrong day. Partition by the league's **local** game date |
| NBA seasons are named for the year they **end** (2026 = 2025-26). WNBA seasons are named for the **calendar year** they're played in (May to October) | `dim_season` needs a rule per league, not one formula |
| NBA and WNBA seasons barely overlap | Most dates have games in only one league. A date × league grid has many empty partitions; that's normal |
| ESPN `team_id`s overlap between leagues (14 = Heat and Storm) | Every key you partition, dedupe or join on must include league |
| Dagster multi-partition keys print as `2025-10-21\|nba` (dimensions in alphabetical order) | Use `context.partition_key.keys_by_dimension["league"]`, never string-split |
| Dagster backfill runs are tagged `dagster/backfill` | That tag is the handle for limiting backfill concurrency separately from daily runs |
