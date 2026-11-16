# PF.3 · ADR index

> **Ticket:** [#172](https://github.com/Dfscashline21/sideline/issues/172) ·
> **Mode:** agent: the agent drafts, you review every line ·
> **Time:** 45 min · **Needs:** your ADRs in `docs/adr/`

## Why this matters

Your architecture decision records are some of the strongest evidence in
the repo that you can make and defend decisions. An index turns six
scattered files into a one-glance list a reviewer can scan. It's simple
work, which is why it's `mode:agent`. Your job is to make sure every
one-liner is **accurate**, because a summary that misstates your own
decision is worse than none.

## What you'll produce

`docs/adr/README.md` listing **every** ADR with one line each.

The curriculum produces at least these (yours may differ, and you may
have written more):

| ADR | Ticket |
|---|---|
| ADR-001 Why we land raw data unchanged | M2.8 |
| ADR-002 Kimball over Data Vault | M3.8 |
| ADR-003 Iceberg over Delta Lake (incl. catalog choice) | M4.10 |
| ADR-004 Incremental strategy for fact_play | M5.13 |
| ADR-005 Dagster vs Airflow | M6.9 |
| ADR-006 Stream processor choice | M8.10 |

## Steps

### 1. List what actually exists (5 min)

```bash
ls docs/adr/
grep -l -i "status" docs/adr/*.md
```

Compare with the table above. Any missing? Any extra ones you wrote
along the way? The index lists what exists, not what the curriculum
planned.

### 2. Prompt the agent (10 min)

> Read every file in `docs/adr/` except README.md. Write
> `docs/adr/README.md`: a short intro (what an ADR is in one sentence,
> linking https://adr.github.io), then a table with columns: number and
> title (linked to the file), status, date, and a one-line summary of the
> **decision and its main trade-off** in under 25 words. Use only what
> the ADRs say; don't add reasons that aren't in them. Sort by number.

### 3. Review it line by line (20 min)

For each row, open the ADR and check:

| Check | Why |
|---|---|
| Does the one-liner state the decision the ADR actually made? | Agents sometimes summarise the options, not the choice |
| Is the trade-off one the ADR states? | Invented reasons are the commonest agent error here |
| Status and date match the file? | |
| Link works (relative path, correct filename)? | |

Rewrite any line you wouldn't say out loud in an interview.

✅ **Checkpoint:** you can explain every ADR from its one-liner alone,
without opening the file.

### 4. Link it (5 min)

Link the index from the README's Decisions section (PF.1). If your ADRs
are numbered inconsistently (`001-...` vs `adr-1-...`), decide whether to
rename now. Renaming breaks old links, so grep for them first.

### 5. Ship it

```bash
git switch -c pf.3-adr-index
git add docs/adr/README.md
git commit -m "PF.3: ADR index"
gh pr create --fill     # Closes #172
```

In the PR description, list any one-liners you corrected and why. That's
also material for PF.4's "where agents were wrong".

## Done when

- [ ] All ADRs that exist are listed, with links that work
- [ ] Every one-liner checked against its ADR
- [ ] Linked from the README
- [ ] PR merged with `Closes #172`

## Check yourself

1. Give the one-line decision and trade-off for ADR-003 from memory.
2. Which ADR would you write differently now, and why?
