# L7 OPEN ITEMS REGISTER
Kode      : MICO-L7-OPEN-001
Tanggal   : 2026-09-14
Status    : OPEN
Note      : These items are NOT closed. Implementation required before deployment.

## 1. Command Replay
Status  : OPEN
Risk    : High
Need    : Nonce or monotonic sequence + reject previously-used nonce
Owner   : TBD (Task Card pending)
Evidence: NONE

## 2. Command Duplication
Status  : OPEN
Risk    : High
Need    : Dedup window (e.g., 1 hour) + reject identical payload
Owner   : TBD (Task Card pending)
Evidence: NONE

## 3. Stale Command Execution
Status  : OPEN
Risk    : High
Need    : issued_at + expires_at, reject if now > expires_at (e.g., 15 min)
Owner   : TBD (Task Card pending)
Evidence: NONE