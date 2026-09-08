# SLUMP_TEST_K1.ps1 — Uji Beban Statis Kolom K1 (API Gateway)
# Simulasi beban 150 MB selama 300 detik, monitoring tiap 10 detik.

$alokasiMB = 150
$durasiDetik = 300
$intervalDetik = 10
$iterasi = [int]($durasiDetik / $intervalDetik)

$evidenceDir = "D:\MICO_SSOT\TREE_L\08_EVIDENCE\RUNTIME"
New-Item -ItemType Directory -Path $evidenceDir -Force | Out-Null

# 1. Alokasi memori statis
$bytes = [byte[]]::new($alokasiMB * 1024 * 1024)
$procId = $PID

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logFile = Join-Path $evidenceDir "SLUMP_TEST_K1_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
"[$timestamp] SLUMP TEST K1 DIMULAI" | Tee-Object -FilePath $logFile -Append

# 2. Loop monitoring
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

# 3. Hancurkan variabel, paksa GC
$bytes = $null
[GC]::Collect()
[GC]::WaitForPendingFinalizers()
[GC]::Collect()

Start-Sleep -Seconds 2

$finalFree = [math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1KB, 2)
$finalProc = [math]::Round((Get-Process -Id $procId).WorkingSet64 / 1MB, 2)
$endTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$finalLine = "[$endTime] SLUMP TEST K1 SELESAI | Free RAM: $finalFree MB | Process RAM: $finalProc MB"
Write-Output $finalLine
$finalLine | Tee-Object -FilePath $logFile -Append
