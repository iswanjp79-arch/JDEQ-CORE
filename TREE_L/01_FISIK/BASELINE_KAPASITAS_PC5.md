# BASELINE KAPASITAS PC-i5 — KAPAL-INDUK
Tanggal: 2026-09-07

## Status Perangkat
- Node ID : KAPAL-INDUK
- Peran   : HEAVY_LOCAL_WORKER
- CPU     : Intel Core i5
- RAM     : 16 GB
- Drive C : SSD 128 GB (OS) — awas penuh
- Drive D : HDD 1 TB (Data)
- Drive E : HDD 500 GB (Impuls)
- GPU     : Tidak ada — jangan panggil model besar
- OS      : Windows Enterprise

## Batas Kerja Aman
- Maksimum RAM untuk proses AI: 8 GB
- Maksimum disk C: 80% dari kapasitas
- Tanpa GPU: embedding besar harus lewat cloud worker
- Jangan jalankan 2 tugas berat bersamaan

## EOS / EOF
- EOS: Akhir dari sesi pengembangan.
- EOF: Akhir dari file log atau bukti.
- Setiap selesai wajib menulis penanda EOF di log.

## SSOT
- Sumber kebenaran tunggal: D:\MICO_SSOT\TREE_L
- Semua keputusan wajib merujuk ke sini.
