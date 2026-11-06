#!/bin/bash
OUT="/var/log/mico-jdeq/DOCUMENTATION.md"
HASH_OUT="/var/log/mico-jdeq/DOCUMENTATION.sha256"
REPO="/home/iswanjp/mico/JDEQ-CORE-repo"
mkdir -p "$(dirname "$OUT")"

{
  echo "# MICO-JDEQ DOCUMENTATION & KNOWLEDGE BASE"
  echo ""
  echo "Generated: $(date '+%Y-%m-%dT%H:%M:%S%z')"
  echo "Node: $(hostname)"
  echo ""
  echo "## Latest Git Log"
  git -C "$REPO" log --oneline -10
  echo ""
  echo "## Verifier Status"
  tail -n 5 /var/log/mico-jdeq/VERIFIKASI_INDEPENDEN_20260817.log 2>/dev/null | grep -E 'HASIL|Bukti' || echo "verifier log not found"
  echo ""
  echo "## Evidence Chain Tail"
  tail -n 5 /var/log/mico-jdeq/EVIDENCE_CHAIN.sha256
  echo ""
  echo "## Alert Log Tail"
  tail -n 5 /var/log/mico-jdeq/ALERT.log 2>/dev/null || echo "no alert log"
} > "$OUT"

sha256sum "$OUT" > "$HASH_OUT"

echo "=== DOCUMENTATION RESULT ==="
head -n 30 "$OUT"
echo ""
echo "=== HASH ==="
cat "$HASH_OUT"

