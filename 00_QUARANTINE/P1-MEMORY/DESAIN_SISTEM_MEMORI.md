# DESAIN SISTEM MEMORI LOKAL — P1
Versi: P1-20260917
Prinsip:
- Lokal-pertama: tidak bergantung koneksi
- SHA-256 sebagai sidik jari tunggal
- Karantina sebelum pengesahan
- Tidak menimpa data tanpa izin L0
Struktur:
  - 01_INDEX/  -> indeks topik & entri
  - 02_STORE/  -> arsip rekaman
  - 03_LOG/    -> jejak perubahan
  - 04_HASH/   -> rekaman integritas