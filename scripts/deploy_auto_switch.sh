#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: MEGA ZORD AUTO-SWITCH"
echo "=========================================="

# 1. Buat skrip auto-switch
echo "[1/3] Membangun Auto-Switch Engine..."
cat > ~/mico_jdeq/scripts/auto_switch.sh << 'SWITCH'
#!/data/data/com.termux/files/usr/bin/bash
LOG="$HOME/mico_jdeq/journal/auto_switch.log"
GATEWAY="192.168.1.1"
MAGIC_DNS="z83-server.tail2a1291.ts.net"
INFINIX_IP="100.103.39.81"

echo "[$(date '+%H:%M:%S')] Auto-Switch: Memeriksa jaringan..." >> $LOG

# Deteksi WiFi rumah
if ping -c1 -W2 $GATEWAY > /dev/null 2>&1; then
    echo "[$(date '+%H:%M:%S')] MODE: WIFI RUMAH" >> $LOG
    # Pastikan alias radar & penjaga tersedia
    grep -q "alias radar=" ~/.bashrc || echo "alias radar='ssh iswan@z83-server.tail2a1291.ts.net'" >> ~/.bashrc
    grep -q "alias penjaga=" ~/.bashrc || echo "alias penjaga='ssh -p 8022 iswan@$INFINIX_IP'" >> ~/.bashrc
    source ~/.bashrc 2>/dev/null
    echo "MODE: 🏠 WIFI RUMAH — Jalur lokal siap."
else
    echo "[$(date '+%H:%M:%S')] MODE: GSM SMARTFREN — Mengaktifkan Tailscale..." >> $LOG
    # Paksa Tailscale Android aktif
    am start -n com.tailscale.ipn/.ui.MainActivity 2>/dev/null
    sleep 5
    # Gunakan MagicDNS untuk akses remote
    grep -q "alias radar=" ~/.bashrc || echo "alias radar='ssh iswan@$MAGIC_DNS'" >> ~/.bashrc
    grep -q "alias penjaga=" ~/.bashrc || echo "alias penjaga='ssh -p 8022 iswan@$INFINIX_IP'" >> ~/.bashrc
    source ~/.bashrc 2>/dev/null
    echo "MODE: 📡 GSM SMARTFREN — Tailscale aktif, MagicDNS siap."
fi

# Catat status koneksi
echo "[$(date '+%H:%M:%S')] Koneksi: $(ping -c1 -W2 8.8.8.8 > /dev/null 2>&1 && echo 'ONLINE' || echo 'OFFLINE')" >> $LOG
SWITCH
chmod +x ~/mico_jdeq/scripts/auto_switch.sh
echo "  ✅ Auto-Switch Engine siap."

# 2. Pasang di crontab setiap 2 menit
echo "[2/3] Memasang Auto-Switch di Crontab (setiap 2 menit)..."
(crontab -l 2>/dev/null | grep -v auto_switch; echo "*/2 * * * * bash ~/mico_jdeq/scripts/auto_switch.sh") | crontab -
echo "  ✅ Crontab terpasang."

# 3. Uji langsung
echo "[3/3] Menguji Auto-Switch..."
bash ~/mico_jdeq/scripts/auto_switch.sh

# Commit
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0035: Deploy MEGA ZORD Auto-Switch — WiFi/GSM Hybrid" && echo "✅ Auto-Switch terkunci."

# Notifikasi
bash ~/mico_jdeq/scripts/send_alert.sh "📡 MEGA ZORD AUTO-SWITCH AKTIF
✅ WiFi → GSM otomatis
✅ Tailscale dipicu saat di luar
✅ MagicDNS siap
STATUS: MOBILITAS PENUH" 2>/dev/null || true

echo ""
echo "=========================================="
echo " MEGA ZORD AUTO-SWITCH AKTIF"
echo " 🏠 WiFi rumah: jalur lokal"
echo " 📡 GSM Smartfren: Tailscale + MagicDNS"
echo " Setiap 2 menit: auto-switch"
echo "=========================================="
