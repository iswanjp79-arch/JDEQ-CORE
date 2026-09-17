# ============================================================
# AG-003 | MICO MEMORY SYSTEM GENERATOR | FINAL
# Target : D:\MICO_SSOT\00_QUARANTINE\P1-MEMORY-SYSTEM\
# Prinsip: idempotent | UTF-8 | no Git | no SSOT write
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$SSOTRoot  = 'D:\MICO_SSOT'
$QuarRoot  = Join-Path $SSOTRoot '00_QUARANTINE'
$TargetDir = Join-Path $QuarRoot 'P1-MEMORY-SYSTEM'

# ---------- FILE 1 : DESIGN-P1-MEMORY-SYSTEM-REV1.md ----------
$File1 = @'
# MICO-JDEQ MEMORY SYSTEM - DESIGN REV1

Status: DRAFT | NOT ADOPTED | NOT RUNTIME
Tujuan: Replikasi memory jangka panjang ala Gemini, versi sovereign MICO
Perancang: AG-003

## 1. KATEGORI MEMORY

| Kode | Nama | Isi | Umur |
|---|---|---|---|
| PRF | PROFILE | Identitas, peran, konteks hidup L0 | Permanen |
| PREF | PREFERENCE | Preferensi kerja, gaya, format | Sampai diubah |
| DEC | DECISION | Keputusan sah L0 | Permanen (immutable) |
| LRN | LEARNING | Pelajaran dari insiden/kejadian | Permanen |
| CTX | PROJECT_CONTEXT | Status proyek aktif | Sampai proyek selesai |
| SESS | SESSION | Catatan sesi individual | 30 hari (dapat diarsip) |
| HOFF | HANDOFF | Serah terima antar sesi | Sampai sesi berikut |
| EVID | EVIDENCE | Bukti terverifikasi | Permanen |

## 2. FORMAT MEMORY RECORD

File: KODE-YYYYMMDD-NNN.md
Contoh: PRF-20260916-001.md

Isi ringkas:
- memory_id
- category
- status (ACTIVE | ARCHIVED | SUPERSEDED | DELETED)
- created_at
- updated_at
- source_agent
- authority
- content.title
- content.body
- tags
- retention

## 3. LIFECYCLE

CREATE -> ACTIVE -> (ARCHIVED | DELETED)
                 \-> SUPERSEDED

- CREATE : ditulis via mico-mem.ps1 add
- ACTIVE : dapat dibaca, direferensi
- ARCHIVED : dipindah ke 99_ARCHIVE, read-only
- SUPERSEDED : ditandai, digantikan record baru
- DELETED : tidak dihapus, ditandai status=DELETED

## 4. FOLDER STRUCTURE

D:\MICO_SSOT\02_DATA\LOCAL_MEMORY\
  PROFILE\
  PREFERENCES\
  DECISIONS\
  LEARNING\
  PROJECT_CONTEXT\
  TOPIC_INDEX\
  SESSIONS\
    YYYY-MM\
      SESS-YYYYMMDD-X.md
      HANDOFF-YYYYMMDD-X.md

## 5. ATURAN

- Setiap memory WAJIB punya memory_id unik
- Setiap memory WAJIB punya sha256
- Memory DECISION = immutable setelah ACTIVE
- Memory EVIDENCE hanya dibuat setelah verifikasi
- Memory PROFILE / PREFERENCE = milik L0

## 6. HAK AKSES

- L0: baca + tulis semua
- Agen: baca PROFILE/PREF/DEC/LRN/CTX/EVID
- Agen: tulis LRN, CTX, SESS
- Agen: tidak boleh tulis PRF, PREF, DEC, EVID, HOFF

## 7. HUBUNGAN DENGAN HANDOFF

Handoff = memory tipe HOFF yang dibuat otomatis saat sesi tutup.

## 8. BATASAN FASE P1

- Tidak ada auto-extract dari percakapan
- Tidak ada embedding
- Tidak ada vector database
- Tidak ada cloud sync
- Semua operasi = file I/O murni
'@

