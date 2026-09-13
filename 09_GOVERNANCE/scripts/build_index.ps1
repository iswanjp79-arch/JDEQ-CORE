# build_index.ps1 — MICO-L4 M3
# Derived index. Rebuildable. Never authoritative.

function Build-L4Index {
    [CmdletBinding()]
    param(
        [string]$Root     = 'D:\MICO_SSOT\08_EVIDENCE',
        [string]$IndexDir = 'D:\MICO_SSOT\09_INDEX',
        [string]$LogPath  = 'D:\MICO_SSOT\08_EVIDENCE\l4-m3\build_index.log',
        [switch]$WhatIf
    )
    $entry = [ordered]@{
        ts=(Get-Date).ToString('o'); host=$env:COMPUTERNAME
        root=$Root; index_dir=$IndexDir; total_files=0
        indexed=0; orphan=0; conflict=0; skipped=0
        status='UNKNOWN'; reason=$null; dry_run=[bool]$WhatIf
    }
    if ($env:COMPUTERNAME -ne 'KAPAL-INDUK') {
        $entry.status='BLOCKED'; $entry.reason='host_mismatch'; _M3Log $LogPath $entry; return $entry }
    if (-not (Test-Path $Root)) {
        $entry.status='BLOCKED'; $entry.reason='root_missing'; _M3Log $LogPath $entry; return $entry }
    if (-not (Test-Path $IndexDir)) {
        New-Item -ItemType Directory -Force -Path $IndexDir | Out-Null
    }
    # Canonical zones only
    $canonicalTop = @('BUFFER','STAGING','LIVE','RETAIN','QUARANTINE','DISPOSABLE','GLOBAL','incomplete')
    $nodes = @('HP_Mini','Z83','Vivo','Infinix','Aspire')
    # Collect target files: canonical zone only, skip GLOBAL (protected, not indexed here)
    $files = Get-ChildItem $Root -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
        $p = $_.FullName
        $rel = $p.Substring($Root.Length).TrimStart('\')
        $top = ($rel -split '\\')[0]
        ($canonicalTop -contains $top) -and ($top -ne 'GLOBAL')
    }
    $entry.total_files = $files.Count
    $records = New-Object System.Collections.Generic.List[object]
    foreach ($f in $files) {
        try {
            $rel = $f.FullName.Substring($Root.Length).TrimStart('\')
            $parts = $rel -split '\\'
            $zone = $parts[0]
            $node = if ($parts.Length -ge 2 -and $nodes -contains $parts[1]) { $parts[1] } else { 'UNKNOWN' }
            $hash = (Get-FileHash -Path $f.FullName -Algorithm SHA256).Hash.ToLower()
            $rid  = [System.BitConverter]::ToString(
                [System.Security.Cryptography.SHA256]::Create().ComputeHash(
                    [System.Text.Encoding]::UTF8.GetBytes($rel))).Replace('-','').ToLower()
            $rec = [ordered]@{
                artifact_id     = $rid.Substring(0,16)
                source_node     = $node
                file_path       = $f.FullName
                relative_path   = $rel
                sha256_hash     = $hash
                last_write_time = $f.LastWriteTimeUtc.ToString('o')
                size_bytes      = $f.Length
                retention_class = $zone
                zone            = $zone
            }
            $records.Add($rec) | Out-Null
            $entry.indexed = $entry.indexed + 1
        } catch {
            $entry.skipped = $entry.skipped + 1
        }
    }
    if ($WhatIf) {
        $entry.status='DRY_RUN_OK'; _M3Log $LogPath $entry; return $entry
    }
    $indexFile = Join-Path $IndexDir 'index.json'
    $payload = [ordered]@{
        generated_at = (Get-Date).ToString('o')
        host         = $env:COMPUTERNAME
        root         = $Root
        count        = $records.Count
        records      = $records
    }
    try {
        $json = $payload | ConvertTo-Json -Depth 6
        $tmp  = Join-Path $IndexDir 'index.json.tmp'
        $json | Out-File -FilePath $tmp -Encoding utf8
        if (Test-Path $indexFile) { Remove-Item -Force $indexFile }
        Move-Item -Force $tmp $indexFile
        $entry.status='OK'
    } catch {
        $entry.status='BLOCKED'; $entry.reason=$_.Exception.Message
    }
    _M3Log $LogPath $entry
    return $entry
}

function _M3Log {
    param([string]$LogPath,$Entry)
    $d = Split-Path -Parent $LogPath
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
    ($Entry | ConvertTo-Json -Compress) | Add-Content -Path $LogPath -Encoding utf8
}
