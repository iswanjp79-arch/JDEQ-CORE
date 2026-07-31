#!/bin/bash
while true; do
    clear
    echo "════════════════════════════════════════════════════════"
    echo "  MICO-JDEQ POHON TERIKAT — VIVO Y28 MULTI HYBRID"
    echo "  KUNCI: Jantung Hidup + Kuantum + Keterikatan Penuh"
    echo "════════════════════════════════════════════════════════"
    echo "  📡 SISI KIRI → CERMINAN AWAN (GITHUB/SSOT)"
    tree -L 4 ~/mico_jdeq/cloud_mirror -I '__pycache__|*.log' 2>/dev/null || echo "  (belum ada data)"
    echo ""
    echo "  📱 SISI KANAN → AKAR LOKAL (VIVO Y28)"
    tree -L 4 ~/mico_jdeq/local_root -I '__pycache__|*.log' 2>/dev/null || echo "  (belum ada data)"
    echo ""
    echo "  🔗 IKATAN: Semua berubah serentak sesuai SSOT"
    echo "════════════════════════════════════════════════════════"
    sleep 5
done
