# IP.1 · Compile 8 STAR stories

> **Ticket:** [#178](https://github.com/Dfscashline21/sideline/issues/178) ·
> **Mode:** hand · **Time:** 4 to 5 hours, then 15 min rehearsal sessions ·
> **Target week:** 18 · **Needs:** the module STAR stories you've written so far

## Why this matters

Behavioural rounds ask a small set of recurring questions in many
disguises. Eight well-rehearsed stories cover almost all of them. You've
been drafting raw material since week 1: every module ended with a STAR
ticket. This lab turns that pile into a **bank** you can draw from under
pressure.

The ticket's eight themes: **pipeline fixed, production incident, design
disagreement, wrong-ask stakeholder, mentoring, cost cut, migration,
quality catch.**

The STAR format and word budgets are in the
[M0.9 lab](../m0/m0.9-star-story.md). Reread it first.

## What you'll produce

Eight stories in your **private** notes, each under 200 words, each
rehearsed out loud.

## Steps

### 1. Gather what you have (30 min)

Collect every module STAR story from your private notes:

| Ticket | Prompt |
|---|---|
| [M0.9](https://github.com/Dfscashline21/sideline/issues/25) | Poor engineering hygiene (no CI, environments, manual deploys) cost your team |
| [M1.10](https://github.com/Dfscashline21/sideline/issues/35) | A query or report that was wrong or slow, and how it was fixed |
| [M2.10](https://github.com/Dfscashline21/sideline/issues/45) | A pipeline that duplicated or lost data on retry; idempotency |
| [M3.10](https://github.com/Dfscashline21/sideline/issues/55) | A reporting inconsistency from unclear grain or missing history |
| [M4.12](https://github.com/Dfscashline21/sideline/issues/67) | A storage/file-layout problem (small files, slow scans, no history) |
| [M5.15](https://github.com/Dfscashline21/sideline/issues/82) | A transformation with no tests or docs, and what a dbt-style approach changed |
| [M6.11](https://github.com/Dfscashline21/sideline/issues/93) | A scheduling or dependency failure and the orchestration fix |
| [M7.13](https://github.com/Dfscashline21/sideline/issues/106) | A job that was slow or expensive at scale |
| [M8.12](https://github.com/Dfscashline21/sideline/issues/118) | A real-time need, and whether streaming was the right call |
| [M9.12](https://github.com/Dfscashline21/sideline/issues/130) | A bad-data incident: how found, how long, what checks would catch it |
| [M10.13](https://github.com/Dfscashline21/sideline/issues/143) | A security, access or cloud-cost problem |
| [M11.8](https://github.com/Dfscashline21/sideline/issues/151) | A team that couldn't get data in the form it needed |
| [M12.10](https://github.com/Dfscashline21/sideline/issues/161) | A model or analysis that was too good to be true; leakage |
| [M13.8](https://github.com/Dfscashline21/sideline/issues/169) | Influencing a technical decision without authority |

At week 18 you'll have written M0.9 to M9.12 at most; the later ones can
replace weaker stories when you write them.

### 2. Map stories to the eight themes (30 min)

Fill this in. One story can fit several themes, but each theme needs its
own **best** story, and no story should fill more than two slots.

| Theme | Best candidate | Backup |
|---|---|---|
| Pipeline fixed | e.g. M2.10 or M6.11 | |
| Production incident | e.g. M9.12 | |
| Design disagreement | e.g. M13.8 (later) | |
| Wrong-ask stakeholder | e.g. M11.8 or M8.12 | |
| Mentoring | none of the module prompts: needs a new story | |
| Cost cut | e.g. M10.13 or M7.13 | |
| Migration | e.g. M4.12 or your M13.4 thinking applied at work | |
| Quality catch | e.g. M3.10, M9.12 or M12.10 | |

✅ **Checkpoint:** every theme has a candidate. Mentoring will likely be
empty. That's expected: write a new story for it in step 4.

### 3. Strengthen each story (2 hours)

For each of the eight, check against this list and revise:

- under 200 words, about 90 seconds spoken
- "I" for what you did; actions in concrete steps
- a **number** in the result
- a lesson: what you'd do differently, or now do by default
- one follow-up answer ready ("what would you do differently?")

<details>
<summary>Hint · What each theme is really testing</summary>

- **Pipeline fixed:** debugging method and ownership
- **Production incident:** calm under pressure, communication, the postmortem
- **Design disagreement:** respect for the other view, evidence, outcome
- **Wrong-ask stakeholder:** finding the real need behind the request
- **Mentoring:** making someone else better, not just answering questions
- **Cost cut:** measurement before and after, trade-offs accepted
- **Migration:** planning, risk, rollback, people
- **Quality catch:** how it was noticed, the impact avoided, prevention

</details>

### 4. Write the missing ones (45 min)

Usually mentoring, sometimes design disagreement. Mentoring examples:
onboarding a new hire, teaching a colleague a technique (window
functions?), reviewing someone's code in a way that changed their
habits. If you have no real story, say so in an interview and offer the
closest true one. Never invent.

### 5. Build a quick-reference sheet (15 min)

One line per story: theme, title, the number. That's what you glance at
before an interview.

```markdown
| Theme | Story | Number |
|---|---|---|
| Production incident | "The duplicate-orders Monday" | 4 hrs to detect → 10 min after checks |
```

(Example placeholder: use your own.)

### 6. Rehearse out loud (15 min sessions, ongoing)

The ticket requires **rehearsed out loud**. For each story: record it,
listen once, re-record if over two minutes. Then practise **switching**:
have someone (or an AI) ask a random behavioural question and pick the
right story within five seconds.

## Gotchas

- **Same story for everything.** Interviewers in a loop compare notes.
  Use different stories in different rounds.
- **Public repo.** None of this goes in Sideline. Close the issue with
  "Compiled in private notes".
- **Stale numbers.** If you don't remember the number precisely, say
  "roughly", and be ready to explain how you know.

## Done when

- [ ] All 8 themes have a story, each under 200 words with a number
- [ ] All 8 rehearsed out loud and recorded at least once
- [ ] Quick-reference sheet written
- [ ] Saved in private notes; issue closed without details

## Check yourself

1. "Tell me about a time you disagreed with a senior engineer." Which story, in under five seconds?
2. Which story is weakest, and what would make it stronger?
