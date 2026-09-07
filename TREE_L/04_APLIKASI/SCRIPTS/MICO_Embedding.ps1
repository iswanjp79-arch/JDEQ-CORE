param(
    [switch]$DryRun
)

$TargetFolder = "D:\MICO_SSOT\KNOWLEDGE_BASE\03_FOTO_PROYEK"
$BatchSize = 10
$PythonScript = "D:\MICO_SSOT\mico_embed.py"
$PythonExe = "python"

if (-not (Test-Path $TargetFolder)) {
    Write-Host "Folder target tidak ditemukan: $TargetFolder" -ForegroundColor Red
    exit 1
}

if (-not (Get-Command $PythonExe -ErrorAction SilentlyContinue)) {
    Write-Host "Python tidak ditemukan. Pastikan Python terinstall." -ForegroundColor Red
    exit 1
}

$files = Get-ChildItem -Path $TargetFolder -Filter "*.jpg.md" -File -ErrorAction SilentlyContinue

$pending = @()
foreach ($f in $files) {
    $content = Get-Content -Path $f.FullName -Raw -ErrorAction SilentlyContinue
    if ($content -match "Status_RAG:\s*PENDING_EMBEDDING") {
        $pending += $f
    }
}

if ($pending.Count -eq 0) {
    Write-Host "Tidak ada file dengan status PENDING_EMBEDDING." -ForegroundColor Yellow
    exit 0
}

Write-Host "Ditemukan $($pending.Count) file PENDING_EMBEDDING." -ForegroundColor Cyan

if ($DryRun) {
    $preview = $pending | Select-Object -First $BatchSize
    Write-Host "`n===== DRY RUN MODE =====" -ForegroundColor Green
    Write-Host "File pertama yang akan diproses (maksimal $BatchSize file):"
    foreach ($p in $preview) {
        Write-Host "  - $($p.Name)" -ForegroundColor White
    }
    Write-Host "`nTidak ada embedding nyata yang dilakukan." -ForegroundColor Green
    exit 0
}

$counter = 0
foreach ($file in $pending) {
    try {
        Write-Host "Processing: $($file.Name)"
        $output = & $PythonExe $PythonScript $file.FullName 2>&1
        if ($LASTEXITCODE -eq 0) {
            $raw = Get-Content -Path $file.FullName -Raw
            $updated = $raw -replace "Status_RAG:\s*PENDING_EMBEDDING", "Status_RAG: INDEXED"
            Set-Content -Path $file.FullName -Value $updated -Encoding UTF8
            Write-Host "  SUCCESS -> INDEXED" -ForegroundColor Green
        } else {
            Write-Host "  FAILED (exit code $LASTEXITCODE)" -ForegroundColor Red
            Write-Host "  Output: $output" -ForegroundColor DarkYellow
        }
    }
    catch {
        Write-Host "  ERROR: $($_.Exception.Message)" -ForegroundColor Red
    }

    $counter++
    if ($counter % $BatchSize -eq 0) {
        Write-Host "--- Batch selesai. Membersihkan memori... ---"
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
        Start-Sleep -Milliseconds 500
    }
}

Write-Host "`nSelesai. $counter file diproses." -ForegroundColor Cyan
