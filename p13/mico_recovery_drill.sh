#!/bin/bash
OUT="/var/log/mico-jdeq/RECOVERY_DRILL.json"
HASH_OUT="/var/log/mico-jdeq/RECOVERY_DRILL.sha256"
BACKUP_PARENT="/var/mico-backup"
mkdir -p "$(dirname "$OUT")"

TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S%z')
BACKUP_DIR=$(ls -1dt "$BACKUP_PARENT"/* 2>/dev/null | head -1)
SERVICES_OK=true
SERVICE_DETAIL=""
for svc in ssh tailscaled systemd-networkd; do
  if systemctl is-active --quiet "$svc"; then
    SERVICE_DETAIL="$SERVICE_DETAIL $svc:ok;"
  else
    SERVICE_DETAIL="$SERVICE_DETAIL $svc:down;"
    SERVICES_OK=false
  fi
done

BACKUP_CHECK="SKIPPED"
if [ -n "$BACKUP_DIR" ] && [ -f "$BACKUP_DIR/INTEGRITAS.sha256" ]; then
  if (cd "$BACKUP_DIR" && sha256sum -c INTEGRITAS.sha256 >/dev/null 2>&1); then
    BACKUP_CHECK="OK"
  else
    BACKUP_CHECK="FAIL"
  fi
else
  BACKUP_CHECK="MISSING"
fi

VERIFIER_STATUS="UNKNOWN"
if tail -n 5 /var/log/mico-jdeq/VERIFIKASI_INDEPENDEN_20260817.log 2>/dev/null | grep -q "SAH"; then
  VERIFIER_STATUS="SAH"
fi

EVIDENCE_LAST=$(tail -n 1 /var/log/mico-jdeq/EVIDENCE_CHAIN.sha256 | awk '{print $1}')

if $SERVICES_OK && [ "$BACKUP_CHECK" = "OK" ] && [ "$VERIFIER_STATUS" = "SAH" ]; then
  DRILL_RESULT="PASS"
else
  DRILL_RESULT="FAIL"
fi

cat > "$OUT" <<JSON
{
  "timestamp": "$TIMESTAMP",
  "backup_dir": "$BACKUP_DIR",
  "backup_integrity": "$BACKUP_CHECK",
  "services": "$SERVICE_DETAIL",
  "verifier_status": "$VERIFIER_STATUS",
  "evidence_chain_last_hash": "$EVIDENCE_LAST",
  "drill_result": "$DRILL_RESULT",
  "status": "RECOVERY_DRILL_V1"
}
JSON

sha256sum "$OUT" > "$HASH_OUT"
echo "=== RECOVERY DRILL RESULT ==="
cat "$OUT"
echo ""
echo "=== HASH ==="
cat "$HASH_OUT"
