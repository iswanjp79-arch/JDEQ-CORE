#!/bin/bash
OUT="/var/log/mico-jdeq/STRESS_TEST.json"
HASH_OUT="/var/log/mico-jdeq/STRESS_TEST.sha256"
STRESS_FILE="/tmp/mico_stress_test.bin"
mkdir -p "$(dirname "$OUT")"

START=$(date +%s)
LOAD_BEFORE=$(awk '{print $1}' /proc/loadavg)
MEM_BEFORE=$(free -g | awk '/^Mem:/ {print $7}')
DISK_BEFORE=$(df -BG / | awk 'NR==2 {gsub("G",""); print $4}')

# Generate file uji 25MB
dd if=/dev/zero of="$STRESS_FILE" bs=1M count=25 status=none

HASH_LOOP=""
for i in $(seq 1 3); do
  H=$(sha256sum "$STRESS_FILE" | awk '{print $1}')
  HASH_LOOP="$HASH_LOOP iteration$i=$H;"
done

rm -f "$STRESS_FILE"

END=$(date +%s)
DURATION=$((END-START))
LOAD_AFTER=$(awk '{print $1}' /proc/loadavg)
MEM_AFTER=$(free -g | awk '/^Mem:/ {print $7}')
DISK_AFTER=$(df -BG / | awk 'NR==2 {gsub("G",""); print $4}')

if [ "$DURATION" -le 120 ] && python3 -c "exit(0 if float('$LOAD_AFTER') <= 3.0 else 1)"; then
  RESULT="PASS"
else
  RESULT="FAIL"
fi

TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S%z')
cat > "$OUT" <<JSON
{
  "timestamp": "$TIMESTAMP",
  "duration_seconds": "$DURATION",
  "load_before": "$LOAD_BEFORE",
  "load_after": "$LOAD_AFTER",
  "mem_free_before_gb": "$MEM_BEFORE",
  "mem_free_after_gb": "$MEM_AFTER",
  "disk_free_before_gb": "$DISK_BEFORE",
  "disk_free_after_gb": "$DISK_AFTER",
  "hash_loop": "$HASH_LOOP",
  "result": "$RESULT",
  "status": "STRESS_TEST_V1"
}
JSON

sha256sum "$OUT" > "$HASH_OUT"
echo "=== STRESS TEST RESULT ==="
cat "$OUT"
echo ""
echo "=== HASH ==="
cat "$HASH_OUT"
