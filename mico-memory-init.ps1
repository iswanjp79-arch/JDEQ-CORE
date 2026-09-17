# ============================================================
# mico-memory-init.ps1 - Inisialisasi struktur folder memory
# Jalankan sekali. Idempotent.
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$SSOTRoot = 'D:\MICO_SSOT'
$MemRoot  = Join-Path $SSOTRoot '02_DATA\LOCAL_MEMORY'

$folders = @(
    'PROFILE',
    'PREFERENCES',
    'DECISIONS',
    'LEARNING',
    'PROJECT_CONTEXT',
    'TOPIC_INDEX',
    'SESSIONS'
)

Write-Host ""
Write-Host "Inisialisasi memory folder..."
Write-Host ""

foreach ($f in $folders) {
    $path = Join-Path $MemRoot $f
    if (-not (Test-Path -LiteralPath $path)) {
        New-Item -ItemType Directory -Force -Path $path | Out-Null
        $keep = Join-Path $path '.gitkeep'
        if (-not (Test-Path -LiteralPath $keep)) {
            New-Item -ItemType File -Force -Path $keep | Out-Null
        }
        Write-Host "BUAT: $path"
    } else {
        Write-Host "ADA : $path"
    }
}

Write-Host ""
Write-Host "Selesai. Struktur memory siap."
Write-Host ""