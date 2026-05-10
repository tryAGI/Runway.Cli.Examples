# `manga` — json-to-manga

A minimal user-style prompt produces a 4-page manga: a JSON description of the pages plus generated panel images, all from zero.

## What runs

[`./run.sh`](./run.sh) hands the prompt in [`prompt.md`](./prompt.md) to `claude -p` running headless. Claude — equipped with the [`runway-cli`](https://github.com/tryAGI/Runway#use-as-an-agent-skill) skill — drives `dnx Runway.Cli` to:

1. Generate a single character reference image (text-to-image).
2. Write a storyboard JSON describing the pages and panels.
3. Run the built-in `runway json-to-manga` workflow with the character + storyboard as inputs (renders all panels in one workflow call rather than per-panel).
4. Assemble a single `result.json` describing the title, character, pages, and panels.

## The prompt

The exact prompt (committed in [`prompt.md`](./prompt.md)):

> Make a short 3-page manga about a samurai cat befriending a rival ninja mouse. Use the `json-to-manga` workflow from the runway-cli skill so the panels render in a single workflow call rather than one image at a time. Generate one character reference image to feed the workflow, then write the storyboard JSON, run the workflow, and emit a single result.json describing the title, character, pages, and panels (image path, dialogue, caption).

That's it. The skill teaches Claude *how*; the prompt only states *what*.

## Expected runtime & cost

Typical: **3–6 minutes**, dominated by the Runway workflow invocation. A run with no workflow guidance (raw text-to-image per panel) can balloon past 15 minutes and 20+ image-gen calls — see [`sample-output/`](./sample-output/) for an earlier "naive" run that produced 22 PNGs across 12 panels.

Cost is captured per run in `output/manga/<ts>/meta.json`. Budget ceiling defaults to `$5` (`CLAUDE_MAX_BUDGET_USD=5`); override before invoking if you want a different cap.

## Run it

```bash
./examples/manga/run.sh
```

Output (per run):

```
output/manga/<timestamp>/
├── result.json
├── transcript.json
├── meta.json
└── assets/
    ├── char-<name>.png        # character reference images
    └── p<n>-panel<m>.png      # one PNG per panel
```

## Suggested `result.json` shape

The prompt does not pin the schema — Claude shapes it sensibly. Expect something like:

```jsonc
{
  "title": "The Last Bushido",
  "synopsis": "A wandering samurai cat encounters a ninja mouse rival ...",
  "characters": [
    {
      "name": "Kenji",
      "role": "samurai cat",
      "soul_id": "soul_abc123",
      "ref_image": "assets/char-kenji.png",
      "description": "..."
    }
  ],
  "pages": [
    {
      "page_number": 1,
      "panels": [
        {
          "panel_number": 1,
          "image": "assets/p1-panel1.png",
          "characters": ["Kenji"],
          "dialogue": [{ "speaker": "Kenji", "text": "..." }],
          "caption": "..."
        }
      ]
    }
  ]
}
```

## Notes

- **Workflow-first.** The prompt explicitly asks Claude to use the built-in `runway json-to-manga` workflow rather than rendering each panel via a separate `runway image` call. This keeps the run under ~6 minutes; without the nudge Claude tends to generate ~20 images individually.
- **Sample output.** [`sample-output/result.json`](./sample-output/result.json) is a real result from an earlier run (4 pages × 3 panels, ~22 images, ~17 min). Yours will differ — character names, dialogue, and panel composition are non-deterministic.
- **Cost.** Captured in `meta.json` per run. A workflow-based run is typically a few cents in Claude tokens plus the underlying Runway workflow charge.
- **Reproducibility.** Generation is non-deterministic. `meta.json` records the `claude` and `Runway.Cli` versions plus the Anthropic session id for forensic replay.
