$ram = Get-CimInstance Win32_OperatingSystem
$totalRam = [math]::Round($ram.TotalVisibleMemorySize/1MB,2)
$freeRam  = [math]::Round($ram.FreePhysicalMemory/1MB,2)
$pctRamFree = [math]::Round(($freeRam/$totalRam)*100,2)

$diskC = Get-PSDrive C
$totalC = [math]::Round(($diskC.Used+$diskC.Free)/1GB,2)
$freeC  = [math]::Round($diskC.Free/1GB,2)
$pctCFree = [math]::Round(($diskC.Free/1GB/$totalC)*100,2)

Write-Output "RAM Free: $freeRam GB ($pctRamFree %) | SSD C Free: $freeC GB ($pctCFree %)"

if ($pctCFree -lt 20) {
    Write-Output "WARNING: Free SSD C kurang dari 20%" -ForegroundColor Red
}
elseif ($pctCFree -lt 35) {
    Write-Output "INFO: Free SSD C antara 20-35%" -ForegroundColor Yellow
}
else {
    Write-Output "OK: Free SSD C di atas 35%" -ForegroundColor Green
}
