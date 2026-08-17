#!/bin/bash
LATEST=$(ls -1t /var/log/mico-jdeq/VERIFIKASI_INDEPENDEN_*.log 2>/dev/null | head -1)
echo "P4-D7 VALIDATION"
echo "LATEST_VERIFIER_LOG: $LATEST"
if [ -n "$LATEST" ] && tail -n 5 "$LATEST" | grep -q "SAH"; then
  echo "VERIFIER: SAH"
else
  echo "VERIFIER: NOT_SAH"
fi
echo "TIME: $(date -Iseconds)"
