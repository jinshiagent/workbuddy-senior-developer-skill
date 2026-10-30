#!/usr/bin/env bash
# package.sh — 调用 package.py 生成分发 zip
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
python3 "$SCRIPT_DIR/package.py"
