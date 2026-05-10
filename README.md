# Runway.Cli.Examples

**A visual showcase of [`Runway.Cli`](https://github.com/tryAGI/Runway) + the [`runway-cli`](https://github.com/tryAGI/Runway#use-as-an-agent-skill) agent skill + [Claude Code](https://claude.com/claude-code) as the orchestrator.**

Each example is a tiny bash wrapper that hands a **minimal user-style prompt** to `claude -p` running headless. Claude — guided by the installed `runway-cli` skill — picks the right Runway CLI commands, generates intermediate assets when needed, and writes a final `result.json` describing what it made.

**No pre-existing assets are required.** Every example runs from zero.

---

## Showcase

<table>
  <thead>
    <tr>
      <th>Preview</th>
      <th>Example</th>
      <th>Prompt</th>
      <th>Output</th>
      <th>Time</th>
      <th>Runway credits</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><a href="./examples/image/"><img src="./examples/image/sample-output/assets/coffee-grinder.png" width="220" alt="Minimalist coffee grinder"></a></td>
      <td><a href="./examples/image/"><code>image</code></a></td>
      <td><em>"a minimalist coffee grinder on brushed steel, soft morning light"</em></td>
      <td>1 PNG + <code>result.json</code></td>
      <td><strong>~49 s</strong></td>
      <td><strong>7</strong><br/>(1 × <code>runway image</code>)</td>
    </tr>
    <tr>
      <td><a href="./examples/haircut/"><img src="./examples/haircut/sample-output/assets/02-after-bob-blonde.png" width="220" alt="Restyled portrait: bob with blonde highlights against sunset"></a></td>
      <td><a href="./examples/haircut/"><code>haircut</code></a></td>
      <td><em>"give someone a virtual haircut: generate a portrait, then restyle with ai-hair-salon"</em></td>
      <td>1 portrait + 4 restyled variations + <code>result.json</code></td>
      <td><strong>~3 min</strong></td>
      <td><strong>95</strong><br/>(image + <code>ai-hair-salon</code> workflow)</td>
    </tr>
    <tr>
      <td><a href="./examples/virtual-try-on/"><img src="./examples/virtual-try-on/sample-output/assets/03-tryon-1.png" width="220" alt="Same person now wearing a black leather jacket on a misty harbor"></a></td>
      <td><a href="./examples/virtual-try-on/"><code>virtual-try-on</code></a></td>
      <td><em>"generate a person and a leather jacket, then put the jacket on them on a foggy harbor at dawn"</em></td>
      <td>1 person + 1 garment + 4 try-on variations + <code>result.json</code></td>
      <td><strong>~3 min</strong></td>
      <td><strong>91</strong><br/>(2 × <code>runway image</code> + <code>virtual-try-on</code>)</td>
    </tr>
    <tr>
      <td><a href="./examples/manga/"><img src="./examples/manga/sample-output/assets/03-p1-encounter.png" width="220" alt="Samurai cat vs ninja mouse, page 1 encounter"></a></td>
      <td><a href="./examples/manga/"><code>manga</code></a></td>
      <td><em>"a 3-page manga about a samurai cat befriending a rival ninja mouse"</em></td>
      <td>6 PNGs + <code>result.json</code><br/>(2 char refs + 4 panels)</td>
      <td><strong>~17 min</strong><br/>(3–6 min with workflow)</td>
      <td><strong>~150</strong><br/>(22 × <code>runway image</code>, pre-tracking)</td>
    </tr>
    <tr>
      <td><a href="./examples/short-video/"><img src="./examples/short-video/sample-output/assets/shot-still.png" width="220" alt="Aerial sunrise still: motorcycle on misty mountain pass"></a></td>
      <td><a href="./examples/short-video/"><code>short-video</code></a></td>
      <td><em>"a short cinematic video of a vintage motorcycle through a foggy mountain pass at sunrise"</em></td>
      <td>3-shot stitched MP4 (18 s) + plan.json + <code>result.json</code></td>
      <td><strong>~6 min</strong></td>
      <td><strong>200</strong><br/>(3 × <code>gemini-image3-pro</code> keyframes + 3 × <code>veo3.1-fast</code> shots)</td>
    </tr>
    <tr>
      <td><a href="./examples/wine-label/"><img src="./examples/wine-label/sample-output/assets/04-composited-bottle.png" width="220" alt="Stellar Vines composited bottle hero shot"></a></td>
      <td><a href="./examples/wine-label/"><code>wine-label</code></a></td>
      <td><em>"design a fictional vineyard 'Stellar Vines' — generate bottle + two labels + hero MP4"</em></td>
      <td>3 source PNGs + composited preview + hero MP4 + <code>result.json</code></td>
      <td><strong>~7 min</strong></td>
      <td><strong>1241</strong><br/>(3 × <code>runway image</code> + <code>wine-label-generator</code> with 3 video variations)</td>
    </tr>
  </tbody>
</table>

Each example's own README has the same layout repeated in detail: **Prompt → Inputs → What Claude did → Output → Run it → Cost & runtime**.

> **Cost transparency.** The `Runway credits` column is the **measured delta** of `runway organization get | jq .creditBalance` before and after each run — captured by [`scripts/_runner.sh`](./scripts/_runner.sh) into `meta.json` as `runway_credits.{before,after,used}`. Claude token spend is captured separately in each run's `meta.json` (`claude_cost_usd`) and noted in the per-example README, but kept out of this table to keep it scannable. The `manga` row's credits are approximate (run pre-dates credit tracking).

---

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

This drops the skill at `.claude/skills/runway-cli/SKILL.md` (provided by the [skills.sh](https://skills.sh) ecosystem). Headless `claude -p` invocations in this repo pick it up automatically. The skill file itself is **not committed** — it is re-installed by `setup.sh` on a fresh clone. The auto-generated [`skills-lock.json`](./skills-lock.json) records the exact source + hash for reproducibility.

## Run an example

```bash
./examples/image/run.sh           # ~49 s,  $0.15 Claude,    7 Runway credits
./examples/haircut/run.sh         # ~3 min, $0.31 Claude,   95 Runway credits
./examples/virtual-try-on/run.sh  # ~3 min, $0.66 Claude,   91 Runway credits
./examples/short-video/run.sh     # ~6 min, $0.61 Claude,  200 Runway credits
./examples/manga/run.sh           # ~3–6 min with the workflow nudge
./examples/wine-label/run.sh      # ~7 min, $0.65 Claude, 1241 Runway credits (video!)
```

Output lands in `output/<example>/<ISO-timestamp>/`:

```
output/<example>/<timestamp>/
├── result.json     # the final JSON Claude produced
├── transcript.json # the raw `claude -p --output-format json` envelope
├── meta.json       # claude version, runway version, cost, session id
└── assets/         # generated PNGs (and MP4s for video examples)
```

Each example also commits a `sample-output/` directory containing real artifacts from a real run, so the README previews are honest evidence rather than mockups.

## Examples index

| Workflow                       | Status     | Path                              |
|--------------------------------|------------|-----------------------------------|
| image (json-to-image)          | shipped    | [`examples/image/`](./examples/image/) |
| haircut (ai-hair-salon)        | shipped    | [`examples/haircut/`](./examples/haircut/) |
| virtual-try-on                 | shipped    | [`examples/virtual-try-on/`](./examples/virtual-try-on/) |
| manga (json-to-manga)          | shipped    | [`examples/manga/`](./examples/manga/) |
| short-video                    | shipped    | [`examples/short-video/`](./examples/short-video/) |
| wine-label (wine-label-generator) | shipped | [`examples/wine-label/`](./examples/wine-label/) |
| video                          | planned    | `examples/video/`                 |
| image-to-video                 | planned    | `examples/image-to-video/`        |
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

The goal is **one example per Runway CLI workflow** — each with the same showcase layout so you can scan the whole repo and see Runway's surface area at a glance.

## Reproducibility

Runs are non-deterministic. Each run captures a `meta.json` with:

- `claude` CLI version
- `runway` (Runway.Cli) version
- total cost in USD
- Anthropic session id (for replay/debugging)

## Contributing a new example

Every example follows the same six-section README so the repo reads as a uniform showcase:

1. **The prompt** — one or two sentences in user voice, telling Claude *what*, not *how*
2. **Inputs** — env vars, no pre-existing assets
3. **What Claude did** — the workflow Claude orchestrated
4. **Output** — embedded PNGs/MP4s + a `result.json` snippet (real artifacts in `sample-output/`)
5. **Run it** — the exact command
6. **Cost & runtime** — observed numbers from a real run

To add one:

1. `cp -r examples/image examples/<workflow-name>/`
2. Rewrite `prompt.md` for the new workflow
3. Run `./examples/<workflow-name>/run.sh` once and commit a curated subset of the output into `sample-output/`
4. Update the README following the six-section structure
5. Add a row to the **Examples index** table above

The skill teaches Claude how to drive Runway. Your example just needs to ask, in plain language, and capture the result.

## Related

- [tryAGI/Runway](https://github.com/tryAGI/Runway) — the SDK, CLI, and skill
- [skills.sh](https://skills.sh) — agent-skill ecosystem this repo consumes
- [Claude Code](https://claude.com/claude-code) — the agent runtime
