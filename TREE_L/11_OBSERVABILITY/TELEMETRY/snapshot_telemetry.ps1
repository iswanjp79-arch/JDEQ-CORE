# Telemetry snapshot ringan
$ram = Get-CimInstance Win32_OperatingSystem
$diskC = Get-PSDrive C
[PSCustomObject]@{
    ram_free_gb = [math]::Round($ram.FreePhysicalMemory/1MB,2)
    ssd_c_free_gb = [math]::Round($diskC.Free/1GB,2)
    cpu_load_percent = (Get-CimInstance Win32_Processor).LoadPercentage
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
} | ConvertTo-Json | Out-File "D:\MICO_SSOT\TREE_L\11_OBSERVABILITY\TELEMETRY\telemetry_snapshot.json"
Write-Output "TELEMETRY SNAPSHOT DIBUAT"
