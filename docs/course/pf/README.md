# PF · Portfolio packaging: module overview

> **Epic:** [#15](https://github.com/Dfscashline21/sideline/issues/15) ·
> **Weeks:** 23 to 24 · **Ready when:** a peer who doesn't know the
> project can explain what it does and why it's senior-level after
> 5 minutes.

> **Written ahead of time.** These labs were drafted before the platform
> existed. Every number, link and component they mention is a placeholder
> for what you actually built and measured. Never publish a number you
> didn't measure.

## The path

```
Week 23                                           Week 24
PF.2 final diagram ──┐
PF.3 ADR index ──────┼──► PF.1 final README ──► PF.5 demo video ──► PF.8 fresh-eyes review
PF.4 'AI agents' ────┘            │                                       │
                                  └──► PF.6 resume bullets ──► PF.7 site + LinkedIn
                                                                          │
                                       fix top 3 items from PF.8 ◄────────┘
```

- PF.2, PF.3 and PF.4 are independent; each becomes a section or link in
  the final README.
- PF.1 needs them. PF.5 (video) is linked at the top of the README.
- PF.6 and PF.7 reuse the README's numbers.
- PF.8 comes last: the reviewer should see the finished thing, and you
  need time after to fix the top three items.

## What you'll produce

| Artifact | Where |
|---|---|
| Final README: six sections, real numbers | `README.md` |
| Architecture diagram matching the deployed system | `docs/architecture/` (or wherever your M0.6 skeleton points) |
| ADR index | `docs/adr/README.md` |
| "How I used AI agents" section | README or `docs/ai-agents.md` |
| 3–5 minute demo video | Hosted (YouTube unlisted, Loom, etc.), linked at the top of the README |
| 3–5 resume bullets | Private (your resume) |
| Site and LinkedIn update | External |
| Peer review notes and fixes | `docs/notes/pf.md` |

## Your numbers inventory

Every PF lab draws on the same set of measured numbers. Before starting,
collect them into **one table** in `docs/notes/pf.md`, each with the
place it was measured, so PF.1, PF.5 and PF.6 can't disagree:

| Metric | Value | Source (ticket, file, dashboard) | Date measured |
|---|---|---|---|
| Rows/events ingested, per league | | M2, M6, M7 | |
| Seasons covered | | M4.3 | |
| dbt models / tests passing | | M5.10, CI | |
| Data-quality checks / freshness SLO attainment | | M9.6, M9.10 | |
| API p95 latency | | M11.4 | |
| Monthly cloud cost, and the % cut | | M10.9, M10.10 | |
| Streaming end-to-end lag | | M8 | |
| Rebuild-from-code time | | M10 ready-when | |

If a number is missing, measure it now or leave it out. Don't estimate
a number and present it as measured.

## Know these before you start

| Fact | Why it matters |
|---|---|
| Reviewers spend about a minute on a README | Pitch, live link and one diagram must be visible without scrolling far |
| A demo video is watched by people who won't clone anything | It must show the *running* system, not code |
| Resume bullets get screened by people and by keyword filters | Outcome + number + technology, in that order |
| Everything here is public | No employer details, secrets, or personal data in any artifact |
