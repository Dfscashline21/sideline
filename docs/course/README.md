# The Sideline Course

The GitHub issues say **what** to build. This course says **how to get
there**: one lab per ticket, walked through step by step, so you learn by
doing rather than by reading someone else's finished code.

The [M0 study guide](../m0-study-guide.md) explains the parts that were
already built (M0.1 to M0.5). The labs here start where it stops.

---

## How to use a lab

Every lab has the same shape:

| Section | What it's for |
|---|---|
| **Ticket box** | Issue link, build mode, time budget, what you need first |
| **Why this matters** | The concept, and why an interviewer cares about it |
| **What you'll produce** | The acceptance criteria, in plain words |
| **Steps** | Numbered steps. Each ends with a ✅ **Checkpoint** you can verify |
| **Hints** | Collapsed. Open them one at a time, only when you're stuck |
| **Gotchas** | Traps in *this* repo or *this* data that cost real time |
| **Done when** | The checklist to tick before closing the issue |
| **Ship it** | Branch, commit and PR for this ticket |
| **Check yourself** | Questions to answer out loud, closed-book |

### The hint ladder

Most tickets are `mode:hand`: you write the core logic yourself, because
it's what interviews test. When you're stuck, open hints **in order**:

1. **Nudge**: a question that points you in the right direction.
2. **Approach**: the technique to use, in words.
3. **Skeleton**: pseudocode or a partial query with blanks.
4. **Solution**: a working answer. Open it only after you have your own,
   to compare, or after 30 honest minutes stuck.

If you open the solution, close it, wait an hour, and write your own
version from a blank file. That's what makes it stick.

### Build modes

| Label | What it means for the lab |
|---|---|
| `mode:hand` | You write it. Labs give steps and hints, never the code up front. |
| `mode:agent` | An agent may draft it. The lab gives you a **prompt** and a **review checklist**; you must be able to explain every line. |
| `mode:mixed` | Core logic by hand, boilerplate by agent. The lab says which is which. |

### Rhythm for every ticket

```bash
git switch main && git pull
git switch -c m1.3-win-streaks        # one branch per ticket
# ... do the lab ...
make lint && make typecheck && make test
git push -u origin m1.3-win-streaks
gh pr create --fill                   # body: "Closes #28"
```

Branch protection means CI must pass before you merge. Then add a short
entry to the build log (what was asked, what you built, how and why), the
same way M0.1 to M0.5 were written up.

### Your notes

Each module ends with a closed-book check that asks for "3 sentences in
the module's notes". Keep them in `docs/notes/m<N>.md` (public, in the
repo). STAR stories are about your employer, so they go in **private**
notes outside the repo.

---

## Labs

Written just in time: each module's labs are written when you reach it,
so they can build on the code you actually wrote.

### M0 · Engineering hygiene (week 1) · [epic #1](https://github.com/Dfscashline21/sideline/issues/1)

| Ticket | Lab | Mode |
|---|---|---|
| M0.1 to M0.5 | Covered by the [M0 study guide](../m0-study-guide.md) | done |
| [M0.6](https://github.com/Dfscashline21/sideline/issues/22) | [README skeleton and CI badge](m0/m0.6-readme-skeleton.md) | hand |
| [M0.7](https://github.com/Dfscashline21/sideline/issues/23) | [Agent instructions file](m0/m0.7-agent-instructions.md) | hand |
| [M0.8](https://github.com/Dfscashline21/sideline/issues/24) | [Ready-when check](m0/m0.8-ready-when.md) | hand |
| [M0.9](https://github.com/Dfscashline21/sideline/issues/25) | [STAR story](m0/m0.9-star-story.md) | hand |

### M1 · Advanced SQL (weeks 1 to 2) · [epic #2](https://github.com/Dfscashline21/sideline/issues/2)

Start with the [module overview](m1/README.md): it describes the practice
tables every M1 lab uses.

| Ticket | Lab | Mode |
|---|---|---|
| [M1.1](https://github.com/Dfscashline21/sideline/issues/26) | [Study: windows, frames, QUALIFY, CTEs, plans](m1/m1.1-study.md) | hand |
| [M1.2](https://github.com/Dfscashline21/sideline/issues/27) | [Load practice data into DuckDB](m1/m1.2-load-practice-data.md) | agent |
| [M1.3](https://github.com/Dfscashline21/sideline/issues/28) | [Longest win streak (gaps and islands)](m1/m1.3-win-streaks.md) | hand |
| [M1.4](https://github.com/Dfscashline21/sideline/issues/29) | [Rolling 5-game scoring average](m1/m1.4-rolling-average.md) | hand |
| [M1.5](https://github.com/Dfscashline21/sideline/issues/30) | [Possessions as sessions](m1/m1.5-possessions.md) | hand |
| [M1.6](https://github.com/Dfscashline21/sideline/issues/31) | [Top 3 college players by TS%](m1/m1.6-true-shooting.md) | hand |
| [M1.7](https://github.com/Dfscashline21/sideline/issues/32) | [Read a query plan and speed it up 2x](m1/m1.7-query-plan.md) | hand |
| [M1.8](https://github.com/Dfscashline21/sideline/issues/33) | [20 more problems](m1/m1.8-problem-bank.md) | hand |
| [M1.9](https://github.com/Dfscashline21/sideline/issues/34) | [Ready-when check](m1/m1.9-ready-when.md) | hand |
| [M1.10](https://github.com/Dfscashline21/sideline/issues/35) | [STAR story](m1/m1.10-star-story.md) | hand |

### Later modules

M2 (Python ingestion) onwards: not written yet. When you finish M1, ask
for the M2 labs; they'll build on your actual `sql/` and practice data.
