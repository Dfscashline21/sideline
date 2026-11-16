# The Sideline Course

The GitHub issues say **what** to build. This course says **how to get
there**: one lab per ticket, walked through step by step, so you learn by
doing rather than by reading someone else's finished code.

The [M0 study guide](../m0-study-guide.md) explains the parts that were
already built (M0.1 to M0.5). The labs here start where it stops.

---

## How to use a lab

Every lab has the same shape:

| Section | What it's for |
|---|---|
| **Ticket box** | Issue link, build mode, time budget, what you need first |
| **Why this matters** | The concept, and why an interviewer cares about it |
| **What you'll produce** | The acceptance criteria, in plain words |
| **Steps** | Numbered steps. Each ends with a ✅ **Checkpoint** you can verify |
| **Hints** | Collapsed. Open them one at a time, only when you're stuck |
| **Gotchas** | Traps in *this* repo or *this* data that cost real time |
| **Done when** | The checklist to tick before closing the issue |
| **Ship it** | Branch, commit and PR for this ticket |
| **Check yourself** | Questions to answer out loud, closed-book |

### The hint ladder

Most tickets are `mode:hand`: you write the core logic yourself, because
it's what interviews test. When you're stuck, open hints **in order**:

1. **Nudge**: a question that points you in the right direction.
2. **Approach**: the technique to use, in words.
3. **Skeleton**: pseudocode or a partial query with blanks.
4. **Solution**: a working answer. Open it only after you have your own,
   to compare, or after 30 honest minutes stuck.

If you open the solution, close it, wait an hour, and write your own
version from a blank file. That's what makes it stick.

### Build modes

| Label | What it means for the lab |
|---|---|
| `mode:hand` | You write it. Labs give steps and hints, never the code up front. |
| `mode:agent` | An agent may draft it. The lab gives you a **prompt** and a **review checklist**; you must be able to explain every line. |
| `mode:mixed` | Core logic by hand, boilerplate by agent. The lab says which is which. |

### Rhythm for every ticket

```bash
git switch main && git pull
git switch -c m1.3-win-streaks        # one branch per ticket
# ... do the lab ...
make lint && make typecheck && make test
git push -u origin m1.3-win-streaks
gh pr create --fill                   # body: "Closes #28"
```

Branch protection means CI must pass before you merge. Then add a short
entry to the build log (what was asked, what you built, how and why), the
same way M0.1 to M0.5 were written up.

### Your notes

Each module ends with a closed-book check that asks for "3 sentences in
the module's notes". Keep them in `docs/notes/m<N>.md` (public, in the
repo). STAR stories are about your employer, so they go in **private**
notes outside the repo.

---

## Labs

One lab per ticket, every module.

### M0 · Engineering hygiene (week 1) · [epic #1](https://github.com/Dfscashline21/sideline/issues/1)

