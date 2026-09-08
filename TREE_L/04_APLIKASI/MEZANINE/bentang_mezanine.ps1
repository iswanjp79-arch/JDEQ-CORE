# bentang_mezanine.ps1 — Bentang Mezanine, tampilkan status ringkas
$log = @()
$log += "=== BENTANG MEZANINE ==="
$log += "Waktu: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

# Jalankan orchestrator_core.ps1 untuk menghasilkan laporan terbaru
$core = "D:\MICO_SSOT\TREE_L\05_PIPELINE\RINGBALK\orchestrator_core.ps1"
if (Test-Path $core) {
    & $core | Out-Null
    $log += "Laporan inti diperbarui."
} else {
    $log += "orchestrator_core.ps1 tidak ditemukan."
}

$log += "Status: MEZANINE TERBENTANG"
$log | Out-File "$evDir\BENTANG_MEZANINE_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt" -Encoding UTF8
$log | Write-Output
