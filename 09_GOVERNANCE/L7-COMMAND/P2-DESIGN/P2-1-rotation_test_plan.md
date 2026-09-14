# P2-1 — ROTATION TEST PLAN

## Skenario Uji
| ID | Skenario | Harapan |
|---|---|---|
| RT-01 | Rotasi normal | Arsip dibuat, hash tercatat, berkas aktif kosong |
| RT-02 | Berkas aktif <50MB, interval tiba | Tetap rotasi sesuai jadwal |
| RT-03 | Berkas aktif >50MB sebelum jadwal | Rotasi paksa, catat SIZE_THRESHOLD |
| RT-04 | Disk penuh saat rotasi | BLOCKED, tidak ada data hilang |
| RT-05 | Rename gagal | BLOCKED, berkas asli tidak diubah |
| RT-06 | Hash mismatch setelah rename | Tandai INTEGRITY_CONFLICT, tulis residual risk |
| RT-07 | Dua rotasi beruntun tanpa jeda | Yang kedua BLOCKED |
| RT-08 | Interupsi di tengah proses | Recoverable, tidak ada partial file |

## Kriteria Lulus
- Semua 8 skenario PASS
- Tidak ada data hilang
- Setiap rotasi meninggalkan minimal 1 entri audit
- SHA-256 arsip terverifikasi

## Data Uji
- Berkas contoh: 10.000 baris JSONL sintetis
- Ukuran total: ~5 MB (untuk uji cepat)
- Host: PC-i5 lokal, filesystem NTFS

