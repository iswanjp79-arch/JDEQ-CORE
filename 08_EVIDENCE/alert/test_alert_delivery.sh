#!/bin/sh
# MICO-JDEQ - Alert Delivery Test (non-destructive)
TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
PAYLOAD="{\"id\":\"test-$TS\",\"severity\":\"LOW\",\"source\":\"test_alert_delivery\",\"message\":\"test alert\",\"timestamp\":\"$TS\"}"
echo "$PAYLOAD"
echo "$PAYLOAD" >> /d/MICO_SSOT/08_EVIDENCE/alert/test_alert_payloads.log
exit 0
