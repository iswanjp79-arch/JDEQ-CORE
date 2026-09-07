$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor
$diskC = Get-PSDrive C
$diskD = Get-PSDrive D -ErrorAction SilentlyContinue

$baseline = [PSCustomObject]@{
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    node = "KAPAL-INDUK"
    os = $os.Caption + " " + $os.Version
    os_arch = $os.OSArchitecture
    cpu = $cpu.Name.Trim()
    cpu_cores = $cpu.NumberOfCores
    cpu_threads = $cpu.NumberOfLogicalProcessors
    ram_total_gb = [math]::Round($os.TotalVisibleMemorySize/1MB,2)
    ram_free_gb = [math]::Round($os.FreePhysicalMemory/1MB,2)
    c_total_gb = [math]::Round(($diskC.Used+$diskC.Free)/1GB,2)
    c_free_gb = [math]::Round($diskC.Free/1GB,2)
    c_free_percent = [math]::Round(($diskC.Free/1GB)/(($diskC.Used+$diskC.Free)/1GB)*100,2)
    d_total_gb = if ($diskD) { [math]::Round(($diskD.Used+$diskD.Free)/1GB,2) } else { 0 }
    d_free_gb = if ($diskD) { [math]::Round($diskD.Free/1GB,2) } else { 0 }
}

$out = "D:\MICO_SSOT\TREE_L\01_FISIK\RESOURCE_BASELINE\baseline_audit_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".json"
$baseline | ConvertTo-Json | Out-File $out -Encoding UTF8
Write-Output "BASELINE JSON: $out"
