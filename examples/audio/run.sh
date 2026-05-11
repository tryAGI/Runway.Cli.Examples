#!/usr/bin/env bash
# audio: minimal user prompt -> a spoken VO line + a matching ambient SFX clip.

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAME="audio"
BUDGET=2
. "$HERE/../../scripts/_runner.sh"
