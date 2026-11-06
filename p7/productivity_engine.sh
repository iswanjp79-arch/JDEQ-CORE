#!/bin/bash
OUT="/var/log/mico-jdeq/PRODUCTIVITY.json"
HASH_OUT="/var/log/mico-jdeq/PRODUCTIVITY.sha256"
REPO="/home/iswanjp/mico/JDEQ-CORE-repo"
mkdir -p "$(dirname "$OUT")"

TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S%z')
TASK_COUNT=$(wc -l < /var/log/mico-jdeq/TASK_CONTRACT.jsonl)
EVIDENCE_COUNT=$(wc -l < /var/log/mico-jdeq/EVIDENCE_CHAIN.sha256)
LAST_COMMIT=$(cd "$REPO" && git log -1 --format="%h %s")
UPTIME=$(uptime -p)
CPU_LOAD=$(awk '{print $1}' /proc/loadavg)

cat > "$OUT" <<JSON
{
  "timestamp": "$TIMESTAMP",
  "task_contract_count": "$TASK_COUNT",
  "evidence_chain_length": "$EVIDENCE_COUNT",
  "last_commit": "$LAST_COMMIT",
  "uptime": "$UPTIME",
  "cpu_load": "$CPU_LOAD",
  "status": "PRODUCTIVITY_ENGINE_V1"
}
JSON

sha256sum "$OUT" > "$HASH_OUT"
echo "=== PRODUCTIVITY RESULT ==="
cat "$OUT"
echo ""
echo "=== HASH ==="
cat "$HASH_OUT"
