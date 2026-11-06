#!/bin/bash
CONFIG="/home/iswanjp/mico/p3/multi_agent_contract.json"
OUT="/var/log/mico-jdeq/OBSERVABILITY.json"
HASH_OUT="/var/log/mico-jdeq/OBSERVABILITY.sha256"
mkdir -p "$(dirname "$OUT")"

TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S%z')
CPU_LOAD=$(awk '{print $1}' /proc/loadavg)
MEM_FREE_GB=$(free -g | awk '/^Mem:/ {print $7}')
DISK_FREE_GB=$(df -BG / | awk 'NR==2 {gsub("G",""); print $4}')

TASK_CONTRACT_COUNT=$(wc -l < /var/log/mico-jdeq/TASK_CONTRACT.jsonl)
EVIDENCE_CHAIN_LENGTH=$(wc -l < /var/log/mico-jdeq/EVIDENCE_CHAIN.sha256)

ALERT=""

if ! ssh_command="systemctl is-active --quiet ssh"; then
  ALERT="$ALERT service_down:ssh;"
fi
if ! tailscale status >/dev/null 2>&1; then
  ALERT="$ALERT service_down:tailscale;"
fi
if [ "$DISK_FREE_GB" -lt 5 ]; then
  ALERT="$ALERT disk_low;"
fi
if [ "$TASK_CONTRACT_COUNT" -lt 1 ] || [ "$EVIDENCE_CHAIN_LENGTH" -lt 1 ]; then
  ALERT="$ALERT hash_mismatch;"
fi

VERIFIER_STATUS="UNKNOWN"
if [ -f /var/log/mico-jdeq/VERIFIKASI_INDEPENDEN_20260817.log ]; then
  tail -n 5 /var/log/mico-jdeq/VERIFIKASI_INDEPENDEN_20260817.log | grep -q "SAH" && VERIFIER_STATUS="SAH"
fi

cat > "$OUT" <<JSON
{
  "timestamp": "$TIMESTAMP",
  "node": "$(hostname)",
  "cpu_load": "$CPU_LOAD",
  "mem_free_gb": "$MEM_FREE_GB",
  "disk_free_gb": "$DISK_FREE_GB",
  "verifier_status": "$VERIFIER_STATUS",
  "task_contract_count": "$TASK_CONTRACT_COUNT",
  "evidence_chain_length": "$EVIDENCE_CHAIN_LENGTH",
  "alerts": "$ALERT",
  "status": "OBSERVABILITY_V1"
}
JSON

sha256sum "$OUT" > "$HASH_OUT"
echo "=== OBSERVABILITY RESULT ==="
cat "$OUT"
echo ""
echo "=== HASH ==="
cat "$HASH_OUT"
