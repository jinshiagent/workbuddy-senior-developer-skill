# install.ps1 — 一键安装 senior-developer 技能到 WorkBuddy 用户级技能目录（Windows）
#
# 用法（PowerShell）：
#   .\install.ps1
#
# 安装位置：$env:USERPROFILE\.workbuddy\skills\senior-developer\
# 安装后：重启或刷新 WorkBuddy，输入 /senior-developer 即可调用。

$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Dest = Join-Path $env:USERPROFILE ".workbuddy\skills\senior-developer"

Write-Host "→ 安装 senior-developer 技能 至  $Dest"
New-Item -ItemType Directory -Force -Path (Join-Path $Dest "references") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Dest "assets")   | Out-Null

Copy-Item (Join-Path $ScriptDir "SKILL.md")   $Dest -Force
Copy-Item (Join-Path $ScriptDir "README.md")  $Dest -Force
if (Test-Path (Join-Path $ScriptDir "LICENSE")) {
    Copy-Item (Join-Path $ScriptDir "LICENSE") $Dest -Force
}
Copy-Item (Join-Path $ScriptDir "references\*") (Join-Path $Dest "references") -Recurse -Force
Copy-Item (Join-Path $ScriptDir "assets\*")     (Join-Path $Dest "assets")     -Recurse -Force

Write-Host "✓ 安装完成。请重启或刷新 WorkBuddy，然后输入 /senior-developer 调用。"
