#!/bin/bash
# Nix-on-Droid Listener – Jembatan ke Termux

BRIDGE_DIR="/sdcard/NixBridge"
TASK_FILE="$BRIDGE_DIR/task.txt"
RESULT_FILE="$BRIDGE_DIR/result.txt"
PID_FILE="$BRIDGE_DIR/listener.pid"
LOCK_FILE="$BRIDGE_DIR/listener.lock"

# Fungsi untuk memulai listener di background
start_listener() {
    nohup bash -c '
        while true; do
            if [ -f "'$TASK_FILE'" ]; then
                echo "[NIX] Menjalankan perintah dari task.txt"
                sh "'$TASK_FILE'" > "'$RESULT_FILE'" 2>&1
                rm "'$TASK_FILE'"
            fi
            sleep 3
        done
    ' > /dev/null 2>&1 &
    echo $! > "$PID_FILE"
    touch "$LOCK_FILE"
    echo "[NIX] Listener started (PID: $(cat $PID_FILE))"
}

# Cek apakah listener sudah berjalan
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        echo "[NIX] Listener already running (PID: $PID)"
        exit 0
    else
        echo "[NIX] PID file exists but process dead, restarting..."
        rm -f "$PID_FILE"
    fi
fi

# Start listener
start_listener
