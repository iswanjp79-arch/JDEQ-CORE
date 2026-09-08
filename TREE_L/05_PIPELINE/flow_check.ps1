# flow_check.ps1 — Pemeriksa Alur Lantai 1 (Read-Only)

$base = "D:\MICO_SSOT\TREE_L"
$kolom = @(
    @{ Nama = "K1 Gateway"; Folder = "$base\05_PIPELINE\GATEWAY_DAEMON" },
    @{ Nama = "K2 Tandon"; Folder = "$base\04_APLIKASI\LOCAL_SERVER" },
    @{ Nama = "KP1 Sanitasi"; Folder = "$base\06_RUNTIME\SANITATION_DAEMON" },
    @{ Nama = "KP2 Rclone"; Folder = "$base\05_PIPELINE\SYNC_RCLONE" }
)

$ports = @(8022, 22, 1883, 8080, 11434, 5037, 3240)

$log = @()
$log += "=== FLOW CHECK LANTAI 1 ==="
$log += "Waktu: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

foreach ($k in $kolom) {
    if (Test-Path $k.Folder) {
        $log += "[$($k.Nama)] FOLDER ADA"
    } else {
        $log += "[$($k.Nama)] FOLDER TIDAK ADA"
    }
}

$log += ""
$log += "=== PORT UTAMA ==="
foreach ($p in $ports) {
    $listener = Get-NetTCPConnection -LocalPort $p -State Listen -ErrorAction SilentlyContinue
    if ($listener) {
        $log += "Port $p : LISTEN"
    } else {
        $log += "Port $p : TIDAK LISTEN"
    }
}

$log += ""
$free = [math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1KB, 2)
$log += "Free RAM: $free MB"

$log | Out-File "$base\08_EVIDENCE\RUNTIME\FLOW_CHECK_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt" -Encoding UTF8
$log | Write-Output
