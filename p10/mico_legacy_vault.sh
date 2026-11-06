#!/bin/bash
OUT="/var/log/mico-jdeq/LEGACY_VAULT.json"
HASH_OUT="/var/log/mico-jdeq/LEGACY_VAULT.sha256"
REPO="/home/iswanjp/mico/JDEQ-CORE-repo"
mkdir -p "$(dirname "$OUT")"

TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S%z')
LATEST_COMMIT=$(cd "$REPO" && git log -1 --format="%H %s")
EVIDENCE_LAST=$(tail -n 1 /var/log/mico-jdeq/EVIDENCE_CHAIN.sha256 | awk '{print $1}')
TASK_COUNT=$(wc -l < /var/log/mico-jdeq/TASK_CONTRACT.jsonl)

cat > "$OUT" <<JSON
{
  "timestamp": "$TIMESTAMP",
  "engine": "DIGITAL_LEGACY_VAULT_V1",
  "owner": "ISWAN JUMAN PANCORO, ST",
  "latest_commit": "$LATEST_COMMIT",
  "evidence_chain_last_hash": "$EVIDENCE_LAST",
  "task_contract_count": "$TASK_COUNT",
  "status": "LEGACY_VAULT_PROTECTED"
}
JSON

sha256sum "$OUT" > "$HASH_OUT"
echo "=== LEGACY VAULT RESULT ==="
cat "$OUT"
echo ""
echo "=== HASH ==="
cat "$HASH_OUT"
