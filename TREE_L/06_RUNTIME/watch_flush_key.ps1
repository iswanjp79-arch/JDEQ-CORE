# watch_flush_key.ps1 — Pemantau Flashdisk FLUSH-KEY
$label = "FLUSH-KEY"
$cleanout = "D:\MICO_SSOT\TREE_L\06_RUNTIME\FLUSH_CLEANOUT.ps1"
$evidence = "D:\MICO_SSOT\TREE_L\08_EVIDENCE\RUNTIME"

while ($true) {
    $flash = Get-Volume -ErrorAction SilentlyContinue | Where-Object { $_.FileSystemLabel -eq $label }
    if ($flash) {
        & $cleanout
        "FLUSH-KEY terdeteksi: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File "$evidence\flush_key_event.log" -Append -Encoding UTF8
    }
    Start-Sleep -Seconds 10
}
