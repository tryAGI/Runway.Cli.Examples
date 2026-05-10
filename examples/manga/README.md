# `manga` — json-to-manga

A minimal user-style prompt produces a 4-page manga: a JSON description of the pages plus generated panel images, all from zero.

## What runs

[`./run.sh`](./run.sh) hands the prompt in [`prompt.md`](./prompt.md) to `claude -p` running headless. Claude — equipped with the [`runway-cli`](https://github.com/tryAGI/Runway#use-as-an-agent-skill) skill — drives `dnx Runway.Cli` to:

1. Establish each character with the local `runway soul-id` registry (so faces/styles stay consistent across panels).
2. Generate panel images via `runway image` referencing the character Soul-IDs.
3. Assemble a single `result.json` describing the title, characters, pages, and panels.

## The prompt

The exact prompt (committed in [`prompt.md`](./prompt.md)):

> Make a 4-page manga about a samurai cat befriending a rival ninja mouse. Establish each character with a Soul-ID first so they stay consistent across panels, then generate the panel images and assemble a single result.json describing the title, characters (with soul_id refs), pages, and panels (image path, dialogue, caption).

That's it. The skill teaches Claude *how*; the prompt only states *what*.

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

- **Soul-ID drift.** The Soul-ID registry is local. A second run will create new IDs for new characters; reuse across runs is not automatic.
- **Cost.** A typical run is on the order of a few cents in Claude tokens plus the underlying Runway image-generation calls. Check `meta.json` for the exact figure.
- **Reproducibility.** Image generation is non-deterministic. `meta.json` records the `claude` and `Runway.Cli` versions plus the Anthropic session id for forensic replay.
