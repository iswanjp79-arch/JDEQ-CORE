# MICO-JDEQ — Requirements

## Tujuan Sistem
Sistem otomasi lokal di Vivo Y28 (Termux, tanpa laptop) untuk mengelola
registry keputusan (ADR), sinkronisasi ke GitHub, dan audit fondasi teknis.

## Kebutuhan Fungsional
1. Registry keputusan (registry.json) harus valid JSON dan bisa dibaca otomatis.
2. Setiap keputusan arsitektur dicatat sebagai ADR terpisah, tidak menimpa ADR lama.
3. Sinkronisasi ke GitHub harus berjalan tanpa menghapus data yang belum di-commit.
4. Audit fondasi harus menghasilkan status VERIFIED/UNVERIFIED berbasis bukti nyata,
   bukan klaim manual.

## Kebutuhan Non-Fungsional
1. Berjalan penuh di perangkat Android tanpa root (keterbatasan: tidak bisa modifikasi
   kernel/SELinux/init — lihat ADR terkait).
2. Tidak menyimpan API key atau vault ke repo publik.
3. Struktur folder harus konsisten (tidak ada duplikasi nama seperti CORE/core).

## Batasan Diketahui
- Tidak ada akses root di Vivo Y28 → fitur yang butuh root (sepolicy_adjust,
  init_hook) tidak bisa dijalankan, harus ada fallback non-root.
- Cloud CI (GitHub Actions) hanya untuk build/test, bukan penyimpanan data sensitif.
