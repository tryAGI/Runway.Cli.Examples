#!/usr/bin/env bash
# Idempotent bootstrap for Runway.Cli.Examples.
# - Verifies required tools are on PATH
# - Installs/updates the Runway.Cli .NET tool
# - Installs the runway-cli agent skill via skills.sh
# - Creates a .claude/skills symlink fallback so headless `claude -p` finds it
# - Smoke-checks credentials in .env

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

require() {
  command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1 — $2"; exit 1; }
}

require claude "install Claude Code: https://claude.com/claude-code"
require dotnet "install .NET 10+: https://dot.net"
require jq     "install jq: https://stedolan.github.io/jq/"
require npx    "install Node.js (for npx): https://nodejs.org/"

echo "==> Installing/updating Runway.Cli .NET tool"
if ! dotnet tool install -g Runway.Cli --prerelease >/dev/null 2>&1; then
  dotnet tool update -g Runway.Cli --prerelease
fi

echo "==> Installing runway-cli skill from tryAGI/Runway via skills.sh"
npx -y skills add tryAGI/Runway -a claude-code -y

# skills.sh with `-a claude-code` lands the skill at .claude/skills/runway-cli/,
# which is exactly where headless `claude -p` auto-discovers it.
if [ ! -f .claude/skills/runway-cli/SKILL.md ]; then
  echo "ERR: skill not found at .claude/skills/runway-cli/SKILL.md after install."
  echo "     Re-run 'npx skills add tryAGI/Runway -a claude-code -y' and inspect output."
  exit 1
fi

echo "==> Checking credentials"
if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  . ./.env
  set +a
fi
if [ -z "${RUNWAY_API_KEY:-}" ]; then
  echo "ERR: RUNWAY_API_KEY is not set."
  echo "     Copy .env.example to .env and fill in the key."
  exit 1
fi

echo
echo "Setup OK."
echo "Try:  ./examples/manga/run.sh"
