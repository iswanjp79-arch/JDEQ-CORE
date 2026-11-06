#!/data/data/com.termux/files/usr/bin/bash
LABEL="${1:-auto_$(date +%Y%m%d_%H%M%S)}"
SNAPSHOT_DIR="$HOME/mico_jdeq/backups/$LABEL"
mkdir -p "$SNAPSHOT_DIR"
cp -r "$HOME/mico_jdeq/state" "$SNAPSHOT_DIR/"
cp -r "$HOME/mico_jdeq/policy" "$SNAPSHOT_DIR/"
cp -r "$HOME/mico_jdeq/registry" "$SNAPSHOT_DIR/"
cp "$HOME/mico_jdeq/SSOT_MASTER.lock" "$SNAPSHOT_DIR/" 2>/dev/null || true
echo "Snapshot $LABEL created at $SNAPSHOT_DIR"
