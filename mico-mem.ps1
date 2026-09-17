# ============================================================
# mico-mem.ps1 - Memory Operations (REV2 - with evidence)
# Setiap add: tulis memory ke 02_DATA + evidence ke 08_EVIDENCE
# ============================================================

param(
    [Parameter(Position=0)]
    [string]$Action = 'help',

    [string]$Category = '',
    [string]$Title = '',
    [string]$Body = '',
    [string]$Keyword = '',
    [string]$Id = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------- PATH ----------
$SSOTRoot  = 'D:\MICO_SSOT'
$MemRoot   = Join-Path $SSOTRoot '02_DATA\LOCAL_MEMORY'
$EvidRoot  = Join-Path $SSOTRoot '08_EVIDENCE\MEMORY\MEMORY_EVENTS'
$AgentId   = 'L0'
$Authority = 'L0'
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# ---------- CATEGORY MAP ----------
$CatMap = @{
    PRF  = 'PROFILE'
    PREF = 'PREFERENCES'
    DEC  = 'DECISIONS'
    LRN  = 'LEARNING'
    CTX  = 'PROJECT_CONTEXT'
    SESS = 'SESSIONS'
}

# ---------- HELPERS ----------
function Show-Help {
    Write-Host ""
    Write-Host "MICO MEMORY - Command Reference"
    Write-Host ""
    Write-Host "  init                              Inisialisasi folder"
    Write-Host "  add -Category -Title -Body        Tambah memory + evidence"
    Write-Host "  search -Keyword                   Cari memory"
    Write-Host "  list [-Category]                  List semua/partial"
    Write-Host "  show -Id <memory-id>              Lihat detail + evidence"
    Write-Host ""
    Write-Host "  Categories: PRF PREF DEC LRN CTX SESS"
    Write-Host ""
}

function Get-CategoryFolder([string]$Code) {
    if ($CatMap.ContainsKey($Code)) {
        return Join-Path $MemRoot $CatMap[$Code]
    }
    throw "Kategori tidak valid: $Code"
}

function Ensure-Folder([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        New-Item -ItemType Directory -Force -Path $Path | Out-Null
    }
}

function Get-NextMemoryId([string]$Category, [string]$Folder) {
    $today = Get-Date -Format 'yyyyMMdd'
    $existing = @(Get-ChildItem -LiteralPath $Folder -Filter "$Category-$today-*.md" -ErrorAction SilentlyContinue)
    $num = '{0:D3}' -f ($existing.Count + 1)
    return "$Category-$today-$num"
}

# ---------- EVIDENCE WRITER ----------
function Write-Evidence {
    param(
        [string]$MemoryId,
        [string]$Category,
        [string]$Action,
        [string]$MemoryPath,
        [string]$MemoryHash,
        [string]$MemoryTitle
    )

    Ensure-Folder $EvidRoot

    $evidId   = "EVID-$MemoryId"
    $evidFile = Join-Path $EvidRoot "$evidId.md"
    $now      = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')

    $evidContent = @"
---
evidence_id: $evidId
event_type: MEMORY_WRITE
action: $Action
memory_id: $MemoryId
memory_category: $Category
memory_title: $MemoryTitle
created_at: $now
agent: $AgentId
authority: $Authority
memory_path: $MemoryPath
memory_hash_sha256: $MemoryHash
source_script: mico-mem.ps1
---

# Evidence: $evidId

## Ringkasan

- Event     : MEMORY_WRITE
- Action    : $Action
- Memory ID : $MemoryId
- Category  : $Category
- Title     : $MemoryTitle
- Timestamp : $now
- Agent     : $AgentId
- Authority : $Authority

## Referensi

- Memory file : $MemoryPath
- Memory hash : $MemoryHash

## Catatan

Dokumen ini adalah bukti operasional otomatis saat memory ditulis.
Dokumen ini tidak boleh diubah tanpa prosedur koreksi resmi.
"@

    [System.IO.File]::WriteAllText($evidFile, $evidContent, $Utf8NoBom)

    $evidHash = (Get-FileHash -LiteralPath $evidFile -Algorithm SHA256).Hash
    return @{
        Path = $evidFile
        Hash = $evidHash
        Id   = $evidId
    }
}

# ---------- COMMANDS ----------
function Init-Structure {
    foreach ($folder in $CatMap.Values) {
        $path = Join-Path $MemRoot $folder
        if (-not (Test-Path -LiteralPath $path)) {
            New-Item -ItemType Directory -Force -Path $path | Out-Null
            $keep = Join-Path $path '.gitkeep'
            if (-not (Test-Path -LiteralPath $keep)) {
                New-Item -ItemType File -Force -Path $keep | Out-Null
            }
            Write-Host "BUAT: $path"
        } else {
            Write-Host "ADA : $path"
        }
    }
    Ensure-Folder $EvidRoot
    Write-Host "EVID: $EvidRoot"
    Write-Host ""
    Write-Host "Struktur memory + evidence siap."
}

function Add-Memory {
    if (-not $Category -or -not $Title -or -not $Body) {
        throw "add wajib: -Category -Title -Body"
    }
    if (-not $CatMap.ContainsKey($Category)) {
        throw "Kategori tidak valid: $Category. Pilih: PRF PREF DEC LRN CTX SESS"
    }

    $folder = Get-CategoryFolder $Category
    Ensure-Folder $folder
    Ensure-Folder $EvidRoot

    $memoryId = Get-NextMemoryId $Category $folder
    $fileName = "$memoryId.md"
    $filePath = Join-Path $folder $fileName

    if (Test-Path -LiteralPath $filePath) {
        throw "Collision: file sudah ada -> $filePath"
    }

    $now = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
    $bodyIndented = ($Body -split "`n" | ForEach-Object { "    $_" }) -join "`n"

    $memContent = @"
---
memory_id: $memoryId
category: $Category
status: ACTIVE
created_at: $now
updated_at: $now
source_agent: $AgentId
authority: $Authority
content:
  title: $Title
  body: |
$bodyIndented
tags: []
related: []
retention: LONG_TERM
---

# $memoryId

Category: $Category
Title: $Title
Created: $now

## Body

$Body
"@

    [System.IO.File]::WriteAllText($filePath, $memContent, $Utf8NoBom)
    $memHash = (Get-FileHash -LiteralPath $filePath -Algorithm SHA256).Hash

    $evid = Write-Evidence `
        -MemoryId $memoryId `
        -Category $Category `
        -Action 'add' `
        -MemoryPath $filePath `
        -MemoryHash $memHash `
        -MemoryTitle $Title

    Write-Host ""
    Write-Host "OK  : Memory dibuat"
    Write-Host "ID  : $memoryId"
    Write-Host "Mem : $filePath"
    Write-Host "Hash: $memHash"
    Write-Host ""
    Write-Host "OK  : Evidence dibuat"
    Write-Host "ID  : $($evid.Id)"
    Write-Host "Evid: $($evid.Path)"
    Write-Host "Hash: $($evid.Hash)"
    Write-Host ""
}

function Search-Memory {
    if (-not $Keyword) { throw "search wajib: -Keyword" }
    Write-Host ""
    Write-Host "Cari: $Keyword"
    Write-Host ""

    $found = 0
    foreach ($folder in $CatMap.Values) {
        $path = Join-Path $MemRoot $folder
        if (-not (Test-Path -LiteralPath $path)) { continue }

        $files = @(Get-ChildItem -LiteralPath $path -Filter '*.md' -Recurse -ErrorAction SilentlyContinue)
        foreach ($f in $files) {
            $content = Get-Content -LiteralPath $f.FullName -Raw
            if ($content -match [regex]::Escape($Keyword)) {
                $found++
                Write-Host ("[{0}] {1}" -f $f.BaseName, $f.DirectoryName)
            }
        }
    }

    Write-Host ""
    Write-Host "Total: $found memory ditemukan."
    Write-Host ""
}

function List-Memory {
    Write-Host ""
    Write-Host "List memory"
    Write-Host ""

    $folders = @()
    if ($Category -and $CatMap.ContainsKey($Category)) {
        $folders = @((Get-CategoryFolder $Category))
    } else {
        foreach ($v in $CatMap.Values) { $folders += (Join-Path $MemRoot $v) }
    }

    foreach ($folder in $folders) {
        if (-not (Test-Path -LiteralPath $folder)) { continue }
        $files = @(Get-ChildItem -LiteralPath $folder -Filter '*.md' -ErrorAction SilentlyContinue | Sort-Object Name)
        if ($files.Count -eq 0) { continue }

        Write-Host ("== {0} ==" -f (Split-Path $folder -Leaf))
        foreach ($f in $files) {
            Write-Host ("  {0}" -f $f.BaseName)
        }
        Write-Host ""
    }
}

function Show-Memory {
    if (-not $Id) { throw "show wajib: -Id" }
    $foundFile = $null
    foreach ($folder in $CatMap.Values) {
        $path = Join-Path $MemRoot $folder
        $filePath = Join-Path $path "$Id.md"
        if (Test-Path -LiteralPath $filePath) {
            $foundFile = $filePath
            break
        }
    }
    if (-not $foundFile) { throw "Memory tidak ditemukan: $Id" }

    Write-Host ""
    Get-Content -LiteralPath $foundFile -Raw
    $hash = (Get-FileHash -LiteralPath $foundFile -Algorithm SHA256).Hash
    Write-Host "SHA256: $hash"
    Write-Host ""

    $evidPath = Join-Path $EvidRoot "EVID-$Id.md"
    if (Test-Path -LiteralPath $evidPath) {
        Write-Host "Evidence: $evidPath"
    } else {
        Write-Host "Evidence: (tidak ditemukan)"
    }
    Write-Host ""
}

# ---------- DISPATCH ----------
switch ($Action) {
    'init'   { Init-Structure }
    'add'    { Add-Memory }
    'search' { Search-Memory }
    'list'   { List-Memory }
    'show'   { Show-Memory }
    'help'   { Show-Help }
    default  { Show-Help }
}