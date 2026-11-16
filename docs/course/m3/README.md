# M3 · Data modeling: module overview

> **Epic:** [#4](https://github.com/Dfscashline21/sideline/issues/4) ·
> **Weeks:** 5 to 6 · **Ready when:** given a new domain (ticket sales),
> you can name the grain, facts and dimensions in 10 minutes.

> **Written ahead of time.** These labs were drafted before your M1 and
> M2 code existed. Table and column names follow the course's default
> conventions; where you built something differently in M2, use your
> names and adapt.

## Why this module is all paper

M3 produces **no code**. You design the dimensional model for all three
leagues on paper first, and only build it in dbt in M5. That's deliberate:
changing a design doc costs minutes, while changing a model with six
months of incremental history behind it costs weeks. Interviewers test
this skill directly ("model ticket sales for me") because it's the part
of data engineering that tooling can't do for you.

## The path

```
M3.1 study ──► M3.2 grains ──┬──► M3.3 dim_player (SCD2) ───┐
                             ├──► M3.4 player crosswalk ────┼──► M3.6 ERD ──► M3.7 critique ──► M3.8 ADR-002 ──► M3.9 check
                             └──► M3.5 team/season/game ────┘

M3.10 STAR story: any time after M3.1
```

- M3.3, M3.4 and M3.5 don't depend on each other. Do them in any order,
  but all three need M3.2's grain statements.
- M3.6 draws what M3.2 to M3.5 decided, so it comes after all three.
- M3.8 records the decision. Write it after the critique, so you can
  answer its objections.

## Where your work goes

All of it goes in one design document, plus the ERD and the ADR:

```
docs/
├── design/
│   ├── data-model.md        # M3.2 grains, M3.3 to M3.5 dimension designs
│   ├── player-crosswalk.md  # M3.4 (long enough for its own file)
│   └── erd.md               # M3.6 Mermaid ERD
├── adr/
│   └── 002-kimball-over-data-vault.md   # M3.8
└── notes/
    └── m3.md                # study notes, critique log, closed-book check
```

## The model you're designing

Course defaults, used in every example (and by M5, M7 and M12 later):

| Table | Type | Built in |
|---|---|---|
| `fact_play` | Transaction fact: play-by-play events | M5.6 |
| `fact_shot` | Transaction fact: shot attempts with location | M5 |
| `fact_player_game` | Box-score line: one player in one game | M5 |
| `fact_team_game` | Box-score line: one team in one game | M5 |
| `dim_player` | SCD Type 2 | M5.5 snapshot |
| `dim_team` | SCD Type 2 (conference, name, city change) | M5.8 |
| `dim_season` | One row per league season | M5.8 |
| `dim_game` | One row per game, with game type | M5.8 |
| `dim_date`, `dim_venue` | Conformed dimensions | M5.8 |
| `player_crosswalk` | Bridge: one person across sources | M7.3 |

League keys everywhere: `nba`, `wnba`, `ncaa_m`, `ncaa_w`.

## Concepts that come up in every lab

| Term | One-line meaning |
|---|---|
| **Grain** | Exactly what one row of a table represents. Decided first, never changed later |
| **Fact** | Something that happened and can be measured (a shot, a game result) |
| **Dimension** | The context you filter and group by (who, which team, when, where) |
| **Surrogate key** | An ID your warehouse makes up (`player_sk`), independent of any source |
| **Natural key** | The ID a source gives you (`espn_athlete_id`, `nba_person_id`) |
| **Conformed dimension** | One dimension shared by every fact and league, so they join consistently |
| **SCD Type 2** | A dimension that keeps history by adding a new row when an attribute changes |

## Facts about the data worth knowing

Checked against the M1 practice data:

| Fact | Why it matters for the model |
|---|---|
| ESPN uses the **same `athlete_id`** for a player in college and the NBA (e.g. Paolo Banchero is 4432573 in both) | Within ESPN, the crosswalk is easy. The hard part is linking ESPN to `nba_api`'s `PERSON_ID` and other sources |
| 313 display names in the 2024-25 men's college data belong to **more than one** `athlete_id` (five different "Caleb Williams") | Matching people by name alone is wrong hundreds of times a season |
| OG Anunoby played for the Raptors until 2023-12-29 and the Knicks from 2024-01-01 | Your SCD2 worked example; ESPN's box score shows the change |
| `season` means different things per league: 2027 is the NBA's 2026-27 season, 2026 is the WNBA's 2026 season | A bare integer can't be a season key across leagues |
