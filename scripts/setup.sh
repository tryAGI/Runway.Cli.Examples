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

if [ ! -f .agents/skills/runway-cli/SKILL.md ]; then
  echo "WARN: skill not found at .agents/skills/runway-cli/SKILL.md after install."
  echo "      Check the output of 'npx skills add tryAGI/Runway -a claude-code -y' above."
fi

# Some Claude Code versions only auto-discover skills from .claude/skills/.
# If that's the case, surface the same files there via a symlink.
if [ -f .agents/skills/runway-cli/SKILL.md ] && [ ! -e .claude/skills/runway-cli ]; then
  mkdir -p .claude/skills
  ln -s ../../.agents/skills/runway-cli .claude/skills/runway-cli
  echo "==> Linked .claude/skills/runway-cli -> ../../.agents/skills/runway-cli"
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
