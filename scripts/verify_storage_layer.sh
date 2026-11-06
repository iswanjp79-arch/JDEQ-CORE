#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: VERIFIKASI LAPISAN STORAGE"
echo "=========================================="
PASS=0; FAIL=0

# 1. Cek SSOT di Scout
echo "[1/5] Cek SSOT Scout..."
if [ -d ~/mico_jdeq ] && [ -f ~/mico_jdeq/manifest/SYSTEM_LOCK.md ]; then
    echo "  ✅ SSOT Scout: ADA"; ((PASS++))
else
    echo "  ❌ SSOT Scout: TIDAK ADA"; ((FAIL++))
fi

# 2. Cek struktur /srv/jdeq/storage di Radar
echo "[2/5] Cek Storage Radar..."
if ssh iswan@z83-server.tail2a1291.ts.net "[ -d /srv/jdeq/storage/cloud ] && echo 'ADA' || echo 'TIDAK'" 2>/dev/null | grep -q ADA; then
    echo "  ✅ /srv/jdeq/storage: ADA"; ((PASS++))
else
    echo "  ❌ /srv/jdeq/storage: TIDAK ADA"; ((FAIL++))
fi

# 3. Cek Checkpoint
echo "[3/5] Cek Checkpoint..."
if ls ~/mico_jdeq/checkpoint/state_*.tar.gz 2>/dev/null | head -1 | grep -q state; then
    echo "  ✅ Checkpoint: ADA"; ((PASS++))
else
    echo "  ❌ Checkpoint: TIDAK ADA"; ((FAIL++))
fi

# 4. Cek Git versioning
echo "[4/5] Cek Git Versioning..."
cd ~/mico_jdeq && if git log --oneline -1 2>/dev/null | grep -q ADR; then
    echo "  ✅ Git: AKTIF"; ((PASS++))
else
    echo "  ❌ Git: TIDAK AKTIF"; ((FAIL++))
fi

# 5. Cek Journal
echo "[5/5] Cek Journal..."
if [ -f ~/mico_jdeq/journal/groq_observer.log ]; then
    echo "  ✅ Journal: ADA"; ((PASS++))
else
    echo "  ❌ Journal: TIDAK ADA"; ((FAIL++))
fi

echo ""
echo "=============================================="
echo " HASIL: $PASS/5 LULUS"
[ $FAIL -eq 0 ] && echo " STATUS: LAPISAN STORAGE & DATA TERVERIFIKASI ✅" || echo " STATUS: PERLU PERBAIKAN"
echo "=============================================="
