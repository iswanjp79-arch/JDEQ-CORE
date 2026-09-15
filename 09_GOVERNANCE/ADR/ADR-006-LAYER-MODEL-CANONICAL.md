# ADR-006: ARSITEKTUR TUJUH LAPISAN TUNGGAL MICO-JDEQ

**Kode:** ADR-006
**Tanggal:** 2026-09-15
**Otoritas:** L0 — Iswan Juman Pancoro, ST
**Pelaksana:** DeepSeek (AG-003)
**Status:** DISAHKAN L0 — 2026-09-16

## 1. DEFINISI RESMI L1–L7
| Layer | Nama Resmi | Cakupan |
|---|---|---|
| L1 | Fisik / Perangkat | Hardware, sensor, aktuator, daya |
| L2 | Koneksi / Gerbang | Network, transport, gateway |
| L3 | Node Tepi | Edge runtime, komputasi dekat sumber |
| L4 | Data Mentah / Bukti | Raw data, buffer, evidence |
| L5 | Data Terstruktur | Normalisasi, skema, logika data |
| L6 | Aplikasi / Komputasi / AI | Aplikasi, LLM, analitik |
| L7 | Kerja Sama / Alur Kerja / Perintah | Orchestration, command |

## 2. ATURAN
- L1–L7 = **taxonomy arsitektur sistem**, bukan kewajiban deployment per node
- Setiap node menempati **satu atau lebih layer** sesuai capability
- **Tidak ada kewajiban setiap node mengimplementasikan seluruh L1–L7**
- Governance = overlay, bukan L8
- Variasi lain (5L/6L/4P) = arsip historis
- File terkait arsitektur merujuk ADR ini (bukan semua file)

## 3. VARIASI YANG DIARSIPKAN
| Sumber | Jumlah | Status |
|---|---|---|
| MASTER_PLAN_FINAL.md | 5L | HISTORIS |
| BLUEPRINT_AGENTIC_REFERENCE.md | 6L | HISTORIS |
| V.21 | 4 Pasal | ATURAN (bukan layer teknis) |

## 4. PROVENANCE
- MICO-L7-IOT-AWARENESS-001 SHA256: C5AB2BC37BC0A9AC5F7AB1D305A59D622784B062158E67693006AA0304846B24
- OSI-LAYER-MAP SHA256: AECCACAE50D0293A8BD5C33B14226B2E3190D5EBEE409A0A889912B73CB5B1CF

**STATUS AKHIR: DISAHKAN L0 — 2026-09-16**