# ---------- FILE 2 : DESIGN-P1-MEMORY-USAGE-REV1.md ----------
$File2 = @'
# MICO-JDEQ MEMORY SYSTEM - PANDUAN PAKAI

Status: DRAFT | NOT ADOPTED

## SAAT BUKA SESI

  .\mico-session-start.ps1

Output:
- Daftar handoff terakhir
- Memory ACTIVE relevan
- DEC terakhir 5
- LRN terakhir 5

Paste output ke AI sebagai anchor.

## SELAMA SESI

Tambah memory:

  .\mico-mem.ps1 add -Category PREF -Title "Format jawaban" -Body "Selalu pakai tabel"

Cari memory:

  .\mico-mem.ps1 search -Keyword "format"

Lihat memory:

  .\mico-mem.ps1 show -Id PRF-20260916-001

List semua:

  .\mico-mem.ps1 list
  .\mico-mem.ps1 list -Category DEC

## SAAT TUTUP SESI

  .\mico-session-end.ps1 -Summary "P1 memory system selesai"

## KATEGORI

PRF  - PROFILE
PREF - PREFERENCE
DEC  - DECISION
LRN  - LEARNING
CTX  - PROJECT_CONTEXT
SESS - SESSION

## PRINSIP

1. Explicit lebih baik dari Implicit
2. File lebih kuat dari Memory
3. Hash lebih terpercaya dari Trust
4. Manual dulu, Auto nanti

## BATASAN P1

- Belum ada search by semantic
- Belum ada auto-tag
- Belum ada vector retrieval
- Semua itu kandidat P2
'@

# ---------- FILE 3 : mico-mem.ps1 ----------
$File3 = @'
# ============================================================
# mico-mem.ps1 - Memory Operations
# Usage:
#   .\mico-mem.ps1 init
#   .\mico-mem.ps1 add -Category PREF -Title "..." -Body "..."
#   .\mico-mem.ps1 search -Keyword "..."
#   .\mico-mem.ps1 list [-Category PREF]
#   .\mico-mem.ps1 show -Id PRF-20260916-001
#   .\mico-mem.ps1 help
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

$SSOTRoot = 'D:\MICO_SSOT'
$MemRoot  = Join-Path $SSOTRoot '02_DATA\LOCAL_MEMORY'

$CatMap = @{
    PRF  = 'PROFILE'
    PREF = 'PREFERENCES'
    DEC  = 'DECISIONS'
    LRN  = 'LEARNING'
    CTX  = 'PROJECT_CONTEXT'
    SESS = 'SESSIONS'
}

