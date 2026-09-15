# ADR-005-REV1: PENYATUAN TATA KELOLA MENJADI SATU RUJUKAN SAH V.21 (REVISI)

**Kode:** ADR-005-REV1
**Tanggal:** 2026-09-15
**Otoritas:** L0 — Iswan Juman Pancoro, ST
**Pelaksana:** DeepSeek (AG-003)
**Status:** DISAHKAN L0 — 2026-09-16

## 1. KLAUSUL LAMA
- ADR-005 asli: header "DISAHKAN L0", §4 "MENUNGGU PERSETUJUAN L0" — inkonsisten
- Istilah "DOLA" dipakai tanpa klarifikasi pasca-decree 2026-09-12

## 2. MASALAH
| # | Masalah |
|---|---|
| 1 | Header vs §4 kontradiktif |
| 2 | Istilah DOLA/MPG belum diklarifikasi |
| 3 | Belum ada mekanisme kait otomatis |

## 3. KLAUSUL YANG DIUSULKAN
| Klausul | Isi |
|---|---|
| §4 Status | "DRAFT REVISI — MENUNGGU PENGESAHAN L0" |
| §5 Istilah kanonik | "DOLA = Pengawas Aktif. MPG = Dokumen Kebijakan di bawah DOLA." |
| §6 Kait otomatis | "Pre-commit hook menolak file governance tanpa referensi ADR/V.21" |

## 4. ALASAN
Konsistensi audit trail · Kepatuhan decree 2026-09-12 · Mencegah dualisme

## 5. DAMPAK
File baru wajib pakai istilah kanonik. File lama tidak diubah.

## 6. PROVENANCE
- ADR-005 asli SHA256: 1056AA382CE86F037218459D2BE67851E5B7B10C1129FA4B89164BB79FAFA818
- Decree SHA256: DA9215D0932163C768FD37D8023F385B6BF3CB68EC2FEEE2A8C3794AA51B38FA

**STATUS AKHIR: DISAHKAN L0 — 2026-09-16**