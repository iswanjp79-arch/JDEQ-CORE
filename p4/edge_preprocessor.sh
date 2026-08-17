#!/bin/bash
INPUT="${1:-}"
OUTPUT="${2:-/var/log/mico-jdeq/EDGE_PREHASH.json}"

if [ -z "$INPUT" ] || [ ! -f "$INPUT" ]; then
  echo "EDGE_INPUT_MISSING"
  exit 1
fi

HASH=$(sha256sum "$INPUT" | awk '{print $1}')
SIZE=$(stat -c%s "$INPUT")
NODE=$(hostname)

cat > "$OUTPUT" <<EOF
{"node":"$NODE","size_bytes":$SIZE,"sha256":"$HASH","timestamp":"$(date -Iseconds)"}
EOF

echo "EDGE_PREHASH_OK $HASH"
