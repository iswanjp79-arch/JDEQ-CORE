#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ EMERGENCY KILL-SWITCH"
echo "=========================================="
echo "[!] MEMUTUS SEMUA KONEKSI..."
tailscale down 2>/dev/null || echo "   Tailscale tidak aktif."

echo "[!] MEMBERSIHKAN CACHE & TOKEN..."
rm -rf ~/.cache/mico_tmp/* 2>/dev/null
rm -rf __pycache__ 2>/dev/null
pkill -f "python3" 2>/dev/null || true

echo "[!] MENGUNCI STATE DATABASE..."
[ -f ~/mico_jdeq/state/state.db ] && chmod 400 ~/mico_jdeq/state/state.db 2>/dev/null

echo "[!] MENGIRIM NOTIFIKASI DARURAT..."
bash ~/mico_jdeq/scripts/send_alert.sh "🚨 KILL-SWITCH DIAKTIFKAN! Semua koneksi diputus. Sistem terkunci." 2>/dev/null || true

echo ""
echo "=========================================="
echo " BENTENG DITUTUP TOTAL."
echo " VIVO Y28 ADHEM & AMAN."
echo "=========================================="
