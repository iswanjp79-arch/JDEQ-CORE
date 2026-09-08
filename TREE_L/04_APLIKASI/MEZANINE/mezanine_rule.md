# MEZANINE RULE — Lapisan Akses Ringan Terpisah

## Prinsip
- Mezanine adalah antarmuka baca, bukan pengendali inti.
- Tidak boleh mengubah konfigurasi sistem inti.
- Harus bisa dibuka/ditutup kapan saja.

## Akses
- Hanya dari localhost atau Tailscale IP (100.x).
- Tidak membuka port eksternal.

## Pengamanan
- Setiap sesi wajib tercatat.
- Jika mezanine gagal, sistem inti tetap hidup.
- Tidak boleh ada satu skrip yang mengendalikan semua kolom.

## Beban
- RAM idle < 50 MB.
- Tidak menjalankan server permanen.
