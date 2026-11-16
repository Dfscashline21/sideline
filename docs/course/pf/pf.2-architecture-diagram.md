# PF.2 · Final architecture diagram

> **Ticket:** [#171](https://github.com/Dfscashline21/sideline/issues/171) ·
> **Mode:** hand · **Time:** 2 to 3 hours ·
> **Needs:** M10 deployed (or your final local stack); M10.11 security diagram

## Why this matters

The diagram is what people remember. In interviews you'll redraw it on a
whiteboard, and it must match what's actually running, or a single
follow-up question ("so where does the catalog run?") will expose the gap.

The ticket's one criterion: **matches the deployed system.** Not the plan
from week 1, not what you meant to build: what's there.

## What you'll produce

- One primary architecture diagram (sources → serving), source file plus
  exported image, committed under `docs/architecture/`.
- Optionally a second, zoomed-in diagram (e.g. the streaming path),
  if the first gets crowded.

## Steps

### 1. Inventory what's actually deployed (45 min)

Don't draw from memory. List components from the source of truth:

```bash
cat compose.yaml | grep -E '^  [a-z-]+:$'          # local services
ls infra/terraform/modules infra/terraform/envs   # cloud resources by module
terraform -chdir=infra/terraform/envs/prod state list   # what actually exists (if still deployed)
```

Adapt the paths to your layout. Also list: data sources (nba_api, ESPN
files, the game replay producer), scheduled jobs (Dagster assets),
consumers (dashboard, API, model, retrieval endpoint).

✅ **Checkpoint:** a flat list where every item names the file or
resource that proves it exists. Anything in your old diagram that isn't
on the list gets removed or marked "planned".

### 2. Choose the level and layout (20 min)

Use C4's [container level](https://c4model.com): one box per deployable
or storage thing, arrows for data flow, labels saying what flows
(e.g. "raw JSON", "Iceberg tables", "Avro events").

Lay it out left to right as data flows:
**sources → ingestion → raw zone → lakehouse → transform → serving →
consumers**, with orchestration and quality as layers above or below
that touch everything.

<details>
<summary>Hint · Keeping it readable</summary>

- At most ~15 boxes. Group related ones (e.g. one "dbt project" box, not
  one per model).
- Batch and streaming paths as two horizontal lanes that meet at the
  lakehouse.
- Use colour for one meaning only (e.g. local vs cloud, or batch vs
  stream), with a legend.
- Mark where security boundaries are (from M10.11), but don't redraw the
  whole security diagram.

</details>

### 3. Draw it (60 min)

Tools: [Excalidraw](https://excalidraw.com), [draw.io](https://www.drawio.com),
or [Mermaid](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-diagrams)
(renders on GitHub and lives in the diff, but is harder to lay out
nicely).

Commit the **editable source** (`.excalidraw`, `.drawio`, or the Mermaid
text) alongside the exported `.svg` or `.png`. Future you will need to
edit it.

### 4. Check it against reality (30 min)

Trace three real data paths through the diagram and confirm each arrow
exists in code or config:

1. One NBA game: API → raw → Iceberg → dbt mart → dashboard
2. One live event in a replayed game: producer → topic → stream job → sink
3. One API request: client → API → which table?

✅ **Checkpoint:** every arrow on the three paths points to a file, asset
or resource you can name. Fix the diagram (or the code) where they
disagree.

### 5. Practise redrawing it (15 min)

Close the file. Redraw it on paper in under 5 minutes, talking through
it. That's the interview version.

## Gotchas

- **Logos instead of roles.** A box that only shows a logo tells a reader
  the tool, not the job. Label boxes with the role ("Orchestrator:
  Dagster on ECS").
- **Week-1 leftovers.** Components you planned and dropped. Remove them
  or mark them clearly as not built.
- **Unreadable exports.** Check the image on GitHub at normal zoom, in
  both light and dark mode (transparent backgrounds can vanish in dark
  mode).

## Done when

- [ ] Diagram matches the deployed system, checked by tracing three paths
- [ ] Editable source and exported image committed
- [ ] Readable on GitHub in light and dark mode
- [ ] You can redraw it from memory in 5 minutes
- [ ] PR merged with `Closes #171`

## Check yourself

1. What's the one arrow you're least sure about, and how did you check it?
2. Where are the security boundaries on the diagram?
3. Which box would you split first at 100x?
