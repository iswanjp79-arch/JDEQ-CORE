# ANTI-REPLAY / DUPLICATE / STALE CONTRACT
command_id: unique
correlation_id: UUID
issued_at: ISO8601 UTC
expires_at: ISO8601 UTC (TTL 15 min default)
nonce: UUID v4 (single use)
sequence: monotonic per issuer
idempotency_key: sha256(issuer|command_id|action)

Rejections:
  REPLAY     = nonce pernah dipakai
  DUPLICATE  = idempotency_key dalam window 1 jam
  STALE      = now > expires_at
  MALFORMED  = schema fail
  UNAUTHORIZED = bukan L0 / auth absen
