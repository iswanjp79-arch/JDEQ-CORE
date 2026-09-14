# Evidence Retention Policy (P2-2)

- Raw alert JSON: retain 365 days.
- Checksums and audit entries: retain 5 years.
- Sensitive secrets must not be stored in evidence; store only secret references to vault.
- All evidence files must include SHA256 checksum and be recorded in SSOT manifest.
