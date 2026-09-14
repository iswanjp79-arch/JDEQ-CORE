# WARNING Runbook (short)

1. Acknowledge alert in incident system within 30 minutes.
2. Triage: collect relevant logs and metrics.
3. If disk space low:
   - Identify top consumers and rotate logs.
   - Schedule cleanup and monitor.
4. If degraded performance:
   - Check CPU/memory, GC, and recent deployments.
5. Document remediation steps and evidence to `08_EVIDENCE/alert/`.
