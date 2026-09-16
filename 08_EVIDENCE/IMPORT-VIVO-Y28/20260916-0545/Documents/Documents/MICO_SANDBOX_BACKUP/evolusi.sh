#!/data/data/com.termux/files/usr/bin/bash
# ============================================
# JDEQ PYTHON EVOLUTION SCRIPT - FIXED
# Perbaikan: hapus paket fiktif, fokus ke pkg
# ============================================

set -e  # Tetep stop yen error, supaya aman

echo "🚀 [1/8] Ngresiki cache build sing gagal..."
rm -rf $PREFIX/tmp/pip-* 2>/dev/null || true
rm -rf ~/.cache/pip 2>/dev/null || true
pip cache purge 2>/dev/null || true

echo "🗑️  [2/8] Mbusak pandas versi lawas (yen ana)..."
pip uninstall -y pandas 2>/dev/null || true

echo "🔧 [3/8] Nguatake alat bangun (build tools) & library dasar..."
# Paket openblas-static ora ana; sing bener libopenblas
pkg install -y clang cmake ninja binutils libc++ libxml2 libxslt \
    python python-static python-pip python-numpy python-numpy-static \
    libopenblas libopenblas-static

echo "📦 [4/8] Nginstal numpy saka repositori Termux..."
pkg install -y python-numpy python-numpy-static

echo "✅ [5/8] Verifikasi numpy headers..."
python -c "import numpy; print('✅ Numpy version:', numpy.__version__); print('📁 Include dir:', numpy.get_include())"

echo "🐼 [6/8] Nginstal pandas langsung saka repositori Termux..."
pkg install -y python-pandas

echo "📋 [7/8] Cek versi pandas sing wis keinstal..."
python -c "import pandas as pd; print('✅ Pandas version:', pd.__version__)"

echo "🔗 [8/8] Nyetel environment variable kanggo kompilasi masa depan..."
echo 'export CFLAGS="-O2 -march=armv8-a"' >> ~/.bashrc
echo 'export CXXFLAGS="-O2 -march=armv8-a"' >> ~/.bashrc
source ~/.bashrc

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║   ✅ EVOLUSI INFRASTRUKTUR RAMPUNG        ║"
echo "╚════════════════════════════════════════════╝"
