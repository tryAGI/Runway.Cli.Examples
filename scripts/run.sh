#!/usr/bin/env bash
# Generic dispatcher: ./scripts/run.sh <example-name>
# Equivalent to invoking ./examples/<example-name>/run.sh directly.

set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <example-name>"
  echo
  echo "Available examples:"
  REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  for d in "$REPO_ROOT"/examples/*/; do
    [ -d "$d" ] || continue
    name="$(basename "$d")"
    echo "  - $name"
  done
  exit 1
fi

NAME="$1"
shift
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$REPO_ROOT/examples/$NAME/run.sh"

if [ ! -x "$SCRIPT" ]; then
  echo "Example not found or not executable: $SCRIPT"
  exit 1
fi

exec "$SCRIPT" "$@"
