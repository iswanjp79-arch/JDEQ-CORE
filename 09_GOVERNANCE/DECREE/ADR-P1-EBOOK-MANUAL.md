# ADR-P1-EBOOK-MANUAL

**Tanggal**    : 2026-09-16
**Penulis**    : L0 - Iswan Juman Pancoro, ST
**Rancangan**  : AG-003 (DeepSeek)
**Status**     : DITERIMA
**Fase**       : P1 - Master Planning

## Konteks

MICO-EBOOK-001 v1.0 = penyusunan manual 16 modul
sebagai bagian P1 Master Planning.

## Keputusan

1. Mutasi terbatas (append-only) diizinkan.
2. Jalur kanonik: 09_GOVERNANCE\L7-COMMAND\EBOOK\
3. File existing tidak ditimpa (idempotent).
4. Struktur inti L1-L7 dibekukan.
5. 11 file kerangka + manifest disimpan sebagai baseline.

## Konsekuensi

- Setiap file punya hash SHA-256.
- Commit butuh ADR ini sebagai pelengkap.
- Riwayat & bukti lama tetap utuh.
- Struktur inti 09_GOVERNANCE tidak diubah.

## Rujukan

- MICO-EBOOK-001 v1.0
- LAP-MUTASI-MICO-EBOOK-001-20260916
- MANIFEST-SHA256.txt (EBOOK)