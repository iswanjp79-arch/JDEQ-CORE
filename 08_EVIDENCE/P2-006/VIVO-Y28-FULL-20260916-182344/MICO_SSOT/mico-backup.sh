#!/bin/sh
# MICO-JDEQ Backup (Termux/Linux)
cd "${MICO_ROOT:-$HOME/MICO_SSOT}" 2>/dev/null || { echo "[FAIL] MICO_ROOT tidak ditemukan"; exit 1; }
dir="12_BACKUP/git-mirror"
mkdir -p "$dir"
ts=$(date +%Y%m%d-%H%M%S)
bundle="$dir/jdeq-mirror-manual-$ts.bundle"
if git bundle create "$bundle" --all >/dev/null 2>&1; then
    hash=$(sha256sum "$bundle" | cut -c1-16)
    echo "[OK] Bundle: $bundle"
    echo "[OK] SHA256: ${hash}..."
    ls -1t "$dir"/jdeq-mirror-manual-*.bundle 2>/dev/null | tail -n +6 | xargs -r rm -f
else
    echo "[FAIL] Bundle gagal."; exit 1
fi