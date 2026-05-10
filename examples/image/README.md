# `image` — json-to-image

> One sentence in → one finished product shot out. The simplest possible showcase of Claude Code orchestrating `Runway.Cli` via the agent skill.

## 1. The prompt

What we hand to Claude — verbatim, the way a user would type it ([`prompt.md`](./prompt.md)):

> Generate a single hero image: a minimalist coffee grinder on a brushed-steel kitchen counter, soft morning light, premium product-ad aesthetic. Save the PNG and emit a result.json with the title, description, prompt used, model, and image_path.

## 2. Inputs

- `RUNWAY_API_KEY` (loaded from `.env`)
- The [`runway-cli`](https://github.com/tryAGI/Runway#use-as-an-agent-skill) skill installed at `.claude/skills/runway-cli/` (done by `./scripts/setup.sh`)
- **No pre-existing assets** — the example runs from zero.

## 3. What Claude did

Guided only by the skill, Claude:

1. Picked the right Runway CLI verb: `runway image` (text-to-image).
2. Expanded the user's one-sentence brief into a richer Runway prompt (depth of field, lighting, material adjectives).
3. Chose `gemini-2.5-flash` as the model (the skill's default for quick images).
4. Saved the PNG to the per-run `assets/` directory and emitted `result.json`.

A single Runway API call, ~30 seconds.

## 4. Output

The generated image — a real artifact from a real run:

![Minimalist coffee grinder on brushed steel](./sample-output/assets/coffee-grinder.png)

And the `result.json` Claude wrote ([full file](./sample-output/result.json)):

```json
{
  "title": "Minimalist Coffee Grinder Hero Image",
  "description": "A premium product-ad hero shot of a minimalist coffee grinder ...",
  "prompt": "Minimalist coffee grinder on a brushed-steel kitchen counter, soft diffused morning light from a nearby window, shallow depth of field, matte black grinder body with polished chrome accents, clean negative space, premium product advertisement aesthetic, editorial photography style",
  "model": "gemini-2.5-flash",
  "image_path": "assets/coffee-grinder.png"
}
```

## 5. Run it

```bash
./examples/image/run.sh
```

Per-run output lands under `output/image/<ISO-timestamp>/`:

```
output/image/<timestamp>/
├── result.json
├── transcript.json   # raw claude -p envelope
├── meta.json         # claude/runway versions, cost, session id
└── assets/
    └── runway-image-<timestamp>-<hash>.png
```

## 6. Cost & runtime

| Metric         | Value (observed)              |
|----------------|-------------------------------|
| Wall time      | **~49 s**                     |
| Claude cost    | **$0.14** (Sonnet 4.6)        |
| Runway calls   | 1 (`runway image`)            |
| Budget ceiling | `CLAUDE_MAX_BUDGET_USD=2`     |

Override the budget per run: `CLAUDE_MAX_BUDGET_USD=1 ./examples/image/run.sh`.
