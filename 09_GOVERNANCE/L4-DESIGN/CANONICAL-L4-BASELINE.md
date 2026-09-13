# MICO-L4 — CANONICAL EXECUTION BASELINE
Kode    : MICO-L4-CANONICAL-BASELINE-001
Tanggal : 2026-09-14
Otoritas: L0 — Iswan Juman Pancoro, ST
Status  : FROZEN (execution complete, dry-run verified)

## 1. CANONICAL DIRECTORY TREE
D:\MICO_SSOT\
├── 08_EVIDENCE\
│   ├── GLOBAL\ (PROTECTED: ADR, DOKTRIN, HASH-CHAIN, AUDIT-TRAIL)
│   ├── BUFFER\<node>\
│   ├── STAGING\<node>\
│   ├── LIVE\<node>\        (WORM)
│   ├── RETAIN\<node>\      (WORM)
│   ├── QUARANTINE\<node>\
│   ├── DISPOSABLE\
│   └── incomplete\YYYYMMDD\
├── 09_GOVERNANCE\
│   ├── L4-DESIGN\
│   ├── scripts\lib\
│   └── ADR-003-L3-Execution.txt
├── 09_INDEX\index.json
└── L3-modules\

## 2. DATA FLOW
EDGE → BUFFER → STAGING → LIVE/RETAIN/QUARANTINE → L5 → L6

## 3. STATE MODEL
INCOMPLETE (.tmp) · READY (mature) · PROCESSING · HANDED_OFF (WORM)
HOLD (incomplete/QUARANTINE) · RECONCILIATION_REQUIRED (QUARANTINE)

## 4. WORM CONTRACT
LIVE + RETAIN: read-only untuk runtime · no overwrite/delete/rename
Operational WORM — bukan tamper-proof absolut terhadap admin.

## 5. M4 DRAINAGE BOUNDARY
Allowed: DISPOSABLE only.
Trigger: disk > 85% · Disposal: 20% oldest.
Denied: BUFFER, STAGING, LIVE, RETAIN, QUARANTINE, GLOBAL, incomplete.

## 6. TC-05 LOCAL INDEX
Flat-file = SSOT · Index = derived metadata (rebuildable)
SQLite: PROHIBITED unless explicit L0 exception.

## 7. EXECUTION PLAN M1-M5
M1 atomic_write.ps1 · M2 host_gate.ps1 · M3 build_index.ps1
M4 storage_cleanup.ps1 · M5 pull_edge.ps1
All: dry-run first · evidence mandatory · failure → BLOCKED.

## 8. PC-i5 EXECUTION BOUNDARY
Host gate: KAPAL-INDUK (canonical).
All L4 execution on PC-i5 only. No edge modification.

## 9. TERMINAL EXECUTION CONTRACT
DISCOVERY → DRY-RUN → VERIFY → L0 ACC → EXECUTE → POST-VERIFY → RECORD

## 10. FINAL STATUS
M1-M5: PASS (dry-run phase)
Reconciliation: RESOLVED (legacy .db in 99_ARCHIVE = out of scope)
Runtime real ingest (M5-REAL): PENDING
