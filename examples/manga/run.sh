#!/usr/bin/env bash
# json-to-manga: minimal user prompt -> a 4-page manga (PNGs + result.json).
# All the work is done by Claude using the runway-cli skill.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$HERE/../.." && pwd)"
NAME="manga"
TS="$(date -u +%Y-%m-%dT%H-%M-%SZ)"
OUT="$REPO/output/$NAME/$TS"
mkdir -p "$OUT/assets"

# Load .env if present so RUNWAY_API_KEY is in the child process environment.
if [ -f "$REPO/.env" ]; then
  set -a
  # shellcheck disable=SC1091
  . "$REPO/.env"
  set +a
fi
if [ -z "${RUNWAY_API_KEY:-}" ]; then
  echo "RUNWAY_API_KEY is not set. Copy .env.example to .env and fill it in."
  exit 1
fi

# The user-style prompt is in prompt.md. We append output paths so Claude knows
# where to drop assets and the final JSON.
PROMPT="$(cat "$HERE/prompt.md")
Write all generated images to: $OUT/assets
Write the final JSON to: $OUT/result.json"

echo "==> Running json-to-manga"
echo "    Prompt:    $HERE/prompt.md"
echo "    Output:    $OUT"
echo

cd "$REPO"
claude -p "$PROMPT" \
  --model "${CLAUDE_MODEL:-sonnet}" \
  --max-budget-usd "${CLAUDE_MAX_BUDGET_USD:-5}" \
  --add-dir "$OUT" \
  --permission-mode bypassPermissions \
  --allowedTools "Bash,Read,Write,Edit,Glob,Grep" \
  --output-format json \
  --setting-sources project,local \
  > "$OUT/transcript.json"

# Capture provenance + cost.
jq -n \
  --arg claude_version "$(claude --version 2>/dev/null || echo unknown)" \
  --arg runway_version "$(runway --version 2>/dev/null || echo unknown)" \
  --arg cost           "$(jq -r '.total_cost_usd // .cost_usd // "unknown"' "$OUT/transcript.json")" \
  --arg session        "$(jq -r '.session_id // "unknown"' "$OUT/transcript.json")" \
  --arg prompt_path    "$HERE/prompt.md" \
  '{
     example: "manga",
     claude:       $claude_version,
     runway_cli:   $runway_version,
     cost_usd:     $cost,
     session_id:   $session,
     prompt_path:  $prompt_path
   }' \
  > "$OUT/meta.json"

echo
echo "Done."
echo "  result.json:    $OUT/result.json"
echo "  transcript:     $OUT/transcript.json"
echo "  meta:           $OUT/meta.json"
echo "  assets:         $OUT/assets/"
