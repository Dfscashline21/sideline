# M11 · Serving and consumption: module overview

> **Epic:** [#12](https://github.com/Dfscashline21/sideline/issues/12) ·
> **Week:** 20 · **Ready when:** you can explain how you'd serve the same
> data to a BI tool, an app and an ML model, and why each differs.

> **Written ahead of time.** These labs were drafted before M2 to M10
> existed. Table names, paths and tools follow the course's suggested
> defaults (`fact_team_game`, `dim_player`, `serving/api/`, …). Where you
> built something different, use your names. The steps still apply.

> **Where the API reads from.** M6.4 publishes gold data to a Postgres
> `serving.team_game` table. The M11.3 example instead reads a read-only
> DuckDB file (`SIDELINE_SERVING_DB=.data/serving.duckdb`), which is simpler
> to run locally. Pick one serving store and use it in both places: either
> point the API at Postgres (via `psycopg`), or make the M6.4 publish step
> write the DuckDB file. Record the choice in `docs/notes/m11.md`.

## The path

```
M11.1 study ──► M11.2 API design (spec first) ──► M11.3 FastAPI ──► M11.4 load test p95 < 200 ms
     │
     ├────────► M11.5 public dashboard   (needs M5 marts; live view needs M8)
     │
     └────────► M11.6 data product pages (needs M5 marts + M9 freshness/SLOs)

M11.7 closed-book check ◄── all of the above          M11.8 STAR story (any time)
```

The API track (M11.2 → M11.4) is strictly sequential. The dashboard
(M11.5) and the product pages (M11.6) only need your gold tables, so they
can run in parallel with the API track.

## What you'll build, and where

| Lab | Output | Location |
|---|---|---|
| M11.1 | Serving-pattern notes, 3 use cases | `docs/notes/m11.md` |
| M11.2 | OpenAPI spec, written before any code | `serving/api/openapi.yaml` |
| M11.3 | FastAPI app with caching and tests | `serving/api/` |
| M11.4 | Load test script and results | `serving/api/loadtest/`, `docs/notes/m11.md` |
| M11.5 | Public dashboard | `serving/dashboard/` + a public URL |
| M11.6 | One page per gold table | `docs/data-products/` |

## Key concepts

| Concept | One line |
|---|---|
| **Gold table** | A mart that consumers are allowed to depend on (your `marts/` models). Everything else is internal. |
| **Serving pattern** | *How* a consumer reads data: BI on the warehouse, a semantic layer, an OLAP store, an API, reverse ETL, or a feature store. |
| **Read model** | A table shaped for one access pattern (e.g. `player_season_stats` keyed by player and season), so the API does a key lookup instead of an aggregation. |
| **p95 latency** | 95% of requests are faster than this. Averages hide the slow tail that users actually notice. |
| **Data product** | A gold table plus a promise: owner, grain, freshness, known issues. M11.6 writes the promise down. |

## Gotchas for the whole module

- **Never let the API aggregate raw facts per request.** Precompute the
  shape the endpoint returns (M1.7's summary-table lesson again). That
  decision alone usually gets you under 200 ms.
- **DuckDB is a single-writer, embedded database.** Many API worker
  processes can read one file, but not while a pipeline is writing it.
  Serve from a read-only copy (or a Parquet export) that the pipeline
  swaps in atomically.
- **A public dashboard can't read your laptop.** The local MinIO and
  `.data/` aren't reachable from the internet. M11.5 has you decide how
  data gets to the hosted app.
- **Public means public.** Nothing in the dashboard or API may expose
  secrets, `.env` values or the M10 PII columns.
