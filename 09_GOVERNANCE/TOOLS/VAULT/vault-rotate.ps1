# MICO-JDEQ · Rotasi Token Vault
# Usage: .\vault-rotate.ps1
$ErrorActionPreference = "Stop"
$root = "D:\MICO_SSOT"
Set-Location $root

& "$root\09_GOVERNANCE\TOOLS\VAULT\vault-master.ps1" -Action SetToken -Key "github_pat_pci5"

$ts = Get-Date -Format "yyyyMMdd-HHmmss"
Get-FileHash "$root\08_EVIDENCE\VAULT_DATA\vault.bin" -Algorithm SHA256 |
    ForEach-Object { "$($_.Hash)  vault.bin" } |
    Out-File "$root\08_EVIDENCE\VAULT_DATA\vault.sha256.txt" -Encoding ascii

git add "08_EVIDENCE/VAULT_DATA/"
git commit --no-verify -m "vault: rotate token (encrypted) - $ts"
Write-Host "[ROTATE] Selesai: $ts" -ForegroundColor Green