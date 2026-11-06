#!/data/data/com.termux/files/usr/bin/bash
LABEL="$1"
if [ -z "$LABEL" ]; then echo "Usage: rollback.sh <label>"; exit 1; fi
SNAPSHOT_DIR="$HOME/mico_jdeq/backups/$LABEL"
[ -d "$SNAPSHOT_DIR" ] || { echo "Snapshot not found"; exit 1; }
# Backup current state before rollback
bash "$HOME/mico_jdeq/recovery/snapshot.sh" "pre_rollback_$(date +%Y%m%d_%H%M%S)"
cp -r "$SNAPSHOT_DIR/state" "$HOME/mico_jdeq/"
cp -r "$SNAPSHOT_DIR/policy" "$HOME/mico_jdeq/"
cp -r "$SNAPSHOT_DIR/registry" "$HOME/mico_jdeq/"
cp "$SNAPSHOT_DIR/SSOT_MASTER.lock" "$HOME/mico_jdeq/" 2>/dev/null || true
echo "Rollback to $LABEL completed"
