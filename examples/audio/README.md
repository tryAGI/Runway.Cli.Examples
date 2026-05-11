# `audio` — text-to-speech + sound-effect

> Showcases Runway's audio side: a spoken voice-over (`runway text-to-speech`) paired with a matching short SFX clip (`runway sound-effect`). The only example in this repo that doesn't produce a visual asset.

## 1. The prompt

What we hand to Claude — verbatim, the way a user would type it ([`prompt.md`](./prompt.md)):

> Make a tiny audio scene that pairs voice and sound design. Use the runway `text-to-speech` command to read the line "Welcome to the launch — the future of editing starts here." in a warm female voice (pick a sensible preset). Then use `sound-effect` to generate a short cinematic camera-shutter-plus-soft-whoosh sound that could play under the VO. Save both audio files and emit a single result.json describing the voice preset, the spoken line, the SFX prompt, and the file paths.

## 2. Inputs

- `RUNWAY_API_KEY` (loaded from `.env`)
- The [`runway-cli`](https://github.com/tryAGI/Runway#use-as-an-agent-skill) skill installed at `.claude/skills/runway-cli/` (done by `./scripts/setup.sh`)
- **No pre-existing assets.**

## 3. What Claude did

Guided only by the skill, Claude:

1. **Picked a voice preset** from the ElevenLabs Multilingual V2 catalogue the skill documents (e.g. `clara`).
2. **Generated the VO** via `runway text-to-speech "..."`.
3. **Generated the SFX** via `runway sound-effect "..."`.
4. **Wrote `result.json`** describing both audio files.

Two Runway calls total, both audio.

## 4. Output

### Voice-over

<audio src="https://github.com/tryAGI/Runway.Cli.Examples/raw/main/examples/audio/sample-output/assets/voice.mp3" controls></audio>

Runway TTS, voice preset `clara`. Download: [`sample-output/assets/voice.mp3`](./sample-output/assets/voice.mp3).

### Sound effect

<audio src="https://github.com/tryAGI/Runway.Cli.Examples/raw/main/examples/audio/sample-output/assets/sfx.mp3" controls></audio>

Runway SFX. Download: [`sample-output/assets/sfx.mp3`](./sample-output/assets/sfx.mp3).

### The `result.json` Claude wrote

See [`sample-output/result.json`](./sample-output/result.json).

## 5. Run it

```bash
./examples/audio/run.sh
```

Per-run output lands under `output/audio/<ISO-timestamp>/`.

## 6. Cost & runtime

| Metric           | Value (observed)                                       |
|------------------|--------------------------------------------------------|
| Wall time        | **~30 s**                                              |
| Claude cost      | **$0.15** (Sonnet 4.6)                                 |
| Runway credits   | **7** (the cheapest example — audio is much lighter than image/video) |
| Runway calls     | 1 × `runway text-to-speech` + 1 × `runway sound-effect` |
| Budget ceiling   | `CLAUDE_MAX_BUDGET_USD=2`                              |
