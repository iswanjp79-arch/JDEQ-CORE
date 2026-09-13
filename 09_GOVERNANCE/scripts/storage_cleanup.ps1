# storage_cleanup.ps1 — MICO-L4 M4
# Disposable-only sweeper. Never touches BUFFER/LIVE/RETAIN/GLOBAL.

function Invoke-StorageCleanup {
    [CmdletBinding()]
    param(
        [string]$Root            = 'D:\MICO_SSOT\08_EVIDENCE',
        [string]$Drive           = 'D',
        [int]$PressureThreshold  = 85,
        [double]$DisposalRatio   = 0.20,
        [string]$LogPath         = 'D:\MICO_SSOT\08_EVIDENCE\l4-m4\cleanup.log',
        [switch]$WhatIf
    )
    $entry = [ordered]@{
        ts=(Get-Date).ToString('o'); host=$env:COMPUTERNAME
        disk_pct=0; trigger=$false
        candidates=0; selected=0; deleted=0; failed=0
        status='UNKNOWN'; reason=$null; dry_run=[bool]$WhatIf
    }
    if ($env:COMPUTERNAME -ne 'KAPAL-INDUK') {
        $entry.status='BLOCKED'; $entry.reason='host_mismatch'
        _M4Log $LogPath $entry; return $entry }

    $d = Get-PSDrive $Drive -ErrorAction SilentlyContinue
    if (-not $d) {
        $entry.status='BLOCKED'; $entry.reason='drive_missing'
        _M4Log $LogPath $entry; return $entry }
    $total = $d.Used + $d.Free
    $pct = [math]::Round(($d.Used / $total) * 100, 2)
    $entry.disk_pct = $pct

    if ($pct -lt $PressureThreshold) {
        $entry.status='OK'; $entry.reason='below_threshold'
        _M4Log $LogPath $entry; return $entry }

    $entry.trigger = $true
    $dispo = Join-Path $Root 'DISPOSABLE'
    if (-not (Test-Path $dispo)) {
        $entry.status='OK'; $entry.reason='disposable_zone_empty'
        _M4Log $LogPath $entry; return $entry }

    $files = Get-ChildItem $dispo -File -ErrorAction SilentlyContinue |
             Sort-Object LastWriteTime -Descending
    $entry.candidates = $files.Count
    if ($files.Count -eq 0) {
        $entry.status='OK'; $entry.reason='no_candidates'
        _M4Log $LogPath $entry; return $entry }

    $take = [math]::Max(1, [math]::Floor($files.Count * $DisposalRatio))
    $targets = $files | Select-Object -Last $take
    $entry.selected = $targets.Count

    if ($WhatIf) {
        $entry.status='DRY_RUN_OK'
        _M4Log $LogPath $entry; return $entry }

    foreach ($f in $targets) {
        try {
            Remove-Item -LiteralPath $f.FullName -Force -ErrorAction Stop
            $entry.deleted = $entry.deleted + 1
        } catch {
            $entry.failed = $entry.failed + 1
        }
    }
    if ($entry.failed -gt 0) {
        $entry.status='BLOCKED'; $entry.reason='partial_failure'
    } else {
        $entry.status='OK'
    }
    _M4Log $LogPath $entry
    return $entry
}

function _M4Log {
    param([string]$LogPath,$Entry)
    $d = Split-Path -Parent $LogPath
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
    ($Entry | ConvertTo-Json -Compress) | Add-Content -Path $LogPath -Encoding utf8
}
