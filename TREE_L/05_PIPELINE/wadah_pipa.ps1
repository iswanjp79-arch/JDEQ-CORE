# wadah_pipa.ps1 — Peluncur terlindung untuk watchdog_pipeline.py
param(
    [string]$Priority = "AboveNormal"
)

$ScriptPath = "D:\MICO_SSOT\TREE_L\05_PIPELINE\watchdog_pipeline.py"

# Cegah duplikasi proses
$existing = Get-CimInstance Win32_Process -Filter "Name='python.exe'" -ErrorAction SilentlyContinue |
    Where-Object { $_.CommandLine -like "*watchdog_pipeline.py*" }
if ($existing) {
    Write-Output "Watchdog sudah berjalan. PID: $($existing.ProcessId)"
    exit
}

$p = Start-Process -FilePath "python" -ArgumentList "`"$ScriptPath`"" -WindowStyle Hidden -PassThru
$p.PriorityClass = $Priority
$p.ProcessorAffinity = 0xE  # Core 1-3, sisakan core 0 untuk UI Windows

Write-Output "Watchdog diluncurkan. PID: $($p.Id) | Prioritas: $Priority | Affinity: 0xE"
Write-Output "Pipa terlindung dari beban tanah Windows."
