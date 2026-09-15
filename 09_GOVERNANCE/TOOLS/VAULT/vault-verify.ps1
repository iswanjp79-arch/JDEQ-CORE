# MICO-JDEQ · Verifikasi Vault
$ErrorActionPreference = "Stop"
$root = "D:\MICO_SSOT"
$vf = "$root\08_EVIDENCE\VAULT_DATA\vault.bin"
$sf = "$root\08_EVIDENCE\VAULT_DATA\vault.sha256"

if (-not (Test-Path $vf)) { Write-Host "[FAIL] vault.bin tidak ada." -ForegroundColor Red; exit 1 }

$current = (Get-FileHash $vf -Algorithm SHA256).Hash
$recorded = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($sf)).Trim()
if ($current -eq $recorded) { Write-Host "[OK] Hash cocok" -ForegroundColor Green }
else { Write-Host "[FAIL] Hash beda" -ForegroundColor Red; exit 1 }

$s = Read-Host "Passphrase" -AsSecureString
$pass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($s))
$raw = [System.IO.File]::ReadAllBytes($vf)
$salt = $raw[0..15]; $enc = $raw[16..($raw.Length-1)]
$b = [System.Text.Encoding]::UTF8.GetBytes($pass)
$d = New-Object System.Security.Cryptography.Rfc2898DeriveBytes($b, $salt, 100000)
$k = $d.GetBytes(32); $iv = $d.GetBytes(16)
try {
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Mode='CBC'; $aes.Padding='PKCS7'; $aes.Key=$k; $aes.IV=$iv
    $null = $aes.CreateDecryptor().TransformFinalBlock($enc,0,$enc.Length)
    Write-Host "[OK] Passphrase benar. Vault utuh." -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Passphrase salah / file rusak." -ForegroundColor Red
    Get-Content "$root\08_EVIDENCE\VAULT_DATA\decoy.txt" -Raw
    exit 2
}