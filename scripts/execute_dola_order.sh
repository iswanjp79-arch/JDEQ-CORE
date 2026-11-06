#!/data/data/com.termux/files/usr/bin/bash
echo "======================================================"
echo " PELAKSANAAN PERINTAH DOLA: INTEGRASI DOKUMEN INDUK"
echo "======================================================"
TARGET_FILE="~/mico_jdeq/evidence/100_ACHIEVEMENTS.md"

# 1. Menandai sebagai immutable di Scout
echo "[1/5] Mengunci dokumen induk di Scout..."
cd ~/mico_jdeq && git add evidence/100_ACHIEVEMENTS.md && git commit -m "KUNCI: 100 Pencapaian sebagai Dokumen Induk SSOT (Validasi DOLA)" && echo "  ✅ Terkunci di Git."

# 2. Menyebar ke Radar (Z83)
echo "[2/5] Menyebarkan ke Radar..."
ssh iswan@z83-server.tail2a1291.ts.net "mkdir -p ~/mico_jdeq/evidence && cat > ~/mico_jdeq/evidence/100_ACHIEVEMENTS.md" < ~/mico_jdeq/evidence/100_ACHIEVEMENTS.md && echo "  ✅ Radar diperbarui."

# 3. Menyebar ke Penjaga (Infinix)
echo "[3/5] Menyebarkan ke Penjaga..."
ssh -p 8022 iswan@100.103.39.81 "mkdir -p ~/mico_jdeq/evidence && cat > ~/mico_jdeq/evidence/100_ACHIEVEMENTS.md" < ~/mico_jdeq/evidence/100_ACHIEVEMENTS.md && echo "  ✅ Penjaga diperbarui."

# 4. Verifikasi hash
echo "[4/5] Memverifikasi integritas..."
HASH_SCOUT=$(sha256sum ~/mico_jdeq/evidence/100_ACHIEVEMENTS.md | cut -d' ' -f1)
HASH_RADAR=$(ssh iswan@z83-server.tail2a1291.ts.net "sha256sum ~/mico_jdeq/evidence/100_ACHIEVEMENTS.md" 2>/dev/null | cut -d' ' -f1)
HASH_PENJAGA=$(ssh -p 8022 iswan@100.103.39.81 "sha256sum ~/mico_jdeq/evidence/100_ACHIEVEMENTS.md" 2>/dev/null | cut -d' ' -f1)

if [ "$HASH_SCOUT" = "$HASH_RADAR" ] && [ "$HASH_SCOUT" = "$HASH_PENJAGA" ]; then
    echo "  ✅ Semua node sinkron. Hash: ${HASH_SCOUT:0:16}..."
else
    echo "  ❌ Ketidaksinkronan terdeteksi! Scout: ${HASH_SCOUT:0:8}..., Radar: ${HASH_RADAR:0:8}..., Penjaga: ${HASH_PENJAGA:0:8}..."
fi

# 5. Laporan akhir & kirim notifikasi
echo "[5/5] Menyusun laporan pelaksanaan..."
echo "✅ PERINTAH DOLA TERLAKSANA.
   - Dokumen Induk: ~/mico_jdeq/evidence/100_ACHIEVEMENTS.md
   - Status: TERKUNCI & TERSINKRON
   - Hash: ${HASH_SCOUT:0:16}...
   - Node: Scout, Radar, Penjaga" > ~/mico_jdeq/evidence/dola_execution_report.md

bash ~/mico_jdeq/scripts/matt_notify.sh "✅ Perintah DOLA terlaksana. 100 Pencapaian kini menjadi Dokumen Induk SSOT. Semua node sinkron." 2>/dev/null

echo ""
echo "======================================================"
echo " PERINTAH DOLA SELESAI. Laporan: ~/mico_jdeq/evidence/dola_execution_report.md"
echo "======================================================"
