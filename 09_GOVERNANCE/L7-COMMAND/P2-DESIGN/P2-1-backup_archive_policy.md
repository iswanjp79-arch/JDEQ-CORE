# P2-1 — BACKUP & IMMUTABLE ARCHIVE POLICY

## Tujuan
Menyimpan arsip rotasi log dan alert secara aman, immutable,
dengan prosedur restore yang terverifikasi.

## Jadwal Backup
| Jenis | Frekuensi | Target |
|---|---|---|
| Arsip rotasi | Setiap selesai rotasi | 12_BACKUP/L7-STATE/LOG-ARCHIVE/ |
| Alert ledger | Harian 04:00 | 12_BACKUP/L7-STATE/ALERT-ARCHIVE/ |
| Manifest | Bersama arsip | Sama folder |

## Sifat Arsip
- Setelah ditulis, arsip TIDAK boleh diubah
- Hash SHA-256 dihitung saat penulisan, disimpan di manifest
- Modifikasi apa pun = pelanggaran, catat INTEGRITY_CONFLICT

## Retensi
- Arsip aktif : 90 hari
- Arsip > 90 hari : pindah ke 99_ARCHIVE, tetap immutable
- Arsip > 365 hari : boleh dipadatkan (gzip) tanpa mengubah isi

## Verifikasi
- Verifikasi hash setiap 7 hari
- Verifikasi restore setiap 30 hari
- Hasil verifikasi disimpan di 08_EVIDENCE/L7-OPERATIONAL/backup-verify/

## Batas
- Tidak ada backup ke jalur publik
- Tidak ada operasi delete otomatis
- Tidak ada rotasi arsip tanpa jejak audit
