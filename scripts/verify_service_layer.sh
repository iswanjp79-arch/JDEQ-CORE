#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: VERIFIKASI SERVICE & AUTOMATION"
echo "=========================================="
PASS=0; FAIL=0

# 1. Cek SSH di Radar
echo "[1/6] Cek SSHD Radar..."
if ssh iswan@z83-server.tail2a1291.ts.net "systemctl is-active ssh" 2>/dev/null | grep -q active; then
    echo "  ✅ SSHD Radar: AKTIF"; ((PASS++))
else
    echo "  ❌ SSHD Radar: MATI"; ((FAIL++))
fi

# 2. Cek SSH di Penjaga
echo "[2/6] Cek SSHD Penjaga..."
if ssh -p 8022 iswan@100.103.39.81 "pgrep sshd > /dev/null && echo active" 2>/dev/null | grep -q active; then
    echo "  ✅ SSHD Penjaga: AKTIF"; ((PASS++))
else
    echo "  ❌ SSHD Penjaga: MATI"; ((FAIL++))
fi

# 3. Cek NATS di Radar
echo "[3/6] Cek NATS Radar..."
if ssh iswan@z83-server.tail2a1291.ts.net "systemctl is-active nats-server" 2>/dev/null | grep -q active; then
    echo "  ✅ NATS: AKTIF"; ((PASS++))
else
    echo "  ❌ NATS: MATI"; ((FAIL++))
fi

# 4. Cek Crond di Scout
echo "[4/6] Cek Crond Scout..."
if pgrep crond > /dev/null; then
    echo "  ✅ Crond: AKTIF"; ((PASS++))
else
    echo "  ❌ Crond: MATI"; ((FAIL++))
fi

# 5. Cek Health Check
echo "[5/6] Cek Health Check..."
if bash ~/mico_jdeq/scripts/health_check.sh 2>/dev/null | grep -q "Radar  : ✅"; then
    echo "  ✅ Health Check: BERFUNGSI"; ((PASS++))
else
    echo "  ❌ Health Check: GAGAL"; ((FAIL++))
fi

# 6. Cek Cron job laporan dewan
echo "[6/6] Cek Cron Laporan Dewan..."
if crontab -l 2>/dev/null | grep -q laporan_dewan; then
    echo "  ✅ Cron Laporan: AKTIF"; ((PASS++))
else
    echo "  ❌ Cron Laporan: TIDAK AKTIF"; ((FAIL++))
fi

echo ""
echo "=============================================="
echo " HASIL: $PASS/6 LULUS"
[ $FAIL -eq 0 ] && echo " STATUS: SERVICE & AUTOMATION TERVERIFIKASI ✅" || echo " STATUS: PERLU PERBAIKAN"
echo "=============================================="
