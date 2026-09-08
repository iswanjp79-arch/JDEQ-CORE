# log_cleanup.ps1 — Pembersihan log lama untuk 11_OBSERVABILITY
$root = "D:\MICO_SSOT\TREE_L"
$logDirs = @(
    "$root\06_RUNTIME\LOGS",
    "$root\08_EVIDENCE\RUNTIME"
)
$alertDir = "$root\11_OBSERVABILITY\ALERT"
$metricsDir = "$root\11_OBSERVABILITY\METRICS"
$evidenceDir = "$root\08_EVIDENCE\RUNTIME"
$retentionDays = 90

New-Item -ItemType Directory -Path $alertDir -Force | Out-Null
New-Item -ItemType Directory -Path $metricsDir -Force | Out-Null

$cutoff = (Get-Date).AddDays(-$retentionDays)
$removed = @()
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

foreach ($dir in $logDirs) {
    if (-not (Test-Path $dir)) { continue }
    $files = Get-ChildItem -Path $dir -File -Filter *.log -Recurse -ErrorAction SilentlyContinue
    foreach ($f in $files) {
        if ($f.LastWriteTime -lt $cutoff) {
            $hash = (Get-FileHash $f.FullName -Algorithm SHA256).Hash
            $removed += [PSCustomObject]@{
                file = $f.FullName
                size_kb = [math]::Round($f.Length / 1KB, 2)
                last_write = $f.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
                sha256 = $hash
            }
            Remove-Item $f.FullName -Force
        }
    }
}

if ($removed.Count -gt 0) {
    $removed | ConvertTo-Json -Depth 3 | Out-File "$alertDir\cleanup_log_$timestamp.json" -Encoding UTF8

    $report = @()
    $report += "# LAPORAN PEMBERSIHAN LOG"
    $report += "Waktu : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    $report += "Jumlah file dihapus : $($removed.Count)"
    $report += ""
    $report += "## Daftar file"
    foreach ($r in $removed) {
        $report += "- $($r.file) ($($r.size_kb) KB) — hash: $($r.sha256)"
    }
    $report | Out-File "$metricsDir\cleanup_report.md" -Encoding UTF8

    $evidence = @()
    $evidence += "LOG_CLEANUP"
    $evidence += "Waktu : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    $evidence += "Jumlah file dihapus : $($removed.Count)"
    $evidence += "Hash manifest : $alertDir\cleanup_log_$timestamp.json"
    $evidence | Out-File "$evidenceDir\CLEANUP_BUILD_$timestamp.txt" -Encoding UTF8

    Write-Output "Pembersihan selesai. File lama dihapus: $($removed.Count)"
    Write-Output "Laporan: $metricsDir\cleanup_report.md"
} else {
    Write-Output "Tidak ada file log yang melewati retensi $retentionDays hari."
}
