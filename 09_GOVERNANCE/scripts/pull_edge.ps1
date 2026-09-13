# pull_edge.ps1 — MICO-L4 M5
# Sovereign pull-only. Dry-run by default. Uses M1 atomic write + M2 gate.

. "D:\MICO_SSOT\09_GOVERNANCE\scripts\lib\atomic_write.ps1"
. "D:\MICO_SSOT\09_GOVERNANCE\scripts\lib\host_gate.ps1"

function Invoke-PullEdge {
    [CmdletBinding()]
    param(
        [string]$NodeName    = 'HP_Mini',
        [string]$RemoteHost  = 'iswanjp@192.168.1.6',
        [string]$RemotePath  = '/var/spool/mico/metrics.json',
        [string]$Root        = 'D:\MICO_SSOT\08_EVIDENCE',
        [string]$LogPath     = 'D:\MICO_SSOT\08_EVIDENCE\l4-m5\pull.log',
        [switch]$Execute
    )
    $entry = [ordered]@{
        ts=(Get-Date).ToString('o'); host=$env:COMPUTERNAME
        node=$NodeName; remote="$RemoteHost`:$RemotePath"
        destination=$null; bytes=0; sha256_local=$null
        sha256_remote=$null; status='UNKNOWN'; reason=$null; dry_run=(-not $Execute)
    }

    # Host gate
    $hg = Test-HostGate -LogPath "$Root\l4-m5\host_gate.log"
    if ($hg.status -ne 'OK') {
        $entry.status='BLOCKED'; $entry.reason='host_gate_failed'
        _M5Log $LogPath $entry; return $entry }

    # Destination
    $destDir = Join-Path $Root "BUFFER\$NodeName"
    $destFile = Join-Path $destDir ("metrics_{0}.json" -f (Get-Date -Format 'yyyyMMdd_HHmmss'))
    $entry.destination = $destFile

    # Path guard
    $pg = Test-PathGuard -Path $destFile -LogPath "$Root\l4-m5\path_guard.log"
    if ($pg.status -ne 'OK') {
        $entry.status='BLOCKED'; $entry.reason="path_guard:" + $pg.reason
        _M5Log $LogPath $entry; return $entry }

    if (-not $Execute) {
        $entry.status='DRY_RUN_OK'
        _M5Log $LogPath $entry; return $entry }

    # Ensure dest dir
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Force -Path $destDir | Out-Null }

    # Remote hash
    try {
        $remoteHash = (& ssh -o BatchMode=yes -o ConnectTimeout=10 $RemoteHost "sha256sum $RemotePath | awk '{print `$1}'") 2>$null
        if (-not $remoteHash) { throw 'remote_hash_empty' }
        $entry.sha256_remote = $remoteHash.Trim()
    } catch {
        $entry.status='BLOCKED'; $entry.reason='remote_hash_failed'
        _M5Log $LogPath $entry; return $entry }

    # Fetch bytes
    try {
        $tmpRemote = [System.IO.Path]::GetTempFileName()
        & scp -o BatchMode=yes -o ConnectTimeout=10 "${RemoteHost}:${RemotePath}" $tmpRemote 2>$null
        if (-not (Test-Path $tmpRemote)) { throw 'scp_failed' }
        $bytes = [System.IO.File]::ReadAllBytes($tmpRemote)
        Remove-Item -Force $tmpRemote -ErrorAction SilentlyContinue
        $entry.bytes = $bytes.Length
    } catch {
        $entry.status='BLOCKED'; $entry.reason='transfer_failed'
        _M5Log $LogPath $entry; return $entry }

    # Local hash
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $hashBytes = $sha.ComputeHash($bytes)
    $entry.sha256_local = ([System.BitConverter]::ToString($hashBytes)).Replace('-','').ToLower()

    if ($entry.sha256_local -ne $entry.sha256_remote) {
        $entry.status='BLOCKED'; $entry.reason='hash_mismatch'
        _M5Log $LogPath $entry; return $entry }

    # Atomic write via M1
    $aw = Write-AtomicFile -Destination $destFile -Content $bytes -LogPath "$Root\l4-m5\atomic_write.log"
    if ($aw.status -ne 'OK') {
        $entry.status='BLOCKED'; $entry.reason="atomic_write:" + $aw.reason
        _M5Log $LogPath $entry; return $entry }

    $entry.status='OK'
    _M5Log $LogPath $entry
    return $entry
}

function _M5Log {
    param([string]$LogPath,$Entry)
    $d = Split-Path -Parent $LogPath
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
    ($Entry | ConvertTo-Json -Compress) | Add-Content -Path $LogPath -Encoding utf8
}
