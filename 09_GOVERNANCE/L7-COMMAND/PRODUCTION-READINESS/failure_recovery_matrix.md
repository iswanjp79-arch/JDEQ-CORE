# FAILURE / RECOVERY MATRIX

| Kode | Kondisi | Respons |
|---|---|---|
| 2  | parse_error (JSON rusak) | REJECTED (no state change) |
| 3  | schema_reject (field kurang/tidak valid) | REJECTED |
| 4  | nonce_reuse | REJECTED |
| 5  | duplicate_command_id | REJECTED |
| 6  | stale_command (lewat TTL 900s) | REJECTED |
| 7  | sequence_rollback | REJECTED |
| 8  | circuit_breaker_open | BLOCKED |
| 9  | recovery_failed | ESCALATED + CB record |
| 10 | unauthorized_issuer (bukan L0) | REJECTED |
| 11 | execution_timeout | FAILED |
| 12 | dependency_unavailable | ESCALATED |
| 13 | verification_failed | VERIFICATION_FAILED + CB record |
| 14 | audit_emit_failed | exit 14 (no further execution) |
| 15 | interrupted (killed mid-exec) | state recoverable via audit trail |

## Mapping ke State Machine
- Kode 2, 3, 10 → state akhir: REJECTED
- Kode 4, 5, 6, 7 → state akhir: REJECTED
- Kode 8 → state akhir: BLOCKED
- Kode 9, 12 → state akhir: ESCALATED
- Kode 11 → state akhir: FAILED
- Kode 13 → state akhir: VERIFICATION_FAILED
- Kode 14 → state akhir: intake only (no transition)
- Kode 15 → state akhir: indeterminate (audit-based recovery)
