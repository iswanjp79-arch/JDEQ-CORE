# skrip_akhiri_sesi.ps1
# Revisi: F-002 (PSScriptRoot)
$root = $PSScriptRoot
Write-Output ("=== SESI DIAKHIRI: " + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + " ===")
Get-ChildItem -Path $root -Recurse -File | ForEach-Object {
  $h = Get-FileHash $_.FullName -Algorithm SHA256
  "$($h.Hash)  $($_.Name)"
} | Out-File (Join-Path $root ("MANIFEST_SESI_" + (Get-Date -Format 'yyyyMMdd-HHmmss') + ".txt"))
Write-Output "Manifest tersimpan."