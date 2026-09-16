#!/data/data/com.termux/files/usr/bin/bash
echo "=== MICO-JDEQ SSOT PURIFIER ==="
echo ""

# --- 1. Buat struktur SSOT baru ---
echo ">> Membangun struktur ssot/..."
mkdir -p ssot/00_PIAGAM
mkdir -p ssot/01_ARCHITECTURE
mkdir -p ssot/02_NODES/{Z83,PC-I5,VIVO,INFINIX}
mkdir -p ssot/03_POLICIES
mkdir -p ssot/04_EVIDENCE/{baseline,snapshots}
echo "   ✅ Struktur ssot/ selesai."

# --- 2. Salin Prasasti & SSOT Resmi ---
echo ">> Menyalin Prasasti & SSOT Resmi..."
cp PRASASTI_MICO_JDEQ.md ssot/00_PIAGAM/PRASASTI.md
cp JDEQ/SSOT_OFFICIAL/MICO_JDEQ_SSOT_v2.0.md ssot/00_PIAGAM/SSOT_RESMI_v2.0.md
echo "   ✅ Prasasti & SSOT Resmi disalin."

# --- 3. Satukan Piagam Dasar ---
echo ">> Menyusun Piagam Dasar Tunggal..."
cat mico_jdeq/piagam/PIAGAM_DASAR.md > ssot/00_PIAGAM/PIAGAM_DASAR.md
echo "" >> ssot/00_PIAGAM/PIAGAM_DASAR.md
echo "## Prinsip Tambahan (dari Piagam Kanban)" >> ssot/00_PIAGAM/PIAGAM_DASAR.md
tail -n +3 mico_jdeq/kanban/PIAGAM.md >> ssot/00_PIAGAM/PIAGAM_DASAR.md
echo "   ✅ Piagam Dasar Tunggal disusun."

# --- 4. Salin dokumen pendukung ---
echo ">> Menyalin dokumen pendukung..."
cp JDEQ/SSOT/BUILD_STATUS.md ssot/01_ARCHITECTURE/
cp JDEQ/SSOT/JARVIS_CODE_BAN.md ssot/03_POLICIES/
cp -r MICO_PLATFORM/M03_SSOT/* ssot/01_ARCHITECTURE/ 2>/dev/null
echo "   ✅ Dokumen pendukung disalin."

# --- 5. Arsipkan bayangan SSOT lama ---
echo ">> Mengarsipkan bayangan SSOT..."
mkdir -p ssot/04_EVIDENCE/snapshots/piagam_lama
cp mico_jdeq/kanban/PIAGAM.md ssot/04_EVIDENCE/snapshots/piagam_lama/
cp mico_jdeq/charter/PIAGAM.md ssot/04_EVIDENCE/snapshots/piagam_lama/
cp mico_jdeq/piagam/PIAGAM_DASAR.md ssot/04_EVIDENCE/snapshots/piagam_lama/
cp JDEQ_backup_20260709/00_SSOT/constitution.md ssot/04_EVIDENCE/snapshots/piagam_lama/
cp JDEQ_backup_20260709/00_SSOT/HIRARKI_RESMI.md ssot/04_EVIDENCE/snapshots/piagam_lama/
echo "   ✅ Arsip bayangan selesai."

# --- 6. Ringkasan ---
echo ""
echo "=== PEMURNIAN SELESAI ==="
echo "Struktur baru:"
tree ssot/ 2>/dev/null || ls -R ssot/
echo ""
echo "File asli tetap aman di tempatnya."
echo "Struktur baru ada di: $(pwd)/ssot/"
echo ""
echo "🛡️ Tindakan ini AMAN. Belum ada file yang dihapus."
