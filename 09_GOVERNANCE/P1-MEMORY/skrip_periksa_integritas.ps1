# skrip_periksa_integritas.ps1
Get-ChildItem -Path "02_STORE" -File | ForEach-Object {
  $aktual = (Get-FileHash $_.FullName -Algorithm SHA256).Hash
  $rekamanPath = "04_HASH/$($_.Name).sha256"
  if (Test-Path $rekamanPath) {
    $tercatat = (Get-Content $rekamanPath -Raw).Split(':')[-1].Trim()
    if ($aktual -eq $tercatat) { "OK  $($_.Name) - TERVERIFIKASI" }
    else { "BAD $($_.Name) - RUSAK / BERUBAH" }
  } else { "MISS $($_.Name) - BELUM ADA REKAMAN" }
}