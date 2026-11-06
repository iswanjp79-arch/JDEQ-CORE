#!/bin/bash
OUT="/var/log/mico-jdeq/RECOVERY_MODEL.json"
HASH_OUT="/var/log/mico-jdeq/RECOVERY_MODEL.sha256"
mkdir -p "$(dirname "$OUT")"

TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S%z')
ACTIONS=""
STATUS="HEALTHY"

for svc in ssh tailscaled systemd-networkd; do
  if ! systemctl is-active --quiet "$svc"; then
    systemctl restart "$svc" >/dev/null 2>&1
    sleep 1
    if systemctl is-active --quiet "$svc"; then
      ACTIONS="$ACTIONS$svc:restarted;"
    else
      ACTIONS="$ACTIONS$svc:FAILED;"
      STATUS="DEGRADED"
    fi
  else
    ACTIONS="$ACTIONS$svc:ok;"
  fi
done

LISTEN=$(ss -tuln | grep ':8080' | head -1)
if echo "$LISTEN" | grep -q '127.0.0.1'; then
  ACTIONS="$ACTIONS listener8080:ok;"
else
  ACTIONS="$ACTIONS listener8080:non_localhost;"
  STATUS="DEGRADED"
fi

cat > "$OUT" <<JSON
{
  "timestamp": "$TIMESTAMP",
  "node": "$(hostname)",
  "actions": "$ACTIONS",
  "status": "$STATUS",
  "model": "RECOVERY_MODEL_V1"
}
JSON

sha256sum "$OUT" > "$HASH_OUT"

echo "=== RECOVERY MODEL OUTPUT ==="
cat "$OUT"
echo ""
echo "=== HASH ==="
cat "$HASH_OUT"
