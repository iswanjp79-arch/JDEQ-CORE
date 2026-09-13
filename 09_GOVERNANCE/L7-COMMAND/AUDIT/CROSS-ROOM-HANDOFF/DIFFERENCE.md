# DIFFERENCE - PREVIOUS vs CURRENT

## State Delta

| Dimension | Previous | Current | Verdict |
|---|---|---|---|
| Stage 1 evidence | belum ada report | snapshot + fixture + SHA256 | PARTIAL |
| SHA256SUMS | v1 (24) | v2 (25), committed eafdc4f | RESOLVED |
| Fixture proof | summary PASS | hash + mtime verified | RESOLVED |
| ADR-004 | belum ada | TRACKED, ACCEPTED | RESOLVED |
| Restructure commit | n/a | NONE FOUND | OPEN |
| .bak policy | n/a | GOVERNANCE_GAP | OPEN |
| L4 mutation | claimed 0 | 25 present, attribution PARTIAL | CORRECTED |

## Gate Skip Analysis

ROOM LAMA GATE: MICO-L7-RECONCILIATION-001 (Stage 1)
   |  (SWITCH)
ROOM BARU     : K1/K3 EXECUTE -> commit eafdc4f

Gate terlewati: Stage 1 evidence -> langsung commit.
Bukan authority violation, tapi sequencing violation.

## Authority Continuity

| Actor | Before | After | Status |
|---|---|---|---|
| L0 | Iswan | Iswan | PRESERVED |
| AG-003 | DeepSeek | DeepSeek | PRESERVED |
| DOLA | Active | Active | PRESERVED |
