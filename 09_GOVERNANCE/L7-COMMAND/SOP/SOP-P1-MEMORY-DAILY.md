# SOP-P1-MEMORY-DAILY - PROSEDUR PENGGUNAAN MEMORI HARIAN

Status : DRAFT
Versi  : v1.0
Tanggal: 2026-09-16
Fase   : P1 - Master Planning

## Tujuan
Pastikan sistem memori dipakai konsisten setiap hari,
konteks utuh, bebas kontaminasi, terlacak penuh.

## Alur Harian Baku

### 1. Buka Sesi
- Jalankan: .\mico-session-start.ps1
- Tempel teks jangkar ke awal percakapan dengan agen
- Konfirmasi: "Jangkar diterima, lanjut dari handoff terakhir"

### 2. Selama Bekerja
- Catat keputusan penting    -> add -Category DEC
- Simpan hal yang dipelajari -> add -Category LRN
- Tulis preferensi tetap     -> add -Category PREF
- Rekam konteks sesi ini     -> add -Category CTX
- Aturan: hanya tambah, jangan ubah/hapus yang sudah ada

### 3. Cek dan Cari
- Lihat daftar : .\mico-mem.ps1 list
- Cari kata    : .\mico-mem.ps1 search "kata"
- Baca catatan : .\mico-mem.ps1 show <ID>

### 4. Tutup Sesi
- Jalankan: .\mico-session-end.ps1
- Simpan ringkasan handoff
- Konfirmasi: "Sesi ditutup, siap lanjut nanti"

## Larangan Keras
- DILARANG tempel teks dari sumber tidak dikenal
- DILARANG ubah/hapus catatan yang sudah ber-hash SHA-256
- DILARANG bawa riwayat percakapan lain ke sesi ini
- DILARANG ganti jangkar sesi sesuka hati

## Verifikasi Harian
- SHA-256 manifest tetap cocok
- Tidak ada berkas dimodifikasi di luar folder kerja
- Git status bersih, perubahan hanya bertambah