# inject_fasad.ps1 — Static Injection dengan profil otomatis
$base = "D:\MICO_SSOT\TREE_L"
$mezDir = "$base\04_APLIKASI\MEZANINE"
$evDir = "$base\08_EVIDENCE\RUNTIME"

$reportCore = Get-ChildItem "$base\08_EVIDENCE\RUNTIME\RINGBALK_CORE_*.txt" -File -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1

$ram = "—"
$cpu = 0
$kolom = "—"
if ($reportCore) {
    $lines = Get-Content $reportCore.FullName -Encoding UTF8
    foreach ($line in $lines) {
        if ($line -match 'Free RAM:\s*([\d\.]+)\s*MB') { $ram = $matches[1] + " MB" }
        if ($line -match 'CPU Load:\s*([\d]+)%') { $cpu = [int]$matches[1] }
        if ($line -match 'TERIKAT') { $kolom = "Terikat" }
    }
}

$estetika = Get-Content "$mezDir\MICO_ESTETIKA.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$profilNama = if ($cpu -gt 75) { "industrial" } else { "organik" }
$css = $estetika.profil.$profilNama.css

$html = @"
<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MICO-JDEQ — Fasad $profilNama</title>
<style>
  :root {
    --tanah: $($css.warna_utama);
    --sekunder: $($css.warna_sekunder);
    --aksen: $($css.warna_aksen);
  }
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    font-family: $($css.font_family);
    background: $($css.background_body);
    color: var(--tanah);
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 1rem;
  }
  .fasad {
    max-width: 880px;
    width: 100%;
    background: $($css.background_fasad);
    border-radius: $($css.border_radius_fasad);
    box-shadow: $($css.shadow);
    padding: $($css.padding_fasad);
    border: 1px solid rgba(107,90,73,0.2);
  }
  .fasad::before {
    content: "〰️ MICO-JDEQ — $profilNama";
    display: block;
    font-weight: 600;
    letter-spacing: 3px;
    color: var(--sekunder);
    margin-bottom: 1.75rem;
    font-size: 1.1rem;
    text-align: center;
  }
  .organik-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.25rem;
  }
  .kartu {
    position: relative;
    padding: $($css.padding_kartu);
    color: #fff;
    border-radius: $($css.border_radius_kartu);
    background: $($css.warna_kartu_batu);
    box-shadow: $($css.shadow);
    text-align: center;
    min-height: 140px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  .kartu.daun { background: $($css.warna_kartu_daun); color: #1a2e16; }
  .kartu.batu { background: $($css.warna_kartu_batu); color: #fff7e8; }
  .kartu.akar { background: $($css.warna_kartu_akar); color: #17313a; }
  .label {
    font-size: 0.85rem;
    letter-spacing: 1px;
    text-transform: uppercase;
    opacity: 0.85;
  }
  .angka {
    display: block;
    font-size: $($css.font_size_angka);
    font-weight: 700;
    margin-top: 0.5rem;
  }
  .catatan-kecil {
    margin-top: 1.5rem;
    font-size: 0.78rem;
    color: var(--sekunder);
    text-align: center;
    letter-spacing: 0.3px;
  }
</style>
</head>
<body>
  <main class="fasad">
    <section class="organik-grid">
      <div class="kartu daun">
        <span class="label">🌿 RAM Bebas</span>
        <span class="angka">$ram</span>
      </div>
      <div class="kartu batu">
        <span class="label">🪨 CPU Load</span>
        <span class="angka">$cpu%</span>
      </div>
      <div class="kartu akar">
        <span class="label">💧 Air Node</span>
        <span class="angka">$kolom</span>
      </div>
    </section>
    <p class="catatan-kecil">
      Fasad statis · injeksi tanpa fetch · profil $profilNama · tanpa server · tanpa CORS
    </p>
  </main>
</body>
</html>
"@

$outHtml = "$mezDir\fasad_organik_terbaru.html"
Set-Content -Path $outHtml -Value $html -Encoding UTF8

$hash = (Get-FileHash $outHtml -Algorithm SHA256).Hash
$evPath = "$evDir\FASAD_INJECT_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
@"
=== FASAD STATIC INJECTION ===
Waktu: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Node: KAPAL-INDUK
HTML: $outHtml
SHA256: $hash
Profil: $profilNama
Status: FASAD_TERINJEKSI
"@ | Out-File $evPath -Encoding UTF8

Write-Output "Fasad berhasil diinjeksi dengan profil: $profilNama"
Write-Output "HTML: $outHtml"
Write-Output "Evidence: $evPath"
