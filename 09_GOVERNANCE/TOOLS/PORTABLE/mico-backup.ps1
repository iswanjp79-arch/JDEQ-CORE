# MICO-JDEQ Backup — trigger bundle manual
Set-Location "D:\MICO_SSOT"
$dir = "12_BACKUP\git-mirror"
New-Item -ItemType Directory -Force -Path $dir | Out-Null
$ts = Get-Date -Format "yyyyMMdd-HHmmss"
$bundle = "$dir\jdeq-mirror-manual-$ts.bundle"
git bundle create $bundle --all
if ($LASTEXITCODE -eq 0) {
    $h = (Get-FileHash $bundle -Algorithm SHA256).Hash
    Write-Host "[OK] Bundle: $bundle" -ForegroundColor Green
    Write-Host "[OK] SHA256: $($h.Substring(0,16))..." -ForegroundColor Green
    # Simpan 5 manual terbaru saja
    Get-ChildItem "$dir\jdeq-mirror-manual-*.bundle" | Sort-Object LastWriteTime -Descending | Select-Object -Skip 5 | Remove-Item -Force
} else { Write-Host "[FAIL] Bundle gagal." -ForegroundColor Red; exit 1 }