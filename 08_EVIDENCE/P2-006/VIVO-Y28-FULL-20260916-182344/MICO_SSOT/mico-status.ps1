# MICO-JDEQ Status (Windows)
Set-Location "D:\MICO_SSOT"
Write-Host "=== MICO STATUS ===" -ForegroundColor Cyan
Write-Host "Host: $env:COMPUTERNAME"
Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')"
Write-Host ""
Write-Host "--- Git ---" -ForegroundColor Yellow
git status -sb
git log --oneline -1
Write-Host ""
Write-Host "--- Vault ---" -ForegroundColor Yellow
$vf = "08_EVIDENCE\VAULT_DATA\vault.bin"
if (Test-Path $vf) {
    $h = (Get-FileHash $vf -Algorithm SHA256).Hash
    $size = (Get-Item $vf).Length
    "vault.bin : $size byte"
    "sha256    : $($h.Substring(0,16))..."
} else { "vault.bin : TIDAK ADA" }
Write-Host ""
Write-Host "--- Hooks ---" -ForegroundColor Yellow
Get-ChildItem ".git\hooks" -File | Where-Object { $_.Name -notlike "*.sample" } | Select-Object Name, Length | Format-Table -AutoSize