#!/bin/bash
echo "P4-D7 VALIDATION"
if tail -n 5 /var/log/mico-jdeq/VERIFIKASI_INDEPENDEN_20260818.log 2>/dev/null | grep -q SAH; then
  echo "VERIFIER: SAH"
else
  echo "VERIFIER: NOT_SAH"
fi
echo "TIME: $(date -Iseconds)"
