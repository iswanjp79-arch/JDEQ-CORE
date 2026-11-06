#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: EARLY WARNING & ALERTING SYSTEM"
echo "=========================================="

# 1. Alert Observer (di Radar)
echo "[1/4] Membangun Alert Observer di Radar..."
ssh iswan@z83-server.tail2a1291.ts.net 'sudo mkdir -p /opt/jdeq && sudo tee /opt/jdeq/alert_observer.sh > /dev/null << '\''EOF'\''
#!/bin/bash
LOG=/var/log/jdeq_alerts.log
CPU=$(top -bn1 | grep "Cpu(s)" | awk '\''{print $2}'\'' | cut -d'\''%'\'' -f1)
RAM=$(free -m | awk '\''/Mem:/ {print int($3/$2*100)}'\'')
DISK=$(df -h / | awk '\''NR==2 {print int($5)}'\'')

[ $(echo "$CPU > 80" | bc) -eq 1 ] && echo "$(date): CPU HIGH ($CPU%)" >> $LOG
[ "$RAM" -gt 80 ] && echo "$(date): RAM HIGH ($RAM%)" >> $LOG
[ "$DISK" -gt 80 ] && echo "$(date): DISK HIGH ($DISK%)" >> $LOG
EOF
sudo chmod +x /opt/jdeq/alert_observer.sh'

# 2. Notifikasi via Telegram
echo "[2/4] Menghubungkan Alert ke Telegram..."
cat > ~/mico_jdeq/scripts/send_alert.sh << 'ALERT'
#!/data/data/com.termux/files/usr/bin/bash
MSG="🚨 MICO-JDEQ ALERT: $1"
curl -s -X POST "https://api.telegram.org/bot8052456691:AAFCe6dKIk-_YsnLnLfyMs4Ckn9N4BB28Ps/sendMessage" \
  -d "chat_id=MASUKKAN_CHAT_ID" -d "text=$MSG" -d "parse_mode=HTML" > /dev/null 2>&1 && echo "✅ Alert terkirim." || echo "⚠️ Alert gagal."
ALERT
chmod +x ~/mico_jdeq/scripts/send_alert.sh

# 3. Simple Anomaly Detector (SAD)
echo "[3/4] Memasang Simple Anomaly Detector..."
cat > ~/mico_jdeq/scripts/anomaly_detector.sh << 'SAD'
#!/data/data/com.termux/files/usr/bin/bash
THRESHOLD=90
RAM=$(free -m | awk '/Mem:/ {print int($3/$2*100)}')
DISK=$(df -h /data | awk 'NR==2 {print int($5)}')
[ "$RAM" -gt "$THRESHOLD" ] && bash ~/mico_jdeq/scripts/send_alert.sh "RAM kritis: ${RAM}%!"
[ "$DISK" -gt "$THRESHOLD" ] && bash ~/mico_jdeq/scripts/send_alert.sh "Disk kritis: ${DISK}%!"
echo "$(date): Anomaly check selesai. RAM=${RAM}%, DISK=${DISK}%" >> ~/mico_jdeq/journal/anomaly.log
SAD
chmod +x ~/mico_jdeq/scripts/anomaly_detector.sh

# 4. Pasang di crontab
echo "[4/4] Mengaktifkan Alerting (setiap 5 menit)..."
(crontab -l 2>/dev/null | grep -v 'anomaly_detector\|send_alert'; echo "*/5 * * * * bash ~/mico_jdeq/scripts/anomaly_detector.sh") | crontab -

echo "=========================================="
echo " EARLY WARNING SYSTEM AKTIF"
echo " Alert Observer: Radar (CPU/RAM/Disk > 80%)"
echo " Anomaly Detector: Scout (RAM/Disk > 90%)"
echo " Notifikasi: Telegram"
echo "=========================================="
