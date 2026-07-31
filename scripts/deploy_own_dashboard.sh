#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: DEPLOY DASHBOARD SENDIRI"
echo " 100% Otomatis — Tanpa Daftar"
echo "=========================================="

# 1. Buat dashboard HTML statis dari data sistem
echo "[1/3] Membangun Dashboard..."
mkdir -p ~/mico_jdeq/dashboard_web
cat > ~/mico_jdeq/dashboard_web/index.html << 'HTML'
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="refresh" content="30">
    <title>MICO-JDEQ Dashboard</title>
    <style>
        body { background: #0a0a0a; color: #00ff00; font-family: monospace; padding: 1rem; }
        .card { background: #111; border: 1px solid #00ff00; padding: 10px; margin: 5px 0; border-radius: 5px; }
        .online { color: #00ff00; } .offline { color: #ff4444; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 10px; }
    </style>
</head>
<body>
    <h1>🌐 MICO-JDEQ</h1>
    <p>Digital Awareness OS — <span id="time"></span></p>
    <div class="grid" id="nodes"></div>
    <div class="card" id="health"></div>
    <script>
        document.getElementById('time').textContent = new Date().toLocaleString('id-ID');
        // Auto-refresh data setiap 30 detik
        fetch('/health.json').then(r => r.json()).then(data => {
            let html = '';
            for (let [node, status] of Object.entries(data.nodes)) {
                html += `<div class="card"><b>${node.toUpperCase()}</b><br><span class="${status}">${status}</span></div>`;
            }
            document.getElementById('nodes').innerHTML = html;
            document.getElementById('health').textContent = JSON.stringify(data, null, 2);
        });
    </script>
</body>
</html>
HTML
echo "  ✅ Dashboard HTML siap."

# 2. Buat health.json otomatis (data real-time)
echo "[2/3] Membangun Health API..."
cat > ~/mico_jdeq/scripts/generate_health_json.sh << 'HEALTH'
#!/data/data/com.termux/files/usr/bin/bash
cat > ~/mico_jdeq/dashboard_web/health.json << EOF
{
  "nodes": {
    "scout": "$(pgrep sshd >/dev/null && echo 'ONLINE' || echo 'OFFLINE')",
    "radar": "$(ssh -o ConnectTimeout=2 iswan@z83-server.tail2a1291.ts.net 'echo ONLINE' 2>/dev/null || echo 'OFFLINE')",
    "penjaga": "$(ssh -o ConnectTimeout=2 -p 8022 iswan@100.103.39.81 'echo ONLINE' 2>/dev/null || echo 'OFFLINE')"
  },
  "timestamp": "$(date)",
  "commit": "$(git -C ~/mico_jdeq log --oneline -1 2>/dev/null || echo 'N/A')"
}
EOF
HEALTH
chmod +x ~/mico_jdeq/scripts/generate_health_json.sh
bash ~/mico_jdeq/scripts/generate_health_json.sh
# Jalankan setiap 5 menit
(crontab -l 2>/dev/null | grep -v generate_health_json; echo "*/5 * * * * bash ~/mico_jdeq/scripts/generate_health_json.sh") | crontab -
echo "  ✅ Health JSON otomatis."

# 3. Host dashboard di Z83 via Python HTTP server
echo "[3/3] Hosting Dashboard di Z83..."
ssh iswan@z83-server.tail2a1291.ts.net "mkdir -p ~/mico_jdeq/dashboard_web && cat > ~/mico_jdeq/dashboard_web/index.html" < ~/mico_jdeq/dashboard_web/index.html
ssh iswan@z83-server.tail2a1291.ts.net "cd ~/mico_jdeq/dashboard_web && nohup python3 -m http.server 8080 > /dev/null 2>&1 & echo '✅ Dashboard hosted di port 8080'"

# Commit
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0064: Deploy Dashboard Sendiri — 100% Otomatis, Tanpa Daftar" && git push origin main

echo ""
echo "=========================================="
echo " DASHBOARD MICO-JDEQ SENDIRI — AKTIF"
echo " Akses: http://z83-server.local:8080"
echo " Auto-refresh: setiap 30 detik"
echo " 100% OTOMATIS — TANPA DAFTAR"
echo "=========================================="
