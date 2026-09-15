#!/bin/sh
# MICO-JDEQ Status (Termux/Linux)
cd "${MICO_ROOT:-$HOME/MICO_SSOT}" 2>/dev/null || { echo "[FAIL] MICO_ROOT tidak ditemukan"; exit 1; }
echo "=== MICO STATUS ==="
echo "Host: $(hostname)"
echo "Time: $(date -Iseconds)"
echo ""
echo "--- Git ---"
git status -sb
git log --oneline -1
echo ""
echo "--- Vault ---"
if [ -f "08_EVIDENCE/VAULT_DATA/vault.bin" ]; then
    size=$(stat -c%s "08_EVIDENCE/VAULT_DATA/vault.bin" 2>/dev/null || stat -f%z "08_EVIDENCE/VAULT_DATA/vault.bin")
    hash=$(sha256sum "08_EVIDENCE/VAULT_DATA/vault.bin" 2>/dev/null | cut -c1-16)
    echo "vault.bin : ${size} byte"
    echo "sha256    : ${hash}..."
else
    echo "vault.bin : TIDAK ADA"
fi
echo ""
echo "--- Hooks ---"
ls -la .git/hooks 2>/dev/null | grep -v sample || echo "(tidak ada hook non-sample)"