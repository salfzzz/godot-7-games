<#
.SYNOPSIS
    一键提交并推送 Godot 开发进度。

.DESCRIPTION
    自动完成 add + commit + push，并可自动按 <项目>/builds/ 规则提醒。
    在仓库根目录 D:\Godot\Godot_source 下运行。

.PARAMETER Message
    提交信息。不传则进入交互模式让你现场输入。

.PARAMETER Project
    只提交指定项目，例如 02.Metroid。不传则提交所有改动。

.PARAMETER NoPush
    只提交不推送，方便你攒几个 commit 一起推。

.EXAMPLE
    .\push.ps1 "完成角色基础移动"

.EXAMPLE
    .\push.ps1 "修复子弹碰撞" -Project 02.Metroid

.EXAMPLE
    .\push.ps1 "写了点笔记" -NoPush
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Message,

    [Parameter()]
    [string]$Project,

    [switch]$NoPush
)

$ErrorActionPreference = 'Stop'

# 仓库根目录 = 脚本所在目录（所以从任何子目录运行都能工作）
$repoRoot = $PSScriptRoot
Set-Location $repoRoot

function Write-Step($text) { Write-Host "==> $text" -ForegroundColor Cyan }
function Write-Ok($text)   { Write-Host "    $text" -ForegroundColor Green }
function Write-Warn2($text){ Write-Host "    $text" -ForegroundColor Yellow }
function Write-Err2($text) { Write-Host "    $text" -ForegroundColor Red }

# ---------- 0. 前置检查 ----------
# 这个脚本是 PowerShell 脚本，不能在 cmd.exe 里直接运行（会报 Access is denied）。
if ($PSVersionTable.PSEdition -eq 'Desktop' -and $PSVersionTable.PSVersion.Major -lt 5) {
    Write-Err2 "PowerShell 版本过低（需要 5.1+）。请用 pwsh 或 Windows PowerShell 运行。"
    exit 1
}

if (-not (Test-Path (Join-Path $repoRoot '.git'))) {
    Write-Err2 "脚本所在目录不是 git 仓库根目录：$repoRoot"
    Write-Host "    请确认 push.ps1 位于 D:\Godot\Godot_source\ 下。" -ForegroundColor DarkGray
    exit 1
}

# ---------- 1. 确定提交范围 ----------
if ($Project) {
    $target = Join-Path $repoRoot $Project
    if (-not (Test-Path $target)) {
        Write-Err2 "找不到项目文件夹：$Project"
        Write-Host "    现有项目：" -ForegroundColor DarkGray
        Get-ChildItem $repoRoot -Directory |
            Where-Object { $_.Name -match '^\d\d\.' } |
            ForEach-Object { Write-Host "      $($_.Name)" -ForegroundColor DarkGray }
        exit 1
    }
    Write-Step "提交范围：$Project"
    $addArgs = @('add', '--', $Project)
} else {
    Write-Step "提交范围：全部改动"
    $addArgs = @('add', '-A')
}

# ---------- 2. 暂存 ----------
& git @addArgs
if ($LASTEXITCODE -ne 0) {
    # LFS 过滤器在受限环境下会报 signal pipe 错误，但暂存通常已经成功
    Write-Warn2 "git add 返回非零，检查暂存结果…"
}

$staged = & git diff --cached --name-only
if (-not $staged) {
    Write-Warn2 "没有需要提交的改动，退出。"
    exit 0
}

# ---------- 3. 安全检查：课程资料绝不能进仓库 ----------
$leak = $staged | Where-Object { $_ -match '课程资料|课程素材|课程资源' }
if ($leak) {
    Write-Err2 "检测到课程资料被暂存，已中止提交！"
    $leak | ForEach-Object { Write-Host "      $_" -ForegroundColor Red }
    Write-Host "    请检查 .gitignore 是否被改动。" -ForegroundColor Yellow
    exit 1
}

Write-Ok "待提交 $(($staged | Measure-Object).Count) 个文件"

# ---------- 4. 大文件提醒 ----------
$big = @()
foreach ($f in $staged) {
    $p = Join-Path $repoRoot $f
    if (Test-Path $p -PathType Leaf) {
        $sizeMb = (Get-Item $p).Length / 1MB
        if ($sizeMb -gt 20) { $big += "  $f  ($([math]::Round($sizeMb,1)) MB)" }
    }
}
if ($big) {
    Write-Warn2 "以下文件较大，确认不是导出产物："
    $big | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
}

# ---------- 5. 提交信息 ----------
if (-not $Message) {
    Write-Host ""
    Write-Host "请输入提交信息（例如：完成角色基础移动）：" -ForegroundColor Cyan
    $Message = Read-Host "  "
    if (-not $Message) {
        Write-Err2 "提交信息不能为空。"
        exit 1
    }
}

# 自动补前缀：没写 type(scope) 的话，按改了哪个项目推断
if ($Message -notmatch '^\w+(\(.+\))?:') {
    $scope = 'repo'
    $changed = $staged | Select-Object -First 1
    if ($changed -match '^(\d\d\.[^/\\]+)') { $scope = $Matches[1] }
    $Message = "feat($scope): $Message"
    Write-Ok "自动补全为：$Message"
}

# ---------- 6. 提交 ----------
$msgFile = Join-Path $env:TEMP "dsh_commit_msg.txt"
Set-Content -Path $msgFile -Value $Message -Encoding UTF8

& git commit -q -F $msgFile
if ($LASTEXITCODE -ne 0) {
    Write-Err2 "提交失败。"
    exit 1
}
Remove-Item $msgFile -Force -ErrorAction SilentlyContinue
Write-Ok "已提交：$Message"

# ---------- 7. 推送 ----------
if ($NoPush) {
    Write-Warn2 "已跳过推送（-NoPush）。记得之后手动 git push。"
    exit 0
}

Write-Step "推送到 GitHub…"
& git push origin main
if ($LASTEXITCODE -ne 0) {
    Write-Err2 "推送失败。可能是网络问题或需要重新登录 GitHub。"
    Write-Host "    手动重试：git push origin main" -ForegroundColor DarkGray
    exit 1
}

Write-Host ""
Write-Ok "完成！查看仓库：https://github.com/salfzzz/godot-7-games"

# ---------- 8. 展示最近提交 ----------
Write-Host ""
Write-Host "最近提交：" -ForegroundColor Cyan
& git log --oneline -5 | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
