# lipat_mezanine.ps1 — Lipat Mezanine, pastikan nol beban
$log = @()
$log += "=== LIPAT MEZANINE ==="
$log += "Waktu: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

# Matikan proses ringkasan jika ada
$procs = Get-Process python -ErrorAction SilentlyContinue |
    Where-Object { $_.Path -like "*MEZANINE*" }
if ($procs) {
    $procs | Stop-Process -Force -ErrorAction SilentlyContinue
    $log += "Proses ringkasan mati."
} else {
    $log += "Tidak ada proses mezanine aktif."
}

# Bersihkan file sementara (tidak menyentuh inti)
$tempFile = "$base\04_APLIKASI\MEZANINE\status_temp.json"
if (Test-Path $tempFile) {
    Remove-Item $tempFile -Force
    $log += "File temp dibersihkan."
}

$log += "Status: MEZANINE TERLIPAT"
$log | Out-File "$evDir\LIPAT_MEZANINE_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt" -Encoding UTF8
$log | Write-Output
