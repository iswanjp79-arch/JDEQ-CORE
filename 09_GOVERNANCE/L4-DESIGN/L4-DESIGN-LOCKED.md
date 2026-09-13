# MICO-L4 — SOVEREIGN DATA LANDING · DESIGN DOCUMENT
Tanggal     : 2026-09-13
Otoritas    : L0 — Iswan Juman Pancoro, ST
Auditor     : Perplexity · Microsoft Copilot · Jarvis
Status      : DESIGN_LOCKED · EXECUTION_PENDING
Kode        : MICO-L4-FINAL-EXECUTION

## 5 MODUL (desain)
M1 — Atomic Write & FlushFileBuffers
M2 — Host Gate & Path Protection
M3 — Derived Index Structure (09_INDEX)
M4 — Storage Pressure & Disposable Cleanup
M5 — Sovereign Pull-Only Transport

## PRINSIP
- Flat-file = SSOT · SQLite hanya di 09_INDEX
- Atomic rename on same NTFS volume
- FlushFileBuffers sebelum close
- Host gate: COMPUTERNAME -eq 'PC-i5'
- Path protection: tolak \GLOBAL\
- Whitelist ekstensi: .json .md .txt
- Cleanup trigger: disk > 85%
- Cleanup scope: Disposable\ + Buffer\ ONLY
- Circuit breaker: > 10 file dihapus → BLOCKED
- Pull-only: worker tidak menulis ke SSOT
- Zero cloud storage

## LOKASI ARTEFAK NANTI
- Script : D:\MICO_SSOT\09_GOVERNANCE\scripts\
- Log    : D:\MICO_SSOT\08_EVIDENCE\
- Index  : D:\MICO_SSOT\09_INDEX\

## STATUS
EXECUTION_PENDING — menunggu ACC L0 terpisah.
Tidak ada script ditulis pada sesi ini.
