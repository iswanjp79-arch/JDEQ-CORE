# resonance_daily.ps1  Protokol Resonansi Jiwa
$base = "D:\MICO_SSOT\TREE_L"
$quotesPath = "$base\03_LOGIKA\JDIGI_001_QUOTES.json"
$evDir = "$base\08_EVIDENCE\RUNTIME"
$z83_ip = "100.67.36.31"

$quotes = Get-Content $quotesPath -Raw | ConvertFrom-Json
$today = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Pilih kutipan acak
$randomIndex = Get-Random -Minimum 0 -Maximum $quotes.Count
$quote = $quotes[$randomIndex]

# Cek kondisi Z83 via ping (tanpa SSH)
$ping = Test-Connection -ComputerName $z83_ip -Count 1 -Quiet -ErrorAction SilentlyContinue

$statusZ83 = if ($ping) { "ONLINE" } else { "OFFLINE" }

# Buat laporan
$laporan = @()
$laporan += "=== RESONANSI HARIAN MICO-JDEQ ==="
$laporan += "Waktu : $today"
$laporan += "Node : KAPAL-INDUK (PC-i5)"
$laporan += ""
$laporan += "Status Z83 : $statusZ83"
$laporan += "Kutipan JDIGI-001 : $quote"

$reportPath = Join-Path $evDir "RESONANCE_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
$laporan | Out-File -FilePath $reportPath -Encoding UTF8

Write-Output $laporan
Write-Output "Laporan tersimpan: $reportPath"
