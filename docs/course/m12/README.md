# M12 · Data for ML and AI: module overview

> **Epic:** [#13](https://github.com/Dfscashline21/sideline/issues/13) ·
> **Week:** 21 · **Ready when:** you can explain exactly how a naive join
> leaks future data into training, with an example.

> **Written ahead of time.** These labs were drafted before M2 to M11
> existed. Table names and paths follow the course's suggested defaults
> (`fact_team_game`, `dim_player`, `ml/`, pgvector in Compose Postgres).
> Where you built something different, use your names. The leakage
> numbers below were measured on the M1 practice data, so you can
> reproduce them today.

## The path

```
M12.1 study ──► M12.2 feature pipeline ──► M12.3 leakage test ──► M12.4 train model ──► M12.5 NCAA bracket
     │                                                                    │
     │                                                                    └──► M12.8 blog post (needs M12.2–M12.4 numbers)
     │
     └──► M12.6 recap embeddings + endpoint ──► M12.7 retrieval eval set

M12.9 closed-book check ◄── all of the above          M12.10 STAR story (any time)
```

Two independent tracks after the study lab: the **features → model**
track and the **retrieval** track. Do them in either order. M12.3 must
come before M12.4: never train on features you haven't proven leak-free.

## What you'll build, and where

| Lab | Output | Location |
|---|---|---|
| M12.1 | Leakage explanation, cheat sheet | `docs/notes/m12.md` |
| M12.2 | Point-in-time features, all leagues | `transform/models/marts/ml/` or `ml/features/` |
| M12.3 | Leakage test that fails on a planted leak | `ml/tests/` |
| M12.4 | Model training pipeline, held-out season | `ml/` |
| M12.5 | NCAA bracket results table | `docs/blog/` or the dashboard |
| M12.6 | Embedded recaps + "ask about last night" endpoint | `ml/retrieval/`, `serving/api/` |
| M12.7 | 20-question eval set and tracked score | `ml/retrieval/eval/` |
| M12.8 | Blog post on point-in-time joins | `docs/blog/` |

## The leakage demo you can run today

The whole module rests on one idea, so see it in numbers first. Predict
each NBA regular-season game's winner by picking the team with the better
win %. Measured on the M1 practice data, 6,153 games, seasons 2021-22 to
2025-26:

| Win % used | Accuracy |
|---|---|
| Always pick the home team (baseline) | 0.553 |
| Each team's record **before tip-off** (point-in-time, `ASOF JOIN`) | 0.631 |
| Each team's **final season** record (naive join on `season`) | 0.676 |

The naive version looks 4.5 points better, and **all of that gain is
leakage**. Its "feature" includes the result of the game being
predicted, plus every game after it. On opening night 2023-24 it already
"knows" Boston will finish 64-18 and Detroit 14-68; the point-in-time
version knows neither has played. You can't use the naive model in
production, because the future isn't available at tip-off.

M12.1 has you rebuild this query yourself.

## Key concepts

| Concept | One line |
|---|---|
| **Prediction time** | The moment the model must make its prediction. Here: tip-off (`game_date_time`). |
| **Point-in-time correct** | Every feature uses only data that existed *strictly before* prediction time. |
| **Label leakage** | The label (who won), or something computed from it, leaks into a feature. |
| **As-of join** | Join each row to the latest matching row at or before a timestamp (`ASOF JOIN` in DuckDB). |
| **Offline vs online store** | Offline: features for every past moment, for training. Online: the latest value per entity, for inference. Same definitions. |
| **Held-out season** | Evaluate on a whole later season, never on random rows mixed with training seasons. |
| **Retrieval eval** | Measure whether search returns the right source documents (recall@k), separately from whether the answer reads well. |

## Gotchas for the whole module

- **`<` vs `<=` at tip-off.** A feature row timestamped exactly at
  `game_date_time` describes *this* game. Use strictly-before.
- **Dates aren't times.** Two games on the same date: a date-level join
  (`game_date <= ...`) lets a 7 pm game see a 4 pm game that day, but
  also lets a 4 pm game see the 7 pm one. Use timestamps.
- **Random train/test splits leak across time.** A model trained on
  January games and tested on December games "knows" the future. Split by
  season.
- **Late-arriving corrections** (M4.6 stat corrections) change history.
  Point-in-time correctness means "as known then", which is harder than
  "as true now". Note which one you built.
