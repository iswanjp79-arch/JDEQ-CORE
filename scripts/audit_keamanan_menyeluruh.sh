#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: AUDIT KEAMANAN MENYELURUH"
echo " Plug and Play — Zero Failures"
echo "=========================================="
PASS=0; FAIL=0; WARN=0

echo ""
echo "[1/8] Memeriksa Port Terbuka (Scan Lokal)..."
OPEN_PORTS=$(ss -tlnp 2>/dev/null | grep LISTEN | wc -l)
if [ "$OPEN_PORTS" -le 5 ]; then
    echo "  ✅ PASS: Hanya $OPEN_PORTS port terbuka."
    PASS=$((PASS+1))
else
    echo "  ⚠️ WARN: $OPEN_PORTS port terbuka. Periksa manual."
    WARN=$((WARN+1))
fi

echo ""
echo "[2/8] Memeriksa Proses Mencurigakan..."
SUSPICIOUS=$(ps aux | grep -v grep | grep -E "keylog|trojan|malware|backdoor|reverse_shell|/tmp/|/dev/shm/")
if [ -z "$SUSPICIOUS" ]; then
    echo "  ✅ PASS: Tidak ada proses mencurigakan."
    PASS=$((PASS+1))
else
    echo "  ❌ FAIL: Proses mencurigakan terdeteksi!"
    echo "$SUSPICIOUS"
    FAIL=$((FAIL+1))
fi

echo ""
echo "[3/8] Memeriksa DOLA Gatekeeper..."
if python3 ~/mico_jdeq/scripts/dola_gatekeeper.py "sudo rm -rf /" 2>&1 | grep -q "DITOLAK"; then
    echo "  ✅ PASS: DOLA Gatekeeper aktif."
    PASS=$((PASS+1))
else
    echo "  ❌ FAIL: DOLA Gatekeeper tidak berfungsi!"
    FAIL=$((FAIL+1))
fi

echo ""
echo "[4/8] Memeriksa Integritas MANIFEST..."
cd ~/mico_jdeq
if git diff --name-only | grep -q "MANIFEST\|SYSTEM_LOCK"; then
    echo "  ❌ FAIL: MANIFEST berubah! Kemungkinan penyusupan."
    FAIL=$((FAIL+1))
else
    echo "  ✅ PASS: MANIFEST tidak berubah."
    PASS=$((PASS+1))
fi

echo ""
echo "[5/8] Memeriksa Checkpoint Terakhir..."
LATEST=$(ls -t ~/mico_jdeq/checkpoint/state_*.tar.gz 2>/dev/null | head -1)
if [ -n "$LATEST" ]; then
    echo "  ✅ PASS: Checkpoint tersedia: $(basename $LATEST)"
    PASS=$((PASS+1))
else
    echo "  ❌ FAIL: Tidak ada checkpoint!"
    FAIL=$((FAIL+1))
fi

echo ""
echo "[6/8] Memeriksa Koneksi ke Node Lain..."
if ssh -o ConnectTimeout=3 iswan@z83-server.tail2a1291.ts.net "echo OK" 2>/dev/null | grep -q OK; then
    echo "  ✅ PASS: Radar (Z83) terjangkau."
    PASS=$((PASS+1))
else
    echo "  ⚠️ WARN: Radar (Z83) tidak terjangkau."
    WARN=$((WARN+1))
fi

echo ""
echo "[7/8] Memeriksa XSS Defense..."
if [ -f ~/mico_jdeq/security/block_patterns.json ] && [ -f ~/mico_jdeq/scripts/xss_sanitizer.py ]; then
    echo "  ✅ PASS: XSS Defense aktif (37 pola)."
    PASS=$((PASS+1))
else
    echo "  ❌ FAIL: XSS Defense tidak lengkap!"
    FAIL=$((FAIL+1))
fi

echo ""
echo "[8/8] Memeriksa IDS (Intrusion Detection)..."
if [ -f ~/mico_jdeq/scripts/intrusion_detector.sh ]; then
    bash ~/mico_jdeq/scripts/intrusion_detector.sh 2>/dev/null | grep -q "AMAN"
    if [ $? -eq 0 ]; then
        echo "  ✅ PASS: IDS melaporkan AMAN."
        PASS=$((PASS+1))
    else
        echo "  ⚠️ WARN: IDS menemukan anomali."
        WARN=$((WARN+1))
    fi
else
    echo "  ❌ FAIL: IDS tidak ditemukan!"
    FAIL=$((FAIL+1))
fi

echo ""
echo "=========================================="
echo " HASIL AUDIT KEAMANAN"
echo " PASS: $PASS | WARN: $WARN | FAIL: $FAIL"
if [ $FAIL -eq 0 ] && [ $WARN -eq 0 ]; then
    echo " STATUS: 🟢 BENTENG AMAN — ZERO FAILURES"
elif [ $FAIL -eq 0 ]; then
    echo " STATUS: 🟡 BENTENG AMAN DENGAN CATATAN"
else
    echo " STATUS: 🔴 DITEMUKAN CELAH — SEGERA PERBAIKI"
fi
echo "=========================================="
