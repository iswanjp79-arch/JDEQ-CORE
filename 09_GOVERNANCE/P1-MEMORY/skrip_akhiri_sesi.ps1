# skrip_akhiri_sesi.ps1
Write-Output "=== SESI DIAKHIRI: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ==="
Get-ChildItem -Recurse -File | ForEach-Object {
  $h = Get-FileHash $_.FullName -Algorithm SHA256
  "$($h.Hash)  $($_.Name)"
} | Out-File "MANIFEST_SESI_$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
Write-Output "Manifest tersimpan."