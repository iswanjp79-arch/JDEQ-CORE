#!/bin/bash
echo "[L0 RECEIVER] Memeriksa file handoff..."
git pull origin main
ZIP_FILE="MICO_SYSTEM/L6_EVIDENCE_AUDIT/colab_handoff.zip"
if [ -f "$ZIP_FILE" ]; then
    echo "[L0 RECEIVER] Sinyal Colab Handoff Terdeteksi!"
    mkdir -p MICO_SYSTEM/L6_EVIDENCE_AUDIT/COLAB_EXTRACTED
    unzip -o "$ZIP_FILE" -d MICO_SYSTEM/L6_EVIDENCE_AUDIT/COLAB_EXTRACTED/
    rm "$ZIP_FILE"
    echo "[L0 RECEIVER] Estafet Selesai. Silakan periksa folder EXTRACTED."
else
    echo "[L0 RECEIVER] Belum ada file handoff. Menunggu..."
fi
