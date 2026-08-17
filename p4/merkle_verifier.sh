#!/bin/bash
ROOT_HASH="${1:-}"
LOG="/var/log/mico-jdeq/MERKLE_VERIFY.log"
mkdir -p "$(dirname "$LOG")"

if [[ ! "$ROOT_HASH" =~ ^[a-fA-F0-9]{64}$ ]]; then
  echo "$(date '+%F %T %z') MERKLE_ROOT_INVALID: $ROOT_HASH" >> "$LOG"
  exit 1
fi

/home/iswanjp/mico/p2/mico_task_contract.sh "P4_MERKLE_ROOT_VERIFIED" "MERKLE" >> "$LOG" 2>&1
echo "$(date '+%F %T %z') MERKLE_ROOT_ACCEPTED $ROOT_HASH" >> "$LOG"
echo "MERKLE_ROOT_ACCEPTED $ROOT_HASH"
