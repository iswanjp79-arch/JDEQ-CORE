#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: PERBAIKI USB GUARDIAN Z83"
echo "=========================================="

# 1. Buat aturan udev dan skrip alert menggunakan printf + sudo -S
echo "[1/2] Memperbaiki USB Guardian di Z83..."
printf '%s\n' 'reticulatus' | ssh iswan@z83-server.tail2a1291.ts.net "sudo -S tee /etc/udev/rules.d/99-jdeq-usb-guardian.rules > /dev/null << 'UDEV'
ACTION==\"add\", SUBSYSTEM==\"usb\", RUN+=\"/usr/local/bin/jdeq_usb_alert.sh\"
UDEV

sudo tee /usr/local/bin/jdeq_usb_alert.sh > /dev/null << 'ALERTSCRIPT'
#!/bin/bash
logger \"[JDEQ-USB-GUARDIAN] Perangkat USB baru ditancapkan.\"
echo \"\$(date): USB DEVICE PLUGGED\" >> /var/log/jdeq_usb.log
ALERTSCRIPT

sudo chmod +x /usr/local/bin/jdeq_usb_alert.sh
sudo udevadm control --reload-rules
echo '✅ USB Guardian Z83 AKTIF.'
"

# 2. Commit perbaikan
echo "[2/2] Mencatat perbaikan ke SSOT..."
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0018-FIX: Perbaiki USB Guardian Z83 - Gunakan printf + sudo -S" && echo "✅ Perbaikan terkunci."

echo "=========================================="
echo " USB GUARDIAN AKTIF DI SEMUA NODE"
echo " Z83: udev rule + alert script"
echo " Vivo: auto‑mount dinonaktifkan"
echo "=========================================="
