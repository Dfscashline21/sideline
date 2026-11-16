# M13 · System design and leadership: module overview

> **Epic:** [#14](https://github.com/Dfscashline21/sideline/issues/14) ·
> **Week:** 22 · **Ready when:** you can run a 45-minute system design
> interview end to end, out loud, with a timer.

> **Written ahead of time.** These labs were drafted before M2 to M12
> existed. Wherever they mention a number, component or ADR, swap in what
> you actually built and measured.

## The path

```
                     ┌──► M13.2 betting odds doc ─────┐
                     ├──► M13.3 player tracking doc ──┤
M13.1 framework ─────┼──► M13.4 migration doc ────────┼──► M13.6 four mocks ──► M13.7 closed-book check
                     └──► M13.5 maturity roadmap ─────┘

M13.8 STAR story: any time this week (it pairs well with M13.5)
```

The four design docs (M13.2 to M13.5) depend only on the framework, not
on each other. Do them in any order. Each mock in M13.6 reuses one doc's
problem, so finish the docs first.

| Lab | Core skill | Interview signal |
|---|---|---|
| M13.1 framework | A repeatable checklist for any design question | You don't freeze on an unfamiliar prompt |
| M13.2 betting odds | Low latency plus audit and retention | Trading latency against correctness and compliance |
| M13.3 player tracking | High-volume time series | Back-of-envelope sizing, storage layout |
| M13.4 migration | Change without downtime | Dual-run, reconcile, roll back: the senior signal |
| M13.5 maturity roadmap | Sequencing work over a year | Leadership: what first, and why |
| M13.6 mocks | Performing under time pressure | Communication, handling pushback |

## What you'll produce

```
docs/design/
├── README.md                          # index of the four docs
├── template.md                        # your doc template (M13.1)
├── 001-realtime-betting-odds.md
├── 002-player-tracking-pipeline.md
├── 003-sqlserver-to-lakehouse-migration.md
└── diagrams/                          # exported PNG/SVG, or Mermaid in the docs
docs/notes/m13.md                      # framework, mock log summary, closed-book notes
```

**M13.5 is the exception.** The maturity roadmap is about your employer.
Keep the full version in private notes. Only commit it if it's
thoroughly anonymised (see the lab).

## Shared tools

- **Diagrams:** [Excalidraw](https://excalidraw.com) for whiteboard-style
  sketches (it's also what many remote interviews use),
  [draw.io](https://www.drawio.com) for neater boxes, or
  [Mermaid](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-diagrams),
  which GitHub renders inside Markdown so the diagram lives in the diff.
- **Diagram levels:** the [C4 model](https://c4model.com)'s idea of
  zoom levels (context → containers → components) stops you drawing
  everything at once.
- **Your own system:** Sideline *is* a worked design. Your ADRs
  (ADR-001 to ADR-006), the M10 security diagram and the M11 latency
  numbers are evidence you can quote in every doc and mock.

## Know these before you start

| Fact | Why it matters |
|---|---|
| Interviewers score the **process**, not the final diagram | Saying requirements and trade-offs out loud earns more than a pretty picture |
| Numbers beat adjectives | "≈2 TB/season" lets you choose storage; "a lot of data" doesn't |
| Every design has a failure mode | Saying "here's how this breaks, and how we'd notice" is the senior signal |
| A design doc is for **readers**, not for you | Lead with the decision and the trade-offs; put details last |
