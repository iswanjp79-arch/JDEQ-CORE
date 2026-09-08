# TIMING RULE — Bounded Timing Control MICO-JDEQ

## Prinsip
- Jitter: jeda acak agar skrip tidak seperti bot kaku.
- Backoff: jeda istirahat saat error, bertahap.
- CPU-Aware Jitter: sebelum tidur, cek beban CPU/RAM.
  Jika sistem sibuk, perpanjang batas atas tidur agar tidak menambah beban.

## Batas
- Jitter normal: 1–15 detik.
- Backoff error: 2, 4, 8, maksimal 30 detik.
- CPU-Aware: jika CPU > 50%, max sleep menjadi 30 detik.

## Aturan
- Semua skrip otomatis yang menyentuh jaringan/file watcher wajib memakai modul ini.
- Tidak boleh install pustaka eksternal.
- RAM idle modul < 50 MB.
