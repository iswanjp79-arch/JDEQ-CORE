# CRITICAL Runbook (short)

1. Acknowledge alert in incident system within 5 minutes.
2. Identify source and event_id from alert payload.
3. If authentication failure:
   - Check OpenSSH/Operational logs for `userauth_pubkey` entries.
   - Verify authorized_keys checksum in SSOT.
4. If backup failure:
   - Check last backup job logs under /var/log/backup.
   - Attempt immediate retry; escalate if retry fails.
5. If circuit breaker tripped:
   - Follow circuit breaker remediation: disable auto-rotation, collect logs, open incident.
6. Notify L0 if unresolved after 30 minutes.
7. Record all actions to evidence store: `08_EVIDENCE/alert/<timestamp>_<event_id>.json`.
