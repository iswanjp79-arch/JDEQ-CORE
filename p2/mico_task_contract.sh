#!/bin/bash
LOG="/var/log/mico-jdeq/TASK_CONTRACT.jsonl"
CHAIN="/var/log/mico-jdeq/EVIDENCE_CHAIN.sha256"
mkdir -p "$(dirname "$LOG")"

ACTION="${1:-TASK_DEFAULT}"
OPERATOR="${2:-ISWANJP}"
TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S%z')
PREV_HASH=$(tail -n 1 "$CHAIN" 2>/dev/null | awk '{print $1}')
[ -z "$PREV_HASH" ] && PREV_HASH="GENESIS"

ENTRY=$(printf '{"timestamp":"%s","operator":"%s","action":"%s","prev_hash":"%s"}' "$TIMESTAMP" "$OPERATOR" "$ACTION" "$PREV_HASH")
echo "$ENTRY" >> "$LOG"

NEW_HASH=$(echo -n "$ENTRY" | sha256sum | awk '{print $1}')
echo "$NEW_HASH  $TIMESTAMP" >> "$CHAIN"

echo "TASK_CONTRACT_LOGGED"
echo "$ENTRY"
echo "NEW_HASH: $NEW_HASH"
