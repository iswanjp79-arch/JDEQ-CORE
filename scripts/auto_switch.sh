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
