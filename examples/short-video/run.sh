#!/usr/bin/env bash
# short-video: minimal user scenario -> planned, generated, and stitched multi-shot MP4.

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAME="short-video"
BUDGET=6
. "$HERE/../../scripts/_runner.sh"
