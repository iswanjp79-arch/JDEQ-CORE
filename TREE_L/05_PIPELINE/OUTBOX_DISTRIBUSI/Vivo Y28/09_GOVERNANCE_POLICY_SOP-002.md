# SOP-002 — Pemisahan Zona Git vs Data

## Tujuan
Menjaga repo Git tetap ringan dan tidak bengkak.

## Aturan
- Git hanya untuk kode, konfigurasi, SOP, Task Card, manifest (< 1GB).
- Data besar, log, model, media disimpan di Drive D:\ atau E:\.
- Jangan pernah commit file besar ke Git.

## Implementasi
- Gunakan .gitignore untuk mengecualikan *.log, *.csv besar, *.bin, model AI.
- Evidence besar masuk 08_EVIDENCE atau 12_BACKUP.
