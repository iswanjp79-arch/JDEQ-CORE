#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ AUTO-HEAL DAEMON"
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="

# Jalankan health check dan simpan hasilnya
bash ~/mico_jdeq/scripts/health_check_enterprise.sh > ~/mico_jdeq/journal/health_result.txt 2>&1
HEAL_LOG=~/mico_jdeq/journal/auto_heal.log

# Fungsi untuk mencatat dan memperbaiki
heal() {
    echo "[$(date '+%H:%M:%S')] AUTO-HEAL: $1" | tee -a $HEAL_LOG
    eval "$2" 2>&1 | tee -a $HEAL_LOG
}

# Cek dan perbaiki SSH Radar
if ! ssh -o ConnectTimeout=3 iswan@z83-server.tail2a1291.ts.net "echo OK" 2>/dev/null | grep -q OK; then
    heal "SSH Radar mati. Mencoba restart..." "ssh iswan@z83-server.tail2a1291.ts.net 'sudo systemctl restart ssh' 2>/dev/null"
fi

# Cek dan perbaiki SSH Penjaga
if ! ssh -o ConnectTimeout=3 -p 8022 iswan@100.103.39.81 "echo OK" 2>/dev/null | grep -q OK; then
    heal "SSH Penjaga mati. Menunggu node kembali online..." "echo 'Penjaga offline - perlu pengecekan manual'"
fi

# Cek dan perbaiki NATS
if ! ssh iswan@z83-server.tail2a1291.ts.net "systemctl is-active nats-server" 2>/dev/null | grep -q active; then
    heal "NATS mati. Mencoba restart..." "ssh iswan@z83-server.tail2a1291.ts.net 'sudo systemctl restart nats-server' 2>/dev/null"
fi

# Cek dan perbaiki Crond
if ! pgrep crond > /dev/null; then
    heal "Crond mati. Mencoba restart..." "crond && echo 'Crond dinyalakan'"
fi

# Cek dan perbaiki SSHD lokal
if ! pgrep sshd > /dev/null; then
    heal "SSHD Scout mati. Mencoba restart..." "sshd && echo 'SSHD dinyalakan'"
fi

echo "=========================================="
echo " AUTO-HEAL COMPLETE"
echo "=========================================="