| Ticket | Lab | Mode |
|---|---|---|
| M0.1 to M0.5 | Covered by the [M0 study guide](../m0-study-guide.md) | done |
| [M0.6](https://github.com/Dfscashline21/sideline/issues/22) | [README skeleton and CI badge](m0/m0.6-readme-skeleton.md) | hand |
| [M0.7](https://github.com/Dfscashline21/sideline/issues/23) | [Agent instructions file](m0/m0.7-agent-instructions.md) | hand |
| [M0.8](https://github.com/Dfscashline21/sideline/issues/24) | [Ready-when check](m0/m0.8-ready-when.md) | hand |
| [M0.9](https://github.com/Dfscashline21/sideline/issues/25) | [STAR story](m0/m0.9-star-story.md) | hand |

### M1 · Advanced SQL (weeks 1 to 2) · [epic #2](https://github.com/Dfscashline21/sideline/issues/2)

Start with the [module overview](m1/README.md): it describes the practice
tables every M1 lab uses.

| Ticket | Lab | Mode |
|---|---|---|
| [M1.1](https://github.com/Dfscashline21/sideline/issues/26) | [Study: windows, frames, QUALIFY, CTEs, plans](m1/m1.1-study.md) | hand |
| [M1.2](https://github.com/Dfscashline21/sideline/issues/27) | [Load practice data into DuckDB](m1/m1.2-load-practice-data.md) | agent |
| [M1.3](https://github.com/Dfscashline21/sideline/issues/28) | [Longest win streak (gaps and islands)](m1/m1.3-win-streaks.md) | hand |
| [M1.4](https://github.com/Dfscashline21/sideline/issues/29) | [Rolling 5-game scoring average](m1/m1.4-rolling-average.md) | hand |
| [M1.5](https://github.com/Dfscashline21/sideline/issues/30) | [Possessions as sessions](m1/m1.5-possessions.md) | hand |
| [M1.6](https://github.com/Dfscashline21/sideline/issues/31) | [Top 3 college players by TS%](m1/m1.6-true-shooting.md) | hand |
| [M1.7](https://github.com/Dfscashline21/sideline/issues/32) | [Read a query plan and speed it up 2x](m1/m1.7-query-plan.md) | hand |
| [M1.8](https://github.com/Dfscashline21/sideline/issues/33) | [20 more problems](m1/m1.8-problem-bank.md) | hand |
| [M1.9](https://github.com/Dfscashline21/sideline/issues/34) | [Ready-when check](m1/m1.9-ready-when.md) | hand |
| [M1.10](https://github.com/Dfscashline21/sideline/issues/35) | [STAR story](m1/m1.10-star-story.md) | hand |

### M2 onwards

These labs were written ahead of time, before your M2+ code existed. Each module overview says so: where you named or built something differently, use your names. The suggested defaults (Dagster, dbt-duckdb, an Iceberg REST catalog, Redpanda, Terraform on AWS) are consistent across modules.

### M2 · Python ingestion (NBA first) · [epic #3](https://github.com/Dfscashline21/sideline/issues/3)

Start with the [module overview](m2/README.md).

| Ticket | Lab | Mode |
|---|---|---|
| [M2.1](https://github.com/Dfscashline21/sideline/issues/36) | [Study: retries, backoff, idempotency, watermarks](m2/m2.1-study.md) | hand |
| [M2.2](https://github.com/Dfscashline21/sideline/issues/37) | [Design the raw zone layout](m2/m2.2-raw-zone-layout.md) | hand |
| [M2.3](https://github.com/Dfscashline21/sideline/issues/38) | [NBA extractor with nba_api](m2/m2.3-nba-extractor.md) | hand |
| [M2.4](https://github.com/Dfscashline21/sideline/issues/39) | [Incremental loads with watermarks and --start/--end](m2/m2.4-watermarks.md) | hand |
| [M2.5](https://github.com/Dfscashline21/sideline/issues/40) | [Validate at the edge with Pydantic](m2/m2.5-pydantic-validation.md) | hand |
| [M2.6](https://github.com/Dfscashline21/sideline/issues/41) | [Tests: unit and integration, 80%+ coverage](m2/m2.6-tests-coverage.md) | mixed |
| [M2.7](https://github.com/Dfscashline21/sideline/issues/42) | [Kill-and-restart idempotency test](m2/m2.7-kill-restart.md) | hand |
| [M2.8](https://github.com/Dfscashline21/sideline/issues/43) | [ADR-001: Why we land raw data unchanged](m2/m2.8-adr-001.md) | hand |
| [M2.9](https://github.com/Dfscashline21/sideline/issues/44) | [Ready-when check (closed-book)](m2/m2.9-ready-when.md) | hand |
| [M2.10](https://github.com/Dfscashline21/sideline/issues/45) | [STAR story from current job](m2/m2.10-star-story.md) | hand |

### M3 · Data modeling · [epic #4](https://github.com/Dfscashline21/sideline/issues/4)

Start with the [module overview](m3/README.md).

| Ticket | Lab | Mode |
|---|---|---|
| [M3.1](https://github.com/Dfscashline21/sideline/issues/46) | [Study: Kimball, grain, SCD types, Data Vault, OBT](m3/m3.1-study.md) | hand |
| [M3.2](https://github.com/Dfscashline21/sideline/issues/47) | [Write grain statements for every table](m3/m3.2-grain-statements.md) | hand |
| [M3.3](https://github.com/Dfscashline21/sideline/issues/48) | [Design dim_player as SCD Type 2](m3/m3.3-dim-player-scd2.md) | hand |
| [M3.4](https://github.com/Dfscashline21/sideline/issues/49) | [Design the cross-league player identity crosswalk](m3/m3.4-player-crosswalk.md) | hand |
| [M3.5](https://github.com/Dfscashline21/sideline/issues/50) | [Design dim_team, dim_season, dim_game](m3/m3.5-team-season-game-dims.md) | hand |
| [M3.6](https://github.com/Dfscashline21/sideline/issues/51) | [Draw the ERD](m3/m3.6-erd.md) | hand |
| [M3.7](https://github.com/Dfscashline21/sideline/issues/52) | [Agent critique pass on the model](m3/m3.7-agent-critique.md) | agent |
| [M3.8](https://github.com/Dfscashline21/sideline/issues/53) | [ADR-002: Kimball over Data Vault](m3/m3.8-adr-002.md) | hand |
| [M3.9](https://github.com/Dfscashline21/sideline/issues/54) | [Ready-when check (closed-book)](m3/m3.9-ready-when.md) | hand |
| [M3.10](https://github.com/Dfscashline21/sideline/issues/55) | [STAR story from current job](m3/m3.10-star-story.md) | hand |

### M4 · Storage and Apache Iceberg · [epic #5](https://github.com/Dfscashline21/sideline/issues/5)

Start with the [module overview](m4/README.md).

| Ticket | Lab | Mode |
|---|---|---|
| [M4.1](https://github.com/Dfscashline21/sideline/issues/56) | [Study: Parquet internals and Iceberg metadata](m4/m4.1-study.md) | hand |
| [M4.2](https://github.com/Dfscashline21/sideline/issues/57) | [Add an Iceberg REST catalog to Compose](m4/m4.2-rest-catalog.md) | agent |
| [M4.3](https://github.com/Dfscashline21/sideline/issues/58) | [Load NBA play-by-play since 2002 into Iceberg](m4/m4.3-load-pbp.md) | hand |
| [M4.4](https://github.com/Dfscashline21/sideline/issues/59) | [Partition evolution: league, then bucket(team_id)](m4/m4.4-partition-evolution.md) | hand |
| [M4.5](https://github.com/Dfscashline21/sideline/issues/60) | [Schema evolution: add shot coordinates](m4/m4.5-schema-evolution.md) | hand |
| [M4.6](https://github.com/Dfscashline21/sideline/issues/61) | [Stat correction and time travel](m4/m4.6-time-travel.md) | hand |
| [M4.7](https://github.com/Dfscashline21/sideline/issues/62) | [Compaction before and after](m4/m4.7-compaction.md) | hand |
| [M4.8](https://github.com/Dfscashline21/sideline/issues/63) | [Benchmark harness and charts](m4/m4.8-benchmark-harness.md) | agent |
| [M4.9](https://github.com/Dfscashline21/sideline/issues/64) | [Blog post: Iceberg on basketball data](m4/m4.9-blog-post.md) | hand |
| [M4.10](https://github.com/Dfscashline21/sideline/issues/65) | [ADR-003: Iceberg over Delta Lake](m4/m4.10-adr-003.md) | hand |
| [M4.11](https://github.com/Dfscashline21/sideline/issues/66) | [Ready-when check (closed-book)](m4/m4.11-ready-when.md) | hand |
| [M4.12](https://github.com/Dfscashline21/sideline/issues/67) | [STAR story from current job](m4/m4.12-star-story.md) | hand |

### M5 · Transformation with dbt · [epic #6](https://github.com/Dfscashline21/sideline/issues/6)

Start with the [module overview](m5/README.md).

| Ticket | Lab | Mode |
|---|---|---|
| [M5.1](https://github.com/Dfscashline21/sideline/issues/68) | [Study: materializations, incremental strategies, snapshots](m5/m5.1-study.md) | hand |
| [M5.2](https://github.com/Dfscashline21/sideline/issues/69) | [Initialize dbt project with sources and freshness](m5/m5.2-init-dbt-project.md) | agent |
| [M5.3](https://github.com/Dfscashline21/sideline/issues/70) | [First staging models by hand](m5/m5.3-first-staging-models.md) | hand |
| [M5.4](https://github.com/Dfscashline21/sideline/issues/71) | [Remaining staging models and schema YAML](m5/m5.4-remaining-staging.md) | agent |
| [M5.5](https://github.com/Dfscashline21/sideline/issues/72) | [dim_player snapshot (SCD2)](m5/m5.5-dim-player-snapshot.md) | hand |
| [M5.6](https://github.com/Dfscashline21/sideline/issues/73) | [fact_play incremental with 3-day lookback](m5/m5.6-fact-play-incremental.md) | hand |
| [M5.7](https://github.com/Dfscashline21/sideline/issues/74) | [fact_shot and fact_player_game](m5/m5.7-fact-shot-player-game.md) | hand |
| [M5.8](https://github.com/Dfscashline21/sideline/issues/75) | [Conformed dimensions: date, game, team, season, venue](m5/m5.8-conformed-dimensions.md) | mixed |
| [M5.9](https://github.com/Dfscashline21/sideline/issues/76) | [Metrics in the semantic layer](m5/m5.9-semantic-layer-metrics.md) | hand |
| [M5.10](https://github.com/Dfscashline21/sideline/issues/77) | [50+ tests including unit tests](m5/m5.10-tests.md) | mixed |
| [M5.11](https://github.com/Dfscashline21/sideline/issues/78) | [Slim CI with state:modified+](m5/m5.11-slim-ci.md) | agent |
| [M5.12](https://github.com/Dfscashline21/sideline/issues/79) | [Host dbt docs on GitHub Pages](m5/m5.12-dbt-docs-pages.md) | agent |
| [M5.13](https://github.com/Dfscashline21/sideline/issues/80) | [ADR-004: Incremental strategy for fact_play](m5/m5.13-adr-incremental-strategy.md) | hand |
| [M5.14](https://github.com/Dfscashline21/sideline/issues/81) | [Ready-when check (closed-book)](m5/m5.14-ready-when.md) | hand |
| [M5.15](https://github.com/Dfscashline21/sideline/issues/82) | [STAR story from current job](m5/m5.15-star-story.md) | hand |

### M6 · Orchestration (WNBA joins) · [epic #7](https://github.com/Dfscashline21/sideline/issues/7)

Start with the [module overview](m6/README.md).

| Ticket | Lab | Mode |
|---|---|---|
| [M6.1](https://github.com/Dfscashline21/sideline/issues/83) | [Study: assets vs DAGs, backfills, sensors](m6/m6.1-study.md) | hand |
| [M6.2](https://github.com/Dfscashline21/sideline/issues/84) | [WNBA extractor following the NBA pattern](m6/m6.2-wnba-extractor.md) | agent |
| [M6.3](https://github.com/Dfscashline21/sideline/issues/85) | [WNBA staging models and conformed dims](m6/m6.3-wnba-staging-dims.md) | agent |
| [M6.4](https://github.com/Dfscashline21/sideline/issues/86) | [Dagster: daily partitioned assets per league](m6/m6.4-dagster-partitioned-assets.md) | hand |
| [M6.5](https://github.com/Dfscashline21/sideline/issues/87) | [League calendar sensor and post-game run](m6/m6.5-calendar-sensor.md) | hand |
| [M6.6](https://github.com/Dfscashline21/sideline/issues/88) | [Alerting and runbook](m6/m6.6-alerting-runbooks.md) | mixed |
| [M6.7](https://github.com/Dfscashline21/sideline/issues/89) | [Backfill NBA 2015-2025 with concurrency 4](m6/m6.7-backfill.md) | hand |
| [M6.8](https://github.com/Dfscashline21/sideline/issues/90) | [Port one league to Airflow 3 and compare](m6/m6.8-airflow-port.md) | agent |
| [M6.9](https://github.com/Dfscashline21/sideline/issues/91) | [ADR-005: Dagster vs Airflow](m6/m6.9-adr-005.md) | hand |
| [M6.10](https://github.com/Dfscashline21/sideline/issues/92) | [Ready-when check (closed-book)](m6/m6.10-ready-when.md) | hand |
| [M6.11](https://github.com/Dfscashline21/sideline/issues/93) | [STAR story from current job](m6/m6.11-star-story.md) | hand |

### M7 · Spark at scale (college joins) · [epic #8](https://github.com/Dfscashline21/sideline/issues/8)

Start with the [module overview](m7/README.md).

| Ticket | Lab | Mode |
|---|---|---|
| [M7.1](https://github.com/Dfscashline21/sideline/issues/94) | [Study: Spark architecture, shuffles, joins, AQE](m7/m7.1-study.md) | hand |
| [M7.2](https://github.com/Dfscashline21/sideline/issues/95) | [Design the college quota strategy](m7/m7.2-quota-strategy.md) | hand |
| [M7.3](https://github.com/Dfscashline21/sideline/issues/96) | [College extractor (men's and women's)](m7/m7.3-college-extractor.md) | agent |
| [M7.4](https://github.com/Dfscashline21/sideline/issues/97) | [College staging, dims and identity crosswalk build](m7/m7.4-college-crosswalk.md) | hand |
| [M7.5](https://github.com/Dfscashline21/sideline/issues/98) | [Local Spark with Iceberg](m7/m7.5-local-spark-iceberg.md) | agent |
| [M7.6](https://github.com/Dfscashline21/sideline/issues/99) | [SCD2 as-of join: broadcast vs sort-merge](m7/m7.6-asof-join.md) | hand |
| [M7.7](https://github.com/Dfscashline21/sideline/issues/100) | [Create and fix data skew](m7/m7.7-data-skew.md) | hand |
| [M7.8](https://github.com/Dfscashline21/sideline/issues/101) | [5-player lineup stats](m7/m7.8-lineup-stats.md) | hand |
| [M7.9](https://github.com/Dfscashline21/sideline/issues/102) | [DuckDB vs Spark crossover benchmark](m7/m7.9-crossover-benchmark.md) | mixed |
| [M7.10](https://github.com/Dfscashline21/sideline/issues/103) | [March Madness tournament-week replay](m7/m7.10-tournament-replay.md) | hand |
| [M7.11](https://github.com/Dfscashline21/sideline/issues/104) | [Blog post: Spark tuning diary](m7/m7.11-tuning-diary.md) | hand |
| [M7.12](https://github.com/Dfscashline21/sideline/issues/105) | [Ready-when check (closed-book)](m7/m7.12-ready-when.md) | hand |
| [M7.13](https://github.com/Dfscashline21/sideline/issues/106) | [STAR story from current job](m7/m7.13-star-story.md) | hand |

### M8 · Streaming: live game simulator · [epic #9](https://github.com/Dfscashline21/sideline/issues/9)

Start with the [module overview](m8/README.md).

| Ticket | Lab | Mode |
|---|---|---|
| [M8.1](https://github.com/Dfscashline21/sideline/issues/107) | [Study: event time, watermarks, delivery semantics](m8/m8.1-study.md) | hand |
| [M8.2](https://github.com/Dfscashline21/sideline/issues/108) | [Redpanda and Schema Registry in Compose](m8/m8.2-redpanda-schema-registry.md) | agent |
| [M8.3](https://github.com/Dfscashline21/sideline/issues/109) | [Game replay producer with chaos](m8/m8.3-replay-producer.md) | agent |
| [M8.4](https://github.com/Dfscashline21/sideline/issues/110) | [Stream job: live team stats with event time](m8/m8.4-live-team-stats.md) | hand |
| [M8.5](https://github.com/Dfscashline21/sideline/issues/111) | [Late events and dead-letter topic](m8/m8.5-late-events-dlq.md) | hand |
| [M8.6](https://github.com/Dfscashline21/sideline/issues/112) | [Live win-probability feed](m8/m8.6-win-probability.md) | mixed |
| [M8.7](https://github.com/Dfscashline21/sideline/issues/113) | [Iceberg sink every minute](m8/m8.7-iceberg-sink.md) | hand |
| [M8.8](https://github.com/Dfscashline21/sideline/issues/114) | [Fantasy league DB and Debezium CDC](m8/m8.8-fantasy-cdc.md) | mixed |
| [M8.9](https://github.com/Dfscashline21/sideline/issues/115) | [Demo video](m8/m8.9-demo-video.md) | hand |
| [M8.10](https://github.com/Dfscashline21/sideline/issues/116) | [ADR-006: Stream processor choice](m8/m8.10-adr-stream-processor.md) | hand |
| [M8.11](https://github.com/Dfscashline21/sideline/issues/117) | [Ready-when check (closed-book)](m8/m8.11-ready-when.md) | hand |
| [M8.12](https://github.com/Dfscashline21/sideline/issues/118) | [STAR story from current job](m8/m8.12-star-story.md) | hand |

### M9 · Data quality, contracts and observability · [epic #10](https://github.com/Dfscashline21/sideline/issues/10)

Start with the [module overview](m9/README.md).

| Ticket | Lab | Mode |
|---|---|---|
| [M9.1](https://github.com/Dfscashline21/sideline/issues/119) | [Study: quality dimensions, contracts, SLOs](m9/m9.1-study.md) | hand |
| [M9.2](https://github.com/Dfscashline21/sideline/issues/120) | [NBA source contract by hand](m9/m9.2-nba-contract.md) | hand |
| [M9.3](https://github.com/Dfscashline21/sideline/issues/121) | [WNBA and college contracts](m9/m9.3-wnba-college-contracts.md) | agent |
| [M9.4](https://github.com/Dfscashline21/sideline/issues/122) | [League-aware rule checks](m9/m9.4-league-rules.md) | hand |
| [M9.5](https://github.com/Dfscashline21/sideline/issues/123) | [Volume anomaly checks per league](m9/m9.5-volume-anomalies.md) | hand |
| [M9.6](https://github.com/Dfscashline21/sideline/issues/124) | [Freshness SLO and measurement](m9/m9.6-freshness-slo.md) | hand |
| [M9.7](https://github.com/Dfscashline21/sideline/issues/125) | [Lineage with OpenLineage](m9/m9.7-lineage.md) | agent |
| [M9.8](https://github.com/Dfscashline21/sideline/issues/126) | [Chaos day](m9/m9.8-chaos-day.md) | hand |
| [M9.9](https://github.com/Dfscashline21/sideline/issues/127) | [Postmortem for one chaos failure](m9/m9.9-postmortem.md) | hand |
| [M9.10](https://github.com/Dfscashline21/sideline/issues/128) | [Quality dashboard](m9/m9.10-quality-dashboard.md) | agent |
| [M9.11](https://github.com/Dfscashline21/sideline/issues/129) | [Ready-when check (closed-book)](m9/m9.11-ready-when.md) | hand |
| [M9.12](https://github.com/Dfscashline21/sideline/issues/130) | [STAR story from current job](m9/m9.12-star-story.md) | hand |

### M10 · Cloud, IaC, security and cost · [epic #11](https://github.com/Dfscashline21/sideline/issues/11)

Start with the [module overview](m10/README.md).

| Ticket | Lab | Mode |
|---|---|---|
| [M10.1](https://github.com/Dfscashline21/sideline/issues/131) | [Study: IAM, VPC, Terraform state, FinOps](m10/m10.1-study.md) | hand |
| [M10.2](https://github.com/Dfscashline21/sideline/issues/132) | [Terraform layout and remote state](m10/m10.2-terraform-layout.md) | mixed |
| [M10.3](https://github.com/Dfscashline21/sideline/issues/133) | [S3 lakehouse and catalog](m10/m10.3-s3-lakehouse.md) | agent |
| [M10.4](https://github.com/Dfscashline21/sideline/issues/134) | [Orchestrator on ECS](m10/m10.4-orchestrator-ecs.md) | agent |
| [M10.5](https://github.com/Dfscashline21/sideline/issues/135) | [Warehouse reading Iceberg](m10/m10.5-warehouse-iceberg.md) | mixed |
| [M10.6](https://github.com/Dfscashline21/sideline/issues/136) | [IAM least-privilege review](m10/m10.6-iam-review.md) | hand |
| [M10.7](https://github.com/Dfscashline21/sideline/issues/137) | [CI/CD deploy across environments](m10/m10.7-cicd-deploy.md) | agent |
| [M10.8](https://github.com/Dfscashline21/sideline/issues/138) | [PII masking for the analyst role](m10/m10.8-pii-masking.md) | hand |
| [M10.9](https://github.com/Dfscashline21/sideline/issues/139) | [Budget alarm and cost-per-league report](m10/m10.9-budget-cost-report.md) | mixed |
| [M10.10](https://github.com/Dfscashline21/sideline/issues/140) | [Cut cost 30% with one documented change](m10/m10.10-cut-cost.md) | hand |
| [M10.11](https://github.com/Dfscashline21/sideline/issues/141) | [Security-boundary architecture diagram](m10/m10.11-security-diagram.md) | hand |
| [M10.12](https://github.com/Dfscashline21/sideline/issues/142) | [Ready-when check (closed-book)](m10/m10.12-ready-when.md) | hand |
| [M10.13](https://github.com/Dfscashline21/sideline/issues/143) | [STAR story from current job](m10/m10.13-star-story.md) | hand |

### M11 · Serving and consumption · [epic #12](https://github.com/Dfscashline21/sideline/issues/12)

Start with the [module overview](m11/README.md).

| Ticket | Lab | Mode |
|---|---|---|
| [M11.1](https://github.com/Dfscashline21/sideline/issues/144) | [Study: serving patterns](m11/m11.1-study.md) | hand |
| [M11.2](https://github.com/Dfscashline21/sideline/issues/145) | [API design](m11/m11.2-api-design.md) | hand |
| [M11.3](https://github.com/Dfscashline21/sideline/issues/146) | [FastAPI implementation](m11/m11.3-fastapi.md) | agent |
| [M11.4](https://github.com/Dfscashline21/sideline/issues/147) | [Load test: p95 under 200 ms](m11/m11.4-load-test.md) | mixed |
| [M11.5](https://github.com/Dfscashline21/sideline/issues/148) | [Public dashboard](m11/m11.5-public-dashboard.md) | agent |
| [M11.6](https://github.com/Dfscashline21/sideline/issues/149) | [Data product pages](m11/m11.6-data-product-pages.md) | mixed |
| [M11.7](https://github.com/Dfscashline21/sideline/issues/150) | [Ready-when check (closed-book)](m11/m11.7-ready-when.md) | hand |
| [M11.8](https://github.com/Dfscashline21/sideline/issues/151) | [STAR story from current job](m11/m11.8-star-story.md) | hand |

### M12 · Data for ML and AI · [epic #13](https://github.com/Dfscashline21/sideline/issues/13)

Start with the [module overview](m12/README.md).

| Ticket | Lab | Mode |
|---|---|---|
| [M12.1](https://github.com/Dfscashline21/sideline/issues/152) | [Study: point-in-time correctness, feature stores](m12/m12.1-study.md) | hand |
| [M12.2](https://github.com/Dfscashline21/sideline/issues/153) | [Feature pipeline with as-of joins](m12/m12.2-feature-pipeline.md) | hand |
| [M12.3](https://github.com/Dfscashline21/sideline/issues/154) | [Leakage test](m12/m12.3-leakage-test.md) | hand |
| [M12.4](https://github.com/Dfscashline21/sideline/issues/155) | [Train a simple model](m12/m12.4-train-model.md) | agent |
| [M12.5](https://github.com/Dfscashline21/sideline/issues/156) | [Run the model on an NCAA tournament bracket](m12/m12.5-ncaa-bracket.md) | mixed |
| [M12.6](https://github.com/Dfscashline21/sideline/issues/157) | [Recap embeddings and retrieval endpoint](m12/m12.6-recap-retrieval.md) | agent |
| [M12.7](https://github.com/Dfscashline21/sideline/issues/158) | [Retrieval evaluation set](m12/m12.7-retrieval-eval.md) | hand |
| [M12.8](https://github.com/Dfscashline21/sideline/issues/159) | [Blog post: point-in-time joins](m12/m12.8-blog-post.md) | hand |
| [M12.9](https://github.com/Dfscashline21/sideline/issues/160) | [Ready-when check (closed-book)](m12/m12.9-ready-when.md) | hand |
| [M12.10](https://github.com/Dfscashline21/sideline/issues/161) | [STAR story from current job](m12/m12.10-star-story.md) | hand |

### M13 · System design and leadership · [epic #14](https://github.com/Dfscashline21/sideline/issues/14)

Start with the [module overview](m13/README.md).

| Ticket | Lab | Mode |
|---|---|---|
| [M13.1](https://github.com/Dfscashline21/sideline/issues/162) | [Study: design framework](m13/m13.1-design-framework.md) | hand |
| [M13.2](https://github.com/Dfscashline21/sideline/issues/163) | [Design doc: real-time betting odds platform](m13/m13.2-betting-odds.md) | hand |
| [M13.3](https://github.com/Dfscashline21/sideline/issues/164) | [Design doc: player-tracking pipeline](m13/m13.3-player-tracking.md) | hand |
| [M13.4](https://github.com/Dfscashline21/sideline/issues/165) | [Design doc: legacy SQL Server to lakehouse migration](m13/m13.4-sqlserver-migration.md) | hand |
| [M13.5](https://github.com/Dfscashline21/sideline/issues/166) | [Design doc: maturity roadmap for your current employer](m13/m13.5-maturity-roadmap.md) | hand |
| [M13.6](https://github.com/Dfscashline21/sideline/issues/167) | [Mock system design interviews with an AI interviewer](m13/m13.6-ai-mock-interviews.md) | agent |
| [M13.7](https://github.com/Dfscashline21/sideline/issues/168) | [Ready-when check (closed-book)](m13/m13.7-ready-when.md) | hand |
| [M13.8](https://github.com/Dfscashline21/sideline/issues/169) | [STAR story from current job](m13/m13.8-star-story.md) | hand |

### PF · Portfolio packaging · [epic #15](https://github.com/Dfscashline21/sideline/issues/15)

Start with the [module overview](pf/README.md).

| Ticket | Lab | Mode |
|---|---|---|
| [PF.1](https://github.com/Dfscashline21/sideline/issues/170) | [Final README](pf/pf.1-final-readme.md) | hand |
| [PF.2](https://github.com/Dfscashline21/sideline/issues/171) | [Final architecture diagram](pf/pf.2-architecture-diagram.md) | hand |
| [PF.3](https://github.com/Dfscashline21/sideline/issues/172) | [ADR index](pf/pf.3-adr-index.md) | agent |
| [PF.4](https://github.com/Dfscashline21/sideline/issues/173) | ['How I used AI agents' section](pf/pf.4-ai-agents-section.md) | hand |
| [PF.5](https://github.com/Dfscashline21/sideline/issues/174) | [Demo video (3-5 minutes)](pf/pf.5-demo-video.md) | hand |
| [PF.6](https://github.com/Dfscashline21/sideline/issues/175) | [Resume bullets with real numbers](pf/pf.6-resume-bullets.md) | hand |
| [PF.7](https://github.com/Dfscashline21/sideline/issues/176) | [Site and LinkedIn update](pf/pf.7-site-linkedin.md) | hand |
| [PF.8](https://github.com/Dfscashline21/sideline/issues/177) | [Fresh-eyes review by a peer](pf/pf.8-fresh-eyes-review.md) | hand |

### IP · Interview preparation (weeks 12-24) · [epic #16](https://github.com/Dfscashline21/sideline/issues/16)

Start with the [module overview](ip/README.md).

| Ticket | Lab | Mode |
|---|---|---|
| [IP.1](https://github.com/Dfscashline21/sideline/issues/178) | [Compile 8 STAR stories](ip/ip.1-star-stories.md) | hand |
| [IP.2](https://github.com/Dfscashline21/sideline/issues/179) | [SQL practice 3x a week (weeks 12-24)](ip/ip.2-sql-practice.md) | hand |
| [IP.3](https://github.com/Dfscashline21/sideline/issues/180) | [Weekly recorded system design (weeks 12-24)](ip/ip.3-weekly-system-design.md) | hand |
| [IP.4](https://github.com/Dfscashline21/sideline/issues/181) | [Biweekly data modeling in a new domain](ip/ip.4-data-modeling-domains.md) | hand |
| [IP.5](https://github.com/Dfscashline21/sideline/issues/182) | [Answer the 6 cold questions closed-book](ip/ip.5-cold-questions.md) | hand |
| [IP.6](https://github.com/Dfscashline21/sideline/issues/183) | [Monthly full mock loop](ip/ip.6-mock-loops.md) | mixed |
