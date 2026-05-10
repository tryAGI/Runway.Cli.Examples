#!/usr/bin/env bash
# haircut: minimal user prompt -> generated portrait restyled with ai-hair-salon.

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAME="haircut"
BUDGET=3
. "$HERE/../../scripts/_runner.sh"
