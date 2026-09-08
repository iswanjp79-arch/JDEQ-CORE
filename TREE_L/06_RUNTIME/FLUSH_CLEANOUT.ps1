# FLUSH_CLEANOUT.ps1 — Katup Darurat, bukan pemutus pompa utama
$root = "D:\MICO_SSOT\TREE_L"
$quarantine = "$root\05_PIPELINE\QUARANTINE"
$evidence = "$root\08_EVIDENCE\RUNTIME"
$log = @()

$log += "=== FLUSH CLEANOUT V2 ==="
$log += "Waktu: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

# Sumber/pompa yang DILINDUNGI
$protected = @("mosquitto","tailscale","sshd","wslservice","usbipd","adb")

# Hanya proses liar yang boleh dimatikan
$targets = @("python","wscript","ollama","postgres")
foreach ($t in $targets) {
    if ($t -in $protected) { continue }
    $procs = Get-Process -Name $t -ErrorAction SilentlyContinue
    if ($procs) {
        $procs | Stop-Process -Force -ErrorAction SilentlyContinue
        $log += "MATI PAKSA: $t"
    }
}

# Karantina file INBOX mencurigakan
$inbox = "$root\05_PIPELINE\INBOX"
New-Item -ItemType Directory -Path $quarantine -Force | Out-Null
if (Test-Path $inbox) {
    Get-ChildItem $inbox -File -ErrorAction SilentlyContinue | ForEach-Object {
        Move-Item $_.FullName -Destination $quarantine -Force
        $log += "KARANTINA INBOX: $($_.Name)"
    }
}

# Hanya bersihkan STAGING, jangan CURATED
$staging = "$root\02_DATA\STAGING"
if (Test-Path $staging) {
    Get-ChildItem $staging -File -Recurse -ErrorAction SilentlyContinue |
        ForEach-Object {
            Move-Item $_.FullName -Destination $quarantine -Force
            $log += "BUANG STAGING: $($_.Name)"
        }
}

$log | Out-File "$evidence\flush_cleanout_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt" -Encoding UTF8
$log
