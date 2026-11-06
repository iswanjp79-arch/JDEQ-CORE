#!/bin/bash
OBS="/var/log/mico-jdeq/OBSERVABILITY.json"
LOG="/var/log/mico-jdeq/ALERT.log"
STATE_DIR="/tmp/mico_alert_cooldown"
mkdir -p "$STATE_DIR"

[ ! -f "$OBS" ] && { echo "$(date '+%Y-%m-%dT%H:%M:%S%z') OBSERVABILITY.json not found" >> "$LOG"; exit 0; }

CPU_LOAD=$(python3 -c 'import json; print(json.load(open("/var/log/mico-jdeq/OBSERVABILITY.json"))["cpu_load"])')
DISK_FREE=$(python3 -c 'import json; print(json.load(open("/var/log/mico-jdeq/OBSERVABILITY.json"))["disk_free_gb"])')
VERIFIER=$(python3 -c 'import json; print(json.load(open("/var/log/mico-jdeq/OBSERVABILITY.json"))["verifier_status"])')

now=$(date +%s)
alert=false
msg=""

if [ "$VERIFIER" != "SAH" ]; then alert=true; msg="$msg verifier_fail;"; fi
if python3 -c "exit(0 if float('$CPU_LOAD') > 2.0 else 1)"; then alert=true; msg="$msg cpu_high($CPU_LOAD);"; fi
if [ "$DISK_FREE" -lt 10 ]; then alert=true; msg="$msg disk_low($DISK_FREE);"; fi

TASK_FILE="/var/log/mico-jdeq/TASK_CONTRACT.jsonl"
if [ -f "$TASK_FILE" ]; then
  last_mod=$(stat -c %Y "$TASK_FILE")
  diff_min=$(( (now - last_mod) / 60 ))
  if [ "$diff_min" -gt 30 ]; then alert=true; msg="$msg task_contract_stale(${diff_min}m);"; fi
else
  alert=true; msg="$msg task_contract_missing;"
fi

if $alert; then
  cooldown="$STATE_DIR/alert_dedup"
  if [ -f "$cooldown" ]; then
    last=$(cat "$cooldown")
  else
    last=0
  fi
  diff=$(( now - last ))
  if [ "$diff" -ge 300 ]; then
    echo "$now" > "$cooldown"
    echo "$(date '+%Y-%m-%dT%H:%M:%S%z') ALERT:$msg" >> "$LOG"
  fi
else
  echo "$(date '+%Y-%m-%dT%H:%M:%S%z') OK" >> "$LOG"
fi
