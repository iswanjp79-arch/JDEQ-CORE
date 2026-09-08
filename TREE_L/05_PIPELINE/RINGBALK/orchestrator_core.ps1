# orchestrator_core.ps1 — Ringbalk Core MICO-JDEQ
$base = "D:\MICO_SSOT\TREE_L"
$ringDir = "$base\05_PIPELINE\RINGBALK"
$evDir = "$base\08_EVIDENCE\RUNTIME"

$kolom = @(
    @{ Nama = "K1 Gateway"; Folder = "$base\05_PIPELINE\GATEWAY_DAEMON" },
    @{ Nama = "K2 Tandon"; Folder = "$base\04_APLIKASI\LOCAL_SERVER" },
    @{ Nama = "KP1 Sanitasi"; Folder = "$base\06_RUNTIME\SANITATION_DAEMON" },
    @{ Nama = "KP2 Rclone"; Folder = "$base\05_PIPELINE\SYNC_RCLONE" }
)

$ports = @(8022, 22, 1883, 8080, 11434, 5037, 3240)

$log = @()
$log += "=== RINGBALK CORE REPORT ==="
$log += "Waktu: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$log += "Node: KAPAL-INDUK"
$log += ""

# Status folder kolom
$log += "=== STATUS KOLOM ==="
foreach ($k in $kolom) {
    if (Test-Path $k.Folder) {
        $log += "[$($k.Nama)] TERIKAT — folder ada"
    } else {
        $log += "[$($k.Nama)] BELUM TERIKAT — folder tidak ada"
    }
}

# Status port
$log += ""
$log += "=== STATUS PORT ==="
foreach ($p in $ports) {
    $listener = Get-NetTCPConnection -LocalPort $p -State Listen -ErrorAction SilentlyContinue
    if ($listener) {
        $log += "Port $p : LISTEN"
    } else {
        $log += "Port $p : TIDAK LISTEN"
    }
}

# Beban sistem
$log += ""
$free = [math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1KB, 2)
$cpu = (Get-CimInstance Win32_Processor).LoadPercentage
$log += "Free RAM: $free MB"
$log += "CPU Load: $cpu%"

# Tulis laporan evidence
$reportPath = Join-Path $evDir "RINGBALK_CORE_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
$log | Out-File -FilePath $reportPath -Encoding UTF8
$log | Write-Output
