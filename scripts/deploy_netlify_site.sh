#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: DEPLOY WEBSITE VIA Z83"
echo "=========================================="

# 1. Buat folder publik
mkdir -p ~/mico_jdeq/public
cat > ~/mico_jdeq/public/index.html << 'HTML'
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MICO-JDEQ | Digital Identity</title>
    <style>
        body { background-color: #0a0a0a; color: #00ff00; font-family: monospace; padding: 2rem; }
        a { color: #00ffff; text-decoration: none; }
    </style>
</head>
<body>
    <h2>STATUS: 🟢 KESADARAN VISUAL AKTIF</h2>
    <p>Infrastruktur MICO-JDEQ Online. Node Mark III (Vivo Y28) Terkunci.</p>
</body>
</html>
HTML
echo "[1/2] ✅ File website siap."

# 2. Deploy via Z83 (Netlify gratis)
echo "[2/2] Deploy ke Netlify..."
ssh iswan@z83-server.tail2a1291.ts.net "mkdir -p ~/mico_jdeq/public && cat > ~/mico_jdeq/public/index.html" < ~/mico_jdeq/public/index.html
ssh iswan@z83-server.tail2a1291.ts.net "npm install -g netlify-cli 2>/dev/null || true"
ssh iswan@z83-server.tail2a1291.ts.net "cd ~/mico_jdeq/public && npx netlify-cli deploy --dir=. --prod 2>&1" | tail -5

echo ""
echo "=========================================="
echo " WEBSITE DEPLOYED VIA Z83"
echo "=========================================="
