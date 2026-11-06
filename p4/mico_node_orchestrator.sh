#!/bin/bash
OUT="/var/log/mico-jdeq/NODE_STATUS.json"
HASH_OUT="/var/log/mico-jdeq/NODE_STATUS.sha256"
mkdir -p "$(dirname "$OUT")"

TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S%z')
CPU_LOAD=$(awk '{print $1}' /proc/loadavg)
MEM_FREE_GB=$(free -g | awk '/^Mem:/ {print $7}')
DISK_FREE_GB=$(df -BG / | awk 'NR==2 {gsub("G",""); print $4}')

PC_IP=$(python3 -c 'import json; print(json.load(open("/home/iswanjp/mico/p4/multi_node_contract.json"))["nodes"]["PC-I5"]["ip"])')

if ping -c 1 -W 2 "$PC_IP" >/dev/null 2>&1; then
  PC_STATUS="REACHABLE"
else
  PC_STATUS="UNREACHABLE"
fi

if [ "$PC_STATUS" = "REACHABLE" ] && python3 -c "exit(0 if float('$CPU_LOAD') > 1.5 else 1)"; then
  ROUTE="REMOTE"
  DEST="PC-I5"
else
  ROUTE="LOCAL"
  DEST="Z83"
fi

cat > "$OUT" <<JSON
{
  "timestamp": "$TIMESTAMP",
  "orchestrator": "Z83",
  "cpu_load": "$CPU_LOAD",
  "mem_free_gb": "$MEM_FREE_GB",
  "disk_free_gb": "$DISK_FREE_GB",
  "pc_i5_status": "$PC_STATUS",
  "route_decision": "$ROUTE",
  "destination_node": "$DEST",
  "status": "NODE_ORCHESTRATOR_V1"
}
JSON

sha256sum "$OUT" > "$HASH_OUT"

echo "=== NODE STATUS RESULT ==="
cat "$OUT"
echo ""
echo "=== HASH ==="
cat "$HASH_OUT"
