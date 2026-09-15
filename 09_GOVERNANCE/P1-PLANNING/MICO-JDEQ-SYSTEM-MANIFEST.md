# MICO-JDEQ SYSTEM MANIFEST
Kode   : MICO-P1-MANIFEST-001 (DRAFT)
Status : DRAFT — MENUNGGU ACC L0
Mode   : REFERENCE_ONLY (tidak menyalin file, hanya mencatat path + hash)
Prinsip: B2 — satu sumber kebenaran, tidak duplikasi

## 1. GOVERNANCE & DOCTRINE
| File | Peran | Status |
|---|---|---|
| 09_GOVERNANCE/P1-PLANNING/DEL03-GOVERNANCE/MICO-P1-DEL03-GOV-001_CETAK-BIRU-V21.md | Konstitusi tata kelola (SAH) | AKTIF |
| 09_GOVERNANCE/ADR/ADR-005_REKONSILIASI_GOVERNANCE_V21.md | Rekonsiliasi SSOT (SAH) | AKTIF |
| 09_GOVERNANCE/DECREE/DOLA_DEPRECATION_20260912.md | Deprecation istilah legacy | AKTIF |
| 09_GOVERNANCE/P1-PLANNING/AUDIT-ANCHOR-REGISTRY.md | Peta audit P1 | AKTIF |

## 2. ARCHITECTURE 7 LAYERS
| File | Peran |
|---|---|
| 09_GOVERNANCE/L7-COMMAND/AWARENESS/MICO-L7-IOT-AWARENESS-001.md | Framework 7 layer |
| 09_GOVERNANCE/L7-COMMAND/AWARENESS/OSI-LAYER-MAP.yaml | Peta L1-L7 detail |
| 09_GOVERNANCE/L7-COMMAND/AWARENESS/DEVICE-ROLES.yaml | 7 device + peran |

## 3. BEHAVIOR CONTRACT MODEL
| File | Peran |
|---|---|
| MICO-P1-LAYER-001 (LAYER-MODEL-RECONCILIATION-DRAFT.md) | Konsolidasi model layer |
| (belum ada) | File Behavior Contract formal — MISSING_IN_SSOT |

## 4. TOOLS & HOOKS
| File | Peran |
|---|---|
| 09_GOVERNANCE/TOOLS/HOOKS/pre-commit | Guard governance + DOLA legacy |
| 09_GOVERNANCE/TOOLS/HOOKS/post-commit | Mirror bundle otomatis |
| 09_GOVERNANCE/TOOLS/HOOKS/install-hooks.ps1 | Installer |
| 09_GOVERNANCE/TOOLS/VAULT/vault-master.ps1 | Fungsi inti vault |
| 09_GOVERNANCE/TOOLS/VAULT/vault-rotate.ps1 | Rotasi token |
| 09_GOVERNANCE/TOOLS/VAULT/vault-verify.ps1 | Verifikasi |
| 09_GOVERNANCE/TOOLS/mico-exec-guard.ps1 | Wrapper eksekusi |

## 5. EVIDENCE
| Folder | Peran |
|---|---|
| 08_EVIDENCE/VAULT_DATA/ | Data terenkripsi (AES-256) |
| 08_EVIDENCE/jarvis_breach/ | Bukti FIX-001R |
| 08_EVIDENCE/alert/ | Bukti P2-2 |
| 08_EVIDENCE/execution_guard/ | Log wrapper |

## 6. PLANNING DRAFTS (belum final)
| File | Status |
|---|---|
| GAP-ANALYSIS-v1.0.md | DRAFT |
| MASTER-PLAN-v1.0-DRAFT.md | DRAFT — T5 BLOCKED |
| LAYER-MODEL-RECONCILIATION-DRAFT.md | DRAFT |
| P1-PLANNING-INDEX.md | DRAFT |

## 7. TASK CARDS AKTIF
| File | Status |
|---|---|
| 09_GOVERNANCE/L7-COMMAND/P2-EXECUTION/P2-EXECUTION-TASK-CARD.md | READY_FOR_AUTHORIZED_RUN |
| 08_EVIDENCE/L1/Vivo/LUCID_DOZE_TASKCARD_STATUS.md | ARCHIVED_AS_REFERENCE |

## 8. 5 KONFLIK TERBUKA (BLOCKER)
1. Istilah kanonik: "DOLA" (legacy) vs "MPG" — belum diputuskan
2. Role Vivo Y28: server vs terminal — belum diputuskan
3. 4 model layer paralel (5L/6L/7L/4P) — butuh ADR-006
4. BLUEPRINT_AGENTIC model AI tidak terverifikasi — butuh audit
5. ADR-005 §4 status "MENUNGGU" tapi header "DISAHKAN" — housekeeping

## 9. STATUS TRANSISI
| Tahap | Status |
|---|---|
| T1 Manifest referensi | EXECUTED (file ini) |
| T2 CORE-LOGIC JSON | EXECUTED |
| T3 Skrip Python/Termux | NOT_STARTED |
| T4 SHA256 manifest | EXECUTED |
| T5 Master Plan v1.0 lengkap | BLOCKED_BY_CONFLICTS |
| T6 Monument zip lock | BLOCKED_BY_CONFLICTS |

## 10. KEPUTUSAN L0
- A1: Pecah bertahap ✅
- B2: Referensi manifest (bukan copy) ✅
- C2: T5/T6 BLOCKED ✅