# trip_switch.ps1 — Autonomous Trip-Switch aman (single-run, stateful)
# Tidak loop abadi. Dipanggil oleh Task Scheduler atau manual.
# State disimpan di JSON, counter reset jika normal.

$base = "D:\MICO_SSOT\TREE_L"
$evDir = "$base\08_EVIDENCE\RUNTIME"
$stateFile = "$base\06_RUNTIME\trip_state.json"

$whitelist = @("Tailscale", "sshd", "pwsh", "System", "Idle", "python", "conhost")
$thresholdCpu = 85
$thresholdRamFreeMB = 500
$maxCycles = 3

# Baca state sebelumnya
$cycles = 0
if (Test-Path $stateFile) {
    $state = Get-Content $stateFile -Raw -Encoding UTF8 | ConvertFrom-Json
    $cycles = $state.cycles
}

# Baca kondisi saat ini
$cpu = (Get-CimInstance Win32_Processor).LoadPercentage
$freeRamMB = [math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1KB, 2)

# Evaluasi anomali
$anomali = ($cpu -gt $thresholdCpu) -or ($freeRamMB -lt $thresholdRamFreeMB)

if (-not $anomali) {
    $cycles = 0
} else {
    $cycles++
}

# Simpan state
@{ cycles = $cycles; last_cpu = $cpu; last_free_ram_mb = $freeRamMB; timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss" } |
    ConvertTo-Json | Set-Content -Path $stateFile -Encoding UTF8

if ($cycles -ge $maxCycles) {
    $target = Get-Process -ErrorAction SilentlyContinue |
        Where-Object { $whitelist -notcontains $_.ProcessName } |
        Sort-Object CPU -Descending |
        Select-Object -First 1

    if ($target) {
        $logFile = Join-Path $evDir "TRIP_SWITCH_LOG_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
        @"
=== TRIP SWITCH ACTION ===
Waktu: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
CPU Load: $cpu%
Free RAM: $freeRamMB MB
Proses dihentikan: $($target.ProcessName) (PID $($target.Id))
White-list: $($whitelist -join ', ')
"@ | Out-File -FilePath $logFile -Encoding UTF8

        Stop-Process -Id $target.Id -Force -ErrorAction SilentlyContinue
        Write-Output "TRIP: $($target.ProcessName) dihentikan."
    } else {
        $logFile = Join-Path $evDir "TRIP_SWITCH_LOG_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
        "Waktu: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`nCPU Load: $cpu%`nFree RAM: $freeRamMB MB`nStatus: NO_ACTION" |
            Out-File -FilePath $logFile -Encoding UTF8
        Write-Output "NO_ACTION: tidak ada proses target."
    }

    # Reset state setelah tindakan
    @{ cycles = 0; last_cpu = $cpu; last_free_ram_mb = $freeRamMB; timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss" } |
        ConvertTo-Json | Set-Content -Path $stateFile -Encoding UTF8
}
