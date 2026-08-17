#!/bin/bash
LOG="/var/log/mico-jdeq/MESSAGE_BUS.jsonl"
HASH_OUT="/var/log/mico-jdeq/MESSAGE_BUS.sha256"
mkdir -p "$(dirname "$LOG")"

AGENT="${1:-Z83}"
ROLE="${2:-broker}"
MESSAGE="${3:-heartbeat}"
TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S%z')

PREV_HASH=$(tail -n 1 "$HASH_OUT" 2>/dev/null | awk '{print $1}')
[ -z "$PREV_HASH" ] && PREV_HASH="GENESIS"

ENTRY=$(printf '{"timestamp":"%s","agent":"%s","role":"%s","message":"%s","prev_hash":"%s"}' "$TIMESTAMP" "$AGENT" "$ROLE" "$MESSAGE" "$PREV_HASH")
echo "$ENTRY" >> "$LOG"

NEW_HASH=$(echo -n "$ENTRY" | sha256sum | awk '{print $1}')
echo "$NEW_HASH  $TIMESTAMP" >> "$HASH_OUT"

echo "MESSAGE_BUS_OK $NEW_HASH"
