# package.ps1 — 调用 package.py 生成分发 zip（Windows）
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
python "$ScriptDir\package.py"
