# IP.4 · Biweekly data modelling in a new domain

> **Ticket:** [#181](https://github.com/Dfscashline21/sideline/issues/181) ·
> **Mode:** hand · **Time:** 60 to 90 min every two weeks ·
> **Needs:** M3 (grain, facts, dimensions, SCD types)

## Why this matters

The data modelling round gives you an unfamiliar business and asks you
to model it, usually in 30 to 45 minutes. M3 taught the method on
basketball, which you now know inside out. The skill being tested is
applying it to a domain you **don't** know. Recall M3's ready-when:
*given a new domain, name the grain, facts and dimensions in 10 minutes.*

The ticket lists six domains: **fantasy basketball, ticketing,
e-commerce, healthcare claims, ad clicks, logistics.** Six or more
modelled.

## What you'll produce

Six or more domain models, each with a bus matrix, grain statements, an
ERD sketch and answers to three business questions. These are invented
domains with no employer content, so they can go in the public repo
(e.g. `docs/modeling/`) or stay private.

## Steps

### 1. The routine for each domain (60–90 min)

Same steps every time, timed:

| Minutes | Step |
|---|---|
| 0–10 | Write the business processes (events that happen: an order placed, a ticket scanned). Then the **grain** of each in one sentence. |
| 10–20 | Facts: which measures sit at each grain? Additive, semi-additive or non-additive? |
| 20–30 | Dimensions and their attributes. Which change over time, and which SCD type for each? |
| 30–45 | ERD sketch (star per process) and a **bus matrix** (processes × conformed dimensions) |
| 45–60 | Write the SQL (on paper) for three business questions against your model |
| +30 | Review against the gotchas and one outside reference |

✅ **Checkpoint for the first domain:** grain statements written within
10 minutes, as in M3's ready-when.

### 2. Domain prompts

Use these as starting points. Write the three business questions
**before** modelling, so the model has to answer them.

<details>
<summary>Fantasy basketball</summary>

Users join leagues, draft real players, set weekly lineups, make trades,
score points from real games. Questions: weekly standings; which trades
improved the receiving team; players most often benched before a big
game. Watch for: a player's fantasy team changes over the season (which
SCD type?), and lineups are a snapshot each week.

</details>

<details>
<summary>Ticketing</summary>

Events at venues; tickets sold through primary and resale channels;
prices change; seats are scanned at entry. Questions: sell-through by
event a week before; resale markup by section; no-show rate. Watch for:
a seat's journey across several sales (accumulating snapshot?).

</details>

<details>
<summary>E-commerce</summary>

Products, carts, orders, shipments, returns, promotions. Questions:
revenue net of returns by category; promotion lift; cart abandonment.
Watch for: order header vs order line grain; returns as their own process.

</details>

<details>
<summary>Healthcare claims</summary>

Members, providers, claims with many lines, adjustments and resubmissions,
diagnoses and procedures. Questions: cost per member per month; denial
rate by provider; claims adjusted more than once. Watch for: many-to-many
diagnoses per claim (bridge table), adjustments as new versions. Use
invented data only.

</details>

<details>
<summary>Ad clicks</summary>

Campaigns, ad groups, creatives, impressions, clicks, conversions, spend.
Questions: click-through rate by creative; cost per conversion;
conversions attributed within 7 days of a click. Watch for: very high
volume impressions (aggregate fact?), attribution windows (late-arriving
facts).

</details>

<details>
<summary>Logistics</summary>

Shipments, packages, scans at hubs, routes, carriers, delivery attempts.
Questions: on-time rate by carrier; average dwell time at each hub;
packages with more than two delivery attempts. Watch for: an
accumulating snapshot per package vs a transaction fact per scan.

</details>

Beyond six, invent your own (a gym chain, a streaming service, a bank's
card transactions) or use domains from target companies' industries.

### 3. Check yourself against a reference

After each domain, compare with one outside source. The
[Kimball Group's dimensional modelling techniques](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/)
pages name the patterns (accumulating snapshot, bridge table,
factless fact, junk dimension). Note which pattern you used or missed.

### 4. Log it

```markdown
## Domain N · YYYY-MM-DD · <domain>
- Time to grain statements: __ min
- Processes / facts / dims:
- Patterns used: (e.g. accumulating snapshot, bridge, SCD2)
- Question my model couldn't answer, and the fix:
```

## Gotchas

- **One giant table.** If the grain sentence needs "and", it's two facts.
- **Modelling the source system.** Model the business processes and
  questions, not the app's tables.
- **Skipping the SQL step.** Writing the queries is how you find out the
  model can't answer a question.

## Done when

- [ ] 6+ domains modelled, each with grain statements, bus matrix, ERD and three queries
- [ ] Each compared against a reference, patterns noted
- [ ] Grain-to-dimensions done in about 10 minutes by the last domain
- [ ] Close the issue with the domain count

## Check yourself

1. When do you use an accumulating snapshot instead of a transaction fact?
2. Name a bridge table from your domains and why it was needed.
