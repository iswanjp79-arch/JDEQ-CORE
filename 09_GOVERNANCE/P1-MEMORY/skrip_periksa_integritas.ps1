# skrip_periksa_integritas.ps1
# Revisi: F-001 (auto-guard) + F-002 (PSScriptRoot)
$root    = $PSScriptRoot
$store   = Join-Path $root "02_STORE"
$hashDir = Join-Path $root "04_HASH"
if (-not (Test-Path $store))   { Write-Output "MISS: 02_STORE belum ada"; exit 0 }
if (-not (Test-Path $hashDir)) { Write-Output "MISS: 04_HASH belum ada"; exit 0 }
Get-ChildItem -Path $store -File | ForEach-Object {
  $aktual = (Get-FileHash $_.FullName -Algorithm SHA256).Hash
  $rekamanPath = Join-Path $hashDir ($_.Name + ".sha256")
  if (Test-Path $rekamanPath) {
    $tercatat = (Get-Content $rekamanPath -Raw).Split(':')[-1].Trim()
    if ($aktual -eq $tercatat) { "OK  $($_.Name) - TERVERIFIKASI" }
    else { "BAD $($_.Name) - RUSAK / BERUBAH" }
  } else { "MISS $($_.Name) - BELUM ADA REKAMAN" }
}