# M9 · Data quality, contracts and observability: module overview

> **Epic:** [#10](https://github.com/Dfscashline21/sideline/issues/10) ·
> **Week:** 17 · **Ready when:** you can describe your alerting strategy
> without causing alert fatigue.

> **Written ahead of time.** These labs were drafted before you built M2
> to M8, so they use the course's default names: `sideline-raw`,
> `fact_play`, `dim_game`, the Dagster assets in `orchestration/`, and the
> rest. Wherever your actual design differs, use your own names. The
> ideas carry over unchanged.

## What this module is really about

Up to now you've built a pipeline that works when the data behaves. M9
is about what happens when it doesn't, and about knowing **before** a
stakeholder does. Four layers, from earliest to latest catch:

```
 source API ──► raw zone ──► staging ──► marts (gold) ──► dashboard / API
     │              │            │             │
 [contract]    [contract     [rule checks] [freshness SLO]
  M9.2, M9.3    test]          M9.4         M9.6
                             [volume checks]
                               M9.5
                     lineage over all of it: M9.7
```

Then you test the whole thing by breaking it on purpose (M9.8), write
up one failure properly (M9.9), and put the results on a dashboard
(M9.10).

## The path

```
M9.1 study ──► M9.2 NBA contract ──► M9.3 WNBA + college contracts
     │
     ├──────► M9.4 league-aware rules ─┐
     ├──────► M9.5 volume anomalies ───┤
     └──────► M9.6 freshness SLO ──────┼──► M9.8 chaos day ──► M9.9 postmortem
                                       │                            │
M9.7 lineage (agent, any time after M9.1) ────────────────► M9.10 quality dashboard
                                                                     │
                                                  M9.11 closed-book check ◄┘

M9.12 STAR story: any time.
```

M9.4, M9.5 and M9.6 don't depend on each other or on the contracts: do
them in any order. M9.8 needs all the checks in place, because the point
is to see whether they catch things. M9.10 needs check results, SLO
measurements and at least one incident (M9.9) to show.

## Where things go

```
quality/
├── contracts/
│   ├── nba/nba_api.odcs.yaml          # M9.2 (by hand)
│   ├── wnba/...odcs.yaml              # M9.3 (agent drafts)
│   ├── ncaa_m/...  ncaa_w/...
│   └── fixtures/                      # tiny sample payloads used by CI
├── rules/league_rules.csv             # M9.4: periods, period length per league
├── checks/                            # M9.4/M9.5: SQL checks (or dbt tests)
└── slo/                               # M9.6: freshness measurement
docs/incidents/YYYY-MM-DD-<slug>.md    # M9.9
docs/notes/m9.md                       # M9.11
```

Check results and SLO measurements go in Postgres (already in Compose),
in an `ops` schema, so Dagster, the dashboard and you can all read them:

| Table | One row per | Filled by |
|---|---|---|
| `ops.check_results` | check × run (`run_id`, `checked_at`, `league`, `check_name`, `severity`, `status`, `observed`, `threshold`) | M9.4, M9.5, contract tests |
| `ops.freshness_daily` | league × game day (`game_day`, `league`, `deadline`, `landed_at`, `met`) | M9.6 |

If you'd rather keep them in DuckDB or as dbt test results, that's fine.
Decide once, in M9.4, and use it everywhere.

## Tools used in this module

Versions checked in November 2026. Pin exact versions in `pyproject.toml`
when you add them.

| Tool | Used for | Notes |
|---|---|---|
| [Open Data Contract Standard](https://bitol-io.github.io/open-data-contract-standard/latest/) (ODCS) v3.x | Contract file format | Latest release v3.2.0 (Sept 2026). Required fields: `apiVersion`, `kind`, `id`, `version` |
| [`datacontract-cli`](https://pypi.org/project/datacontract-cli/) | `lint`, `test`, `changelog`, `breaking` on ODCS files | Install with the `[duckdb]` extra for local/S3 testing |
| dbt tests (from M5) or plain SQL | Rule and volume checks | A check is a query that returns the bad rows; zero rows means pass |
| [`openlineage-dbt`](https://pypi.org/project/openlineage-dbt/) | `dbt-ol build` emits lineage | Supports the `duckdb` adapter |
| [`openlineage-python`](https://pypi.org/project/openlineage-python/) | Emit lineage from your own Dagster assets | See M9.7 for why not a ready-made Dagster plugin |
| [Marquez](https://marquezproject.ai/) `marquezproject/marquez` + `marquez-web` 0.51.1 | Lineage UI | Needs its own Postgres database |

## Facts about the data that the checks depend on

All measured on the 2024-25 season's ESPN play-by-play (sportsdataverse
releases), one file per league:

| Fact | NBA | WNBA | NCAA men | NCAA women |
|---|---|---|---|---|
| Regulation periods | 4 quarters | 4 quarters | **2 halves** | 4 quarters |
| Period length (s) | 720 | 600 | 1,200 | 600 |
| Overtime period (s) | 300 | 300 | 300 | 300 |
| Games in the file | 1,324 | 312 | 6,136 | 5,473 |
| Median events per game (regulation only) | 468 | 386 | 335 | 341 |

Things that will trip your checks:

- **Clock column names differ by league.** NBA, WNBA and women's college
  have `start_quarter_seconds_remaining`; men's college has
  `start_period_seconds_remaining` instead. Normalise this in staging.
- **Sentinel coordinates.** Some college shots carry
  `coordinate_x_raw = -214748340` (an integer-overflow placeholder), not
  NULL. A "shots on the court" check finds them; staging should turn them
  into NULL.
- **Most college shots have no coordinates at all** (about 74% of men's
  field-goal attempts are NULL). A rule about coordinates must skip NULLs,
  and a separate check can watch the NULL *rate*.
- **Legitimate weirdness.** The 2025 NBA All-Star event was a mini
  tournament of first-to-40 games: three "regular season" games with a
  single period. Your checks will flag them. That's correct behaviour
  from the check, and a decision for you (exclude exhibitions upstream).
- **Fast teams are real.** The busiest college games (Tennessee women,
  Samford men) have about twice the median number of events with no
  duplicates. High volume isn't automatically bad data.
