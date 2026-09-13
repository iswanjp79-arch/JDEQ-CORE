# host_gate.ps1 — MICO-L4 M2
# Host verification + Path protection (GLOBAL/WORM/extension)

function Test-HostGate {
    [CmdletBinding()]
    param(
        [string]$Expected = 'KAPAL-INDUK',
        [string]$LogPath  = 'D:\MICO_SSOT\08_EVIDENCE\l4-m2\host_gate.log'
    )
    $entry = [ordered]@{
        ts=(Get-Date).ToString('o'); check='host'; computer=$env:COMPUTERNAME
        expected=$Expected; status='UNKNOWN'; reason=$null
    }
    if ($env:COMPUTERNAME -ne $Expected) {
        $entry.status='BLOCKED'; $entry.reason='host_mismatch'
    } else {
        $entry.status='OK'
    }
    _M2Log $LogPath $entry
    return $entry
}

function Test-PathGuard {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [string]$LogPath = 'D:\MICO_SSOT\08_EVIDENCE\l4-m2\path_guard.log'
    )
    $entry = [ordered]@{
        ts=(Get-Date).ToString('o'); check='path'; path=$Path
        status='UNKNOWN'; reason=$null; extension=$null
    }
    $norm = $Path -replace '/','\'
    if ($norm -match '\\GLOBAL\\') {
        $entry.status='BLOCKED'; $entry.reason='global_zone_protected'
        _M2Log $LogPath $entry; return $entry
    }
    if ($norm -match '\\LIVE\\') {
        $entry.status='BLOCKED'; $entry.reason='worm_zone_live'
        _M2Log $LogPath $entry; return $entry
    }
    if ($norm -match '\\RETAIN\\') {
        $entry.status='BLOCKED'; $entry.reason='worm_zone_retain'
        _M2Log $LogPath $entry; return $entry
    }
    $ext = [System.IO.Path]::GetExtension($Path).ToLower()
    $entry.extension = $ext
    $allow = @('.json','.md','.txt')
    if ($allow -notcontains $ext) {
        $entry.status='BLOCKED'; $entry.reason='extension_not_whitelisted'
        _M2Log $LogPath $entry; return $entry
    }
    $entry.status='OK'
    _M2Log $LogPath $entry
    return $entry
}

function _M2Log {
    param([string]$LogPath,$Entry)
    $d = Split-Path -Parent $LogPath
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
    ($Entry | ConvertTo-Json -Compress) | Add-Content -Path $LogPath -Encoding utf8
}
