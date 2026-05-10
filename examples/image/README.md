# `image` — json-to-image

The cheapest example. A minimal user-style prompt produces one Runway-generated PNG and a `result.json` describing it.

## What runs

[`./run.sh`](./run.sh) hands the prompt in [`prompt.md`](./prompt.md) to `claude -p` running headless. Claude — equipped with the [`runway-cli`](https://github.com/tryAGI/Runway#use-as-an-agent-skill) skill — drives `dnx Runway.Cli image` once, then writes `result.json` referencing the saved PNG.

## The prompt

The exact prompt (committed in [`prompt.md`](./prompt.md)):

> Generate a single hero image: a minimalist coffee grinder on a brushed-steel kitchen counter, soft morning light, premium product-ad aesthetic. Save the PNG and emit a result.json with the title, description, prompt used, model, and image_path.

## Run it

```bash
./examples/image/run.sh
```

Output (per run):

```
output/image/<timestamp>/
├── result.json
├── transcript.json
├── meta.json
└── assets/
    └── runway-image-<timestamp>-<hash>.png
```

## Expected runtime & cost

Typical: **30–60 seconds**, dominated by the single Runway text-to-image call. Budget ceiling defaults to `$2` (`CLAUDE_MAX_BUDGET_USD=2`); override before invoking if you want a different cap.

## Suggested `result.json` shape

The prompt does not pin the schema. Expect something like:

```jsonc
{
  "title": "Minimalist Coffee Grinder Product Shot",
  "description": "A minimalist coffee grinder on brushed steel ...",
  "prompt": "minimalist coffee grinder on a brushed-steel kitchen counter ...",
  "model": "gemini-2.5-flash",
  "image_path": "assets/runway-image-...png",
  "ratio": "1024:1024"
}
```
