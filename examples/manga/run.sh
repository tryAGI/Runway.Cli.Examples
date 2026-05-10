#!/usr/bin/env bash
# json-to-manga: minimal user prompt -> a multi-page manga (PNGs + result.json).

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAME="manga"
BUDGET=5
. "$HERE/../../scripts/_runner.sh"
