# bentang_mezanine.ps1 — Bentang Mezanine Modular (Versi Bersih)
$base = "D:\MICO_SSOT\TREE_L"
$mezDir = "$base\04_APLIKASI\MEZANINE"
$evDir = "$base\08_EVIDENCE\RUNTIME"

$log = @()
$log += "=== BENTANG MEZANINE ==="
$log += "Waktu: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

# Jalankan orchestrator_core.ps1 untuk laporan inti terbaru
$core = "$base\05_PIPELINE\RINGBALK\orchestrator_core.ps1"
if (Test-Path $core) {
    & $core | Out-Null
    $log += "Laporan inti diperbarui."
} else {
    $log += "orchestrator_core.ps1 tidak ditemukan."
}

$log += "Status: MEZANINE TERBENTANG"
$log | Out-File "$evDir\BENTANG_MEZANINE_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt" -Encoding UTF8
$log | Write-Output

# Inject fasad statis setelah laporan inti dibuat — SATU KALI di sini
& "$mezDir\inject_fasad.ps1"
