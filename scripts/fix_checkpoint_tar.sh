#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: PERBAIKI SKRIP CHECKPOINT"
echo "=========================================="

# 1. Perbaiki sintaks tar — exclude harus sebelum path
echo "[1/3] Memperbaiki sintaks tar..."
cat > ~/mico_jdeq/scripts/create_checkpoint.sh << 'TARFIX'
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
TARFIX
chmod +x ~/mico_jdeq/scripts/create_checkpoint.sh
echo "  ✅ Skrip checkpoint diperbaiki."

# 2. Uji checkpoint baru
echo "[2/3] Menguji checkpoint baru..."
bash ~/mico_jdeq/scripts/create_checkpoint.sh "fix_$(date +%Y%m%d_%H%M%S)"

# 3. Commit
echo "[3/3] Commit perbaikan..."
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0036: Perbaiki skrip checkpoint — sintaks tar exclude" && echo "  ✅ Perbaikan terkunci."

echo "=========================================="
echo " CHECKPOINT TAR SUDAH DIPERBAIKI"
echo "=========================================="
