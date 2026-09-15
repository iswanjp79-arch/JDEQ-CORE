# MICO-JDEQ Install Hooks (Windows)
Set-Location "D:\MICO_SSOT"
$src = "09_GOVERNANCE\TOOLS\HOOKS"
$dst = ".git\hooks"
foreach ($h in @("pre-commit","post-commit")) {
    $s = Join-Path $src $h
    if (Test-Path $s) { Copy-Item $s (Join-Path $dst $h) -Force; Write-Host "[INSTALL] $h" }
}