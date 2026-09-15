# MICO-JDEQ · Wrapper Eksekusi Agen
# Setiap eksekusi agen WAJIB memuat hash V.21 & ADR-005 lebih dulu

param(
    [Parameter(Mandatory=$true)]
    [string]$Task
)

$ErrorActionPreference = "Stop"
Set-Location "D:\MICO_SSOT"

$v21  = "09_GOVERNANCE\P1-PLANNING\DEL03-GOVERNANCE\MICO-P1-DEL03-GOV-001_CETAK-BIRU-V21.md"
$adr  = "09_GOVERNANCE\ADR\ADR-005_REKONSILIASI_GOVERNANCE_V21.md"

# Verifikasi eksistensi
if (-not (Test-Path $v21)) { throw "V.21 tidak ditemukan. Eksekusi ditolak." }
if (-not (Test-Path $adr)) { throw "ADR-005 tidak ditemukan. Eksekusi ditolak." }

# Hitung & catat hash sebagai konteks
$hV21 = (Get-FileHash $v21 -Algorithm SHA256).Hash
$hADR = (Get-FileHash $adr -Algorithm SHA256).Hash
$ts   = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$log = "08_EVIDENCE\execution_guard\exec_guard_$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
New-Item -ItemType Directory -Force -Path (Split-Path $log) | Out-Null

@"
=== MICO EXEC GUARD ===
Time     : $ts
Task     : $Task
V.21     : $hV21
ADR-005  : $hADR
Host     : $env:COMPUTERNAME
Operator : $env:USERNAME
"@ | Out-File $log -Encoding UTF8

Write-Host "[GUARD] Task     : $Task" -ForegroundColor Cyan
Write-Host "[GUARD] V.21     : $hV21" -ForegroundColor Cyan
Write-Host "[GUARD] ADR-005  : $hADR" -ForegroundColor Cyan
Write-Host "[GUARD] Log      : $log" -ForegroundColor Cyan
Write-Host "[GUARD] Eksekusi disetujui. Lanjutkan." -ForegroundColor Green