# PF.6 · Resume bullets with real numbers

> **Ticket:** [#175](https://github.com/Dfscashline21/sideline/issues/175) ·
> **Mode:** hand · **Time:** 2 hours ·
> **Needs:** the numbers inventory ([PF overview](README.md#your-numbers-inventory)), PF.1

## Why this matters

A resume gets seconds of attention, from a person and often from a
keyword filter first. Bullets that say what you **achieved**, with a
**number**, using the **technology** the job names, get read. Bullets
that list duties ("worked on data pipelines") don't.

The ticket asks for **3 to 5 outcome-focused bullets: rows, tests, SLO,
cost.**

## What you'll produce

3 to 5 bullets for a "Projects" entry on your resume, each tied to a
measured number. They live in your resume (private), not in the repo.

## The rule

**Only numbers you measured.** Each bullet's number must appear in your
numbers inventory with a source. If an interviewer asks "how did you
measure that?", you'll have the answer, and the link.

## Steps

### 1. Pick the five strongest outcomes (20 min)

From the inventory, choose numbers that show different skills. The
ticket names four areas; map one or two of your numbers to each:

| Area | Your number (from inventory) | Skill it shows |
|---|---|---|
| Rows / scale | e.g. `<N>` play-by-play events across `<leagues>` | Ingestion and storage at volume |
| Tests / quality | e.g. `<N>` dbt tests, `<N>` contract checks in CI | Rigor |
| SLO | e.g. `<X>`% freshness SLO attainment over `<period>` | Production thinking |
| Cost | e.g. cut monthly cost `<X>`% via `<change>` | FinOps |
| Latency | e.g. API p95 `<X>` ms under `<load>` | Serving |

### 2. Draft with a formula (40 min)

A reliable shape:

**Did X (outcome) by Y (how), measured as Z (number).**

or, shorter: **Verb + what + number + technology.**

Draft each bullet in three versions, then keep the best. Placeholders
until you fill your real values:

```text
Built an idempotent, backfillable ingestion and lakehouse pipeline (Python, Iceberg, dbt, Dagster)
  processing <N> games / <M> events across <leagues>, with zero duplicates under kill-and-restart tests.

Cut monthly cloud cost <X>% (<$A> → <$B>) by <one documented change>, with per-league cost attribution
  in Terraform-managed AWS.
```

These show shape only. Every claim in them must be true of what *you*
built; rewrite them in your own words.

<details>
<summary>Hint · Common bullet problems</summary>

- **No outcome:** "Used Spark and Iceberg" → what did it achieve?
- **Unverifiable adjectives:** "highly scalable", "robust" → replace with
  a number or delete.
- **Too long:** more than two lines on a page gets skimmed. Cut the
  "how" before the number.
- **Tool soup:** five technologies in one bullet reads as keyword
  stuffing. Two or three, the ones that matter for that outcome.

</details>

### 3. Tailor for keywords (20 min)

Take three real job postings you'd apply for. Highlight the
technologies and skills they repeat. Where your bullets truthfully use
the same thing, use **their** wording (e.g. "Apache Iceberg" vs
"Iceberg tables"). Don't add tools you didn't use.

### 4. Defend each bullet (30 min)

For each bullet, write the 30-second answer to "tell me more about
that" and the link to the evidence. If you can't, drop the bullet.

✅ **Checkpoint:** 3 to 5 bullets, each with its source in the
inventory, its evidence link, and a 30-second explanation.

### 5. Place them

Add them under a "Projects" entry titled with the project name and the
repo link. Keep the repo link and live dashboard link in the entry; they
make the numbers checkable.

## Gotchas

- **Mixing project and job claims.** Sideline bullets go under Projects,
  not under your employer.
- **Numbers that changed.** If PF.1's README says one value and the
  resume another, reviewers notice. One source of truth: the inventory.
- **Rounding up.** 27% is not "~30%". Round down or state it exactly.

## Done when

- [ ] 3 to 5 outcome-focused bullets covering rows, tests, SLO and/or cost
- [ ] Every number traceable to the inventory and an evidence link
- [ ] Each bullet defended with a 30-second spoken answer
- [ ] Close the issue with "Bullets ready" (no need to post them publicly)

## Check yourself

1. Which bullet would an interviewer ask about first? Rehearse it.
2. Which number are you least sure of, and how would you re-measure it?
