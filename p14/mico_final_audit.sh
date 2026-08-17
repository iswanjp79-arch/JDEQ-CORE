#!/bin/bash
OUT="/var/log/mico-jdeq/FINAL_AUDIT.json"
HASH_OUT="/var/log/mico-jdeq/FINAL_AUDIT.sha256"
REPO="/home/iswanjp/mico/JDEQ-CORE-repo"
mkdir -p "$(dirname "$OUT")"

TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S%z')
LAST_COMMIT=$(cd "$REPO" && git log -1 --format="%H %s")
PHASE_COUNT=$(git -C "$REPO" log --oneline | wc -l)
EVIDENCE_COUNT=$(wc -l < /var/log/mico-jdeq/EVIDENCE_CHAIN.sha256)
TASK_COUNT=$(wc -l < /var/log/mico-jdeq/TASK_CONTRACT.jsonl)
VERIFIER_STATUS=$(tail -n 5 /var/log/mico-jdeq/VERIFIKASI_INDEPENDEN_20260817.log | grep -q "SAH" && echo "SAH" || echo "FAIL")

cat > "$OUT" <<JSON
{
  "timestamp": "$TIMESTAMP",
  "project": "MICO-JDEQ DIGITAL AWARENESS CONSIGNES",
  "final_phase": "P14",
  "status": "FINAL_AUDIT_LOCKED",
  "last_commit": "$LAST_COMMIT",
  "phase_commit_count": "$PHASE_COUNT",
  "evidence_chain_length": "$EVIDENCE_COUNT",
  "task_contract_count": "$TASK_COUNT",
  "verifier_status": "$VERIFIER_STATUS",
  "owner": "ISWAN JUMAN PANCORO, ST"
}
JSON

sha256sum "$OUT" > "$HASH_OUT"

echo "=== FINAL AUDIT RESULT ==="
cat "$OUT"
echo ""
echo "=== FINAL HASH ==="
cat "$HASH_OUT"
