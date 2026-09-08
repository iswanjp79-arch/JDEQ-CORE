# CAPABILITY SCHEMA (DRAFT)

## Tujuan
Mendefinisikan format standar untuk setiap kemampuan yang dimiliki node/agen.

## Field
- capability_id
- nama_kemampuan
- pemilik_node/agen
- status (VERIFIED, CANDIDATE, PROPOSED, BLOCKED, dll)
- resource_budget (RAM/CPU/disk)
- security_boundary
- evidence_required
- acceptance_criteria
- recovery_method

## Contoh
capability_id : NODE-Z83-001
nama_kemampuan : health_snapshot
status : VERIFIED
resource_budget : low
security_boundary : local only
