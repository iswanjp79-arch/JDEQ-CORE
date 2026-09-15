# MICO-JDEQ HANDOVER MINIMAL
Versi ringkas — paste ke chat baru.

## STATUS
- SSOT   : D:\MICO_SSOT
- Shell  : pwsh (PowerShell 7.6.6)
- Commit : f647faec
- Fase   : P1 Master Planning
- Hooks  : pre-commit · commit-msg · post-commit (v4)

## 5 KONFLIK TERBUKA
1. Istilah kanonik DOLA vs MPG — belum diputuskan
2. Role Vivo Y28 (server vs terminal) — belum diputuskan
3. Model layer tunggal (butuh ADR-006 ACC)
4. BLUEPRINT_AGENTIC model AI tidak terverifikasi
5. ADR-005-REV1 status inconsistency

## FILE INTI
- V.21       : 09_GOVERNANCE/P1-PLANNING/DEL03-GOVERNANCE/
- ADR-006    : 09_GOVERNANCE/ADR/ADR-006-LAYER-MODEL-CANONICAL.md
- Master Plan: 09_GOVERNANCE/P1-PLANNING/MICO-JDEQ-MASTER-PLAN-v1.0.md
- Anchor     : 09_GOVERNANCE/P1-PLANNING/AUDIT-ANCHOR-REGISTRY.md

## BLOCKED
- T5 Master Plan final lock (menunggu ACC L0)
- T6 Monument zip (menunggu ACC L0)

## ATURAN
- Commit governance: referensi ADR/V.21 di commit message
- DOLA legacy: tambah DOLA_LEGACY_OK di commit message
- Verifikasi cepat: pwsh -File 09_GOVERNANCE/TOOLS/PORTABLE/mico-verify.ps1