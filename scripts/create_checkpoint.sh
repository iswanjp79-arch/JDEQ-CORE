#!/data/data/com.termux/files/usr/bin/bash
CHECKPOINT_DIR="$HOME/mico_jdeq/checkpoint"
mkdir -p "$CHECKPOINT_DIR"
LABEL="$1"
if [ -z "$LABEL" ]; then
    LABEL="auto_$(date +%Y%m%d_%H%M%S)"
fi
FILE="$CHECKPOINT_DIR/state_${LABEL}.tar.gz"
# Cara benar: --exclude dulu, baru path
tar --exclude='checkpoint/*.tar.gz' --exclude='cache' --exclude='__pycache__' --exclude='.git' -czf "$FILE" -C "$HOME" mico_jdeq 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ Checkpoint $LABEL tersimpan: $FILE"
else
    echo "❌ Checkpoint gagal. Cek log."
fi
