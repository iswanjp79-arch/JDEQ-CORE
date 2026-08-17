#!/bin/bash
OUT="/var/log/mico-jdeq/FORECAST.json"
HASH_OUT="/var/log/mico-jdeq/FORECAST.sha256"
ALERT_LOG="/var/log/mico-jdeq/ALERT.log"
mkdir -p "$(dirname "$OUT")"

TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S%z')
CPU_LOAD=$(awk '{print $1}' /proc/loadavg)
MEM_FREE_GB=$(free -g | awk '/^Mem:/ {print $7}')
DISK_FREE_GB=$(df -BG / | awk 'NR==2 {gsub("G",""); print $4}')
TASK_COUNT=$(wc -l < /var/log/mico-jdeq/TASK_CONTRACT.jsonl)
EVIDENCE_COUNT=$(wc -l < /var/log/mico-jdeq/EVIDENCE_CHAIN.sha256)

ALERT=""
PREDICTION="STABLE"

if python3 -c "exit(0 if float('$CPU_LOAD') > 1.5 else 1)"; then
  PREDICTION="CPU_PRESSURE_24H"
  ALERT="$ALERT cpu_high_forecast;"
fi

if [ "$DISK_FREE_GB" -lt 10 ]; then
  PREDICTION="DISK_LOW_24H"
  ALERT="$ALERT disk_low_forecast;"
fi

if [ "$TASK_COUNT" -gt 100 ]; then
  PREDICTION="TASK_CONTRACT_HIGH_VOLUME"
fi

cat > "$OUT" <<JSON
{
  "timestamp": "$TIMESTAMP",
  "cpu_load": "$CPU_LOAD",
  "mem_free_gb": "$MEM_FREE_GB",
  "disk_free_gb": "$DISK_FREE_GB",
  "task_contract_count": "$TASK_COUNT",
  "evidence_chain_length": "$EVIDENCE_COUNT",
  "prediction": "$PREDICTION",
  "alerts": "$ALERT",
  "status": "FORECAST_ENGINE_V1"
}
JSON

sha256sum "$OUT" > "$HASH_OUT"

if [ -n "$ALERT" ]; then
  echo "$(date '+%F %T %z') ALERT:forecast:$ALERT" >> "$ALERT_LOG"
fi

echo "=== FORECAST RESULT ==="
cat "$OUT"
echo ""
echo "=== HASH ==="
cat "$HASH_OUT"
