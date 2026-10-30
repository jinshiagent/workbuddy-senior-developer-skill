#!/usr/bin/env bash
#
# install.sh — 一键安装 senior-developer 技能到 WorkBuddy 用户级技能目录
#
# 用法：
#   bash install.sh
#
# 安装位置：~/.workbuddy/skills/senior-developer/
# 安装后：重启或刷新 WorkBuddy，输入 /senior-developer 即可调用。
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/.workbuddy/skills/senior-developer"

echo "→ 安装 senior-developer 技能 至  $DEST"
mkdir -p "$DEST/references" "$DEST/assets"

cp "$SCRIPT_DIR/SKILL.md"            "$DEST/"
cp "$SCRIPT_DIR/README.md"           "$DEST/"
cp "$SCRIPT_DIR/LICENSE"             "$DEST/" 2>/dev/null || true
cp -R "$SCRIPT_DIR/references/."     "$DEST/references/"
cp -R "$SCRIPT_DIR/assets/."         "$DEST/assets/"

echo "✓ 安装完成。请重启或刷新 WorkBuddy，然后输入 /senior-developer 调用。"
