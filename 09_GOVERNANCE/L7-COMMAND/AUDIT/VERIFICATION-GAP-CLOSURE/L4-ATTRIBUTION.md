# L4 ATTRIBUTION

- Timestamp : 2026-09-14_0543
- Revision  : 2 (sharpen with scheduler evidence)

## Methodology

Cross-reference: mtime L4 file vs scheduler LastRun + Result.
Causal linkage = CORRELATION, bukan DIRECT PROOF.

## Scheduler Evidence (aktual)

| Task | LastRun | Result |
|---|---|---|
| MICO-L3-M1 | 2026-09-14 05:02:02 | 0 |
| MICO-L3-M2 | 2026-09-14 04:32:32 | 0 |
| MICO-L3-M3 | 2026-09-14 04:32:32 | 0 |
| MICO-L3-M4 | 2026-09-14 04:32:32 | 0 |

## L4 Modified (4 files)

| File | mtime | Nearest scheduler run | Delta |
|---|---|---|---|
| alert_engine/state.json | 2026-09-14 04:32:00 | M2/M3/M4 @ 04:32:32 | -32s |
| path_safety/state.json | 2026-09-14 04:32:00 | M2/M3/M4 @ 04:32:32 | -32s |
| pc5_collector/state.json | 2026-09-14 04:32:00 | M2/M3/M4 @ 04:32:32 | -32s |
| external_sync/state.json | 2026-09-14 01:32:52 | run 01:32 | ~same |

## L4 Untracked (21 files)

Cadence : setiap :02 dan :32 (30 menit).
Match dengan hasil scheduler M1-M4 pada interval sama.

## Classification

| Category | Count | Attribution | Confidence | Causal Proof |
|---|---|---|---|---|
| 4_modified_L4 | 4 | SUPPORTED | HIGH | NOT_DIRECT |
| 21_untracked_L4 | 21 | SUPPORTED | HIGH | NOT_DIRECT |
| fixture-caused | 0 | NONE | - | - |
| handoff-caused | 0 | NONE | - | - |
| other / unknown | 0 | NONE | - | - |

## Basis

- mtime file L4
- scheduler LastRun timestamp
- scheduler LastTaskResult = 0
- cadence konsisten dengan interval 30 menit

## Inference Boundary

- Mtime + scheduler activity = KORELASI kuat, bukan bukti kausal langsung.
- Tidak ada per-file exit code capture.
- Tidak ada per-task stdout capture yang menghubungkan scheduler → file tertentu.
- Karena itu: causal_proof = NOT_DIRECT.

## Verdict

Status : SUPPORTED_WITH_HIGH_CONFIDENCE.
Bukan VERIFIED. Bukan CONTRADICTED. Bukan UNKNOWN.
Attribution formal tetap memerlukan per-file execution trace (future work).
