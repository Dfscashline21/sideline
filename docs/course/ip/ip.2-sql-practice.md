# IP.2 · SQL practice 3x a week (weeks 12 to 24)

> **Ticket:** [#179](https://github.com/Dfscashline21/sideline/issues/179) ·
> **Mode:** hand · **Time:** 20 min per session, 3 sessions a week ·
> **Needs:** M1 (patterns, the `sql/` problem bank), `.data/practice.duckdb`

## Why this matters

By week 12 you'll be deep in Dagster, Spark and streaming, and M1's
window functions will be fading. The SQL round is the most common
screening round, so it must stay sharp. Short, frequent, timed sessions
keep it there with little time each week.

The ticket: **20-minute timed problems; log time and pattern. Practice
log shows 35+ sessions.** Thirteen weeks at three a week is 39, so you
can miss four.

## What you'll produce

A practice log in your private notes with 35+ entries. Optionally, the
solutions on Sideline data added to `sql/` (public, no employer content).

## Steps

### 1. Set up the log (15 min, once)

```markdown
| # | Date | Source | Problem | Pattern | Time (mm:ss) | Result | Mistake / note |
|---|---|---|---|---|---|---|---|
| 1 | 2027-02-01 | DataLemur | ... | gaps and islands | 14:30 | solved | forgot tiebreaker |
```

**Result** is one of: solved, solved over time, wrong, gave up.

### 2. Plan the sources (15 min, once)

Rotate between three kinds so you practise unfamiliar schemas too:

| Kind | Where | Why |
|---|---|---|
| Interview-style platforms | [DataLemur](https://datalemur.com/questions); LeetCode's "SQL 50" study plan | Unfamiliar schemas and the exact interview format |
| Your own data | New problems on `.data/practice.duckdb` or your M5 marts | Practise writing the question as well as the answer |
| Redo | M1.8 problems you marked `Revisit: yes` | Spaced repetition on your weak spots |

A simple rotation: Monday a platform problem, Wednesday Sideline data,
Friday a redo or a hard one.

### 3. Run each session (20 min)

1. Read the problem. **Name the pattern within 2 minutes**, before
   writing SQL. Write it in the log.
2. Solve within the remaining time with no docs, no AI.
3. Check the answer (the platform's tests, or a hand-checked row).
4. Log it, including the mistake. Two minutes, not ten.

When you're stuck at 20 minutes, stop and look at a solution. Then add
the problem to a "redo in a week" list.

### 4. Review the log every four weeks (15 min)

Weeks 15, 19 and 23. Count by pattern and by result:

```text
pattern               sessions  solved in time
gaps and islands         5           2       ← weak
top N per group          6           6
sessionization           3           1       ← weak
```

✅ **Checkpoint:** every review produces one action, e.g. "next two
weeks, two sessions a week on sessionization".

<details>
<summary>Hint · Patterns to make sure you cover by week 24</summary>

Top N per group with ties, running totals, rolling windows (ROWS vs
RANGE), gaps and islands, sessionization, LAG/LEAD comparisons, self
joins (pairs, hierarchies), anti-joins (`NOT EXISTS` / `LEFT JOIN … IS
NULL`), conditional aggregation and pivots, date spines, de-duplication,
percentiles and median, recursive CTEs, and reading a query plan. If a
pattern has zero log entries by week 18, schedule it.

</details>

### 5. Change the conditions as you improve

From week 18 or so, practise the way interviews actually happen:

- in a plain editor with no autocomplete
- speaking your reasoning out loud
- in a Postgres-style dialect (no `QUALIFY`), if your target companies
  use one

## Gotchas

- **Skipping the log on bad days.** The bad sessions are the most useful
  data. Log them.
- **Only easy problems.** If you solve everything in 8 minutes, move up
  a difficulty level.
- **Peeking at hints at minute 5.** Struggle to minute 20; that's where
  learning happens.

## Done when

- [ ] Practice log shows 35+ sessions, each with time and pattern
- [ ] Three four-weekly reviews, each with an action
- [ ] Every core pattern in the hint list practised at least twice
- [ ] Close the issue with the session count (log stays private)

## Check yourself

1. Which pattern was weakest at week 15, and is it still?
2. What's your median solve time now versus the first two weeks?
