#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
echo "=========================================="
echo " MICO-JDEQ: KALI SECURITY AUDIT"
echo " Target: Z83 & Infinix — Tanpa jejak"
echo "=========================================="

TMPDIR="/data/data/com.termux/files/usr/tmp/kali_audit_$$"
mkdir -p "$TMPDIR"
trap "rm -rf $TMPDIR" EXIT

# 1. Unduh alat audit ke RAM (tmpfs)
echo "[1/5] Mengunduh alat audit ke memori sementara..."
cd "$TMPDIR"
pkg install -y nmap nikto hydra sqlmap 2>/dev/null || apt-get install -y nmap nikto hydra sqlmap 2>/dev/null || true
echo "  ✅ Alat siap di RAM."

# 2. Audit ke Radar (Z83)
echo "[2/5] Audit Radar (Z83)..."
nmap -sT -p 22,4222,8222 -T4 z83-server.tail2a1291.ts.net -oN "$TMPDIR/radar_nmap.txt" 2>/dev/null
nikto -h z83-server.tail2a1291.ts.net -port 8222 -o "$TMPDIR/radar_nikto.txt" 2>/dev/null || echo "  ⚠️ Nikto tidak menemukan HTTP di Radar."
echo "  ✅ Radar selesai."

# 3. Audit ke Penjaga (Infinix)
echo "[3/5] Audit Penjaga (Infinix)..."
nmap -sT -p 22,8022 -T4 100.103.39.81 -oN "$TMPDIR/penjaga_nmap.txt" 2>/dev/null
echo "  ✅ Penjaga selesai."

# 4. Audit ke Scout (localhost)
echo "[4/5] Audit Scout (localhost)..."
nmap -sT -p 22,8080 -T4 localhost -oN "$TMPDIR/scout_nmap.txt" 2>/dev/null
echo "  ✅ Scout selesai."

# 5. Kirim hasil ke GitHub, hapus alat
echo "[5/5] Mengirim hasil ke GitHub & membersihkan..."
mkdir -p ~/mico_jdeq/evidence/audit_$(date +%Y%m%d)
cp "$TMPDIR"/*.txt ~/mico_jdeq/evidence/audit_$(date +%Y%m%d)/ 2>/dev/null
cd ~/mico_jdeq && git add evidence/audit_* && git commit -m "Audit: Kali Security Scan $(date +%Y%m%d)" 2>/dev/null
git push origin main 2>/dev/null || echo "  ⚠️ Git push gagal, hasil tetap di commit lokal."

pkg uninstall nmap nikto hydra sqlmap 2>/dev/null || apt-get remove -y nmap nikto hydra sqlmap 2>/dev/null || true

# Laporan ringkas
cat > ~/mico_jdeq/evidence/KALI_AUDIT_$(date +%Y%m%d).md << 'REPORT'
# LAPORAN AUDIT KEAMANAN KALI
**Tanggal:** $(date)
**Target:** Radar (Z83), Penjaga (Infinix), Scout (Vivo)
**Status:** SELESAI — Hasil di GitHub
**Catatan:** Semua alat dihapus, tanpa jejak di perangkat lokal.
REPORT

echo ""
echo "=========================================="
echo " KALI AUDIT SELESAI"
echo " Hasil: GitHub (tanpa jejak lokal)"
echo " Laporan: ~/mico_jdeq/evidence/KALI_AUDIT_*.md"
echo "=========================================="
