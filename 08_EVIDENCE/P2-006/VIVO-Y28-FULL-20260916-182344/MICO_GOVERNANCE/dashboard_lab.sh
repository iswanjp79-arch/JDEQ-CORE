#!/usr/bin/env bash
echo "╔══════════════════════════════════════╗"
echo "║   LABORATORIUM MICO-JDEQ           ║"
echo "╠══════════════════════════════════════╣"
[ -f INTEGRITY_MANIFEST.sha256 ] && echo "║  Manifest: ✅ TERKIRIM" || echo "║  Manifest: ❌ TIDAK ADA"
[ -f LOCK_ESTAFET.json ] && echo "║  LOCK ESTAFET: ✅" || echo "║  LOCK ESTAFET: ❌"
[ -f registry.json ] && echo "║  Registry: ✅" || echo "║  Registry: ❌"
echo "╚══════════════════════════════════════╝"
