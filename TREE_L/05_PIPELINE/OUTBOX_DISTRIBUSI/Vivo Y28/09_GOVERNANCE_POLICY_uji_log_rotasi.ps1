# UJI LOG ROTASI — SIMULASI (TIDAK MENGUBAH LOG SISTEM)
$LogDir = "D:\MICO_SSOT\TREE_L\06_RUNTIME\LOGS"
$ArchiveDir = "$LogDir\ARCHIVE"
New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
New-Item -ItemType Directory -Path $ArchiveDir -Force | Out-Null

# Membuat file log uji kecil 1KB
$testLog = "$LogDir\uji_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
"x" * 1024 | Out-File $testLog -Encoding ASCII

# Simulasi rotasi sederhana: jika ada > 5 file, arsipkan yang terlama
$existing = Get-ChildItem $LogDir -Filter "uji_*.log" -File | Sort-Object LastWriteTime
if ($existing.Count -gt 5) {
    $toArchive = $existing[0]
    Compress-Archive -Path $toArchive.FullName -DestinationPath "$ArchiveDir\$($toArchive.BaseName).zip"
    Remove-Item $toArchive.FullName -Force
    Write-Output "Rotasi: $($toArchive.Name) dipindah ke arsip"
}

# Tampilkan hash file uji
Get-FileHash $testLog -Algorithm SHA256 | Select-Object Path, Hash
Write-Output "Simulasi selesai. Log asli tidak diubah."
