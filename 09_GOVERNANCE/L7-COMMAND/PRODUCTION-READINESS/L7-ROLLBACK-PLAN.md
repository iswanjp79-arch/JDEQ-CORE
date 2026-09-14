# L7 ROLLBACK PLAN

## Trigger
- Runtime anomaly
- L0 order
- AG-004 blocking finding

## Steps
1. Set runtime state LOCKED
2. Stop all L7 processes
3. Snapshot evidence
4. git revert to baseline 35794f7
5. Verify tests PASS

## Evidence
- rollback_evidence_20260914_1425.json (PASS)

## Constraint
- NO git reset --hard
- NO evidence deletion
- NO touching L4/L5
