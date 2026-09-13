# Audit Final L1.5 + L1.6

Waktu: 2026-09-11T00:34:34

## A. Status manifest

Total baris: 2737

- OK: 2314
- LEGACY: 213
- QUARANTINED: 195
- PURGED: 15

## B. Verifikasi file OK

- Diperiksa: 2314
- Missing fisik: 0
- Size mismatch: 0

## C. Verifikasi file QUARANTINED

- Diperiksa: 195
- Tidak ditemukan di quarantine: 0

## D. Bukti tersimpan

### L1.5

- atomic_cleanup_summary.md
- bin_probe_list.txt
- bin_probe_summary.md
- duckdb_schema.txt
- gate_summary.md
- junk_purge_log.txt
- legacy_mark_summary.md
- orphans.txt
- quarantine_dup_log.txt
- scan_log.txt

### L1.6

- nsfw_closure.md
- nsfw_quarantine_log.txt
- nsfw_scores.csv
- nsfw_summary.md

## E. Verdict

PASS — substrat L1.5 + L1.6 konsisten, auditable.
