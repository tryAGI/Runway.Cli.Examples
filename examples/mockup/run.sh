#!/usr/bin/env bash
# mockup: minimal user prompt -> generated logo, then mockup-generator places it in 4 advertising contexts.

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAME="mockup"
BUDGET=3
. "$HERE/../../scripts/_runner.sh"
