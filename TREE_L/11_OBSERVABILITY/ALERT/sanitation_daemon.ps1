# sanitation_daemon.ps1 — Bio Tank Digital
# Sekat 1: Log aktif (06_RUNTIME\LOGS)
# Sekat 2: Bakteri pengurai (script ini)
# Sekat 3: Resapan (DRAINAGE / 99_ARCHIVE)

$root = "D:\MICO_SSOT\TREE_L"
$logDirs = @("$root\06_RUNTIME\LOGS", "$root\08_EVIDENCE\RUNTIME")
$drain = "$root\05_PIPELINE\DRAINAGE"
$runoff = "$root\05_PIPELINE\RUNOFF"
$quarantine = "$root\05_PIPELINE\QUARANTINE"
$retentionDays = 7
$idleMinutes = 15

function Test-Idle {
    $lastInput = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    $idle = (Get-CimInstance Win32_ComputerSystem).UserName
    $cpu = (Get-CimInstance Win32_Processor).LoadPercentage
    # Jika CPU rendah dan tidak ada session interaktif, anggap idle
    return ($cpu -lt 15)
}

# Pemicu idle state
if (-not (Test-Idle)) {
    Write-Output "Sistem sibuk. Bakteri digital menunggu idle."
    exit
}

# Inisialisasi folder
foreach ($folder in @($drain, $runoff, $quarantine)) {
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
}

$cutoff = (Get-Date).AddDays(-$retentionDays)
$removed = @()

# Sekat 1: endap log lama
foreach ($dir in $logDirs) {
    if (!(Test-Path $dir)) { continue }
    Get-ChildItem $dir -File -Recurse -Filter *.log |
        Where-Object { $_.LastWriteTime -lt $cutoff } |
        ForEach-Object {
            # Sekat 2: bakteri mengurai — hitung hash, pindah ke resapan
            $hash = (Get-FileHash $_.FullName -Algorithm SHA256).Hash
            $dest = Join-Path $drain ($_.BaseName + "_" + $hash.Substring(0,8) + ".log")
            Move-Item $_.FullName -Destination $dest -Force
            $removed += $dest
        }
}

# Sekat 3: resapan ke RUNOFF jika drainage penuh
$drainFiles = Get-ChildItem $drain -File -ErrorAction SilentlyContinue
if ($drainFiles.Count -gt 100) {
    $excess = $drainFiles | Sort-Object LastWriteTime | Select-Object -First ($drainFiles.Count - 100)
    foreach ($f in $excess) {
        Move-Item $f.FullName -Destination $runoff -Force
    }
}

if ($removed.Count -gt 0) {
    @("=== BIO TANK REPORT ===", "Waktu: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')", "File diurai:") + $removed |
        Out-File "$drain\bio_tank_report_$(Get-Date -Format 'yyyyMMdd_HHmmss').md" -Encoding UTF8
}

Write-Output "Bakteri digital selesai. Log diurai: $($removed.Count)"
