# LOG ROTATION POLICY — 06_RUNTIME

## Aturan
- Log aktif disimpan di LOGS/
- Rotasi harian atau maksimal 10 MB.
- Arsip log pindah ke 99_ARCHIVE atau 12_BACKUP.
- Jangan simpan log jutaan baris di Git.

## Penanda
- Setiap log diakhiri dengan EOF.
