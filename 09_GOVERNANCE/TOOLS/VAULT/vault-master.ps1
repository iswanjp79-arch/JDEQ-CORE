# MICO-JDEQ · Vault Master
# AES-256-CBC + PBKDF2 100k iter. Passphrase TIDAK disimpan.

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('NewVault','SetToken','ShowMeta','ShowDecoy')]
    [string]$Action,
    [string]$Key = "github_pat_pci5"
)

$ErrorActionPreference = "Stop"
$DataDir   = "D:\MICO_SSOT\08_EVIDENCE\VAULT_DATA"
$VaultFile = "$DataDir\vault.bin"
$MetaFile  = "$DataDir\vault.meta.json"
$DecoyFile = "$DataDir\decoy.txt"
New-Item -ItemType Directory -Force -Path $DataDir | Out-Null

function Get-Pass {
    $s = Read-Host "Passphrase (min 20 karakter, tidak muncul di layar)" -AsSecureString
    return [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($s))
}

function Derive-Key([string]$pass, [byte[]]$salt) {
    $b = [System.Text.Encoding]::UTF8.GetBytes($pass)
    $d = New-Object System.Security.Cryptography.Rfc2898DeriveBytes($b, $salt, 100000)
    $k = $d.GetBytes(32); $iv = $d.GetBytes(16)
    [Array]::Clear($b, 0, $b.Length)
    return @{ Key = $k; IV = $iv }
}

function Encrypt-Data([string]$plain, [byte[]]$salt) {
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Mode = 'CBC'; $aes.Padding = 'PKCS7'
    return $aes
}

switch ($Action) {
    'NewVault' {
        if (Test-Path $VaultFile) { Write-Host "[VAULT] Sudah ada." -ForegroundColor Yellow; break }
        $p1 = Get-Pass
        $p2 = Get-Pass
        if ($p1 -ne $p2 -or $p1.Length -lt 20) { Write-Host "[VAULT] Pass beda atau <20." -ForegroundColor Red; break }
        $salt = New-Object byte[] 16
        [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($salt)
        $dk = Derive-Key $p1 $salt
        $aes = Encrypt-Data "" $salt
        $aes.Key = $dk.Key; $aes.IV = $dk.IV
        $enc = $aes.CreateEncryptor()
        $data = '{"github_pat_pci5":""}'
        $b = [System.Text.Encoding]::UTF8.GetBytes($data)
        $out = $enc.TransformFinalBlock($b, 0, $b.Length)
        [System.IO.File]::WriteAllBytes($VaultFile, ($salt + $out))
        $meta = @{ created=(Get-Date -Format 'o'); version=1; keys=@("github_pat_pci5") } | ConvertTo-Json
        [System.IO.File]::WriteAllText($MetaFile, $meta, [System.Text.UTF8Encoding]::new($false))
        $decoy = "TRANSMISI DARI NEBULA X-9`nSinyal Anda terdeteksi.`nData terenkripsi dengan kunci yang tidak Anda miliki.`nAlien signature: 0xDEADBEEF"
        [System.IO.File]::WriteAllText($DecoyFile, $decoy, [System.Text.UTF8Encoding]::new($false))
        [System.IO.File]::WriteAllBytes("$DataDir\vault.sha256", [System.Text.Encoding]::ASCII.GetBytes((Get-FileHash $VaultFile -Algorithm SHA256).Hash))
        Write-Host "[VAULT] Dibuat. Jangan lupa passphrase." -ForegroundColor Green
    }

    'SetToken' {
        if (-not (Test-Path $VaultFile)) { Write-Host "[VAULT] Belum ada."; break }
        $pass = Get-Pass
        $raw = [System.IO.File]::ReadAllBytes($VaultFile)
        $salt = $raw[0..15]; $enc = $raw[16..($raw.Length-1)]
        $dk = Derive-Key $pass $salt
        $aes = [System.Security.Cryptography.Aes]::Create()
        $aes.Mode='CBC'; $aes.Padding='PKCS7'; $aes.Key=$dk.Key; $aes.IV=$dk.IV
        try {
            $dec = $aes.CreateDecryptor()
            $plain = [System.Text.Encoding]::UTF8.GetString($dec.TransformFinalBlock($enc,0,$enc.Length))
            $obj = $plain | ConvertFrom-Json
        } catch {
            Get-Content $DecoyFile -Raw; break
        }
        $token = Read-Host "Token GitHub (tidak muncul di layar)" -AsSecureString
        $obj.$Key = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [Runtime.InteropServices.Marshal]::SecureStringToBSTR($token))
        $new = $obj | ConvertTo-Json -Compress
        $salt2 = New-Object byte[] 16
        [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($salt2)
        $dk2 = Derive-Key $pass $salt2
        $aes2 = [System.Security.Cryptography.Aes]::Create()
        $aes2.Mode='CBC'; $aes2.Padding='PKCS7'; $aes2.Key=$dk2.Key; $aes2.IV=$dk2.IV
        $b = [System.Text.Encoding]::UTF8.GetBytes($new)
        $out = $aes2.CreateEncryptor().TransformFinalBlock($b,0,$b.Length)
        [System.IO.File]::WriteAllBytes($VaultFile, ($salt2 + $out))
        [System.IO.File]::WriteAllBytes("$DataDir\vault.sha256", [System.Text.Encoding]::ASCII.GetBytes((Get-FileHash $VaultFile -Algorithm SHA256).Hash))
        Write-Host "[VAULT] Token '$Key' disimpan terenkripsi." -ForegroundColor Green
    }

    'ShowMeta' { if (Test-Path $MetaFile) { Get-Content $MetaFile } }
    'ShowDecoy' { Get-Content $DecoyFile -Raw }
}