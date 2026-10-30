#!/usr/bin/env python3
"""
package.py — 跨平台打包脚本（无第三方依赖）

将技能包内容（SKILL.md / README.md / LICENSE / references/ / assets/）
打包为 dist/senior-developer.zip，解压后顶层为 senior-developer/ 目录，
可直接放入 ~/.workbuddy/skills/ 或 <项目>/.workbuddy/skills/。

用法：
    python3 package.py            # macOS / Linux
    python  package.py            # Windows (PowerShell / cmd)
"""
import os
import sys
import zipfile
import shutil

ROOT = os.path.dirname(os.path.abspath(__file__))
DIST = os.path.join(ROOT, "dist")
TMP = os.path.join(DIST, "_pkg_tmp", "senior-developer")
OUT = os.path.join(DIST, "senior-developer.zip")

# 进入打包的源文件 / 目录
INCLUDE_FILES = ["SKILL.md", "README.md", "LICENSE"]
INCLUDE_DIRS = ["references", "assets"]


def build():
    shutil.rmtree(os.path.join(DIST, "_pkg_tmp"), ignore_errors=True)
    os.makedirs(TMP, exist_ok=True)

    for f in INCLUDE_FILES:
        src = os.path.join(ROOT, f)
        if os.path.isfile(src):
            shutil.copy2(src, os.path.join(TMP, f))
        else:
            print(f"! 警告：缺少文件 {f}，已跳过")

    for d in INCLUDE_DIRS:
        src = os.path.join(ROOT, d)
        if os.path.isdir(src):
            shutil.copytree(src, os.path.join(TMP, d))
        else:
            print(f"! 警告：缺少目录 {d}/，已跳过")

    with zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED) as z:
        for root, _dirs, files in os.walk(TMP):
            for fn in files:
                fp = os.path.join(root, fn)
                arcname = os.path.relpath(fp, os.path.dirname(TMP))
                z.write(fp, arcname)

    shutil.rmtree(os.path.join(DIST, "_pkg_tmp"), ignore_errors=True)
    size = os.path.getsize(OUT)
    print(f"✓ 打包完成：{OUT}  ({size:,} bytes)")


if __name__ == "__main__":
    try:
        build()
    except Exception as e:  # noqa: BLE001
        print(f"✗ 打包失败：{e}", file=sys.stderr)
        sys.exit(1)
