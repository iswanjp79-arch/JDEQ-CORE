# skrip_tambah.ps1
param([string]$Topik, [string]$Isi)
$jalur = "02_STORE/$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
$Isi | Out-File $jalur -Encoding utf8
$hash = Get-FileHash $jalur -Algorithm SHA256
"Hash: $($hash.Hash)" | Out-File "04_HASH/$(Split-Path $jalur -Leaf).sha256"
Write-Output "Tersimpan: $jalur | SHA256: $($hash.Hash)"