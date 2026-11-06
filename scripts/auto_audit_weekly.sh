#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
LOG="$HOME/mico_jdeq/journal/weekly_audit.log"
echo "[$(date)] MEMULAI AUDIT MINGGUAN OTOMATIS" >> $LOG

TMPDIR="/data/data/com.termux/files/usr/tmp/weekly_audit_$$"
mkdir -p "$TMPDIR"
trap "rm -rf $TMPDIR" EXIT

# 1. Muat amunisi ke RAM
cd "$TMPDIR"
pkg install -y nmap nikto 2>/dev/null || true

# 2. Audit semua node
nmap -sT -p 22,4222,8222 -T4 z83-server.tail2a1291.ts.net -oN "$TMPDIR/radar.txt" 2>/dev/null
nmap -sT -p 22,8022 -T4 100.103.39.81 -oN "$TMPDIR/penjaga.txt" 2>/dev/null
nmap -sT -p 22,8080 -T4 localhost -oN "$TMPDIR/scout.txt" 2>/dev/null

# 3. Kirim ke GitHub
mkdir -p ~/mico_jdeq/evidence/audit_$(date +%Y%m%d)
cp "$TMPDIR"/*.txt ~/mico_jdeq/evidence/audit_$(date +%Y%m%d)/ 2>/dev/null
cd ~/mico_jdeq && git add evidence/audit_* && git commit -m "Auto Audit Weekly $(date +%Y%m%d)" 2>/dev/null
git push origin main 2>/dev/null || true

# 4. Bersihkan RAM
pkg uninstall nmap nikto 2>/dev/null || true

# 5. Laporan ringkas
cat > ~/mico_jdeq/evidence/AUDIT_WEEKLY_$(date +%Y%m%d).md << 'REPORT'
# LAPORAN AUDIT MINGGUAN OTOMATIS
**Tanggal:** $(date)
**Target:** Radar (Z83), Penjaga (Infinix), Scout (Vivo)
**Status:** SELESAI — Hasil di GitHub
**Catatan:** Tanpa jejak alat di perangkat lokal.
REPORT

echo "[$(date)] AUDIT MINGGUAN SELESAI" >> $LOG
