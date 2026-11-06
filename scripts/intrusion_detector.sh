#!/data/data/com.termux/files/usr/bin/bash
echo "=============================================="
echo " MICO-JDEQ INTRUSION DETECTOR — MENARA PENGAWAS"
echo "=============================================="
ALERT=0

# 1. Periksa perubahan MANIFEST
echo "[1/5] Memeriksa integritas MANIFEST..."
cd ~/mico_jdeq
if git diff --name-only | grep -q "MANIFEST\|SYSTEM_LOCK"; then
    echo "  ⚠️ PERINGATAN: MANIFEST berubah! Ini mungkin tanda penyusupan."
    ALERT=1
else
    echo "  ✅ MANIFEST tidak berubah."
fi

# 2. Periksa proses mencurigakan
echo "[2/5] Memeriksa proses mencurigakan..."
SUSPICIOUS=$(ps aux | grep -v grep | grep -E "keylog|trojan|malware|backdoor|reverse_shell|/tmp/|/dev/shm/")
if [ -n "$SUSPICIOUS" ]; then
    echo "  ⚠️ PERINGATAN: Proses mencurigakan terdeteksi!"
    echo "$SUSPICIOUS"
    ALERT=1
else
    echo "  ✅ Tidak ada proses mencurigakan."
fi

# 3. Periksa koneksi jaringan mencurigakan
echo "[3/5] Memeriksa koneksi mencurigakan..."
if ss -tunap 2>/dev/null | grep -v grep | grep -E ":4444|:1337|:6667|:31337"; then
    echo "  ⚠️ PERINGATAN: Port mencurigakan terbuka!"
    ALERT=1
else
    echo "  ✅ Tidak ada port mencurigakan."
fi

# 4. Periksa file baru di folder sistem
echo "[4/5] Memeriksa file baru mencurigakan..."
NEW_FILES=$(find ~/mico_jdeq -name "*.sh" -o -name "*.py" -o -name "*.exe" | while read f; do
    if [ ! -f "$f.hash" ] || [ "$(sha256sum "$f" | cut -d' ' -f1)" != "$(cat "$f.hash")" ]; then
        echo "  ⚠️ File baru/berubah: $f"
    fi
done)
if [ -n "$NEW_FILES" ]; then
    echo "$NEW_FILES"
    ALERT=1
else
    echo "  ✅ Tidak ada file mencurigakan."
fi

# 5. Periksa penggunaan disk abnormal
echo "[5/5] Memeriksa penggunaan disk..."
DISK_USAGE=$(df -h /data | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 90 ]; then
    echo "  ⚠️ PERINGATAN: Disk hampir penuh! ($DISK_USAGE%) - Kemungkinan amoeba splitting."
    ALERT=1
else
    echo "  ✅ Disk aman ($DISK_USAGE%)."
fi

echo ""
echo "=============================================="
if [ $ALERT -eq 0 ]; then
    echo " STATUS: AMAN ✅"
else
    echo " STATUS: ADA PELANGGARAN! ⚠️"
fi
echo "=============================================="
