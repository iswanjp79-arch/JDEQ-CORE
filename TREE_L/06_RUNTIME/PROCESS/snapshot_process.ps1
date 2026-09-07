$procs = Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, Id, CPU, WorkingSet64
$procs | ConvertTo-Json | Out-File "D:\MICO_SSOT\TREE_L\06_RUNTIME\PROCESS\process_snapshot.json"
Write-Output "PROCESS SNAPSHOT DIBUAT"
