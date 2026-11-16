# PF.4 · "How I used AI agents" section

> **Ticket:** [#173](https://github.com/Dfscashline21/sideline/issues/173) ·
> **Mode:** hand · **Time:** 2 hours ·
> **Needs:** your agent instructions file (M0.7); PR descriptions from
> every `mode:agent` and `mode:mixed` ticket

## Why this matters

Every reviewer will wonder how much of this repo an AI wrote. Answer
before they ask, with specifics. A clear account of **where agents
helped, how you reviewed, and where they were wrong** turns a possible
doubt into evidence of judgement, which is the skill teams hiring now
actually want.

The ticket requires **at least one specific agent mistake you caught.**
Vague claims ("I always reviewed carefully") don't count.

## What you'll produce

A section in the README (or `docs/ai-agents.md`, linked from it) covering:
where agents helped, your rules and review process, specific mistakes
caught, and what you never delegated.

## Steps

### 1. Gather the evidence (40 min)

You've been collecting this all along, in PR descriptions. List every
agent-assisted ticket and pull out what happened:

```bash
gh pr list --state merged --limit 200 --json number,title,body \
  --jq '.[] | select(.body | test("agent|Agent")) | "#\(.number) \(.title)"'
```

Adjust the filter to however you labelled agent work. Also reread
M0.7's `AGENTS.md`: has it changed since week 1? Every change was a
lesson.

For each agent ticket, note:

| Ticket | What the agent drafted | What you changed | Why |
|---|---|---|---|
| M1.2 | practice loader | | |
| M4.2 | Iceberg catalog in Compose | | |
| … | | | |

✅ **Checkpoint:** at least three concrete corrections, each with the
ticket, what was wrong, and how you noticed (a test failed, review, a
number looked off, it violated `AGENTS.md`).

### 2. Pick the best mistake story (20 min)

The ideal example is one where the agent's output **looked right** and
**ran**, but was wrong, and your review or a check caught it. It shows
review skill, not just that the agent produced an error.

<details>
<summary>Hint · Kinds of mistakes worth telling</summary>

Without inventing any: look in your notes for things like a loader that
silently skipped a missing season, a dbt model that fanned out a join,
an IAM policy broader than needed, a test that asserted nothing, a
summary that misstated an ADR (PF.3), a reconciliation that compared the
wrong grain. Pick the one with the clearest "how I caught it".

</details>

### 3. Write the section (45 min)

Suggested structure, about 300 to 500 words:

1. **The rule set.** Link `AGENTS.md`. Explain the build modes in one
   line each: hand (core interview-tested skills, no agent code), agent
   (drafted by an agent, reviewed line by line), mixed.
2. **Where agents helped.** Name the kinds of work (infra boilerplate,
   ports to a second league, docs hosting). Give the real share if you
   can count it (n of N tickets).
3. **How I reviewed.** Your actual process: read before running, checks
   against independent numbers, the review questions from M1.2.
4. **Where they were wrong.** Your best mistake story in detail, then
   two or three short ones.
5. **What I never delegated** and why.

### 4. Check it's true (15 min)

Every claim must be supportable by a PR, a commit or a note. Link the
PRs for the mistakes you describe. If a claim can't be linked, soften or
cut it.

## Gotchas

- **Overstating or understating.** Both get caught in interviews. If an
  agent drafted 40% of the infra, say so.
- **Naming tools and versions that will date fast.** Describe roles and
  practices; mention the tool once.
- **Blaming the agent.** Frame mistakes as "the draft did X; I caught it
  by Y", not "the AI was bad".

## Done when

- [ ] Section covers where agents helped, how you reviewed, where they were wrong
- [ ] At least one specific agent mistake you caught, with how you caught it and a PR link
- [ ] "Never delegated" list matches `AGENTS.md`
- [ ] Linked from the README
- [ ] PR merged with `Closes #173`

## Check yourself

1. Tell your best agent-mistake story in 60 seconds.
2. How would you set agent rules for a team of five engineers?
