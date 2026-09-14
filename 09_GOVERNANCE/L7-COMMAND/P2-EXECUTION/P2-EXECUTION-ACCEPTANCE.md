# P2-EXECUTION-ACCEPTANCE

## Kriteria Penerimaan

### P2-1 Rotasi Log
- [ ] Runner rotasi idempotent terpasang
- [ ] Rotasi berdasarkan jadwal (harian 03:00)
- [ ] Rotasi berdasarkan ukuran (>50 MB)
- [ ] Rename atomik terbukti (tidak ada partial file)
- [ ] Hash SHA-256 arsip tercatat di manifest
- [ ] Circuit breaker trip pada 10 gagal / 60 detik
- [ ] Backup arsip immutable berjalan
- [ ] Restore dari arsip terverifikasi

### P2-2 Saluran Alert
- [ ] Alert tertulis ke SSOT oleh PC-i5 saja
- [ ] Edge tidak menulis ke SSOT
- [ ] Pull-only terbukti
- [ ] Sanitasi metadata men-strip kunci terlarang
- [ ] Retry maksimum 3 dengan backoff 2-8-32
- [ ] Dedup window 5 menit
- [ ] Rate limit 30/menit
- [ ] Setiap alert menulis 1 entri audit

## Batas Verifikasi
- Verifikasi TIDAK menyentuh L4/L5
- Verifikasi TIDAK mengaktifkan runtime
- Semua bukti disimpan di 08_EVIDENCE/L7-OPERATIONAL/p2-verify/

## Status Akhir yang Sah
- P2_EXECUTION_VERIFIED
- P2_EXECUTION_VERIFIED_WITH_OPEN_RISKS
- P2_EXECUTION_REQUIRES_RECONCILIATION
