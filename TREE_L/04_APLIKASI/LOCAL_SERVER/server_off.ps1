# server_off.ps1 — Matikan Tandon Server secara bersih
$target = "server_on.py"
$procs = Get-CimInstance Win32_Process -Filter "Name='python.exe'" -ErrorAction SilentlyContinue |
    Where-Object { $_.CommandLine -like "*$target*" }

if (-not $procs) {
    Write-Output "Tandon Server tidak sedang berjalan."
    exit
}

foreach ($proc in $procs) {
    Stop-Process -Id $proc.ProcessId -Force -ErrorAction SilentlyContinue
    Write-Output ("Tandon Server dimatikan. PID: {0}" -f $proc.ProcessId)
}
