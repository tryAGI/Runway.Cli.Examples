# Runway.Cli.Examples

Agent-driven recipes for [`Runway.Cli`](https://github.com/tryAGI/Runway).

Each example is a tiny bash wrapper that hands a **minimal user-style prompt** to `claude -p` running headless. Claude — guided by the installed [`runway-cli` agent skill](https://github.com/tryAGI/Runway#use-as-an-agent-skill) — picks the right Runway CLI commands, generates intermediate assets when needed, and writes a final `result.json` describing what it made.

**No pre-existing assets are required.** Every example runs from zero.

## Setup

Prereqs: [Claude Code](https://claude.com/claude-code), [.NET 10+](https://dot.net), [Node.js](https://nodejs.org/) (for `npx`), `jq`, a Runway API key.

```bash
git clone https://github.com/tryAGI/Runway.Cli.Examples.git
cd Runway.Cli.Examples
cp .env.example .env
# Edit .env and set RUNWAY_API_KEY
./scripts/setup.sh
```

## How the skill is installed

`scripts/setup.sh` runs the install command documented in the upstream Runway repo ([Runway/README.md#use-as-an-agent-skill](https://github.com/tryAGI/Runway#use-as-an-agent-skill)):

```bash
npx skills add tryAGI/Runway -a claude-code -y
```

This drops the skill at `.agents/skills/runway-cli/SKILL.md` (provided by the [skills.sh](https://skills.sh) ecosystem). Headless `claude -p` invocations in this repo pick it up automatically. The skill file itself is **not committed** — it is re-installed by `setup.sh` on a fresh clone.

## Run an example

```bash
./examples/manga/run.sh
```

Output lands in `output/<example>/<ISO-timestamp>/`:

```
output/manga/2026-05-10T14-22-03Z/
├── result.json     # the final JSON Claude produced
├── transcript.json # the raw `claude -p --output-format json` envelope
├── meta.json       # claude version, runway version, cost, session id
└── assets/         # generated PNGs (and MP4s for video examples)
```

Cost expectations: a single `manga` run typically costs a few cents in Anthropic tokens plus the underlying Runway generation calls. Check `meta.json` after each run for the exact figure.

## Examples index

| Workflow                       | Status     | Path                              |
|--------------------------------|------------|-----------------------------------|
| manga (json-to-manga)          | shipped    | `examples/manga/`                 |
| image                          | planned    | `examples/image/`                 |
| video                          | planned    | `examples/video/`                 |
| image-to-video                 | planned    | `examples/image-to-video/`        |
| short-video                    | planned    | `examples/short-video/`           |
| product-photoshoot             | planned    | `examples/product-photoshoot/`    |
| marketplace-cards              | planned    | `examples/marketplace-cards/`     |
| ad-video                       | planned    | `examples/ad-video/`              |
| avatar                         | planned    | `examples/avatar/`                |
| soul-id                        | planned    | `examples/soul-id/`               |
| photo-restyle                  | planned    | `examples/photo-restyle/`         |
| scene-composition              | planned    | `examples/scene-composition/`     |
| story-sequence                 | planned    | `examples/story-sequence/`        |
| character-item                 | planned    | `examples/character-item/`        |
| video-sandbox                  | planned    | `examples/video-sandbox/`         |
| (more named workflows)         | planned    | —                                 |

The goal is **one example per Runway CLI workflow**.

## Reproducibility

Runs are non-deterministic. Each run captures a `meta.json` with:

- `claude` CLI version
- `dnx Runway.Cli` version
- total cost in USD
- Anthropic session id (for replay/debugging)

Soul-IDs (used for character consistency across panels) are stored in a local registry and may differ across runs. See the per-example READMEs for notes.

## Contributing a new example

1. `mkdir examples/<workflow-name>/`
2. Add `run.sh` (copy `examples/manga/run.sh` and tweak `NAME`)
3. Add `prompt.md` — one or two sentences in user voice, telling Claude *what*, not *how*
4. Add `README.md` — what the example produces, sample output snippet, which Runway features it exercises
5. Update the **Examples index** table above

The skill teaches Claude how to drive Runway. Your example just needs to ask, in plain language.

## Related

- [tryAGI/Runway](https://github.com/tryAGI/Runway) — the SDK, CLI, and skill
- [skills.sh](https://skills.sh) — agent-skill ecosystem this repo consumes
- [Claude Code](https://claude.com/claude-code) — the agent runtime
