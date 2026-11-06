#!/bin/bash
BUS="/var/log/mico-jdeq/MESSAGE_BUS.jsonl"
QUARANTINE="/var/log/mico-jdeq/QUARANTINE.jsonl"
LOG="/var/log/mico-jdeq/QUARANTINE.log"
mkdir -p "$(dirname "$BUS")"
touch "$BUS" "$QUARANTINE" "$LOG"

while IFS= read -r line; do
  if echo "$line" | python3 -c 'import json,sys; json.load(sys.stdin)' >/dev/null 2>&1; then
    echo "$line"
  else
    echo "$line" >> "$QUARANTINE"
    echo "$(date '+%F %T %z') QUARANTINED_INVALID_JSON" >> "$LOG"
  fi
done < "$BUS" > /tmp/message_bus_clean

mv /tmp/message_bus_clean "$BUS"

INVALID_COUNT=$(wc -l < "$QUARANTINE")
echo "$(date '+%F %T %z') quarantine_check invalid=$INVALID_COUNT" >> "$LOG"

if [ "$INVALID_COUNT" -gt 0 ]; then
  /home/iswanjp/mico/p3/mico_alerting.sh >> "$LOG" 2>&1 || true
fi

echo "QUARANTINE_VALIDATION_DONE invalid=$INVALID_COUNT"
