#!/usr/bin/env bash
# image-to-video: minimal user prompt -> generated still -> animated short MP4.

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAME="image-to-video"
BUDGET=4
. "$HERE/../../scripts/_runner.sh"
