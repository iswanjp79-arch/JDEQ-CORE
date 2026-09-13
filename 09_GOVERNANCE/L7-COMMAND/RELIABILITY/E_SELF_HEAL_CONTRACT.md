# SELF-HEAL CONTRACT
State: DETECT -> CLASSIFY -> CONTAIN -> RECOVER -> VERIFY -> RECORD -> ESCALATE

allowed: retry idempotent read-only (max 3x), transport re-handshake,
         hash re-verify, restore temp from journal, close circuit after cooldown

prohibited: L4 write, L5 write, modify command contract, bypass auth,
            execute without L0 ACC, self-approve, extend TTL, re-enable circuit without verify

bounded:
  retry_limit: 3
  backoff: 2s -> 8s -> 32s
  circuit_threshold: 3 failures / 60s
  circuit_open_duration: 5 min
  idempotency_key: required
  recovery_verification: mandatory
  fail_safe: BLOCKED (no silent continue)
  escalation: after 3 failed OR circuit open twice
