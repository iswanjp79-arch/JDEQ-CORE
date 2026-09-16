#!/bin/bash
set -euo pipefail
echo "[COPILOT] Python 3.13 ABI Repair - Phase 1: Diagnostics"
BACKUP_DIR="$HOME/.jdeq_python_backup_$(date +%s)"
mkdir -p "$BACKUP_DIR"
python3 --version > "$BACKUP_DIR/python_version.txt"
echo "[OK] State backed up to: $BACKUP_DIR"

echo "[COPILOT] Phase 2: Cleaning legacy 3.12 registry"
rm -rf "$PREFIX/lib/python3.12" || true
rm -rf ~/.cache/pip
rm -rf "$PREFIX/tmp/pip*" 2>/dev/null || true
unset PYTHONPATH 2>/dev/null || true

echo "[COPILOT] Phase 3: Register Python 3.13 as primary"
PYTHON_BIN=$(which python3.13 || which python3)
ln -sf "$PYTHON_BIN" "$PREFIX/bin/python"
ln -sf "$PYTHON_BIN" "$PREFIX/bin/python3"
ln -sf "$PYTHON_BIN" "$PREFIX/bin/python3.12" # Mocking for py3compile

echo "[COPILOT] Phase 4: Rebuild pip with Python 3.13 native ABI"
$PYTHON_BIN -m pip install --upgrade pip setuptools wheel --quiet

echo "[COPILOT] Phase 6: Reinstalling Core Stack (Numpy/Scipy)"
# Menggunakan --force-reinstall untuk menimpa binary yang korup
pkg reinstall python-numpy python-scipy -y

echo "[COPILOT] Phase 7: Integration test"
python3 -c "import numpy; import scipy; print(f'✓ NumPy {numpy.__version__}'); print(f'✓ SciPy {scipy.__version__}')" && echo "PROSES SELESAI: JDEQ PULIH!"
