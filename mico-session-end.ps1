# ============================================================
# mico-session-end.ps1 - Tutup sesi: tulis handoff
# Usage: .\mico-session-end.ps1 -Summary "Ringkasan sesi"
# ============================================================

param(
    [Parameter(Mandatory=$true)]
    [string]$Summary
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$SSOTRoot = 'D:\MICO_SSOT'
$MemRoot  = Join-Path $SSOTRoot '02_DATA\LOCAL_MEMORY'
$SessRoot = Join-Path $MemRoot 'SESSIONS'
$Today    = Get-Date -Format 'yyyyMMdd'
$MonthDir = Join-Path $SessRoot (Get-Date -Format 'yyyy-MM')

if (-not (Test-Path -LiteralPath $MonthDir)) {
    New-Item -ItemType Directory -Force -Path $MonthDir | Out-Null
}

$existing = @(Get-ChildItem -LiteralPath $MonthDir -Filter "HANDOFF-$Today-*.md" -ErrorAction SilentlyContinue)
$num = '{0:D2}' -f ($existing.Count + 1)
$handoffId = "HANDOFF-$Today-$num"
$filePath = Join-Path $MonthDir "$handoffId.md"

function Get-Recent([string]$folder, [int]$n) {
    $path = Join-Path $MemRoot $folder
    if (-not (Test-Path -LiteralPath $path)) { return @() }
    return (Get-ChildItem -LiteralPath $path -Filter '*.md' -ErrorAction SilentlyContinue |
            Sort-Object Name -Descending | Select-Object -First $n |
            ForEach-Object { $_.BaseName })
}

$recentPREF = Get-Recent 'PREFERENCES' 5
$recentDEC  = Get-Recent 'DECISIONS' 5
$recentLRN  = Get-Recent 'LEARNING' 5
$recentCTX  = Get-Recent 'PROJECT_CONTEXT' 5

$now = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')

$content = @"
---
memory_id: $handoffId
category: HANDOFF
status: ACTIVE
created_at: $now
source_agent: L0
authority: L0
content:
  title: Session handoff
---

# $handoffId

Created: $now
Summary: $Summary

## Preferences (terbaru)
$($recentPREF -join "`n")

## Decisions (terbaru)
$($recentDEC -join "`n")

## Learning (terbaru)
$($recentLRN -join "`n")

## Project Context
$($recentCTX -join "`n")

## Instruksi untuk Sesi Baru

1. Jalankan .\mico-session-start.ps1
2. Salin output sebagai anchor
3. Jangan bertindak sebelum baca anchor
4. Semua konteks di luar handoff ini = gugur
"@

$utf8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($filePath, $content, $utf8)

$hash = (Get-FileHash -LiteralPath $filePath -Algorithm SHA256).Hash

Write-Host ""
Write-Host "OK  : Handoff dibuat"
Write-Host "ID  : $handoffId"
Write-Host "File: $filePath"
Write-Host "Hash: $hash"
Write-Host ""