# mico_sleep.ps1 — Bounded Timing Control (PowerShell)
# Fungsi: Invoke-MicoSleep
# Fitur: Random sleep 1-15 detik, CPU-aware perpanjang max, backoff error.

function Get-CpuLoad {
    return (Get-CimInstance Win32_Processor).LoadPercentage
}

function Invoke-MicoSleep {
    param(
        [int]$BaseSleepMin = 1,
        [int]$BaseSleepMax = 15,
        [int]$BackoffLevel = 0
    )

    # Backoff: 2^level, max 30
    if ($BackoffLevel -gt 0) {
        $backoff = [Math]::Min([Math]::Pow(2, $BackoffLevel), 30)
        $min = 1
        $max = [int]$backoff
    } else {
        $min = $BaseSleepMin
        $max = $BaseSleepMax
    }

    # CPU-Aware
    $cpu = Get-CpuLoad
    if ($cpu -gt 50) {
        $max = [Math]::Max($max, 30)
    }

    $sleep = Get-Random -Minimum $min -Maximum ($max + 1)
    Start-Sleep -Seconds $sleep
}
