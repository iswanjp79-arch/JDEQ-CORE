# L7 STATE MACHINE
PROPOSED
  -> AUTHORIZED (L0 ACC ref present)
  -> ACCEPTED (validation pass)
  -> EXECUTING
  -> SUCCEEDED / FAILED
  -> VERIFIED (step terpisah dari SUCCEEDED)
  -> RECOVERING (if FAILED)
  -> RECOVERED / ESCALATED

Rules:
- No implicit transition
- SUCCEEDED != VERIFIED
- EXECUTING -> VERIFIED dilarang tanpa SUCCEEDED/FAILED
- RECOVERING bounded
- ESCALATED = terminal, butuh L0
