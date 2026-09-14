# Alert Pipeline Health

- Heartbeat frequency: every 60s.
- If heartbeat missing for 3 consecutive intervals → generate CRITICAL alert to oncall.
- Health checks:
  - Webhook connectivity test
  - SMTP relay test
  - Syslog TLS handshake test
- Health evidence stored at `08_EVIDENCE/alert/health/` with timestamped JSON and sha256.
