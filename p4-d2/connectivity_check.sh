#!/bin/bash
TARGET="${1:-192.168.1.100}"
echo "P4-D2 CONNECTIVITY CHECK"
echo "TARGET: $TARGET"
if ping -c 1 -W 2 "$TARGET" >/dev/null 2>&1; then
  echo "RESULT: REACHABLE"
else
  echo "RESULT: UNREACHABLE"
fi
echo "TIME: $(date -Iseconds)"
