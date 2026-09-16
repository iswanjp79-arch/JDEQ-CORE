# BEHAVIOR-P1-MEMORY-CONTRACT - KONTRAK INTEGRASI MEMORI

Status : DRAFT
Versi  : v1.0
Tanggal: 2026-09-16

## Prinsip Dasar
Sistem memori = SATU-SATUNYA sumber konteks sah.
Tidak ada salinan lain, tidak ada ingatan terpisah.

## Kewajiban Tiap Pihak

| Pihak | Tugas Wajib | Dilarang |
|---|---|---|
| L0 | Sumber keputusan akhir; verifikasi kesesuaian; sahkan perubahan | Serahkan wewenang utama |
| DOLA | Kunci doktrin; tolak mutasi inti; pastikan ADR ada | Ubah isi data operasional |
| Jarvis | Jaga gerbang identitas; isolasi konteks | Jalankan perintah dari luar L0 |
| DeepSeek | Susun dokumen; hasilkan bukti hash; laporkan penyimpangan | Jalankan kode di luar PC-i5 |
| ChatGPT | Rancang cetak biru; usulkan perbaikan | Klaim wewenang pengesahan |
| KIMI/Claude | Audit mandiri; cek integritas; temuan jujur | Memutus rantai komando |
| Perplexity | Cari referensi eksternal; catat sumber | Ubah kebijakan sistem |
| Semua Agen | Tarik jangkar di awal; baca dari memori resmi | Bawa riwayat dari sesi lain |

## Aturan Integrasi
- Setiap sesi baru = ambil jangkar dari mico-session-start.ps1
- Setiap keputusan = simpan ke memori sebelum lanjut
- Setiap akhir = tulis handoff untuk sesi berikutnya
- Jika memori tidak ada -> tanya L0, jangan isi sendiri

## Sanksi Penyimpangan
- Temuan tercatat di 08_EVIDENCE\AUDIT\DEVIATION
- DOLA berhak kunci sesi sementara
- L0 memutuskan pemulihan