# M8 · Streaming: live game simulator: module overview

> **Epic:** [#9](https://github.com/Dfscashline21/sideline/issues/9) ·
> **Weeks:** 15 to 16 · **Ready when:** you can explain, step by step,
> what happens to a go-ahead three-pointer that arrives 45 seconds late.

> **Written ahead of time.** These labs were drafted before M2 to M7
> existed. Names below (topics, tables, folders) are suggested defaults.
> Wherever you built something differently, keep yours and adapt the lab.

## The path

```
M8.1 study ─────────────────────────────────────────────┐
                                                        ▼
M8.2 Redpanda + Schema Registry ──► M8.3 replay producer ──► M8.4 live team stats ──► M8.5 late events + DLQ
        │                                       │                      │
        │                                       │                      ├──► M8.7 Iceberg sink (needs M4/M7 catalog)
        │                                       └──► M8.6 win-prob feed │
        └──► M8.8 fantasy DB + Debezium CDC (independent of M8.3 to M8.7)
                                                                       ▼
   M8.10 ADR-006 (after M8.4 and M8.5) ──► M8.9 demo video ──► M8.11 closed-book ──► M8.12 STAR
```

- **M8.1** can start any time; finish sessions 1 and 2 before M8.4.
- **M8.8** only needs the broker from M8.2, so it's a good thing to do
  while you're stuck on something else.
- **M8.10** is written after you've built M8.4 and M8.5, because the
  late-data story is where Flink and Spark differ most.
- **M8.12** (STAR) can go anywhere in the fortnight.

| Lab | Core idea | Interview frequency |
|---|---|---|
| M8.1 study | Event time vs processing time, watermarks, delivery semantics | Very high |
| M8.4 live stats | Windowed aggregation on event time | High |
| M8.5 late events | What a watermark actually drops, and where it goes | High |
| M8.7 Iceberg sink | Exactly-once = replayable source + idempotent or transactional sink | Very high |
| M8.8 CDC | Log-based change capture, tombstones, replica identity | Medium |

## Where your work goes

```
streaming/
├── README.md                 # how to run the whole demo, in order
├── schemas/
│   └── game_event.avsc       # M8.2
├── producer/
│   └── replay.py             # M8.3
├── jobs/
│   ├── live_team_stats.py    # M8.4, M8.5
│   ├── win_probability.py    # M8.6
│   └── iceberg_sink.py       # M8.7
├── cdc/
│   ├── seed_fantasy.py       # M8.8
│   └── postgres-connector.json
└── tests/
    └── test_late_events.py   # M8.5
compose.yaml                  # redpanda, console, debezium services added
docs/adr/006-stream-processor.md
```

## The stack (versions checked when these labs were written)

| Piece | Choice | Version used in examples |
|---|---|---|
| Broker | Redpanda (Kafka API), dev-container mode | `docker.redpanda.com/redpandadata/redpanda:v26.2.7` |
| Schema registry | Built into Redpanda, Confluent-compatible API | same image, port 8081 inside Docker, 18081 on your laptop |
| UI (optional) | Redpanda Console | `docker.redpanda.com/redpandadata/console:v3.14.0` |
| Python client | `confluent-kafka` (with Avro serializer) | 2.16.x |
| Stream processor (primary) | Spark Structured Streaming, PySpark | **4.1.4**. See gotcha below |
| Spark Kafka connector | `org.apache.spark:spark-sql-kafka-0-10_2.13` | 4.1.4 |
| Iceberg for Spark | `org.apache.iceberg:iceberg-spark-runtime-4.1_2.13` | 1.12.0 |
| CDC | Debezium Connect | `quay.io/debezium/connect:3.7.1.Final` |

Check for newer versions when you start. Always pin exact tags, as M0
taught you.

### Topics and schemas (other modules assume these)

| Name | What | Key |
|---|---|---|
| `game-events` | Replayed play-by-play events, Avro | `game_id` (keeps one game in one partition, so in order per partition) |
| `game-events-dlq` | Events too late for the watermark | `game_id` |
| `win-probability` | Running home win probability per event | `game_id` |
| `fantasy.public.rosters` (etc.) | Debezium change events | primary key of the row |
| Subject `game-events-value` | Avro schema for `game-events` (TopicNameStrategy) | |
| Iceberg `raw.live_game_events` | Stream sink, appended every minute | `event_id` is unique |

## The replay data

The producer replays NBA play-by-play from the practice database you
built in M1.2 (`nba_pbp`, seasons 2024 to 2026) or from your M4 Iceberg
`raw.pbp` table. Useful columns:

| Column | Use |
|---|---|
| `id` | Unique event ID (checked: unique across all 1.88M rows). Use it as `event_id` |
| `game_id`, `game_play_number` | Game and event order |
| `wallclock` | **Real-world timestamp** of the event (ISO string, UTC). This is your **event time** |
| `period_number`, `clock_display_value`, `start_game_seconds_remaining` | Game clock |
| `team_id`, `type_text`, `scoring_play`, `score_value` | What happened |
| `home_score`, `away_score`, `home_team_id`, `away_team_id` | Running score |

Measured on the 2023-24 regular season:

- A game is about **464 events** (median) spread over about **134 minutes** of
  wall-clock time (median, tip-off to final event).
- So a **1x** replay takes over two hours. **10x** takes ~13 minutes.
  Develop at 60x (~2 minutes); demo at 10x.
- About **0.8%** of events already have a `wallclock` earlier than the
  event before them. The source is slightly out of order before you add
  any chaos. Your job must cope with that anyway.
- In about half of games (577 of ~1,230), at least one event is **more
  than 30 seconds** behind the newest event before it. With a 30-second
  watermark, those games lose data even with no chaos at all. Game
  **401584089** (CLE @ IND, 2023-11-03, 116–121) is at most 18 seconds
  behind, which is why the labs use it as the clean test game.

## Know these before you write any streaming code

| Fact | Why it bites |
|---|---|
| **Event time** is when it happened (`wallclock`); **processing time** is when your job sees it | Every M8 bug in this module is mixing them up |
| A **watermark** is the job's claim "I've probably seen everything before time T". Spark's is `max(event_time seen) − threshold` | It's driven by the *data*, not the wall clock. If events stop, it stops |
| Spark guarantees not to drop data *within* the threshold, but does **not** guarantee to drop data *beyond* it | A test that expects late data to be dropped can flake. Route it yourself (M8.5) |
| Spark computes the watermark at the **end** of a micro-batch and applies it in the **next** | One batch of "grace" you didn't ask for |
| At 10x replay, 3 seconds of real delay = 30 seconds of event time | Your chaos settings must be reasoned about in event time |
| Spark's `from_avro` doesn't understand the Confluent wire format (magic byte + 4-byte schema ID before the Avro body) | Strip the first 5 bytes, or decode in Python. Classic first-day bug |
| `iceberg-spark-runtime` is built per Spark minor version, and lags Spark releases | PySpark 4.3 is out but Iceberg ships runtimes only up to Spark 4.1, so **pin PySpark 4.1.x** for this module |
| Append output mode emits a window only after the watermark passes its end | At the end of a game, nothing pushes the watermark forward, so the last window never emits. Send an end-of-game marker or use update mode |
