# EVIDENCE CATALOG
Required fields per evidence:
evidence_id, command_id, correlation_id, actor, agent,
timestamp_utc, timestamp_local, provenance,
expected_state, actual_state, result, recovery_result,
hash_sha256, retention_class

## RETENTION
- lifecycle evidence: permanent
- authorization evidence: permanent
- replay/duplicate/stale reject: 90d
- self-heal attempt: 90d
- escalation record: permanent
