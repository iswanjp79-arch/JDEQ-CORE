# inject_fasad.ps1 — Static Injection + Profil Override
$base = "D:\MICO_SSOT\TREE_L"
$mezDir = "$base\04_APLIKASI\MEZANINE"
$evDir = "$base\08_EVIDENCE\RUNTIME"
$overrideFile = "$mezDir\profil_override.txt"

# Cek override manual
$manualProfil = $null
if (Test-Path $overrideFile) {
    $manualProfil = (Get-Content $overrideFile -Raw -Encoding UTF8).Trim()
}

$reportCore = Get-ChildItem "$base\08_EVIDENCE\RUNTIME\RINGBALK_CORE_*.txt" -File -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1

$ram = "—"
$cpu = 0
$kolom = "—"
$stale = $false

if ($reportCore) {
    $age = (Get-Date) - $reportCore.LastWriteTime
    if ($age.TotalMinutes -gt 5) {
        $stale = $true
    } else {
        $lines = Get-Content $reportCore.FullName -Encoding UTF8
        foreach ($line in $lines) {
            if ($line -match 'Free RAM:\s*([\d\.]+)\s*MB') { $ram = $matches[1] + " MB" }
            if ($line -match 'CPU Load:\s*([\d]+)%') { $cpu = [int]$matches[1] }
            if ($line -match 'TERIKAT') { $kolom = "Terikat" }
        }
    }
} else {
    $stale = $true
}

$estetika = Get-Content "$mezDir\MICO_ESTETIKA.json" -Raw -Encoding UTF8 | ConvertFrom-Json

# Tentukan profil
if ($stale) {
    $profilNama = "lost"
} elseif ($manualProfil -and ($estetika.profil.PSObject.Properties.Name -contains $manualProfil)) {
    $profilNama = $manualProfil
} elseif ($cpu -gt 75) {
    $profilNama = "industrial"
} else {
    $profilNama = "organik"
}

if ($profilNama -ne "lost") {
    $css = $estetika.profil.$profilNama.css
    $html = @"
<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MICO-JDEQ — Fasad $profilNama</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    font-family: $($css.font_family);
    background: $($css.background_body);
    color: $($css.warna_utama);
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
  }
  .fasad::before {
    content: "MICO-JDEQ — $profilNama";
    display: block;
    font-weight: 600;
    letter-spacing: 3px;
    color: $($css.warna_sekunder);
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
    padding: $($css.padding_kartu);
    border-radius: $($css.border_radius_kartu);
    text-align: center;
    min-height: 140px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background: $($css.warna_kartu_batu);
    color: #fff;
    box-shadow: $($css.shadow);
  }
  .kartu.daun { background: $($css.warna_kartu_daun); color: $($css.warna_utama); }
  .kartu.batu { background: $($css.warna_kartu_batu); color: $($css.warna_utama); }
  .kartu.akar { background: $($css.warna_kartu_akar); color: $($css.warna_utama); }
  .label {
    font-size: 0.85rem;
    letter-spacing: 1px;
    text-transform: uppercase;
    opacity: 0.9;
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
    color: $($css.warna_sekunder);
    text-align: center;
  }
</style>
</head>
<body>
  <main class="fasad">
    <section class="organik-grid">
      <div class="kartu daun">
        <span class="label">RAM Bebas</span>
        <span class="angka">$ram</span>
      </div>
      <div class="kartu batu">
        <span class="label">CPU Load</span>
        <span class="angka">$cpu%</span>
      </div>
      <div class="kartu akar">
        <span class="label">Air Node</span>
        <span class="angka">$kolom</span>
      </div>
    </section>
    <p class="catatan-kecil">Profil $profilNama · tanpa server · tanpa CORS</p>
  </main>
</body>
</html>
"@
} else {
    $html = @"
<!DOCTYPE html>
<html lang="id">
<head><meta charset="UTF-8"><title>MICO-JDEQ — LOST</title></head>
<body style="background:#1a1a1a;color:#888;display:flex;align-items:center;justify-content:center;height:100vh;font-family:sans-serif;">
<div style="text-align:center;">
<h1 style="color:#d9534f;">LOST CONNECTION</h1>
<p>SENSOR MATI — data terakhir lebih dari 5 menit</p>
</div>
</body>
</html>
"@
}

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
