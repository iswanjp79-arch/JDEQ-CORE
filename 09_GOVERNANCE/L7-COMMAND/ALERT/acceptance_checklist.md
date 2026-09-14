# P2-2 Acceptance Checklist

- [ ] alert_recipients.yaml present and validated
- [ ] alert_payload_schema.json present and schema validated
- [ ] webhook, smtp, syslog transports configured and TLS/HMAC enabled
- [ ] test_alert_delivery.sh executed for INFO/WARNING/CRITICAL and results in 08_EVIDENCE/alert/tests/
- [ ] evidence files present with sha256 checksums
- [ ] escalation_policy.yaml approved by DOLA
- [ ] ACL file present and enforced
- [ ] AG-004 independent verification requested and evidence package provided
- [ ] L0 final approval recorded
