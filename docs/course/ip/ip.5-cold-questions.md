# IP.5 · Answer the 6 cold questions closed-book

> **Ticket:** [#182](https://github.com/Dfscashline21/sideline/issues/182) ·
> **Mode:** hand, closed-book · **Time:** 2 hours prep, 20 min test ·
> **Target week:** 20 · **Needs:** M4, M5, M8, M9, M11, M12 done

## Why this matters

Interviewers often ask a "cold" conceptual question with no setup:
*"Explain how Iceberg skips files."* No code, no whiteboard warm-up,
three minutes to sound like someone who has done it. These answers are
also the follow-ups that come up in every other round.

The ticket: **each answered in under 3 minutes without notes.**

## Which six questions?

The ticket points to "the curriculum's interview section", which isn't
in this repo. The six below are taken from the module epics'
**ready-when** criteria that are explanation questions (as opposed to
build tasks). If your curriculum lists different ones, use those.

| # | Question | From |
|---|---|---|
| 1 | Draw Iceberg's metadata tree from memory and explain how a query skips files. | M4 epic ([#5](https://github.com/Dfscashline21/sideline/issues/5)) |
| 2 | When does an incremental model silently produce wrong numbers, and how would you catch it? | M5 epic ([#6](https://github.com/Dfscashline21/sideline/issues/6)) |
| 3 | What happens, step by step, to a go-ahead three-pointer that arrives 45 seconds late? | M8 epic ([#9](https://github.com/Dfscashline21/sideline/issues/9)) |
| 4 | Describe your alerting strategy without causing alert fatigue. | M9 epic ([#10](https://github.com/Dfscashline21/sideline/issues/10)) |
| 5 | How would you serve the same data to a BI tool, an app and an ML model, and why does each differ? | M11 epic ([#12](https://github.com/Dfscashline21/sideline/issues/12)) |
| 6 | Explain exactly how a naive join leaks future data into training, with an example. | M12 epic ([#13](https://github.com/Dfscashline21/sideline/issues/13)) |

## What you'll produce

Six recorded answers, each under 3 minutes, made without notes, plus a
private note with the outline you rehearsed for each.

## Steps

### 1. Outline each answer (90 min, notes allowed)

For each question, write a five-line outline in your private notes:

1. **One-sentence answer** (the headline)
2. **Mechanism** (how it works, two or three steps)
3. **Example from Sideline** (a real table, number or incident)
4. **Failure case or trade-off**
5. **How you'd check or prevent it**

<details>
<summary>Hint · What a strong answer includes, per question</summary>

1. **Iceberg:** catalog → metadata file → manifest list → manifests →
   data files; partition and column stats at each level let the planner
   prune before reading. Your M4.4/M4.8 numbers.
2. **Incremental:** late-arriving or updated rows outside the lookback
   window; changed logic not backfilled; non-unique keys under merge.
   Catch with reconciliation against a full rebuild, uniqueness tests.
   Your ADR-004 lookback choice.
3. **Late three-pointer:** event time vs processing time; watermark
   (your 30-second one from M8.4) has passed; event goes to late handling
   or the dead-letter topic; what the live score shows; how it's
   corrected later in the Iceberg sink.
4. **Alerting:** alert on symptoms tied to SLOs (freshness, volume), not
   every check; severity levels; routing to owners; runbooks; review noisy
   alerts. Your M9.6 SLO and M6.6 runbook.
5. **Serving:** BI wants wide, consistent, governed tables (semantic
   layer); an app wants low-latency key lookups via an API (your M11.4
   p95); ML wants point-in-time-correct features and reproducible
   training sets.
6. **Leakage:** joining features "as of now" to past games includes
   information from after the game; show a concrete example from M12.3
   and the as-of join fix.

Use your own wording and your own numbers.

</details>

### 2. Rehearse with notes (20 min)

Say each answer out loud from the outline with a timer. Aim for 2 to 2.5
minutes, so 3 is a ceiling, not a target.

### 3. The closed-book test (20 min)

Another day. No notes. Have someone (or a randomiser) pick the order. For
each: start a 3-minute timer, record, answer. For question 1, draw the
tree while you talk.

### 4. Score each answer

| Criterion | Yes/no |
|---|---|
| Under 3 minutes | |
| Headline in the first 20 seconds | |
| Mechanism correct | |
| A concrete Sideline example | |
| A failure case or trade-off | |

✅ **Checkpoint:** all six pass "under 3 minutes" and "mechanism
correct". Redo any that don't in two days, closed-book again.

### 5. Keep them warm

Answer two at random each week until week 24, as part of an IP.2 or
IP.3 session.

## Gotchas

- **Memorising scripts.** Outlines, not paragraphs. A recited answer
  falls apart at the first follow-up.
- **No example.** "In my project the watermark was 30 seconds, and a
  late event…" is what makes an answer credible.
- **Running long.** Interviewers interrupt long answers; give the headline
  first so an interruption still leaves the main point made.

## Done when

- [ ] All 6 answered closed-book, each under 3 minutes, recorded
- [ ] Each scored; any failures redone and passed
- [ ] Outlines kept in private notes
- [ ] Close the issue with "6/6 passed"

## Check yourself

Pick one question at random right now. Can you give the headline in one
sentence?
