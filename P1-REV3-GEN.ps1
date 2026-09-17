# ============================================================
# AG-003 | P1-01 REV3 DRAFT GENERATOR | FINAL LOCKED
# Target  : D:\MICO_SSOT\00_QUARANTINE\P1-DRAFT-REV3\
# ============================================================
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$SSOTRoot       = 'D:\MICO_SSOT'
$QuarantineRoot = Join-Path $SSOTRoot '00_QUARANTINE'
$TargetDir      = Join-Path $QuarantineRoot 'P1-DRAFT-REV3'
$ManifestName   = 'MANIFEST-SHA256.txt'

$FileA = @'
# MICO-JDEQ MASTER SYSTEM PLAN V1.0 - REVISION 3
Status: FINAL DESIGN DRAFT | NOT ADOPTED | NOT RUNTIME | NO SSOT WRITE
(placeholder-A)
'@

$FileB = @'
# MICO-P1 ARCHITECTURE BASELINE - REV3
(placeholder-B)
'@

$FileC = @'
# MICO-P1 TASK CONTRACT TEMPLATE - REV3
(placeholder-C)
'@

$FileD = @'
# MICO-P1 RISK REGISTER TEMPLATE - REV3
(placeholder-D)
'@

$FileE = @'
# MICO-P1 ACCEPTANCE CRITERIA - REV3
(placeholder-E)
'@

$FileF = @'
# MICO-P1 NAMING SPEC - REV3
(placeholder-F)
'@

$Files = [ordered]@{
    'MICO-JDEQ-MASTER-SYSTEM-PLAN-V1.0-REV3.md' = $FileA
    'MICO-P1-ARCHITECTURE-BASELINE-REV3.md'     = $FileB
    'MICO-P1-TASK-CONTRACT-TEMPLATE-REV3.md'    = $FileC
    'MICO-P1-RISK-REGISTER-TEMPLATE-REV3.md'    = $FileD
    'MICO-P1-ACCEPTANCE-CRITERIA-REV3.md'       = $FileE
    'MICO-P1-NAMING-SPEC-REV3.md'               = $FileF
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$manifestLines = New-Object System.Collections.Generic.List[string]

try {
    Write-Host "[1/5] Verifikasi SSOT root..." -ForegroundColor Cyan
    if (-not (Test-Path -LiteralPath $SSOTRoot -PathType Container)) {
        throw "SSOT root tidak ditemukan: $SSOTRoot"
    }
    Write-Host "OK  : $SSOTRoot" -ForegroundColor Green

    Write-Host "[2/5] Siapkan workspace draft..." -ForegroundColor Cyan
    if (-not (Test-Path -LiteralPath $QuarantineRoot -PathType Container)) {
        New-Item -ItemType Directory -Force -Path $QuarantineRoot | Out-Null
    }
    if (-not (Test-Path -LiteralPath $TargetDir -PathType Container)) {
        New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
        Write-Host "BUAT: $TargetDir" -ForegroundColor Green
    } else {
        Write-Host "ADA : $TargetDir (idempotent)" -ForegroundColor Yellow
    }

    Write-Host "[3/5] Tulis 6 file draft..." -ForegroundColor Cyan
    foreach ($name in $Files.Keys) {
        $path = Join-Path $TargetDir $name
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            Write-Host "SKIP: $name (sudah ada)" -ForegroundColor Yellow
        } else {
            [System.IO.File]::WriteAllText($path, $Files[$name], $utf8NoBom)
            Write-Host "WRITE: $name" -ForegroundColor Green
        }
    }

    Write-Host "[4/5] Verifikasi + SHA256..." -ForegroundColor Cyan
    foreach ($name in $Files.Keys) {
        $path = Join-Path $TargetDir $name
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            throw "File tidak ditemukan: $name"
        }
        $hash = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
        $manifestLines.Add("$hash  $name")
        Write-Host ("OK  : {0}  {1}" -f $hash.Substring(0,16), $name) -ForegroundColor Green
    }

    Write-Host "[5/5] Tulis MANIFEST-SHA256.txt..." -ForegroundColor Cyan
    $manifestPath = Join-Path $TargetDir $ManifestName
    [System.IO.File]::WriteAllText(
        $manifestPath,
        ($manifestLines -join "`n") + "`n",
        $utf8NoBom
    )
    Write-Host "OK  : $manifestPath" -ForegroundColor Green

    Write-Host "SELESAI." -ForegroundColor Green
}
catch {
    Write-Host "GAGAL: $($_.Exception.Message)" -ForegroundColor Red
    throw
}