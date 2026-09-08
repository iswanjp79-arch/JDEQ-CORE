# servis_tandon.ps1 — Hidupkan server lokal dari tandon
$tandon = "D:\MICO_SSOT\TREE_L\02_DATA\TANDON_UPDATE"
Set-Location $tandon
python -m http.server 8080
