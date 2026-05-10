#!/usr/bin/env bash
# Shared runner sourced by each example's run.sh.
#
# Caller must set BEFORE sourcing:
#   NAME    — example name (e.g. "image", "manga", "haircut")
#   HERE    — absolute path to the example directory (containing prompt.md)
#
# Caller MAY set:
#   BUDGET  — Claude max-budget-usd (default 5)
#   MODEL   — Claude model alias    (default sonnet)
#
# Effects:
#   - Loads RUNWAY_API_KEY from $REPO/.env if present
#   - Captures Runway credit balance before and after the run
#   - Invokes `claude -p` headless with the prompt + output paths appended
#   - Writes result.json (Claude), transcript.json (raw envelope),
#     meta.json (claude/runway versions, cost, credits, session id),
#     and any generated assets under $REPO/output/$NAME/<timestamp>/

set -euo pipefail

if [ -z "${NAME:-}" ] || [ -z "${HERE:-}" ]; then
  echo "scripts/_runner.sh: NAME and HERE must be set by the caller." >&2
  exit 2
fi

REPO="$(cd "$HERE/../.." && pwd)"
BUDGET="${BUDGET:-5}"
MODEL="${MODEL:-sonnet}"
TS="$(date -u +%Y-%m-%dT%H-%M-%SZ)"
OUT="$REPO/output/$NAME/$TS"
mkdir -p "$OUT/assets"

# Load .env so RUNWAY_API_KEY is available to claude -p and runway CLI.
if [ -f "$REPO/.env" ]; then
  set -a
  # shellcheck disable=SC1091
  . "$REPO/.env"
  set +a
fi
if [ -z "${RUNWAY_API_KEY:-}" ]; then
  echo "RUNWAY_API_KEY is not set. Copy .env.example to .env and fill it in." >&2
  exit 1
fi

# The user-style prompt is in prompt.md. We append output paths so Claude knows
# where to drop assets and the final JSON.
PROMPT="$(cat "$HERE/prompt.md")
Write all generated images (and any other assets) to: $OUT/assets
Write the final JSON to: $OUT/result.json"

echo "==> Running example: $NAME"
echo "    Prompt:    $HERE/prompt.md"
echo "    Output:    $OUT"

# Capture Runway credit balance BEFORE the run.
CREDITS_BEFORE="$(runway organization get 2>/dev/null | jq -r '.creditBalance // "unknown"' 2>/dev/null || echo unknown)"
echo "    Credits:   $CREDITS_BEFORE (before)"
echo

cd "$REPO"
claude -p "$PROMPT" \
  --model "$MODEL" \
  --max-budget-usd "$BUDGET" \
  --add-dir "$OUT" \
  --permission-mode bypassPermissions \
  --allowedTools "Bash,Read,Write,Edit,Glob,Grep" \
  --output-format json \
  --setting-sources project,local \
  --append-system-prompt "You are running headless inside an example wrapper. Constraints: (a) write all generated assets only under the output directory provided in the user prompt; (b) write the final result.json only at the path provided in the user prompt; (c) do not run git, gh, or any repository-level commands; (d) do not edit anything outside the per-run output directory; (e) do not push, commit, or amend anything. The wrapper handles git, packaging, and provenance on its own." \
  > "$OUT/transcript.json"

# Capture Runway credit balance AFTER the run, and compute delta.
CREDITS_AFTER="$(runway organization get 2>/dev/null | jq -r '.creditBalance // "unknown"' 2>/dev/null || echo unknown)"
if [ "$CREDITS_BEFORE" != "unknown" ] && [ "$CREDITS_AFTER" != "unknown" ]; then
  CREDITS_USED=$((CREDITS_BEFORE - CREDITS_AFTER))
else
  CREDITS_USED="unknown"
fi

jq -n \
  --arg example         "$NAME" \
  --arg claude_version  "$(claude --version 2>/dev/null || echo unknown)" \
  --arg runway_version  "$(runway --version 2>/dev/null || echo unknown)" \
  --arg cost            "$(jq -r '.total_cost_usd // .cost_usd // "unknown"' "$OUT/transcript.json")" \
  --arg session         "$(jq -r '.session_id // "unknown"' "$OUT/transcript.json")" \
  --arg prompt_path     "$HERE/prompt.md" \
  --arg credits_before  "$CREDITS_BEFORE" \
  --arg credits_after   "$CREDITS_AFTER" \
  --arg credits_used    "$CREDITS_USED" \
  '{
     example:        $example,
     claude:         $claude_version,
     runway_cli:     $runway_version,
     claude_cost_usd: $cost,
     runway_credits: {
       before: ($credits_before | tonumber? // $credits_before),
       after:  ($credits_after  | tonumber? // $credits_after),
       used:   ($credits_used   | tonumber? // $credits_used)
     },
     session_id:     $session,
     prompt_path:    $prompt_path
   }' \
  > "$OUT/meta.json"

echo
echo "Done."
echo "  result.json:    $OUT/result.json"
echo "  transcript:     $OUT/transcript.json"
echo "  meta:           $OUT/meta.json"
echo "  assets:         $OUT/assets/"
echo "  Claude cost:    \$$(jq -r '.claude_cost_usd' "$OUT/meta.json")"
echo "  Runway credits: $(jq -r '.runway_credits.used' "$OUT/meta.json") used (before $CREDITS_BEFORE -> after $CREDITS_AFTER)"
