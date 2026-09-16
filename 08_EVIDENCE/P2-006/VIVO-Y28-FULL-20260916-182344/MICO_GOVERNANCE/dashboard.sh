#!/usr/bin/env bash
echo "╔══════════════════════════════════════╗"
echo "║   MICO-JDEQ GOVERNANCE DASHBOARD   ║"
echo "╠══════════════════════════════════════╣"
# Cek Manifest
if [ -f INTEGRITY_MANIFEST.sha256 ]; then
  echo "║  Manifest: ✅ TERSEDIA"
else
  echo "║  Manifest: ❌ TIDAK ADA"
fi
# Cek Registry
if python3 -c "import json; json.load(open('LOCK_ESTAFET.json'))" 2>/dev/null; then
  echo "║  Registry: ✅ VALID"
else
  echo "║  Registry: ❌ CORRUPT"
fi
echo "╚══════════════════════════════════════╝"
