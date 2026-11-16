# M7 · Spark at scale (college joins): module overview

> **Epic:** [#8](https://github.com/Dfscashline21/sideline/issues/8) ·
> **Weeks:** 13 to 14 · **Ready when:** shown a slow job's Spark UI, you
> can name the bottleneck and two fixes in 5 minutes.

> **Written ahead of time.** These labs were drafted before M2 to M6
> existed in your repo. File names, table names and paths follow the
> course's suggested defaults (`ingestion/sideline_ingestion/`,
> `transform/`, Spark catalog `lake` (REST catalog at `localhost:8181`), namespaces `raw`/`staging`/`marts`).
> Where you built something differently, use your names; the steps
> still apply.

## The path

Two tracks run side by side. The **college track** brings the third
league in; the **Spark track** learns the engine. They meet at the
tournament replay.

```
College track:   M7.2 quota design ──► M7.3 college extractor ──► M7.4 staging + crosswalk ──┐
                                                                                             ├──► M7.10 tournament replay
Spark track:     M7.1 study ──► M7.5 Spark + Iceberg ──┬──► M7.6 as-of join ─────┐           │
                                                       ├──► M7.7 skew ───────────┼──► M7.11 tuning diary
                                                       ├──► M7.8 lineups ────────┤
                                                       └──► M7.9 crossover ──────┘
                                                                                      M7.12 closed-book check (last)
M7.13 STAR story: any time
```

- M7.1 and M7.2 have no dependencies on each other. Start both in week 13.
- M7.6 to M7.9 each need only M7.5. Do them in any order, but take
  **Spark UI screenshots as you go**: M7.11 is written from them.
- M7.7 is more realistic once college data has landed (M7.3), because
  the skew comes from data-rich programs.

| Lab | Core skill | Interview frequency |
|---|---|---|
| M7.1 study | Driver/executors, stages, shuffles, join strategies, AQE | Very high |
| M7.2 quota design | Designing within an API budget | Medium |
| M7.4 crosswalk | Entity resolution with a review queue | High, senior roles |
| M7.6 as-of join | Broadcast vs sort-merge, range joins | Very high |
| M7.7 skew | Detecting skew in the UI, salting, AQE | Very high |
| M7.8 lineups | Exploding joins, `MERGE INTO`, partitioning | Medium |
| M7.9 crossover | Choosing the engine with evidence | High |

## Where your work goes

```
spark/
├── sideline_spark/
│   ├── session.py          # M7.5: one place that builds the SparkSession
│   ├── asof_join.py        # M7.6
│   ├── skew.py             # M7.7
│   └── lineups.py          # M7.8
├── bench/                  # M7.9 benchmark harness + results CSV
└── tests/
ingestion/sideline_ingestion/college.py   # M7.3
ingestion/sideline_ingestion/quota.py     # M7.2 guard
transform/models/staging/ncaa_m/, ncaa_w/  # M7.4
docs/blog/spark-tuning-diary.md            # M7.11
docs/notes/m7.md                           # notes, screenshots index
docs/notes/m7-img/                         # Spark UI screenshots (small PNGs)
```

## The stack (checked November 2026)

| Piece | Version | Why it matters |
|---|---|---|
| PySpark | **4.1.4** (pin `pyspark==4.1.4`, same as M8) | PyPI's latest is 4.3, but Iceberg ships a Spark runtime only up to **Spark 4.1**. Unpinned `pyspark` breaks Iceberg |
| Iceberg Spark runtime | `org.apache.iceberg:iceberg-spark-runtime-4.1_2.13:1.12.0` | Must match Spark's minor version **and** Scala 2.13 |
| Iceberg AWS bundle | `org.apache.iceberg:iceberg-aws-bundle:1.12.0` | Needed for `S3FileIO` to read MinIO |
| Java | 17 or 21 | Spark 4 doesn't run on Java 8 or 11. `java -version` before anything else |

Install Java without admin rights if you need to:
`brew install openjdk@21`, then set `JAVA_HOME` (`/usr/libexec/java_home -V`
lists what's installed).

## The college data

Two sources, by design (M7.2 decides the split):

| Source | What it gives | Cost |
|---|---|---|
| sportsdataverse ESPN releases (same URL pattern as [M1](../m1/README.md#the-practice-data)) | Schedules, team and player box scores, play-by-play, for men's (`espn_mens_college_basketball_*`) and women's (`espn_womens_college_basketball_*`) | Free, one file per season |
| [CollegeBasketballData.com](https://collegebasketballdata.com) API (`cbbd` Python client) | Things ESPN files lack: draft picks, lineups, ratings, betting lines, recruiting, transfer portal | Free key: 1,000 calls a month. `Authorization: Bearer <key>` |

Sizes you'll work with (2024-25 season files): men's play-by-play is
about 2.2 million events across ~6,100 games; women's about 2.0 million
across ~5,500. Each is roughly 3.5x a single NBA season (about 0.6
million events), and all seasons of all leagues together is where Spark
starts being worth discussing.

## Know these before you write any code

| Fact | Why it bites |
|---|---|
| College play-by-play logs a substitution as **two rows** ("Subbing in for…", "Subbing out for…", one player each); the NBA logs **one row** with both players | Lineup code written for the NBA silently breaks on college (M7.8) |
| ESPN college box scores include team-total rows with names like `- Team` | They look like players with hundreds of distinct IDs. Filter them before any player logic |
| ESPN often uses the **same** `athlete_id` for a player in college and the NBA (Zion Williamson, Ja Morant, Cooper Flagg), but older players have **different** IDs (Stephen Curry: 32284 at Davidson, 3975 in the NBA) | The crosswalk can't rely on IDs alone, or on names alone (M7.4) |
| `season_type = 3` in college covers the NCAA tournament **and** the NIT, CBI and Crown | Use `notes_headline like 'Men''s Basketball Championship%'` in the schedule files for the real tournament |
| Spark's default `spark.sql.shuffle.partitions` is 200 | On a laptop with small data that's 200 tiny tasks. Lower it for local work and say so in every benchmark |
| The Spark UI lives at http://localhost:4040 **only while the session is running** | Screenshot before `spark.stop()`, or enable the event log and use the history server |
