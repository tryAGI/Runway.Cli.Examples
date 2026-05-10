#!/usr/bin/env bash
# wine-label: minimal user prompt -> generated bottle + 2 labels, then wine-label-generator workflow (produces final hero MP4).

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAME="wine-label"
BUDGET=4
. "$HERE/../../scripts/_runner.sh"
