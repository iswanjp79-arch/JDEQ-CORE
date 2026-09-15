# MICO-JDEQ Hook Installer
# Copy hooks dari 09_GOVERNANCE/TOOLS/HOOKS/ → .git/hooks/
Set-Location "D:\MICO_SSOT"
$src = "09_GOVERNANCE\TOOLS\HOOKS"
$dst = ".git\hooks"
foreach ($h in @("pre-commit","post-commit")) {
    $s = Join-Path $src $h
    $d = Join-Path $dst $h
    if (Test-Path $s) {
        Copy-Item $s $d -Force
        Write-Host "[INSTALL] $h → $d"
    } else {
        Write-Host "[SKIP] $h tidak ada di source"
    }
}
Write-Host "`nHooks terpasang. Cek dengan: ls .git/hooks"