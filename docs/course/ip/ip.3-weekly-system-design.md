# IP.3 · Weekly recorded system design (weeks 12 to 24)

> **Ticket:** [#180](https://github.com/Dfscashline21/sideline/issues/180) ·
> **Mode:** hand · **Time:** 45 min session + 20 min watching back, weekly ·
> **Needs:** nothing to start; from week 22, M13.1's framework

## Why this matters

System design is the round that most separates mid-level from senior
offers, and it's a performance skill: structure, pacing and speaking
clearly while thinking. That only improves with reps you can **watch
back**. One a week for thirteen weeks turns a scary round into a routine.

The ticket: **45 minutes out loud; watch it back once. 12+ sessions
recorded.**

You start this in week 12, ten weeks before M13 formalises a framework.
That's deliberate: early sessions will be rough, and seeing your own
improvement on video is the point. When you reach M13.1, switch to your
framework.

## What you'll produce

- 12+ recorded 45-minute sessions, stored privately
- A design log in your private notes: one entry per session

## Steps

### 1. A starter framework for weeks 12 to 21 (20 min, once)

Until M13.1, use this minimal sequence and time budget:

| Minutes | Phase |
|---|---|
| 0–8 | Requirements: users, data volume, latency, freshness. Summarise back. |
| 8–15 | High-level flow: sources → storage → processing → serving |
| 15–30 | Deep dive on the hardest part |
| 30–40 | What breaks, how you'd know, cost |
| 40–45 | What changes at 10x |

### 2. Build a prompt list (30 min, once)

Write 15 prompts. Draw them from what you're building that week, so
practice and module reinforce each other:

| Week | Module | Example prompt |
|---|---|---|
| 12 | M6 | Orchestrate daily pipelines for three leagues with different calendars |
| 13–14 | M7 | Nightly aggregation over 5 years of event data that no longer fits one machine |
| 15–16 | M8 | Live scoreboard for 100k concurrent users |
| 17 | M9 | Data quality monitoring for 200 tables owned by 10 teams |
| 18–19 | M10 | Multi-environment data platform on a cloud, with least-privilege access |
| 20 | M11 | Serve the same metrics to a BI tool, a mobile app and an ML model |
| 21 | M12 | Feature pipeline for a model that predicts game outcomes |
| 22–24 | M13 / PF | M13's sealed problems; classic prompts (clickstream analytics, ride-share trips, ad attribution) |

Keep the remaining prompts unseen. Don't research a prompt before its
session.

### 3. Run each session (45 min)

- Record voice and screen ([OBS](https://obsproject.com) or your OS's
  recorder). Draw in [Excalidraw](https://excalidraw.com) or on paper
  under a camera.
- Visible timer. Speak continuously, as if an interviewer were there.
  Where you'd ask the interviewer something, say the question and your
  assumption.
- Stop at 45:00, finished or not.

### 4. Watch it back once (20 min)

At 1.5x. Then write the log entry straight away:

```markdown
## Session N · YYYY-MM-DD · <prompt>
- Reached phase: requirements / flow / deep dive / failures / 10x
- Minute I started drawing: __
- Best moment:
- Worst moment:
- Areas skipped:
- One change next week:
```

✅ **Checkpoint:** "one change next week" is specific and checkable
("summarise requirements back before minute 8"), not "be better".

### 5. Look for trends monthly (15 min)

Weeks 15, 19, 23: read the last four entries together. Are you reaching
the failure-modes phase more often? Starting to draw earlier? If one
problem repeats three times, practise it on its own (e.g. a 10-minute
estimates-only drill).

<details>
<summary>Hint · Common early-session problems</summary>

- 20+ minutes on requirements: set a hard switch at minute 8
- Drawing every tool you know: one box per role, add only when needed
- Silence while thinking: narrate ("I'm deciding between X and Y because…")
- Never mentioning failure or cost: put them in the time budget, not as
  extras

</details>

## Gotchas

- **Skipping the watch-back.** Unwatched recordings teach nothing; the
  ticket requires one watch.
- **Recordings in the repo.** Keep them private and out of git.
- **Researching before the session.** Then it's a presentation, not an
  interview.

## Done when

- [ ] 12+ sessions recorded, each 45 minutes and timed
- [ ] Each watched back once, with a log entry
- [ ] Switched to your M13.1 framework from week 22
- [ ] Close the issue with the session count (recordings stay private)

## Check yourself

1. Compare session 1 and your latest. What's the biggest difference?
2. Which phase do you still rush or skip?
