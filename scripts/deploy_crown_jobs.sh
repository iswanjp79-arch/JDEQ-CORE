#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: DEPLOY CROWN JOBS"
echo "=========================================="

# 1. Crown Job: Pemicu Tailscale Android setiap 5 menit
echo "[1/3] Memasang Crown Tailscale..."
(crontab -l 2>/dev/null; echo "*/5 * * * * am start -n com.tailscale.ipn/.ui.MainActivity 2>/dev/null") | crontab -
echo "  ✅ Crown Tailscale: setiap 5 menit."

# 2. Crown Job: Laporan Dewan setiap 8 pagi & 8 malam
echo "[2/3] Memasang Crown Laporan Dewan..."
(crontab -l 2>/dev/null; echo "0 8,20 * * * bash ~/mico_jdeq/scripts/laporan_dewan.sh") | crontab -
echo "  ✅ Crown Laporan: 08:00 & 20:00."

# 3. Crown Job: Health Check setiap 10 menit
echo "[3/3] Memasang Crown Health Check..."
(crontab -l 2>/dev/null; echo "*/10 * * * * bash ~/mico_jdeq/scripts/health_check.sh >> ~/mico_jdeq/journal/health_cron.log") | crontab -
echo "  ✅ Crown Health Check: setiap 10 menit."

# Verifikasi
echo ""
echo "=========================================="
echo " CROWN JOBS TERPASANG:"
crontab -l | grep -v "^#"
echo "=========================================="
echo " STATUS: CROWN JOBS AKTIF"
echo "=========================================="
