#!/bin/bash
MODE="${1:-check}"
LOG="/var/log/mico-jdeq/PIPELINE.log"
JSON_LOG="/var/log/mico-jdeq/PIPELINE_LOG.jsonl"
REPO="/home/iswanjp/mico/JDEQ-CORE-repo"
mkdir -p "$(dirname "$LOG")"

ts=$(date '+%Y-%m-%dT%H:%M:%S%z')

log_action() {
  echo "$1" >> "$LOG"
  echo "{\"timestamp\":\"$ts\",\"mode\":\"$MODE\",\"action\":\"$1\"}" >> "$JSON_LOG"
}

log_action "PIPELINE_START"

if [ "$MODE" = "check" ]; then
  bash /home/iswanjp/verify_independen_z83.sh >> "$LOG" 2>&1
  sha256sum /home/iswanjp/mico/JDEQ-CORE-repo/p3/* /home/iswanjp/mico/JDEQ-CORE-repo/p4/* 2>/dev/null | grep -v MANIFEST > /tmp/pipeline_check.sha256
  cat /tmp/pipeline_check.sha256 >> "$LOG"
  log_action "PIPELINE_CHECK_DONE"
elif [ "$MODE" = "run" ]; then
  /usr/local/bin/mico_heartbeat.sh >> "$LOG" 2>&1
  /home/iswanjp/mico/p3/mico_alerting.sh >> "$LOG" 2>&1
  /home/iswanjp/mico/p3/mico_observability.sh >> "$LOG" 2>&1
  /home/iswanjp/mico/p3/mico_storage_watch.sh >> "$LOG" 2>&1
  /home/iswanjp/mico/p2/mico_task_contract.sh "P5_PIPELINE_RUN" "ISWANJP" >> "$LOG" 2>&1
  log_action "PIPELINE_RUN_DONE"
elif [ "$MODE" = "push" ]; then
  /usr/local/bin/mico_heartbeat.sh >> "$LOG" 2>&1
  cd "$REPO" || exit 1
  git add p1 p2 p3 p4 p5
  git commit -m "P5-001 pipeline auto-run" >> "$LOG" 2>&1
  git push origin HEAD >> "$LOG" 2>&1
  log_action "PIPELINE_PUSH_DONE"
else
  log_action "PIPELINE_MODE_INVALID"
  echo "Usage: $0 [check|run|push]"
fi

log_action "PIPELINE_END"
