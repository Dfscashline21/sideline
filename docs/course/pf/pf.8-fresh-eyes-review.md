# PF.8 · Fresh-eyes review by a peer

> **Ticket:** [#177](https://github.com/Dfscashline21/sideline/issues/177) ·
> **Mode:** hand · **Time:** 30 min with the reviewer, plus fixes ·
> **Needs:** PF.1 to PF.5 published

## Why this matters

After 24 weeks you can't see your repo the way a stranger does. You know
where everything is, so you can't tell what's confusing. The PF epic's
ready-when is exactly this test: *a peer who doesn't know the project
can explain what it does and why it's senior-level after 5 minutes.*

The ticket: **feedback collected and top 3 items fixed.**

## What you'll produce

- Notes from one (ideally two) 5-minute reviews in `docs/notes/pf.md`
- The top three items fixed, in a PR

## Steps

### 1. Find the right reviewer (whenever, before week 24)

Ideal: an engineer or technical recruiter who **hasn't seen the project**.
A data engineer is great; a software engineer or analyst is fine. Avoid
people who watched you build it. Ask in advance; offer to review
something of theirs.

### 2. Set up the test (5 min)

Send them only the repo link. Don't explain it first. Ask them to share
their screen if remote, so you can watch where they click.

Instructions to give them:

> You have 5 minutes. Look at this repo as if you were deciding whether
> to interview the author. Think out loud. I won't answer questions until
> the end.

### 3. Watch and say nothing (5 min)

Start a timer. Write down, silently:

- where they clicked first, and how long until they found the live
  dashboard and the video
- where they hesitated, scrolled back, or said "what's this?"
- anything they skipped entirely

Not talking is hard. It's also the point: in real life you won't be there.

### 4. Ask the questions (10 min)

After 5 minutes:

1. "In two or three sentences, what does this project do?"
2. "What, if anything, made it look senior-level? What made it look junior?"
3. "What confused you or seemed missing?"
4. "If you only remembered one thing, what would it be?"
5. "What would you cut?"

✅ **Checkpoint:** compare their answer to question 1 with your PF.1
pitch. If it's far off, that's the most important finding.

### 5. Prioritise (15 min)

List every item they raised, then rank by **impact on the 5-minute
impression** × **effort**. Pick the top three.

| Item | Impact (H/M/L) | Effort (H/M/L) | Fix? |
|---|---|---|---|
| | | | |

<details>
<summary>Hint · Typical high-impact, low-effort fixes</summary>

Moving the video/dashboard links higher, cutting the README's first
screen to the essentials, a missing one-line explanation of a term
(what's a "contract" or "SCD2"?), a broken or slow dashboard, an
architecture diagram that's unreadable on GitHub.

</details>

### 6. Fix the top three (1–3 hours)

One PR, with the review notes summarised in the description (no
reviewer name unless they agree). If time allows, a second reviewer
afterwards tells you whether the fixes worked.

## Gotchas

- **Defending the work during the review.** Note it and fix it later.
  Arguing teaches you nothing.
- **Fixing their #1 when it's a matter of taste** and ignoring a
  confusion. Prioritise misunderstandings over preferences.
- **Only friends who are polite.** Ask explicitly for the junior-looking
  parts.

## Done when

- [ ] At least one 5-minute fresh-eyes review done and notes recorded
- [ ] Their two-sentence summary compared with your pitch
- [ ] Top 3 items fixed in a PR merged with `Closes #177`

## Check yourself

1. What did the reviewer misunderstand that you'd never have predicted?
2. After the fixes, would a second reviewer pass the epic's ready-when test?
