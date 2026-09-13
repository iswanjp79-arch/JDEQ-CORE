# BAK LIFECYCLE GOVERNANCE

- Timestamp : 2026-09-14_0530
- Target    : 09_GOVERNANCE/L7-COMMAND/RELIABILITY/SHA256SUMS.txt.bak_2026-09-14_0442

## Facts

- Size      : 2539 bytes
- SHA256    : 2520E07ED1F1DCEED9F1277F77FA69BF973CB4F6BA3B346F8EEA62A1EA157F36
- Tracked   : YES (via commit eafdc4f)
- Canonical : NO
- Policy    : UNDEFINED (sebelum dokumen ini)

## Role

Snapshot pre-fix dari SHA256SUMS.txt sebelum regenerasi 25 entries.

## Proposed Policy (menunggu ACC L0)

1. Backup file .bak_* TIDAK masuk git tracked setelah 30 hari.
2. Policy default : diarsipkan ke 99_ARCHIVE/ dengan hash manifest.
3. Pattern .gitignore .bak_* DILARANG ditambahkan pada fase ini.
4. File existing dibiarkan tracked sampai ADR khusus diterbitkan.

## Status

GOVERNANCE_GAP - tetap OPEN, tidak ditutup tanpa ADR.
