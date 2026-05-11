# `storyboard` — one-line idea → expanded storyboard PNG

> The simplest named workflow in the catalogue: text-only input, single PNG output, multiple panels laid out for at-a-glance visual planning. Useful for pitching a scene before committing to full shot rendering.

## 1. The prompt

What we hand to Claude — verbatim, the way a user would type it ([`prompt.md`](./prompt.md)):

> Use the runway `storyboard-creator` workflow to turn a one-line idea — "a quiet detective scene in a rainy alley" — into a single expanded storyboard PNG with multiple panels laid out on one page. Save the storyboard image and emit a result.json describing the idea, the model, and the output path.

## 2. Inputs

- `RUNWAY_API_KEY` (loaded from `.env`)
- The [`runway-cli`](https://github.com/tryAGI/Runway#use-as-an-agent-skill) skill installed at `.claude/skills/runway-cli/`
- **No pre-existing assets** — text only.

## 3. What Claude did

Guided only by the skill, Claude:

1. **Invoked `runway storyboard-creator --prompt "..."`** — that's it.
2. **Wrote `result.json`** describing the idea and output.

A single Runway call.

## 4. Output

![Storyboard](./sample-output/assets/storyboard.png)

See [`sample-output/result.json`](./sample-output/result.json) for the full file.

## 5. Run it

```bash
./examples/storyboard/run.sh
```

## 6. Cost & runtime

| Metric           | Value (observed)                                |
|------------------|-------------------------------------------------|
| Wall time        | **~1 min**                                      |
| Claude cost      | **$0.16** (Sonnet 4.6)                          |
| Runway credits   | **21**                                          |
| Runway calls     | 1 × `storyboard-creator` (on `gemini-3-pro-image-preview`) |
| Budget ceiling   | `CLAUDE_MAX_BUDGET_USD=2`                       |
