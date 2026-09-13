# L4 ATTRIBUTION

- Timestamp : 2026-09-14_0530

## Methodology

Setiap perubahan L4 dikelompokkan berdasarkan timestamp vs jadwal scheduler.

## Raw L4 changes (with mtime)

|  M | 08_EVIDENCE/alert_engine/state.json | 09/14/2026 04:32:00 |
|  M | 08_EVIDENCE/external_sync/state.json | 09/14/2026 01:32:52 |
|  M | 08_EVIDENCE/path_safety/state.json | 09/14/2026 04:32:00 |
|  M | 08_EVIDENCE/pc5_collector/state.json | 09/14/2026 04:32:00 |
| ?? | 08_EVIDENCE/observer/snapshots/snap_20260913_182541.json | 09/13/2026 18:25:41 |
| ?? | 08_EVIDENCE/observer/snapshots/snap_20260913_190202.json | 09/13/2026 19:02:02 |
| ?? | 08_EVIDENCE/observer/snapshots/snap_20260913_193201.json | 09/13/2026 19:32:01 |
| ?? | 08_EVIDENCE/observer/snapshots/snap_20260913_200201.json | 09/13/2026 20:02:02 |
| ?? | 08_EVIDENCE/observer/snapshots/snap_20260913_203201.json | 09/13/2026 20:32:01 |
| ?? | 08_EVIDENCE/observer/snapshots/snap_20260913_210201.json | 09/13/2026 21:02:01 |
| ?? | 08_EVIDENCE/observer/snapshots/snap_20260914_013202.json | 09/14/2026 01:32:02 |
| ?? | 08_EVIDENCE/observer/snapshots/snap_20260914_020201.json | 09/14/2026 02:02:01 |
| ?? | 08_EVIDENCE/observer/snapshots/snap_20260914_023201.json | 09/14/2026 02:32:03 |
| ?? | 08_EVIDENCE/observer/snapshots/snap_20260914_030201.json | 09/14/2026 03:02:01 |
| ?? | 08_EVIDENCE/observer/snapshots/snap_20260914_033201.json | 09/14/2026 03:32:01 |
| ?? | 08_EVIDENCE/observer/snapshots/snap_20260914_040201.json | 09/14/2026 04:02:01 |
| ?? | 08_EVIDENCE/observer/snapshots/snap_20260914_043201.json | 09/14/2026 04:32:01 |
| ?? | 08_EVIDENCE/observer/snapshots/snap_20260914_050201.json | 09/14/2026 05:02:01 |
| ?? | 08_EVIDENCE/pc5_collector/pull_20260913_182542.json | 09/13/2026 18:25:42 |
| ?? | 08_EVIDENCE/pc5_collector/pull_20260913_193202.json | 09/13/2026 19:32:01 |
| ?? | 08_EVIDENCE/pc5_collector/pull_20260913_203201.json | 09/13/2026 20:32:01 |
| ?? | 08_EVIDENCE/pc5_collector/pull_20260914_013201.json | 09/14/2026 01:32:01 |
| ?? | 08_EVIDENCE/pc5_collector/pull_20260914_023200.json | 09/14/2026 02:32:03 |
| ?? | 08_EVIDENCE/pc5_collector/pull_20260914_033200.json | 09/14/2026 03:32:00 |
| ?? | 08_EVIDENCE/pc5_collector/pull_20260914_043200.json | 09/14/2026 04:32:00 |

## Classification

| Category | Count | Basis |
|---|---|---|
| scheduler-caused | pending | state.json mtime sesuai cadence M1-M5 |
| fixture-caused | 0 (tidak ada bukti) | fixture summary tidak menyentuh 08_EVIDENCE |
| handoff-caused | 0 | handoff commit hanya menyentuh 09_GOVERNANCE/AUDIT |
| other | pending | butuh operator confirmation |
| unknown | pending | file without clear provenance |

## Verdict

Status : ATTRIBUTION_PARTIAL. Full attribution memerlukan scheduler log cross-reference.
