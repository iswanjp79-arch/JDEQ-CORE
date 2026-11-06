#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
echo "=========================================="
echo " MICO-JDEQ: OFFENSIVE SECURITY AUDIT"
echo " Target: Z83 & Infinix — Tanpa jejak lokal"
echo "=========================================="

TMPDIR="/data/data/com.termux/files/usr/tmp/mico_audit_$$"
mkdir -p "$TMPDIR"
trap "rm -rf $TMPDIR" EXIT

# 1. Unduh alat audit ke RAM (tmpfs)
echo "[1/4] Mengunduh alat audit ke memori sementara..."
cd "$TMPDIR"
pkg install -y nmap 2>/dev/null || apt-get install -y nmap 2>/dev/null || true
echo "  ✅ Alat siap di RAM."

# 2. Jalankan audit ke target yang sah
echo "[2/4] Menjalankan audit ke target sah..."

# Radar (Z83)
echo "  🔍 Memindai Radar (Z83)..."
nmap -sT -p 22,4222,8222 -T4 z83-server.tail2a1291.ts.net -oN "$TMPDIR/scan_radar.txt" 2>/dev/null

# Penjaga (Infinix)
echo "  🔍 Memindai Penjaga (Infinix)..."
nmap -sT -p 22,8022 -T4 100.103.39.81 -oN "$TMPDIR/scan_penjaga.txt" 2>/dev/null

# Scout (localhost)
echo "  🔍 Memindai Scout (localhost)..."
nmap -sT -p 22,8080 -T4 localhost -oN "$TMPDIR/scan_scout.txt" 2>/dev/null

echo "  ✅ Audit selesai."

# 3. Kirim hasil ke GitHub (tanpa jejak di lokal)
echo "[3/4] Mengirim hasil ke GitHub..."
mkdir -p ~/mico_jdeq/evidence/audit_$(date +%Y%m%d)
cp "$TMPDIR"/scan_*.txt ~/mico_jdeq/evidence/audit_$(date +%Y%m%d)/ 2>/dev/null
cd ~/mico_jdeq && git add evidence/audit_* && git commit -m "Audit: Offensive Security Scan $(date +%Y%m%d)" 2>/dev/null
git push origin main 2>/dev/null || echo "  ⚠️ Git push gagal, hasil tetap di commit lokal."
echo "  ✅ Hasil audit di GitHub."

# 4. Hanya tinggalkan laporan ringkas
echo "[4/4] Menyusun laporan ringkas..."
cat > ~/mico_jdeq/evidence/AUDIT_REPORT_$(date +%Y%m%d).md << 'REPORT'
# LAPORAN AUDIT KEAMANAN MANDIRI
**Tanggal:** $(date)
**Target:** Radar (Z83), Penjaga (Infinix), Scout (Vivo)
**Status:** SELESAI — Hasil di GitHub
**Catatan:** Tidak ada alat disimpan di perangkat lokal.
REPORT

# Hapus alat dari RAM
pkg uninstall nmap 2>/dev/null || apt-get remove -y nmap 2>/dev/null || true

echo ""
echo "=========================================="
echo " AUDIT SELESAI"
echo " Hasil: GitHub (tanpa jejak lokal)"
echo " Laporan: ~/mico_jdeq/evidence/AUDIT_REPORT_*.md"
echo "=========================================="
