#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: VERIFIKASI LAPISAN KONEKSI"
echo "=========================================="
PASS=0; FAIL=0

# 1. Uji Koneksi SSH ke Radar
echo "[1/4] Uji SSH Radar..."
if ssh -o ConnectTimeout=5 iswan@z83-server.tail2a1291.ts.net "echo ONLINE" 2>/dev/null | grep -q ONLINE; then
    echo "  ✅ Radar SSH: ONLINE"; ((PASS++))
else
    echo "  ❌ Radar SSH: OFFLINE"; ((FAIL++))
fi

# 2. Uji Koneksi SSH ke Penjaga
echo "[2/4] Uji SSH Penjaga..."
if ssh -o ConnectTimeout=5 -p 8022 iswan@100.103.39.81 "echo ONLINE" 2>/dev/null | grep -q ONLINE; then
    echo "  ✅ Penjaga SSH: ONLINE"; ((PASS++))
else
    echo "  ❌ Penjaga SSH: OFFLINE"; ((FAIL++))
fi

# 3. Uji NATS di Radar
echo "[3/4] Uji NATS Radar..."
if ssh iswan@z83-server.tail2a1291.ts.net "curl -s http://localhost:8222/varz" 2>/dev/null | grep -q "server_id"; then
    echo "  ✅ NATS: ONLINE"; ((PASS++))
else
    echo "  ❌ NATS: OFFLINE"; ((FAIL++))
fi

# 4. Uji Tailscale MagicDNS
echo "[4/4] Uji MagicDNS..."
if ssh -o ConnectTimeout=5 iswan@z83-server.tail2a1291.ts.net "echo ONLINE" 2>/dev/null | grep -q ONLINE; then
    echo "  ✅ Tailscale MagicDNS: AKTIF"; ((PASS++))
else
    echo "  ❌ Tailscale MagicDNS: GAGAL"; ((FAIL++))
fi

echo ""
echo "=============================================="
echo " HASIL: $PASS/$((PASS+FAIL)) LULUS"
[ $FAIL -eq 0 ] && echo " STATUS: LAPISAN KONEKSI TERVERIFIKASI" || echo " STATUS: PERLU PERBAIKAN"
echo "=============================================="
