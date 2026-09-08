# SLUMP_TEST_KP2.ps1 — Uji Beban Statis Kolom Praktis KP2 (Rclone Sync)

$alokasiMB = 50
$durasiDetik = 300
$intervalDetik = 10
$iterasi = [int]($durasiDetik / $intervalDetik)

$evidenceDir = "D:\MICO_SSOT\TREE_L\08_EVIDENCE\RUNTIME"
New-Item -ItemType Directory -Path $evidenceDir -Force | Out-Null

$bytes = [byte[]]::new($alokasiMB * 1024 * 1024)
$procId = $PID

$logFile = Join-Path $evidenceDir "SLUMP_TEST_KP2_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
"SLUMP TEST KP2 DIMULAI" | Tee-Object -FilePath $logFile -Append

for ($i=0; $i -lt $iterasi; $i++) {
    $freeMemMB = [math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1KB, 2)
    $procMemMB = [math]::Round((Get-Process -Id $procId).WorkingSet64 / 1MB, 2)
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine = "[$time] Iterasi $($i+1)/$iterasi | Free RAM: $freeMemMB MB | Process RAM: $procMemMB MB"
    Write-Output $logLine
    $logLine | Tee-Object -FilePath $logFile -Append

    if ($i -lt $iterasi - 1) {
        Start-Sleep -Seconds $intervalDetik
    }
}

$bytes = $null
[GC]::Collect()
[GC]::WaitForPendingFinalizers()
[GC]::Collect()

Start-Sleep -Seconds 2

$finalFree = [math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1KB, 2)
$finalProc = [math]::Round((Get-Process -Id $procId).WorkingSet64 / 1MB, 2)
$endTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"[$endTime] SLUMP TEST KP2 SELESAI | Free RAM: $finalFree MB | Process RAM: $finalProc MB" | Tee-Object -FilePath $logFile -Append
