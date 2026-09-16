#!/data/data/com.termux/files/usr/bin/bash
# Script: audit_termux.sh
# Fungsi: Menampilkan semua paket Termux dan Python terinstal beserta versinya

echo "===== DAFTAR PAKET TERMUX ====="
pkg list-installed | awk '{print $1 " : " $2}'

echo ""
echo "===== VERSI PYTHON ====="
python --version

echo ""
echo "===== PAKET PYTHON TERINSTAL ====="
pip list --format=columns

echo ""
echo "===== PATH EXECUTABLE ====="
which python
which pip
which clang
