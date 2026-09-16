# MICO-JDEQ Verify — cek SHA256 seluruh key files
Set-Location "D:\MICO_SSOT"
$mf = "09_GOVERNANCE\P1-PLANNING\KEY-FILES-MANIFEST.sha256.txt"
if (-not (Test-Path $mf)) { Write-Host "[FAIL] Manifest tidak ada." -ForegroundColor Red; exit 1 }

$ok = 0; $bad = 0; $miss = 0
Get-Content $mf | Where-Object { $_ -match "\S" } | ForEach-Object {
    $parts = $_ -split "\s+", 2
    $rec = $parts[0]; $f = $parts[1].Trim()
    if (-not (Test-Path $f)) { Write-Host "[MISSING] $f" -ForegroundColor Yellow; $miss++; return }
    $cur = (Get-FileHash $f -Algorithm SHA256).Hash
    if ($cur -eq $rec) { Write-Host "[OK]      $f" -ForegroundColor Green; $ok++ }
    else { Write-Host "[MISMATCH] $f" -ForegroundColor Red; $bad++ }
}
Write-Host ""
Write-Host "Total: OK=$ok  MISMATCH=$bad  MISSING=$miss"
if ($bad -gt 0 -or $miss -gt 0) { exit 1 }