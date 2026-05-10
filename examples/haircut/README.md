# `haircut` — generate a portrait, then restyle the hair

> Showcases the **`ai-hair-salon`** named workflow: change one attribute (hair) of a photo while keeping the subject recognizable. Run from zero — the input portrait is generated on the fly.

## 1. The prompt

What we hand to Claude — verbatim, the way a user would type it ([`prompt.md`](./prompt.md)):

> Give someone a virtual haircut: first generate a portrait of a person with long dark hair, then use the runway `ai-hair-salon` workflow to restyle their hair as a shoulder-length wavy bob with subtle blonde highlights against a soft sunset gradient backdrop. Save both the original portrait and the restyled output, then emit a single result.json describing the before/after image paths, the portrait prompt, the hairstyle change, and the workflow used.

## 2. Inputs

- `RUNWAY_API_KEY` (loaded from `.env`)
- The [`runway-cli`](https://github.com/tryAGI/Runway#use-as-an-agent-skill) skill installed at `.claude/skills/runway-cli/` (done by `./scripts/setup.sh`)
- **No pre-existing assets** — Claude generates the input portrait first.

## 3. What Claude did

Guided only by the skill, Claude:

1. **Generated a portrait** via `runway image` (text-to-image) — a person with long dark hair.
2. **Ran the `ai-hair-salon` workflow** on that portrait, passing `--hairstyle "shoulder-length wavy bob with subtle blonde highlights"` and `--background "soft sunset gradient backdrop"`.
3. **Wrote `result.json`** linking the original portrait to the restyled output.

Two Runway calls total: one `runway image` + one `ai-hair-salon` workflow.

## 4. Output

### Before / After

|  Before (generated portrait)                                  |  After (`ai-hair-salon` restyle)                              |
|---------------------------------------------------------------|----------------------------------------------------------------|
| ![Portrait before](./sample-output/assets/01-before.png) | ![Portrait after](./sample-output/assets/02-after.png) |

### The `result.json` Claude wrote

See [`sample-output/result.json`](./sample-output/result.json) for the full file.

## 5. Run it

```bash
./examples/haircut/run.sh
```

Per-run output lands under `output/haircut/<ISO-timestamp>/` (same shape as the other examples).

## 6. Cost & runtime

| Metric           | Value (observed)             |
|------------------|------------------------------|
| Wall time        | _filled in after first run_  |
| Claude cost      | _filled in after first run_  |
| Runway credits   | _filled in after first run_  |
| Runway calls     | 1 image + 1 `ai-hair-salon`  |
| Budget ceiling   | `CLAUDE_MAX_BUDGET_USD=3`    |
