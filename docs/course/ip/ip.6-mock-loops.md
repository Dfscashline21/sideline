# IP.6 · Monthly full mock loop

> **Ticket:** [#183](https://github.com/Dfscashline21/sideline/issues/183) ·
> **Mode:** mixed: an agent or peer runs the rounds; *you* do every answer ·
> **Time:** about 4 hours per loop, plus 1 hour review ·
> **When:** weeks 16, 20 and 24 · **Needs:** IP.1 to IP.5 in progress

## Why this matters

Single-round practice doesn't prepare you for a full loop: several
rounds back to back, switching from SQL to behavioural to design, while
tired. The IP epic's ready-when is passing exactly this: **SQL, coding,
modelling, system design, behavioural.**

Three loops a month apart show whether you're improving, and each one
tells you what to practise for the next four weeks.

## What you'll produce

Three completed mock loops with notes on gaps, in your private notes.

## The loop

| Round | Length | Format | Practised by |
|---|---|---|---|
| SQL | 45 min | Two problems, medium then hard, in a plain editor | IP.2 |
| Coding (Python) | 45 min | A data-processing problem: parse, transform, test | M2, M6 work |
| Data modelling | 45 min | Model a new domain, answer queries | IP.4 |
| System design | 45 min | One unseen prompt | IP.3, M13 |
| Behavioural | 30 min | Four to five questions | IP.1 |

Take a 10-minute break between rounds, as in a real onsite. Doing all
five in one day is the realistic test; splitting across two days is
fine for the first loop.

## Steps

### 1. Choose interviewers (30 min, before each loop)

- **A peer** is best for behavioural and design: real follow-ups, real
  reactions. Trade a mock loop with another engineer preparing for interviews.
- **An AI interviewer** (the mixed part of the ticket): it can run any
  round. Reuse your M13.6 interviewer prompt and adapt it per round. Its
  job is to ask, time and push back, never to answer.

### 2. Prepare the questions (30 min, done by someone else if possible)

You shouldn't choose your own questions. Options:

- Ask your peer or the AI interviewer to choose, with only the round
  format and difficulty as input.
- For SQL, keep a sealed list of problems you haven't attempted.
- For coding, prompts like: "parse this nested JSON feed into flat rows,
  handle missing fields, and write two tests", or "implement retry with
  exponential backoff and jitter around a flaky function".

<details>
<summary>Hint · Prompt template for an AI round</summary>

> You are interviewing me for a senior data engineer role. This is the
> **<round>** round, **<length>** minutes. Pick a question I haven't
> seen, of **<difficulty>** difficulty. Ask clarifying-question answers
> only when I ask. Push back on weak reasoning. Don't give hints unless I
> ask, and note when I did. At the end, score me 1–5 on correctness,
> communication and depth, and name my three biggest gaps with quotes.

</details>

### 3. Run the loop

Rules for every round: timer visible, talk out loud, no notes, no
looking things up, no AI help (other than the AI *interviewer*). Record
the design and behavioural rounds.

### 4. Write the gap notes (60 min, same or next day)

```markdown
## Mock loop N · YYYY-MM-DD
| Round | Score (1–5) | Interviewer's top gap | My top gap |
|---|---|---|---|
| SQL | | | |
| Coding | | | |
| Modelling | | | |
| Design | | | |
| Behavioural | | | |

Overall: would this loop get an offer? Why / why not?
Top 3 gaps to practise before the next loop:
1.
2.
3.
```

✅ **Checkpoint:** each gap becomes a scheduled practice item in IP.2,
IP.3, IP.4 or IP.1 for the next four weeks.

### 5. Compare loops

At loop 2 and loop 3, put the score tables side by side. Did last time's
top three gaps improve? If a gap repeats in all three loops, it needs a
different approach (e.g. a peer, a course, or a focused week), not more
of the same practice.

### 6. Ready-when

The epic's ready-when is **passing** a full loop. Define "pass" before
loop 1, for example: no round below 3, and at least three rounds at 4 or
above. If loop 3 doesn't pass, schedule loop 4 after a focused fortnight
on its gaps.

## Gotchas

- **Easy interviewers.** Friendly peers and default AI settings go soft.
  Ask explicitly for a tough interview.
- **Skipping the coding round** because Sideline is SQL-heavy. Many
  loops include Python; practise it.
- **Results in the repo.** Mock results are private notes, per the epic.

## Done when

- [ ] 3 mock loops completed (weeks 16, 20, 24), all five rounds each
- [ ] Notes on gaps for each loop, with top 3 actions
- [ ] Loops compared; repeated gaps addressed differently
- [ ] Close the issue with "3 loops done; latest result: pass / not yet"

## Check yourself

1. What was your weakest round in loop 1, and how did it score in loop 3?
2. Which gap would you most want fixed before a real loop?
