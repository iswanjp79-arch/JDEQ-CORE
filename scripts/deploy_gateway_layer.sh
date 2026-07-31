#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: DEPLOY GATEWAY LAYER DI Z83"
echo "=========================================="

# 1. Pasang Caddy sebagai Reverse Proxy
echo "[1/3] Memasang Caddy Reverse Proxy..."
ssh iswan@z83-server.tail2a1291.ts.net "echo 'reticulatus' | sudo -S apt install -y caddy && echo 'reticulatus' | sudo -S tee /etc/caddy/Caddyfile > /dev/null << 'CADDY'
:80 {
    reverse_proxy localhost:8222
    log {
        output file /var/log/caddy/jdeq.log
    }
}
CADDY
echo 'reticulatus' | sudo -S systemctl enable caddy --now && echo '✅ Caddy aktif di port 80.'"

# 2. Pasang MQTT Bridge (penghubung ke cloud)
echo "[2/3] Memasang MQTT Bridge..."
ssh iswan@z83-server.tail2a1291.ts.net "echo 'reticulatus' | sudo -S apt install -y mosquitto mosquitto-clients && echo 'reticulatus' | sudo -S tee /etc/mosquitto/conf.d/jdeq_bridge.conf > /dev/null << 'MQTT'
connection jdeq_cloud
address cloud_mqtt:1883
topic # both 0
MQTT
echo 'reticulatus' | sudo -S systemctl enable mosquitto --now && echo '✅ MQTT Bridge aktif.'"

# 3. Commit & Checkpoint
echo "[3/3] Menyegel ke SSOT..."
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0016: Deploy Gateway Layer - Caddy Reverse Proxy & MQTT Bridge" && echo "✅ Gateway Layer terkunci."

# Notifikasi Telegram
bash ~/mico_jdeq/scripts/notify_telegram.sh "✅ Gateway Layer Z83: Caddy + MQTT Bridge AKTIF" 2>/dev/null || true

echo "=========================================="
echo " GATEWAY LAYER AKTIF DI Z83"
echo " Caddy : Reverse Proxy port 80 → 8222"
echo " MQTT  : Bridge ke Cloud aktif"
echo "=========================================="
