# MICO-JDEQ MASTER SYSTEM PLAN v1.0
Kode   : MICO-P1-MASTER-001
Status : DRAFT — MENUNGGU ACC L0
Otoritas: L0 — Iswan Juman Pancoro, ST

## 01 — VISI & MISI
Visi: Kedaulatan digital individu atas data, kognisi, aset.
Misi: (1) Kendali lokal, (2) AI sebagai alat, (3) Bukti terverifikasi, (4) Warisan berkelanjutan.
Prinsip: Requirement → Engineering Design → Capability → Technology.
Target jangka panjang: Auto-pilot fungsional setelah P7 — bukan commitment P1.

## 02 — ARSITEKTUR (L1–L7)
Rujuk ADR-006.
L1–L7 = taxonomy arsitektur sistem.
Setiap node menempati satu atau lebih layer sesuai capability — BUKAN kewajiban implementasi penuh.
Governance = overlay.

## 03 — TATA KELOLA
Otoritas: L0 → DOLA (Pengawas) → Gateway → Agen → Eksekusi.
MPG = dokumen kebijakan di bawah DOLA.
Referensi: V.21 (Konstitusi), ADR-005-REV1.

## 04 — RENCANA MUTU
Siklus: PLAN → EXECUTE → RECORD → CHECK → CORRECT → REVIEW.
Referensi: ISO 9001, 45001, 27001, 22301 (referensi metodologi, bukan klaim sertifikasi).

## 05 — DAFTAR RISIKO (Requirement-First)
| Risiko | Control Objective | Requirement | Tech Options | Selection |
|---|---|---|---|---|
| Token bocor | Confidentiality | Cegah plaintext | Vault AES / OS keychain / HSM | TBD (P2) |
| Cloud degradation | Availability | Fallback lokal | Local-first / hybrid / mirror | TBD (P2) |
| Single-node dep | Resilience | Multi-node | Replikasi / mesh / manual | TBD (P2) |
| Konflik doktrin | Integrity | ADR + anchor | Git + hook + hash | ADR-005/006 |
| Loss passphrase | Confidentiality | Recovery | Split / HSM / tulis fisik | TBD (P2) |

**Catatan:** Teknologi spesifik belum dipilih di P1. Hanya objective + requirement.

## 06 — SUMBER DAYA
PC-i5: workstation. Vivo Y28: terminal kendali bergerak (BUKAN peladen).
Z83: node kontrol/bukti. HP Mini/Infinix/Aspire One: node sesuai kapabilitas.
Cloud: sumber daya sesuai kebutuhan (biaya/latensi/privasi).

## 07 — JARINGAN (Netral, Bukan Vendor)
WAN / ISP: penyedia internet (spesifik dipilih di P2).
LAN lokal: komunikasi internal.
Secure remote: Tailscale / VPN (opsional, TBD).
Gateway, trust boundary, fallback: TBD di P2.
Spesifikasi vendor (mis. IndiHome, ISP tertentu) = implementation choice, bukan Master Plan.

## 08 — ALUR KERJA & PERAN (Logical Role, Bukan Provider)
Logical roles:
- PLANNER
- GATEWAY
- POLICY ENGINE
- EXECUTOR
- AUDITOR
- RESEARCHER
- COMPUTE PROVIDER
Provider binding (ChatGPT/Claude/DeepSeek/dll) = implementation assignment.
Prinsip: kalau provider diganti, arsitektur tidak berubah.

## 09 — PERJANJIAN KERJA (BEHAVIOR CONTRACT)
Model: INPUT → TRIGGER → UNDERSTAND → STATE → GOAL → CHECK_CAP → CHECK_CONSTRAINT → ACTION → EVIDENCE → EVALUATION → (PASS: OUTPUT/CLOSE; FAIL: TROUBLESHOOT/RECOVER/VERIFY).
Status: MISSING_IN_SSOT (model terdefinisi, file formal belum ada).

## 10 — DATA & BUKTI
Evidence = provenance + source + timestamp + actor + content + integrity_hash + validation.
SHA256 = **integrity control**, BUKAN definisi seluruh evidence.
HASH ≠ TRUTH.
Satu event bisa hasilkan multiple evidence — wajib punya traceability.
Provenance model: SOURCE → ACTIVITY → AGENT → DERIVATION.

## 11 — PEMANTAUAN
Telemetry: heartbeat, log, state.
Prinsip: HEALTH ≠ CONFIDENCE · EVENT ≠ STATE · CLAIM ≠ EVIDENCE.
Tool: belum dipilih (downstream of requirement).

## 12 — AUDIT & JAMINAN (SoD)
DOLA = Governance / Policy Gate.
AUDIT FUNCTION = fungsi terpisah (independent assurance).
AUDITOR = ditentukan per audit dengan SoD.
Claude/KIMI = candidate, bukan auditor formal terikat.

## 13 — PEMULIHAN & KOREKTIF
Recovery: restore dari mirror lokal.
Korektif: catat → perbaiki → verifikasi → cegah berulang.
Emergency: prosedur OHSAS §8.2.

## 14 — KRITERIA PENERIMAAN
Setiap fase P0–P7 punya gate.
Gate lulus = bukti nyata (hash, log, commit).
L0 = approver terakhir.

## 15 — PETA JALAN
P0 CLOSED · P1 IN_PROGRESS · P2 NOT_STARTED · P3–P7 PLANNED.

**STATUS AKHIR: DRAFT — MENUNGGU ACC L0**