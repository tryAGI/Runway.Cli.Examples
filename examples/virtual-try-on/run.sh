#!/usr/bin/env bash
# virtual-try-on: minimal user prompt -> generated person + garment, then virtual-try-on workflow.

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAME="virtual-try-on"
BUDGET=3
. "$HERE/../../scripts/_runner.sh"
