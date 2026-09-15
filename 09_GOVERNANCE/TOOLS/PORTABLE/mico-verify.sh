#!/bin/sh
# MICO-JDEQ Verify (Termux/Linux)
cd "${MICO_ROOT:-$HOME/MICO_SSOT}" 2>/dev/null || { echo "[FAIL] MICO_ROOT tidak ditemukan"; exit 1; }
mf="09_GOVERNANCE/P1-PLANNING/KEY-FILES-MANIFEST.sha256.txt"
if [ ! -f "$mf" ]; then echo "[FAIL] Manifest tidak ada."; exit 1; fi

ok=0; bad=0; miss=0
while IFS= read -r line; do
    [ -z "$line" ] && continue
    rec=$(echo "$line" | awk '{print $1}')
    f=$(echo "$line" | cut -d' ' -f2- | sed 's/^ *//' | tr -d '\r')
    # Konversi backslash Windows → slash
    f=$(echo "$f" | tr '\\' '/')
    if [ ! -f "$f" ]; then echo "[MISSING] $f"; miss=$((miss+1)); continue; fi
    cur=$(sha256sum "$f" | cut -d' ' -f1)
    if [ "$cur" = "$rec" ]; then echo "[OK]      $f"; ok=$((ok+1)); else echo "[MISMATCH] $f"; bad=$((bad+1)); fi
done < "$mf"
echo ""
echo "Total: OK=$ok  MISMATCH=$bad  MISSING=$miss"
[ "$bad" -gt 0 ] || [ "$miss" -gt 0 ] && exit 1
exit 0