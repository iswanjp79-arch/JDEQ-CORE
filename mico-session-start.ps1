# ============================================================
# mico-session-start.ps1 - Bootstrap sesi baru
# Baca handoff terakhir + memory ACTIVE, cetak sebagai anchor
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$SSOTRoot = 'D:\MICO_SSOT'
$MemRoot  = Join-Path $SSOTRoot '02_DATA\LOCAL_MEMORY'
$SessRoot = Join-Path $MemRoot 'SESSIONS'

Write-Host ""
Write-Host "======================================="
Write-Host "  MICO SESSION START ANCHOR"
Write-Host "======================================="
Write-Host ""
Write-Host "Waktu: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host ""

Write-Host "[1] HANDOFF TERAKHIR"
if (Test-Path -LiteralPath $SessRoot) {
    $handoffs = Get-ChildItem -LiteralPath $SessRoot -Filter 'HANDOFF-*.md' -Recurse -ErrorAction SilentlyContinue |
                Sort-Object LastWriteTime -Descending |
                Select-Object -First 3
    if ($handoffs) {
        foreach ($h in $handoffs) {
            Write-Host ("  - {0}  ({1})" -f $h.Name, $h.LastWriteTime.ToString('yyyy-MM-dd HH:mm'))
        }
        Write-Host ""
        Write-Host "  Isi handoff terbaru:"
        Get-Content -LiteralPath $handoffs[0].FullName -Raw
    } else {
        Write-Host "  (belum ada handoff)"
    }
} else {
    Write-Host "  (folder SESSIONS belum ada)"
}
Write-Host ""

Write-Host "[2] PROFILE AKTIF"
$profileDir = Join-Path $MemRoot 'PROFILE'
if (Test-Path -LiteralPath $profileDir) {
    $files = Get-ChildItem -LiteralPath $profileDir -Filter '*.md' -ErrorAction SilentlyContinue
    if ($files) { foreach ($f in $files) { Write-Host ("  - {0}" -f $f.BaseName) } }
    else { Write-Host "  (kosong)" }
}
Write-Host ""

Write-Host "[3] PREFERENCES"
$prefDir = Join-Path $MemRoot 'PREFERENCES'
if (Test-Path -LiteralPath $prefDir) {
    $files = Get-ChildItem -LiteralPath $prefDir -Filter '*.md' -ErrorAction SilentlyContinue
    if ($files) { foreach ($f in $files) { Write-Host ("  - {0}" -f $f.BaseName) } }
    else { Write-Host "  (kosong)" }
}
Write-Host ""

Write-Host "[4] DECISIONS (5 terbaru)"
$decDir = Join-Path $MemRoot 'DECISIONS'
if (Test-Path -LiteralPath $decDir) {
    $files = Get-ChildItem -LiteralPath $decDir -Filter '*.md' -ErrorAction SilentlyContinue |
             Sort-Object Name -Descending | Select-Object -First 5
    if ($files) { foreach ($f in $files) { Write-Host ("  - {0}" -f $f.BaseName) } }
    else { Write-Host "  (kosong)" }
}
Write-Host ""

Write-Host "[5] LEARNING (5 terbaru)"
$lrnDir = Join-Path $MemRoot 'LEARNING'
if (Test-Path -LiteralPath $lrnDir) {
    $files = Get-ChildItem -LiteralPath $lrnDir -Filter '*.md' -ErrorAction SilentlyContinue |
             Sort-Object Name -Descending | Select-Object -First 5
    if ($files) { foreach ($f in $files) { Write-Host ("  - {0}" -f $f.BaseName) } }
    else { Write-Host "  (kosong)" }
}
Write-Host ""

Write-Host "======================================="
Write-Host "  Salin output ini ke AI sebagai anchor"
Write-Host "======================================="
Write-Host ""