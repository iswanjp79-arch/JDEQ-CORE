#!/data/data/com.termux/files/usr/bin/bash
# Memuat alat audit ke RAM, menjalankan, membersihkan RAM
TMPDIR="/data/data/com.termux/files/usr/tmp/arsenal_$$"
mkdir -p "$TMPDIR"
trap "rm -rf $TMPDIR" EXIT

echo "🔫 Memuat amunisi ke RAM..."
cd "$TMPDIR"
pkg install -y nmap nikto hydra sqlmap 2>/dev/null || true

echo "🎯 Amunisi siap. Jalankan perintah audit."
echo "   Contoh: nmap -sT -p 22,4222,8222 z83-server.tail2a1291.ts.net"
echo "   Setelah selesai, ketik 'exit' — amunisi akan dihapus dari RAM."
bash

echo "🧹 Membersihkan RAM..."
pkg uninstall nmap nikto hydra sqlmap 2>/dev/null || true
echo "✅ RAM bersih. Amunisi tetap di GitHub."
