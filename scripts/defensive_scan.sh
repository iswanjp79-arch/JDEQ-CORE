#!/data/data/com.termux/files/usr/bin/bash
echo "=============================================="
echo " MICO-JDEQ DEFENSIVE SCAN — JALUR TENGAH"
echo "=============================================="

# Instal Nmap jika belum ada
pkg install -y nmap 2>/dev/null && echo "✅ Nmap terpasang."

# Definisikan target (node kita sendiri)
echo ""
echo "[1/3] Memindai Radar (Z83)..."
nmap -sT -p 22,4222,8222 -T4 z83-server.tail2a1291.ts.net 2>/dev/null | tee ~/mico_jdeq/evidence/network_map_z83.txt

echo ""
echo "[2/3] Memindai Penjaga (Infinix)..."
nmap -sT -p 22,8022 -T4 100.103.39.81 2>/dev/null | tee ~/mico_jdeq/evidence/network_map_infinix.txt

echo ""
echo "[3/3] Memindai Scout (localhost)..."
nmap -sT -p 22,8080 -T4 localhost 2>/dev/null | tee ~/mico_jdeq/evidence/network_map_scout.txt

# Simpan peta jaringan final
echo ""
echo "=============================================="
echo " PETA WILAYAH PERTAHANAN MICO-JDEQ"
echo "=============================================="
echo "Node:"
echo "  Scout   (Vivo)    : $(grep -q "22/tcp open" ~/mico_jdeq/evidence/network_map_scout.txt && echo '✅ ONLINE' || echo '❌ OFFLINE')"
echo "  Radar   (Z83)     : $(grep -q "22/tcp open" ~/mico_jdeq/evidence/network_map_z83.txt && echo '✅ ONLINE' || echo '❌ OFFLINE')"
echo "  Penjaga (Infinix) : $(grep -q "22/tcp open" ~/mico_jdeq/evidence/network_map_infinix.txt && echo '✅ ONLINE' || echo '❌ OFFLINE')"
echo ""
echo "Port aktif di Radar:"
grep "open" ~/mico_jdeq/evidence/network_map_z83.txt
echo ""
echo "=============================================="
echo " STATUS: PETA WILAYAH TERKUNCI DI SSOT"
echo "=============================================="
