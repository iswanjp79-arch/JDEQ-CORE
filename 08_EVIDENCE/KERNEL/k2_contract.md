# K2 — Kernel Contract

Ditetapkan: 2026-09-11T00:38:37

## 1. Status yang diizinkan

- `ERROR`
- `LEGACY`
- `OK`
- `PURGED`
- `QUARANTINED`

## 2. Aturan ingest ke `02_DATA/CURATED/`

- **allowed_ext**: {'.txt', '.md', '.json', '.yml', '.yaml', '.csv'}
- **max_size_mb**: 50
- **forbid_zero**: True
- **forbid_junk_patterns**: ('~$', '.tmp', 'Thumbs.db', '.DS_Store')
- **require_not_dup**: True
- **require_not_nsfw**: True

## 3. Invariants (harus selalu benar)

1. setiap file di CURATED harus punya sha256 di manifest
2. tidak ada file NSFW di CURATED
3. tidak ada duplikat hash di CURATED
4. semua file QUARANTINED ada di 00_QUARANTINE/
5. status ∈ {OK, LEGACY, QUARANTINED, PURGED, ERROR}

## 4. Alur gate

```
file masuk → check_ingest() → ACCEPT → tulis ke CURATED + manifest
                            → REJECT → 00_QUARANTINE/<reason>/
```

## 5. Kontrak dengan layer di atas

- Kernel **menyediakan** query (DuckDB view) + validasi (check_ingest).
- Kernel **tidak** menyediakan embedding, LLM, OCR, visualisasi.
- Layer di atas **wajib** memanggil kernel untuk baca/tulis substrat.
