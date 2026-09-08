# heartbeat_silent.ps1 — Heartbeat MICO-JDEQ (silent single-run)
$base = "D:\MICO_SSOT\TREE_L"
$evDir = "$base\08_EVIDENCE\RUNTIME"

$cpu = (Get-CimInstance Win32_Processor).LoadPercentage
$free = [math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1KB, 2)
$time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$status = "ALIVE"

$logFile = Join-Path $evDir "HEARTBEAT_$(Get-Date -Format 'yyyyMMdd').log"
"[$time] STATUS=$status CPU=$cpu% RAM_FREE=$free MB" | Out-File -FilePath $logFile -Append -Encoding UTF8
