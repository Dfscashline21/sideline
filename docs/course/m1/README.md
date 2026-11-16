# M1 · Advanced SQL: module overview

> **Epic:** [#2](https://github.com/Dfscashline21/sideline/issues/2) ·
> **Weeks:** 1 to 2 · **Ready when:** you can solve a medium
> window-function problem in 15 minutes on a whiteboard and explain its plan.

## The path

```
M1.1 study ──► M1.2 load data ──► M1.3 streaks ──► M1.4 rolling avg ──► M1.5 possessions
                                                                              │
     M1.9 closed-book check ◄── M1.8 20 more problems ◄── M1.7 plan 2x ◄── M1.6 TS% top 3
```

M1.1 and M1.2 can run in parallel: study in the evenings while the agent
drafts the loader. Every problem lab after that needs the practice
database.

| Lab | Core pattern | Interview frequency |
|---|---|---|
| M1.3 win streaks | Gaps and islands (`row_number` difference) | Very high |
| M1.4 rolling average | Window frames (`ROWS BETWEEN`) | Very high |
| M1.5 possessions | Sessionization (`LAG` + running `SUM`) | High |
| M1.6 TS% top 3 | Aggregate → filter → rank, ties (`RANK` vs `ROW_NUMBER`) | Very high |
| M1.7 query plan | `EXPLAIN ANALYZE`, pushdown, projection | Medium, senior roles |

## Where your work goes

```
sql/
├── README.md                     # index: one line per problem + pattern
├── practice/
│   └── load_practice_data.py     # M1.2 loader
└── problems/
    ├── 001_longest_win_streak.sql
    ├── 002_rolling_scoring_avg.sql
    └── ...                       # 25 by the end of M1.8
```

The database file lives at `.data/practice.duckdb`. `.data/` and
`*.duckdb` are already in `.gitignore`. Never commit data.

Every problem file starts with the same header (M1.8 requires it):

```sql
-- Problem:  Longest regular-season win streak per team, NBA and WNBA, since 2002
-- Pattern:  gaps and islands (row_number difference)
-- Tables:   nba_team_box, wnba_team_box
-- Verified: Miami Heat 2012-13, 27 games (matches the historical record)
```

## The practice data

Source: [sportsdataverse-data](https://github.com/sportsdataverse/sportsdataverse-data/releases),
free public Parquet files of ESPN data, one file per season. DuckDB reads
them straight over HTTPS:

```sql
select count(*) from read_parquet(
  'https://github.com/sportsdataverse/sportsdataverse-data/releases/download/espn_nba_team_boxscores/team_box_2024.parquet'
);
```

URL pattern: `.../releases/download/<release>/<file>_<season>.parquet`.

### Tables M1.2 should build

| Table | Release / file prefix | Seasons | One row per | Approx. rows |
|---|---|---|---|---|
| `nba_team_box` | `espn_nba_team_boxscores` / `team_box` | 2002 to 2026 | team per game | 64k |
| `wnba_team_box` | `espn_wnba_team_boxscores` / `team_box` | 2003 to 2026 | team per game | 11k |
| `nba_player_box` | `espn_nba_player_boxscores` / `player_box` | 2022 to 2026 | player per game | 170k |
| `nba_pbp` | `espn_nba_pbp` / `play_by_play` | 2024 to 2026 | play-by-play event | 1.8M |
| `ncaa_player_box` | `espn_mens_college_basketball_player_boxscores` / `player_box` | 2008 to 2026 | player per game | 3.3M |

The NCAA table is deliberately big: M1.7 needs enough rows that a 2x
speed-up is measurable.

### Columns you'll use most

**Team box** (`nba_team_box`, `wnba_team_box`): `game_id`, `season`,
`season_type`, `game_date`, `team_id`, `team_display_name`,
`team_home_away`, `team_score`, `team_winner` (boolean),
`opponent_team_id`, `opponent_team_score`, `field_goals_attempted`,
`free_throws_attempted`, `offensive_rebounds`, `total_turnovers`.

**Player box** (`nba_player_box`, `ncaa_player_box`): `game_id`,
`season`, `season_type`, `game_date`, `athlete_id`,
`athlete_display_name`, `team_id`, `minutes`, `points`,
`field_goals_made`, `field_goals_attempted`, `free_throws_attempted`,
`did_not_play` (boolean).

**Play-by-play** (`nba_pbp`): `game_id`, `game_play_number` (event
order within a game), `period_number`, `clock_display_value`,
`start_game_seconds_remaining`, `type_text` (event type, e.g.
`"Defensive Rebound"`, `"Free Throw - 2 of 2"`), `team_id`,
`scoring_play`, `shooting_play`, `score_value`, `text` (human-readable),
`home_team_id`, `away_team_id`.

### Know these before you write any query

| Fact | Why it bites |
|---|---|
| `season` is the year the season **ends**: 2013 means 2012-13 | "Since 2002" means `season >= 2002` = 2001-02 onwards |
| `season_type`: 2 = regular season, 3 = playoffs, 5 = play-in | Mixing playoffs into a "season" streak or average changes answers |
| All-Star and Rising Stars games are in both team boxes as `season_type = 2`, under made-up teams (`EAST`, `Team LeBron`, `USA`, `TEAM CLARK`…) | They add fake "teams" with 1 to 10 games. Real franchises play 20+ games a season, which makes a simple filter |
| The NBA Cup final counts as `season_type = 2`, but not in the standings | The two finalists show 83 regular-season games (e.g. LAL and IND in 2024) |
| `did_not_play = true` rows have `points` and `minutes` = NULL | Averages skip NULLs silently; `COUNT(*)` doesn't |
| `(game_id, team_id)` is unique in the team box | Use it to check your joins don't fan out |
| ESPN `team_id`s differ between leagues (NBA 14 = Heat, WNBA 14 = Storm) | Always partition by league as well as team |
