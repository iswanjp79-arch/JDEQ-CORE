# KEBIJAKAN MEMORI LOKAL — MICO-JDEQ
# Disahkan: 2026-09-16 · L0 — Iswan Juman Pancoro, ST
# Status: MENGUNCI

## 1. PRINSIP TERTINGGI
SUMBER TETAP DI BERKAS
Indeks, vektor, dan cache = bayangan, BUKAN sumber kebenaran
Jika indeks hilang → bangun ulang dari berkas
Jika AI ganti/lupa/rusak → memori tetap utuh

## 2. PEMILIKAN
Memori milik L0, bukan milik model apa pun
Tidak ada data yang wajib dikirim ke luar jaringan sendiri

## 3. TINGKATAN MEMORI
- 02_DATA → Sumber utama, dibaca manusia, di-commit
- 06_APLIKASI → Hasil turunan, boleh dihapus
- 08_EVIDENCE → Bukti peristiwa, tidak boleh diubah
- 09_GOVERNANCE → Aturan, hanya L0 yang ubah

## 4. KOMIT GIT
- Keputusan disahkan → commit
- Pekerjaan selesai → commit
- Bukan tiap pesan → tidak commit
- Tidak pakai --no-verify → aturan tetap berlaku

## 5. KETERGANTUNGAN
- Tanpa DB vektor → tetap jalan
- Tanpa model lokal → tetap baca & cari
- Tanpa internet → tetap berfungsi penuh
