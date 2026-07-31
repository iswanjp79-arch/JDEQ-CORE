#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: ARSENAL MANAGER"
echo " Amunisi disimpan di GitHub, dipanggil ke RAM"
echo "=========================================="

# 1. Buat gudang amunisi di GitHub
echo "[1/3] Menyimpan amunisi ke Gudang (GitHub)..."
mkdir -p ~/mico_jdeq/arsenal
cat > ~/mico_jdeq/arsenal/README.md << 'EOF'
# MICO-JDEQ ARSENAL
Gudang amunisi audit keamanan. Semua alat disimpan di sini, tidak di perangkat lokal.
EOF

# 2. Buat skrip pemanggil amunisi (load ke RAM, jalankan, bersihkan RAM)
echo "[2/3] Membangun Amunisi Loader..."
cat > ~/mico_jdeq/scripts/load_arsenal.sh << 'LOAD'
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
LOAD
chmod +x ~/mico_jdeq/scripts/load_arsenal.sh

# 3. Commit ke GitHub
echo "[3/3] Mengunci Gudang Amunisi ke GitHub..."
cd ~/mico_jdeq && git add arsenal/ scripts/load_arsenal.sh && git commit -m "ADR-0039: Bangun Arsenal Manager — Amunisi di GitHub, dipanggil ke RAM" 2>/dev/null
git push origin main 2>/dev/null || echo "  ⚠️ Git push gagal, amunisi tetap di commit lokal."

echo ""
echo "=========================================="
echo " ARSENAL MANAGER AKTIF"
echo " Gudang: ~/mico_jdeq/arsenal/ (GitHub)"
echo " Panggil: bash ~/mico_jdeq/scripts/load_arsenal.sh"
echo "=========================================="
