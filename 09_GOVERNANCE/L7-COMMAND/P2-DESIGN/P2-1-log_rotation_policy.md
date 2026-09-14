# P2-1 — LOG ROTATION POLICY

## Target
09_GOVERNANCE/L7-COMMAND/RUNTIME/../../../../08_EVIDENCE/L7-OPERATIONAL/runtime_audit.jsonl

## Aturan Rotasi
| Parameter | Nilai |
|---|---|
| Interval waktu | Harian pukul 03:00 lokal |
| Ukuran maksimum | 50 MB per berkas |
| Berkas aktif | runtime_audit.jsonl |
| Arsip | runtime_audit.YYYYMMDD_HHMMSS.jsonl |
| Kompresi | gzip opsional (default: tidak) |
| Retensi aktif | 90 hari |
| Arsip permanen | >90 hari dipindah ke 99_ARCHIVE |

## Prosedur Atomik
1. Buka berkas aktif untuk append penuh
2. Flush buffer ke disk (fsync)
3. Tutup berkas aktif
4. Rename atomik ke nama arsip
5. Buat berkas aktif baru kosong
6. Catat satu entri audit: ROTATION_COMPLETED

## Aturan Immutability Arsip
- Setelah rename, arsip tidak boleh diubah
- Hash SHA-256 dihitung setelah rename, disimpan di rotation_manifest.json
- Modifikasi apa pun pada arsip = pelanggaran integritas, catat INTEGRITY_CONFLICT

## Batas
- Tidak menyentuh direktori di luar 08_EVIDENCE/L7-OPERATIONAL/
- Tidak menyentuh berkas selain pola runtime_audit*.jsonl
- Tidak ada rekursi

