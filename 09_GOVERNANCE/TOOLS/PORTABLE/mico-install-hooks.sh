#!/bin/sh
# MICO-JDEQ Install Hooks (Termux/Linux)
cd "${MICO_ROOT:-$HOME/MICO_SSOT}" 2>/dev/null || { echo "[FAIL] MICO_ROOT tidak ditemukan"; exit 1; }
src="09_GOVERNANCE/TOOLS/HOOKS"
dst=".git/hooks"
for h in pre-commit post-commit; do
    if [ -f "$src/$h" ]; then
        cp "$src/$h" "$dst/$h"
        chmod +x "$dst/$h"
        echo "[INSTALL] $h"
    fi
done