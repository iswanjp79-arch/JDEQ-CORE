#!/bin/bash
CONFIG="/home/iswanjp/mico/p2/gateway_config.json"
OUT="/var/log/mico-jdeq/COMPUTE_GATEWAY.json"
HASH_OUT="/var/log/mico-jdeq/COMPUTE_GATEWAY.sha256"
mkdir -p "$(dirname "$OUT")"

LOAD=$(awk '{print $1}' /proc/loadavg)
MEM_FREE_GB=$(free -g | awk '/^Mem:/ {print $7}')
DISK_FREE_GB=$(df -BG / | awk 'NR==2 {gsub("G",""); print $4}')

CPU_MAX=$(python3 -c 'import json; print(json.load(open("/home/iswanjp/mico/p2/gateway_config.json"))["thresholds"]["cpu_load_max"])')
MEM_MIN=$(python3 -c 'import json; print(json.load(open("/home/iswanjp/mico/p2/gateway_config.json"))["thresholds"]["mem_free_min_gb"])')
DISK_MIN=$(python3 -c 'import json; print(json.load(open("/home/iswanjp/mico/p2/gateway_config.json"))["thresholds"]["disk_free_min_gb"])')

ROUTE="LOCAL"
DEST="Z83"

if (( $(echo "$LOAD > $CPU_MAX" | bc -l) )) || (( $(echo "$MEM_FREE_GB < $MEM_MIN" | bc -l) )) || (( $(echo "$DISK_FREE_GB < $DISK_MIN" | bc -l) )); then
  ROUTE="REMOTE"
  DEST="PC-I5"
fi

TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S%z')
cat > "$OUT" <<JSON
{
  "timestamp": "$TIMESTAMP",
  "node": "Z83",
  "cpu_load": "$LOAD",
  "mem_free_gb": "$MEM_FREE_GB",
  "disk_free_gb": "$DISK_FREE_GB",
  "route_decision": "$ROUTE",
  "destination_node": "$DEST",
  "status": "COMPUTE_GATEWAY_V1"
}
JSON

sha256sum "$OUT" > "$HASH_OUT"

echo "=== COMPUTE GATEWAY RESULT ==="
cat "$OUT"
echo ""
echo "=== HASH ==="
cat "$HASH_OUT"
