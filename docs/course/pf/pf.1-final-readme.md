# PF.1 · Final README

> **Ticket:** [#170](https://github.com/Dfscashline21/sideline/issues/170) ·
> **Mode:** hand · **Time:** 4 to 6 hours ·
> **Needs:** PF.2 (diagram), PF.3 (ADR index), PF.4 (AI section); the
> numbers inventory in the [PF overview](README.md#your-numbers-inventory)

## Why this matters

In M0.6 you wrote a README skeleton with six headings and a one-line plan
under each. Twenty-two weeks later, this is where you keep that promise.
The README is the most-read artifact you'll produce: recruiters, hiring
managers and interviewers open it before anything else, often for under a
minute.

The ticket asks for **pitch and live link, architecture, numbers,
decisions, run locally, and next steps at 100x**, with **real numbers,
not placeholders.**

## What you'll produce

`README.md` with all six sections complete, the demo video and live
dashboard linked at the top, and every number traceable to a measurement.

## Steps

### 1. Reread your M0.6 skeleton (15 min)

Each section has a one-line plan from week 1. For each: did you deliver
it, change it, or drop it? Note the differences; they're honest material
for "next steps".

### 2. Write the pitch (45 min)

Two to four sentences, then the links. Test: could someone repeat it to a
colleague after one read?

<details>
<summary>Hint 1 · Nudge: what a pitch must contain</summary>

What it is (a data platform for…), what data (leagues, seasons, volume),
what it produces (dashboard, API, models), and the one thing that makes
it more than a tutorial (e.g. backfillable, contract-tested, deployed
from code, live streaming). Then: **live dashboard link · demo video ·
blog posts**.

</details>

<details>
<summary>Hint 2 · Approach: write it three times</summary>

Write a 60-word version, then a 30-word one, then a 15-word one. Use the
15-word version as the first line, the 60-word one as the paragraph.
Delete adjectives that a number could replace ("fast" → "p95 140 ms",
using your real figure).

</details>

### 3. Architecture section (30 min)

Embed the PF.2 diagram. Under it, a short walk-through of the data flow
in 4 to 6 bullets (one per layer). Link each folder (`ingestion/`,
`transform/`…) so a reader can jump to code.

### 4. Numbers section (45 min)

Fill the table from your M0.6 skeleton using **only** your numbers
inventory. For each number, link the evidence: a dashboard, a CI run, a
benchmark write-up, a blog post.

✅ **Checkpoint:** every value in the table has a source link, and no
cell says "TBD", "~?", or a number you didn't measure. If you can't
measure something, remove the row.

### 5. Decisions section (30 min)

Link the ADR index (PF.3) and pick the three decisions a reader should
know, one line each with the trade-off: *"Iceberg over Delta (ADR-003):
open REST catalog and engine choice, at the cost of…"*.

Add the "How I used AI agents" section (PF.4) here or link it.

### 6. Run locally (30 min)

Same bar as M0.8: every command must work on a fresh clone. **Do the
fresh-clone run again** (the stack has grown since week 1: Iceberg
catalog, Dagster, Redpanda…). Note how long it takes now, and mention
any services that need more memory or credentials. Cloud deployment
instructions can link to `infra/`.

✅ **Checkpoint:** fresh clone to working local stack, following only the
README, timed. Record the time in `docs/notes/pf.md`.

### 7. Next steps at 100x (30 min)

Not a to-do list: a short design answer to "what breaks first at 100x
the data, users or leagues, and what would you change?" Two or three
bullets, each naming the bottleneck and the change. This section shows
senior thinking, so ground each bullet in something you measured (e.g.
the M7.9 DuckDB/Spark crossover).

### 8. Trim and check (30 min)

- Read it top to bottom in one minute. Do you know what the project is,
  see it running, and see evidence of depth?
- Check every link (a broken link on a portfolio is a bad signal):

  ```bash
  grep -o '](http[^)]*)' README.md | sort -u
  ```

  Open each one, logged out (private window).
- Move long explanations to `docs/`. The README is the front door.

## Gotchas

- **Stale numbers.** If you re-ran something and the number changed,
  update the inventory and every place it appears (README, video, resume).
- **Links to private things.** Dashboards that need a login, private
  repos, local URLs (`localhost:3000`).
- **The build log.** Your old build log (moved to `docs/build-log.md` in
  M0.6) is a great "depth" link. Make sure it's up to date.

## Done when

- [ ] All six sections complete
- [ ] Real numbers only, each linked to evidence
- [ ] Demo video and live dashboard linked at the top
- [ ] Fresh-clone run redone and still works
- [ ] All links checked logged-out
- [ ] PR merged with `Closes #170`

## Check yourself

1. Say the pitch from memory in 15 seconds.
2. Pick any number in the README. Where was it measured, and when?
3. What breaks first at 100x, and why do you believe that?
