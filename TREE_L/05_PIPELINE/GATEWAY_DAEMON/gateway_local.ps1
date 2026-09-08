# gateway_local.ps1 — Pemantau Port/Socket Lokal (Read-Only)
$node = "KAPAL-INDUK"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$log = @()
$log += "=== GATEWAY LOCAL REPORT ==="
$log += "Waktu: $timestamp"
$log += "Node: $node"
$log += ""

# Cek port penting lokal
$ports = @(
    @{ Port = 8022; Nama = "SSH Windows" },
    @{ Port = 22;   Nama = "SSH WSL" },
    @{ Port = 1883; Nama = "Mosquitto" },
    @{ Port = 8080; Nama = "Tandon HTTP" },
    @{ Port = 11434; Nama = "Ollama/LLM" },
    @{ Port = 5037; Nama = "ADB" },
    @{ Port = 3240; Nama = "USBIP" }
)

foreach ($p in $ports) {
    $listen = Get-NetTCPConnection -LocalPort $p.Port -State Listen -ErrorAction SilentlyContinue
    if ($listen) {
        $owner = (Get-Process -Id $listen.OwningProcess -ErrorAction SilentlyContinue).ProcessName
        $log += ("[{0}] {1} : LISTEN (owner: {2})" -f $p.Port, $p.Nama, $owner)
    } else {
        $log += ("[{0}] {1} : TIDAK LISTEN" -f $p.Port, $p.Nama)
    }
}

$log += ""
$log += "=== BATASAN ==="
$log += "Tidak ada port eksternal dibuka. Hanya localhost/Tailscale."

$logFile = Join-Path (Split-Path $MyInvocation.MyCommand.Path -Parent) "gateway_report.log"
$log | Out-File -FilePath $logFile -Encoding UTF8
$log | Write-Output
