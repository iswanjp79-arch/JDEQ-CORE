# pompa_tandon.ps1 — Pompa Pendorong Distribusi Tandon
$root = "D:\MICO_SSOT\TREE_L"
$tandon = "$root\02_DATA\TANDON_UPDATE"
$targets = Get-Content "$tandon\target_node.json" -Raw | ConvertFrom-Json
$outbox = "$root\05_PIPELINE\OUTBOX_DISTRIBUSI"
$evidence = "$root\08_EVIDENCE\RUNTIME"

New-Item -ItemType Directory -Path $outbox -Force | Out-Null

$log = @()
$log += "=== POMPA TANDON REPORT ==="
$log += "Waktu: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

foreach ($t in $targets) {
    $ping = Test-Connection -ComputerName $t.ip -Count 1 -Quiet -ErrorAction SilentlyContinue
    if (-not $ping) {
        $log += "[$($t.nama)] TIDAK TERJANGKAU - pompa tunda"
        continue
    }

    $destFolder = Join-Path $outbox $t.nama
    New-Item -ItemType Directory -Path $destFolder -Force | Out-Null

    if ($t.share_path -and (Test-Path $t.share_path)) {
        $dest = $t.share_path
        $mode = "SHARE"
    } else {
        $dest = $destFolder
        $mode = "LOKAL"
    }

    $files = Get-ChildItem $tandon -File | Where-Object { $_.Name -ne 'target_node.json' -and $_.Name -notlike 'tandon_manifest_*' }
    foreach ($f in $files) {
        Copy-Item $f.FullName -Destination $dest -Force
        $log += "[$($t.nama)] $($f.Name) -> $dest ($mode)"
    }
}

$log | Out-File "$evidence\pompa_tandon_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt" -Encoding UTF8
$log
