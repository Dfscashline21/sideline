# PF.5 · Demo video (3–5 minutes)

> **Ticket:** [#174](https://github.com/Dfscashline21/sideline/issues/174) ·
> **Mode:** hand · **Time:** 4 to 6 hours ·
> **Needs:** PF.1 draft, PF.2 diagram, the live dashboard (M11.5); your
> M8.9 streaming demo video

## Why this matters

Many reviewers will never clone the repo. A short video is how a busy
hiring manager sees the system **running**. It's a walkthrough for busy
reviewers (the ticket's words), so every second must earn its place.

## What you'll produce

A 3 to 5 minute video, hosted publicly (e.g. YouTube unlisted or Loom),
**linked at the top of the README**.

## Steps

### 1. Write the script (60 min)

Script it. Unscripted demos ramble. A structure that fits 4 minutes:

| Time | Section | Show on screen |
|---|---|---|
| 0:00–0:20 | The pitch: what and why | README top / dashboard |
| 0:20–1:00 | Architecture in one pass | PF.2 diagram, pointer moving along the flow |
| 1:00–2:00 | The product: dashboard and API | Live dashboard, one API call |
| 2:00–2:45 | Live streaming moment | Replayed game updating (reuse M8.9 footage) |
| 2:45–3:30 | Depth: one hard problem and how you solved it | e.g. backfill, late events, a quality incident (M9 postmortem) |
| 3:30–4:00 | Numbers and where to read more | README numbers table, blog links |

Read the script aloud with a timer. Over 5 minutes? Cut whole sections,
not words.

<details>
<summary>Hint · Choosing the "depth" moment</summary>

Pick the problem you'd most like to be asked about in an interview. The
video is an invitation: "ask me about the time late events double-counted
three-pointers" is a better interview opener than a feature tour. Show
evidence (a before/after chart, the Dagster backfill screen), not code
scrolling.

</details>

### 2. Prepare the environment (45 min)

- Fresh data: run the pipeline so the dashboard shows recent games.
- Close notifications, use a clean browser profile, hide bookmarks, set
  zoom so text is readable at 720p.
- No secrets on screen: no `.env`, terminal history with tokens, cloud
  console account IDs. Check every frame you plan to show.
- Have each screen open in its own tab in script order.

### 3. Record (60 min)

Record screen and voice ([OBS](https://obsproject.com) or your OS's
recorder). Record section by section so a fluff doesn't mean starting
over. A cheap headset mic sounds far better than a laptop mic.

### 4. Edit and check (60 min)

Trim pauses, join sections. Then watch it as a stranger would:

- Muted: do on-screen visuals still make sense? Add captions if your
  host supports auto-captioning, and fix their errors.
- At 1.5x: still followable?
- Is the length 3:00 to 5:00?

✅ **Checkpoint:** someone who hasn't seen the project watches it and can
tell you, afterwards, what it does and one technical challenge you solved.
(Ask the PF.8 reviewer, or anyone.)

### 5. Publish and link (15 min)

Upload, set visibility so anyone with the link can view, and put it at
the very top of the README, right under the pitch:

```markdown
▶ **[Watch the 4-minute demo](<video-url>)** · [Live dashboard](<url>)
```

Check the link in a logged-out private window.

## Gotchas

- **Leaked secrets in frames.** Re-watch specifically for this before
  publishing. Rotate anything that slipped through.
- **Showing a dashboard that's empty** because the season is over or the
  pipeline is paused. Replay a game, or pick dates with data.
- **Too much code.** Viewers who want code will open the repo.

## Done when

- [ ] 3 to 5 minutes, scripted, edited, captioned if possible
- [ ] Shows the running system, including one live/streaming moment and one depth story
- [ ] No secrets or private data on screen
- [ ] Linked at the top of the README, works logged out
- [ ] PR (README link) merged with `Closes #174`

## Check yourself

1. Which 20 seconds would you keep if the video had to be 1 minute?
2. What question do you hope a viewer asks you afterwards?
