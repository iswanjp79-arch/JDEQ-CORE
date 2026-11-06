#!/data/data/com.termux/files/usr/bin/bash

echo "=========================================="
echo " MICO-JDEQ: DEPLOY GITHUB PAGES & REROUTE"
echo "=========================================="

# 1. Membuat Halaman Utama (index.html)
cat > ~/mico_jdeq/index.html << 'HTML'
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MICO-JDEQ | Digital Identity</title>
    <style>
        body { background-color: #0a0a0a; color: #00ff00; font-family: monospace; padding: 2rem; }
        a { color: #00ffff; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <h2>STATUS: 🟢 KESADARAN VISUAL AKTIF</h2>
    <p>Infrastruktur MICO-JDEQ Online. Node Mark III (Vivo Y28) Terkunci.</p>
    <ul>
        <li>Akses Dashboard Sentral: <a href="https://huggingface.co/spaces/iswanjp79">HuggingFace Spaces</a></li>
    </ul>
</body>
</html>
HTML
echo "[1/3] ✅ File index.html tercetak."

# 2. Membuat Smart Fallback (404.html)
cat > ~/mico_jdeq/404.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="refresh" content="1; url=https://huggingface.co/spaces/iswanjp79">
    <title>404 - Auto Reroute</title>
    <style>body { background-color: #000; color: #0f0; font-family: monospace; text-align: center; margin-top: 20%; }</style>
</head>
<body>
    <h3>Jalur terputus. Mengalihkan ke sistem pusat (HuggingFace)...</h3>
</body>
</html>
HTML
echo "[2/3] ✅ File 404.html (Smart Reroute) tercetak."

# 3. Commit & Push
echo "[3/3] Mengeksekusi Push ke Gudang Amunisi..."
cd ~/mico_jdeq
git add index.html 404.html
git commit -m "ADR-0053: Deploy Web Manifesto & Smart 404 Redirect"
git push origin main

# 4. Notifikasi
bash ~/mico_jdeq/scripts/send_alert.sh "🌐 MICO-JDEQ WEB DEPLOYED
✅ Halaman Utama (index.html) aktif.
✅ Smart Fallback (404.html) aktif.
TINDAKAN MANUAL (1x):
Buka setelan GitHub Repo -> Pages -> Source: 'main' branch (/root) -> Save." 2>/dev/null || true

echo "=========================================="
echo " DEPLOY SELESAI"
echo " Lakukan tindakan manual di GitHub Settings jika belum aktif."
echo "=========================================="
