# FAILURE / RECOVERY MATRIX

| Kode | Kondisi | Respons |
|---|---|---|
| 4 | nonce_reuse | REJECTED |
| 5 | duplicate_command_id | REJECTED |
| 6 | stale | REJECTED |
| 7 | sequence_rollback | REJECTED |
| 8 | CB open | BLOCKED |
| 9 | recovery failed | ESCALATED + CB record |
| 11 | timeout | FAILED |
| 12 | dependency down | ESCALATED |
| 13 | verify fail | VERIFICATION_FAILED + CB record |
| 14 | audit emit fail | exit 14 |