function Show-Help {
    Write-Host ""
    Write-Host "MICO MEMORY - Command Reference" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  init                              Inisialisasi folder"
    Write-Host "  add -Category -Title -Body        Tambah memory baru"
    Write-Host "  search -Keyword                   Cari memory"
    Write-Host "  list [-Category]                  List semua/partial"
    Write-Host "  show -Id <memory-id>              Lihat detail"
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

function Init-Structure {
    foreach ($folder in $CatMap.Values) {
        $path = Join-Path $MemRoot $folder
        if (-not (Test-Path -LiteralPath $path)) {
            New-Item -ItemType Directory -Force -Path $path | Out-Null
            Write-Host "BUAT: $path"
        } else {
            Write-Host "ADA : $path"
        }
    }
    Write-Host ""
    Write-Host "Struktur memory siap."
}

function Add-Memory {
    if (-not $Category -or -not $Title -or -not $Body) {
        throw "add wajib: -Category -Title -Body"
    }
    if (-not $CatMap.ContainsKey($Category)) {
        throw "Kategori tidak valid: $Category. Pilih: PRF PREF DEC LRN CTX SESS"
    }

    $folder = Get-CategoryFolder $Category
    if (-not (Test-Path -LiteralPath $folder)) {
        New-Item -ItemType Directory -Force -Path $folder | Out-Null
    }

    $today = Get-Date -Format 'yyyyMMdd'
    $existing = @(Get-ChildItem -LiteralPath $folder -Filter "$Category-$today-*.md" -ErrorAction SilentlyContinue)
    $num = '{0:D3}' -f ($existing.Count + 1)
    $memoryId = "$Category-$today-$num"
    $fileName = "$memoryId.md"
    $filePath = Join-Path $folder $fileName

    $now = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
    $bodyIndented = ($Body -split "`n" | ForEach-Object { "    $_" }) -join "`n"

    $content = @"
---
memory_id: $memoryId
category: $Category
status: ACTIVE
created_at: $now
updated_at: $now
source_agent: L0
authority: L0
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

    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($filePath, $content, $utf8)

    $hash = (Get-FileHash -LiteralPath $filePath -Algorithm SHA256).Hash
    Write-Host ""
    Write-Host "OK  : Memory dibuat"
    Write-Host "ID  : $memoryId"
    Write-Host "File: $filePath"
    Write-Host "Hash: $hash"
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

        $files = Get-ChildItem -LiteralPath $path -Filter '*.md' -Recurse -ErrorAction SilentlyContinue
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
        $files = Get-ChildItem -LiteralPath $folder -Filter '*.md' -ErrorAction SilentlyContinue | Sort-Object Name
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
}

switch ($Action) {
    'init'   { Init-Structure }
    'add'    { Add-Memory }
    'search' { Search-Memory }
    'list'   { List-Memory }
    'show'   { Show-Memory }
    'help'   { Show-Help }
    default  { Show-Help }
}
'@

# ---------- FILE 4 : mico-session-start.ps1 ----------
$File4 = @'
# ============================================================
# mico-session-start.ps1 - Bootstrap sesi baru
# Baca handoff terakhir + memory ACTIVE, cetak sebagai anchor
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$SSOTRoot = 'D:\MICO_SSOT'
$MemRoot  = Join-Path $SSOTRoot '02_DATA\LOCAL_MEMORY'
$SessRoot = Join-Path $MemRoot 'SESSIONS'

Write-Host ""
Write-Host "======================================="
Write-Host "  MICO SESSION START ANCHOR"
Write-Host "======================================="
Write-Host ""
Write-Host "Waktu: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host ""

Write-Host "[1] HANDOFF TERAKHIR"
if (Test-Path -LiteralPath $SessRoot) {
    $handoffs = Get-ChildItem -LiteralPath $SessRoot -Filter 'HANDOFF-*.md' -Recurse -ErrorAction SilentlyContinue |
                Sort-Object LastWriteTime -Descending |
                Select-Object -First 3
    if ($handoffs) {
        foreach ($h in $handoffs) {
            Write-Host ("  - {0}  ({1})" -f $h.Name, $h.LastWriteTime.ToString('yyyy-MM-dd HH:mm'))
        }
        Write-Host ""
        Write-Host "  Isi handoff terbaru:"
        Get-Content -LiteralPath $handoffs[0].FullName -Raw
    } else {
        Write-Host "  (belum ada handoff)"
    }
} else {
    Write-Host "  (folder SESSIONS belum ada)"
}
Write-Host ""

Write-Host "[2] PROFILE AKTIF"
$profileDir = Join-Path $MemRoot 'PROFILE'
if (Test-Path -LiteralPath $profileDir) {
    $files = Get-ChildItem -LiteralPath $profileDir -Filter '*.md' -ErrorAction SilentlyContinue
    if ($files) { foreach ($f in $files) { Write-Host ("  - {0}" -f $f.BaseName) } }
    else { Write-Host "  (kosong)" }
}
Write-Host ""

Write-Host "[3] PREFERENCES"
$prefDir = Join-Path $MemRoot 'PREFERENCES'
if (Test-Path -LiteralPath $prefDir) {
    $files = Get-ChildItem -LiteralPath $prefDir -Filter '*.md' -ErrorAction SilentlyContinue
    if ($files) { foreach ($f in $files) { Write-Host ("  - {0}" -f $f.BaseName) } }
    else { Write-Host "  (kosong)" }
}
Write-Host ""

Write-Host "[4] DECISIONS (5 terbaru)"
$decDir = Join-Path $MemRoot 'DECISIONS'
if (Test-Path -LiteralPath $decDir) {
    $files = Get-ChildItem -LiteralPath $decDir -Filter '*.md' -ErrorAction SilentlyContinue |
             Sort-Object Name -Descending | Select-Object -First 5
    if ($files) { foreach ($f in $files) { Write-Host ("  - {0}" -f $f.BaseName) } }
    else { Write-Host "  (kosong)" }
}
Write-Host ""

Write-Host "[5] LEARNING (5 terbaru)"
$lrnDir = Join-Path $MemRoot 'LEARNING'
if (Test-Path -LiteralPath $lrnDir) {
    $files = Get-ChildItem -LiteralPath $lrnDir -Filter '*.md' -ErrorAction SilentlyContinue |
             Sort-Object Name -Descending | Select-Object -First 5
    if ($files) { foreach ($f in $files) { Write-Host ("  - {0}" -f $f.BaseName) } }
    else { Write-Host "  (kosong)" }
}
Write-Host ""

Write-Host "======================================="
Write-Host "  Salin output ini ke AI sebagai anchor"
Write-Host "======================================="
Write-Host ""
'@

# ---------- FILE 5 : mico-session-end.ps1 ----------
$File5 = @'
# ============================================================
# mico-session-end.ps1 - Tutup sesi: tulis handoff
# Usage: .\mico-session-end.ps1 -Summary "Ringkasan sesi"
# ============================================================

param(
    [Parameter(Mandatory=$true)]
    [string]$Summary
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$SSOTRoot = 'D:\MICO_SSOT'
$MemRoot  = Join-Path $SSOTRoot '02_DATA\LOCAL_MEMORY'
$SessRoot = Join-Path $MemRoot 'SESSIONS'
$Today    = Get-Date -Format 'yyyyMMdd'
$MonthDir = Join-Path $SessRoot (Get-Date -Format 'yyyy-MM')

if (-not (Test-Path -LiteralPath $MonthDir)) {
    New-Item -ItemType Directory -Force -Path $MonthDir | Out-Null
}

$existing = @(Get-ChildItem -LiteralPath $MonthDir -Filter "HANDOFF-$Today-*.md" -ErrorAction SilentlyContinue)
$num = '{0:D2}' -f ($existing.Count + 1)
$handoffId = "HANDOFF-$Today-$num"
$filePath = Join-Path $MonthDir "$handoffId.md"

function Get-Recent([string]$folder, [int]$n) {
    $path = Join-Path $MemRoot $folder
    if (-not (Test-Path -LiteralPath $path)) { return @() }
    return (Get-ChildItem -LiteralPath $path -Filter '*.md' -ErrorAction SilentlyContinue |
            Sort-Object Name -Descending | Select-Object -First $n |
            ForEach-Object { $_.BaseName })
}

$recentPREF = Get-Recent 'PREFERENCES' 5
$recentDEC  = Get-Recent 'DECISIONS' 5
$recentLRN  = Get-Recent 'LEARNING' 5
$recentCTX  = Get-Recent 'PROJECT_CONTEXT' 5

$now = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')

$content = @"
---
memory_id: $handoffId
category: HANDOFF
status: ACTIVE
created_at: $now
source_agent: L0
authority: L0
content:
  title: Session handoff
---

# $handoffId

Created: $now
Summary: $Summary

## Preferences (terbaru)
$($recentPREF -join "`n")

## Decisions (terbaru)
$($recentDEC -join "`n")

## Learning (terbaru)
$($recentLRN -join "`n")

## Project Context
$($recentCTX -join "`n")

## Instruksi untuk Sesi Baru

1. Jalankan .\mico-session-start.ps1
2. Salin output sebagai anchor
3. Jangan bertindak sebelum baca anchor
4. Semua konteks di luar handoff ini = gugur
"@

$utf8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($filePath, $content, $utf8)

$hash = (Get-FileHash -LiteralPath $filePath -Algorithm SHA256).Hash

Write-Host ""
Write-Host "OK  : Handoff dibuat"
Write-Host "ID  : $handoffId"
Write-Host "File: $filePath"
Write-Host "Hash: $hash"
Write-Host ""
'@

# ---------- FILE 6 : mico-memory-init.ps1 ----------
$File6 = @'
# ============================================================
# mico-memory-init.ps1 - Inisialisasi struktur folder memory
# Jalankan sekali. Idempotent.
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$SSOTRoot = 'D:\MICO_SSOT'
$MemRoot  = Join-Path $SSOTRoot '02_DATA\LOCAL_MEMORY'

$folders = @(
    'PROFILE',
    'PREFERENCES',
    'DECISIONS',
    'LEARNING',
    'PROJECT_CONTEXT',
    'TOPIC_INDEX',
    'SESSIONS'
)

Write-Host ""
Write-Host "Inisialisasi memory folder..."
Write-Host ""

foreach ($f in $folders) {
    $path = Join-Path $MemRoot $f
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

Write-Host ""
Write-Host "Selesai. Struktur memory siap."
Write-Host ""
'@

# ---------- MAP ----------
$Files = [ordered]@{
    'DESIGN-P1-MEMORY-SYSTEM-REV1.md' = $File1
    'DESIGN-P1-MEMORY-USAGE-REV1.md'  = $File2
    'mico-mem.ps1'                    = $File3
    'mico-session-start.ps1'          = $File4
    'mico-session-end.ps1'            = $File5
    'mico-memory-init.ps1'            = $File6
}

# ---------- EXEC ----------
$utf8 = New-Object System.Text.UTF8Encoding($false)
$manifest = New-Object System.Collections.Generic.List[string]

try {
    Write-Host ""
    Write-Host "[1/5] Verifikasi SSOT root..."
    if (-not (Test-Path -LiteralPath $SSOTRoot -PathType Container)) {
        throw "SSOT root tidak ditemukan: $SSOTRoot"
    }
    Write-Host "OK  : $SSOTRoot"

    Write-Host ""
    Write-Host "[2/5] Siapkan target..."
    if (-not (Test-Path -LiteralPath $QuarRoot -PathType Container)) {
        New-Item -ItemType Directory -Force -Path $QuarRoot | Out-Null
    }
    if (-not (Test-Path -LiteralPath $TargetDir -PathType Container)) {
        New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
        Write-Host "BUAT: $TargetDir"
    } else {
        Write-Host "ADA : $TargetDir"
    }

    Write-Host ""
    Write-Host "[3/5] Tulis file..."
    foreach ($name in $Files.Keys) {
        $path = Join-Path $TargetDir $name
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            Write-Host "SKIP: $name"
        } else {
            [System.IO.File]::WriteAllText($path, $Files[$name], $utf8)
            Write-Host "WRITE: $name"
        }
    }

    Write-Host ""
    Write-Host "[4/5] Hash SHA256..."
    foreach ($name in $Files.Keys) {
        $path = Join-Path $TargetDir $name
        $hash = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
        $manifest.Add("$hash  $name")
        Write-Host ("OK  : {0}  {1}" -f $hash.Substring(0,16), $name)
    }

    Write-Host ""
    Write-Host "[5/5] Manifest..."
    $manifestPath = Join-Path $TargetDir 'MANIFEST-SHA256.txt'
    [System.IO.File]::WriteAllText($manifestPath, ($manifest -join "`n") + "`n", $utf8)
    Write-Host "OK  : $manifestPath"

    Write-Host ""
    Write-Host "SELESAI. Target: $TargetDir"
    Write-Host ""
    Write-Host "LANGKAH BERIKUTNYA:"
    Write-Host "  1. Copy 6 file dari $TargetDir ke D:\MICO_SSOT\"
    Write-Host "  2. Jalankan .\mico-memory-init.ps1"
    Write-Host "  3. Mulai pakai .\mico-mem.ps1 add ..."
    Write-Host ""
}
catch {
    Write-Host ""
    Write-Host "GAGAL: $($_.Exception.Message)"
    throw
}