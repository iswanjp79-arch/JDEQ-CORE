#!/data/data/com.termux/files/usr/bin/bash
LOG="$HOME/mico_jdeq/journal/connection_pool.log"
echo "[$(date)] Connection Pool: Memeriksa jalur koneksi..." >> $LOG

# Pre-warming: pantau 4 jalur sekaligus
for TARGET in "192.168.1.3" "100.125.176.126" "100.103.39.81" "8.8.8.8"; do
    LATENCY=$(ping -c1 -W2 $TARGET 2>/dev/null | awk -F'/' 'END{print $5}' | cut -d'.' -f1)
    if [ -n "$LATENCY" ]; then
        echo "[$(date)] $TARGET: ${LATENCY}ms" >> $LOG
    else
        echo "[$(date)] $TARGET: TIMEOUT" >> $LOG
    fi
done

# Simpan cache status
sqlite3 ~/mico_jdeq/state/state.db "INSERT OR REPLACE INTO node (name, status, updated) VALUES ('pool_status', 'active', datetime('now'));" 2>/dev/null
echo "✅ Connection pool diperbarui."
