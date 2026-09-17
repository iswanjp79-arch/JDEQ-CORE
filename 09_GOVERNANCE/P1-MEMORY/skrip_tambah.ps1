# skrip_tambah.ps1
# Revisi: F-001 (auto-create direktori) + F-002 (PSScriptRoot)
param([string]$Topik, [string]$Isi)
$root = $PSScriptRoot
foreach ($d in @("02_STORE", "04_HASH")) {
  $p = Join-Path $root $d
  if (-not (Test-Path $p)) { New-Item -ItemType Directory -Path $p -Force | Out-Null }
}
$jalur = Join-Path $root ("02_STORE\" + (Get-Date -Format 'yyyyMMdd-HHmmss') + ".txt")
$Isi | Out-File $jalur -Encoding utf8
$hash = Get-FileHash $jalur -Algorithm SHA256
"Hash: $($hash.Hash)" | Out-File (Join-Path $root ("04_HASH\" + (Split-Path $jalur -Leaf) + ".sha256"))
Write-Output "Tersimpan: $jalur | SHA256: $($hash.Hash)"