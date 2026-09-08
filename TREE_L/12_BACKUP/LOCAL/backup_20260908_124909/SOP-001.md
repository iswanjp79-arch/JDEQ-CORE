# SOP-001 — Manajemen Sumber Daya PC-i5

## Tujuan
Mencegah over-engineering dan melindungi RAM 16GB + SSD 128GB.

## Aturan
- RAM untuk AI maksimal 8GB; jangan biarkan free < 2GB saat beban berat.
- SSD C free minimal 20%, target 35% sebelum instalasi baru.
- Tanpa GPU diskrit; model besar lewat cloud worker.
- Jangan jalankan dua tugas berat bersamaan.

## Implementasi
- Gunakan `check_capacity.ps1` untuk memantau.
- Catat hasil di 06_RUNTIME.
