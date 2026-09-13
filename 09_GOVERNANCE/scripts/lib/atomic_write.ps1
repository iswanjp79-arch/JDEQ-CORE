# atomic_write.ps1 — MICO-L4 M1
# Host gate: KAPAL-INDUK
# Atomic publication: .tmp -> flush -> rename (same volume)
function Write-AtomicFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Destination,
        [Parameter(Mandatory)][byte[]]$Content,
        [string]$LogPath = 'D:\MICO_SSOT\08_EVIDENCE\l4-m1\atomic_write.log',
        [switch]$WhatIf
    )
    $entry = [ordered]@{
        ts=(Get-Date).ToString('o'); host=$env:COMPUTERNAME; dest=$Destination
        tmp=$null; bytes=$Content.Length; status='UNKNOWN'; reason=$null; dry_run=[bool]$WhatIf
    }
    if ($env:COMPUTERNAME -ne 'KAPAL-INDUK') {
        $entry.status='BLOCKED'; $entry.reason='host_mismatch'; _AWriteLog $LogPath $entry; return $entry }
    $destDir = Split-Path -Parent $Destination
    if (-not (Test-Path $destDir)) {
        $entry.status='HOLD'; $entry.reason='destination_dir_missing'; _AWriteLog $LogPath $entry; return $entry }
    if (Test-Path $Destination) {
        $entry.status='HOLD'; $entry.reason='destination_exists'; _AWriteLog $LogPath $entry; return $entry }
    $destName = Split-Path -Leaf $Destination
    $tmpPath  = Join-Path $destDir ".$destName.tmp"
    $entry.tmp = $tmpPath
    try {
        $dr = [System.IO.Path]::GetPathRoot($destDir)
        $tr = [System.IO.Path]::GetPathRoot($tmpPath)
        if ($dr -ne $tr) { $entry.status='BLOCKED'; $entry.reason='cross_volume'; _AWriteLog $LogPath $entry; return $entry }
    } catch {
        $entry.status='BLOCKED'; $entry.reason='volume_check_failed'; _AWriteLog $LogPath $entry; return $entry }
    if ($WhatIf) { $entry.status='DRY_RUN_OK'; _AWriteLog $LogPath $entry; return $entry }
    try {
        $fs = [System.IO.FileStream]::new(
            $tmpPath,[System.IO.FileMode]::Create,[System.IO.FileAccess]::Write,
            [System.IO.FileShare]::None,4096,[System.IO.FileOptions]::WriteThrough)
        try { $fs.Write($Content,0,$Content.Length); $fs.Flush($true) } finally { $fs.Close() }
        [System.IO.File]::Move($tmpPath,$Destination)
        $entry.status='OK'
    } catch {
        $stamp = (Get-Date).ToString('yyyyMMdd')
        $inc = "D:\MICO_SSOT\08_EVIDENCE\incomplete\$stamp"
        New-Item -ItemType Directory -Force -Path $inc | Out-Null
        if (Test-Path $tmpPath) {
            $stash = "$destName.$((Get-Date).ToString('yyyyMMdd_HHmmss')).tmp"
            Move-Item -Force $tmpPath (Join-Path $inc $stash) -ErrorAction SilentlyContinue
        }
        $entry.status='BLOCKED'; $entry.reason=$_.Exception.Message
    }
    _AWriteLog $LogPath $entry
    return $entry
}
function _AWriteLog {
    param([string]$LogPath,$Entry)
    $d = Split-Path -Parent $LogPath
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
    ($Entry | ConvertTo-Json -Compress) | Add-Content -Path $LogPath -Encoding utf8
}
