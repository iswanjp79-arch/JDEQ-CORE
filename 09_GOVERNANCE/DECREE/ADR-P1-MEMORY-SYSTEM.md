# ADR-P1-MEMORY-SYSTEM

**Tanggal**    : 2026-09-16T14:08:06+07:00
**Penulis**    : L0 - Iswan Juman Pancoro, ST
**Rancangan**  : AG-003 (DeepSeek)
**Status**     : DITERIMA
**Fase**       : P1 - Master Planning

## Konteks

MICO-JDEQ membutuhkan sistem memory jangka panjang lokal
sebagai fondasi replikasi memory cloud versi sovereign.

## Keputusan

1. Sistem memory dibangun sebagai file-based (tanpa vector DB).
2. Struktur 6 kategori: PRF, PREF, DEC, LRN, CTX, SESS.
3. Setiap write memory menghasilkan evidence dengan SHA-256.
4. Session-start dan session-end sebagai anchor + handoff.
5. Lokasi memory: 02_DATA\LOCAL_MEMORY\
6. Lokasi evidence: 08_EVIDENCE\MEMORY\MEMORY_EVENTS\
7. Lokasi laporan: 08_EVIDENCE\MEMORY\REPORTS\

## Konsekuensi

- Setiap memory punya hash, bisa diaudit.
- Setiap sesi baru bisa load anchor dari handoff terakhir.
- Tidak bergantung pada platform AI eksternal.
- Vector DB tetap opsi P2 setelah requirement.

## Rujukan

- TASK-P1-MEMORY-001
- LAP-P1-MEMORY-001-20260916.md
- MEMORY-POLICY.md