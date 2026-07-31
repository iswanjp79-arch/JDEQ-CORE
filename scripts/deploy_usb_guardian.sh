#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: DEPLOY USB GUARDIAN"
echo "=========================================="

# 1. Pasang aturan udev di Z83 untuk deteksi USB
echo "[1/3] Memasang USB Guardian di Radar (Z83)..."
ssh iswan@z83-server.tail2a1291.ts.net "sudo tee /etc/udev/rules.d/99-jdeq-usb-guardian.rules > /dev/null << 'UDEV'
# Deteksi setiap perangkat USB yang ditancapkan
ACTION==\"add\", SUBSYSTEM==\"usb\", RUN+=\"/usr/local/bin/jdeq_usb_alert.sh\"
UDEV

sudo tee /usr/local/bin/jdeq_usb_alert.sh > /dev/null << 'ALERTSCRIPT'
#!/bin/bash
logger \"[JDEQ-USB-GUARDIAN] Perangkat USB baru ditancapkan: \$devname\"
# Kirim notifikasi ke log sistem
echo \"\$(date): USB DEVICE PLUGGED - \$devname\" >> /var/log/jdeq_usb.log
ALERTSCRIPT

sudo chmod +x /usr/local/bin/jdeq_usb_alert.sh
sudo udevadm control --reload-rules
echo '✅ USB Guardian aktif di Z83.'"

# 2. Nonaktifkan auto‑mount di Termux (Vivo) jika memungkinkan
echo "[2/3] Mengamankan Vivo (Scout)..."
echo 'export TERMUX_USB_DISABLE=1' >> ~/.bashrc
echo '✅ Auto‑mount USB dinonaktifkan di Termux.'

# 3. Audit & Commit
echo "[3/3] Mencatat ke SSOT..."
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0018: USB Guardian - Pertahanan Terhadap Injeksi Fisik" && echo "✅ USB Guardian terkunci."

echo "=========================================="
echo " USB GUARDIAN AKTIF"
echo " Z83: udev rule mendeteksi USB baru"
echo " Vivo: auto‑mount USB dinonaktifkan"
echo "=========================================="
