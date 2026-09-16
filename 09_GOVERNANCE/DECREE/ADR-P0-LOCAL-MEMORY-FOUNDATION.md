# ADR-P0 — Fondasi Memori Lokal MICO-JDEQ

**Tanggal:** 2026-09-16
**Penulis:** L0 — Iswan Juman Pancoro, ST
**Rancangan teknis:** AG-003 (DeepSeek) — R-CODE / R-PLAN
**Status:** DITERIMA · DILAKSANAKAN

## Konteks
Membangun fondasi memori jangka panjang MICO-JDEQ berbasis berkas
fisik lokal di D:\MICO_SSOT tanpa ketergantungan penyedia luar.

## Keputusan
1. Empat kelompok struktur:
   - 02_DATA\LOCAL_MEMORY       -> sumber utama, human-readable
   - 06_APLIKASI\LOCAL_MEMORY   -> turunan/indeks, boleh dihapus
   - 08_EVIDENCE\MEMORY         -> bukti operasi, tidak diubah
   - 09_GOVERNANCE\LOCAL-MEMORY -> aturan, hanya L0 mengubah
2. MEMORY-POLICY.md = aturan dasar pengendalian memori
3. Commit hanya menyentuh jalur di atas - tanpa data lain
4. Vector DB = opsional, bukan bagian P0
5. Data pribadi (IMPORT-VIVO-Y28, EXTRACT-OHSAS-001,
   .karantina_sensitif) TIDAK masuk commit sistem

## Konsekuensi
- Setiap perubahan memori punya jalur terpisah
- Indeks dapat dihapus & dibangun ulang dari sumber
- Sistem tetap berjalan tanpa komponen tambahan
- Pencegahan data campuran di tingkat staging,
  bukan sesudah commit

## Rujukan
- MICO-P1-LOCAL-MEMORY-001 (draft, RUNTIME NOT AUTHORIZED)
- 09_GOVERNANCE\LOCAL-MEMORY\MEMORY-POLICY.md
