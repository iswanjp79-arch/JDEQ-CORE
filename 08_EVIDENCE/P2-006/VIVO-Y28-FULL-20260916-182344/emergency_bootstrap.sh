#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================
# MICO-JDEQ :: EMERGENCY BOOTSTRAP (PETA EVAKUASI)
# Cara pakai: bash /sdcard/emergency_bootstrap.sh
# Hanya butuh: bash, coreutils, dan Recovery Anchor di /sdcard/mico_recovery
# ==============================================================
RECOVERY_DIR="/sdcard/mico_recovery"
TARGET_DIR="$HOME/mico_jdeq"

echo "🚨 BOOTSTRAP DARURAT MICO-JDEQ"
echo "Sumber: $RECOVERY_DIR"
echo "Tujuan: $TARGET_DIR"

# Periksa apakah Recovery Anchor ada
if [ ! -f "$RECOVERY_DIR/SSOT_MASTER.lock" ]; then
  echo "❌ Recovery Anchor tidak ditemukan! Tidak bisa melanjutkan."
  exit 1
fi

# 1. Buat ulang struktur direktori inti
mkdir -p "$TARGET_DIR"/{knowledge,policy,registry,state,evidence,contracts,quantum/{kernel,heartbeat},hybrid}

# 2. Pulihkan SSOT
cp "$RECOVERY_DIR/SSOT_MASTER.lock" "$TARGET_DIR/"
echo "✅ SSOT dipulihkan: $(cat $TARGET_DIR/SSOT_MASTER.lock)"

# 3. Pulihkan Doktrin
cp "$RECOVERY_DIR/knowledge/"*.md "$TARGET_DIR/knowledge/" 2>/dev/null
echo "✅ Doktrin dipulihkan"

# 4. Pulihkan Policy & Registry
cp "$RECOVERY_DIR/policy/"*.json "$TARGET_DIR/policy/" 2>/dev/null
cp "$RECOVERY_DIR/registry/"*.json "$TARGET_DIR/registry/" 2>/dev/null
echo "✅ Policy & Registry dipulihkan"

# 5. Buat life.log awal dari bukti anchor
if [ -f "$RECOVERY_DIR/state/life.log" ]; then
  cp "$RECOVERY_DIR/state/life.log" "$TARGET_DIR/state/life.log"
else
  echo "$(date +%s) | HIDUP | TERIKAT | SESUAI DOKTRIN (RECOVERY)" > "$TARGET_DIR/state/life.log"
fi
echo "✅ State awal dipulihkan"

# 6. Hidupkan kembali Jantung (versi minimal, tanpa quantum_core.py)
cat > "$TARGET_DIR/quantum/heartbeat/live_pulse.sh" << 'DETAK'
#!/data/data/com.termux/files/usr/bin/bash
while true; do
  echo "$(date +%s) | HIDUP | TERIKAT | SESUAI DOKTRIN (RECOVERY MODE)" >> ~/mico_jdeq/state/life.log
  sleep 3
done
DETAK
chmod +x "$TARGET_DIR/quantum/heartbeat/live_pulse.sh"
pkill -f live_pulse.sh 2>/dev/null
nohup bash "$TARGET_DIR/quantum/heartbeat/live_pulse.sh" > /dev/null 2>&1 &
echo "✅ Jantung Darurat dihidupkan"

# 7. Tandai pemulihan
echo "📅 Dipulihkan: $(date)" > "$TARGET_DIR/RECOVERY_LOG.txt"

echo ""
echo "=========================================="
echo " BOOTSTRAP SELESAI"
echo " MICO-JDEQ hidup kembali dalam mode minimal"
echo "=========================================="
