# SECURITY BOUNDARY

- Issuer allowlist: L0 saja.
- Nonce unik + anti-replay.
- Duplicate key: command_id.
- TTL 900 detik.
- Sequence monotonik.
- Circuit breaker: 3 gagal / 60 detik.
- Recovery backoff: 2s, 8s, 32s; maks 3 percobaan.
- Fail-safe: BLOCKED.
