#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: STATE-DRIVEN ORCHESTRATOR"
echo "=========================================="

# 1. State Database
echo "[1/4] Membuat State Database..."
python3 << 'PYEOF'
import sqlite3, os
DB = os.path.expanduser("~/mico_jdeq/state/state.db")
os.makedirs(os.path.dirname(DB), exist_ok=True)
conn = sqlite3.connect(DB)
conn.execute("CREATE TABLE IF NOT EXISTS node (name TEXT PRIMARY KEY, status TEXT, updated TEXT)")
conn.execute("CREATE TABLE IF NOT EXISTS service (name TEXT, node TEXT, status TEXT, updated TEXT, PRIMARY KEY(name, node))")
conn.execute("CREATE TABLE IF NOT EXISTS event (timestamp TEXT, source TEXT, type TEXT, message TEXT)")
conn.commit()
conn.close()
print("✅ State database siap.")
PYEOF

# 2. State Observer
echo "[2/4] Membuat State Observer..."
cat > ~/mico_jdeq/scripts/state_observer.py << 'PYEOF'
import os, json, sqlite3, subprocess, time
DB = os.path.expanduser("~/mico_jdeq/state/state.db")

def observe():
    conn = sqlite3.connect(DB); ts = time.strftime("%Y-%m-%dT%H:%M:%S")

    # Koneksi Radar
    r = subprocess.run(["ssh","-o","ConnectTimeout=3","iswan@z83-server.tail2a1291.ts.net","echo OK"], capture_output=True)
    conn.execute("INSERT OR REPLACE INTO node VALUES ('radar', ?, ?)", ("ONLINE" if r.returncode==0 else "OFFLINE", ts))

    # Koneksi Penjaga
    p = subprocess.run(["ssh","-o","ConnectTimeout=3","-p","8022","iswan@100.103.39.81","echo OK"], capture_output=True)
    conn.execute("INSERT OR REPLACE INTO node VALUES ('penjaga', ?, ?)", ("ONLINE" if p.returncode==0 else "OFFLINE", ts))

    # NATS
    n = subprocess.run(["ssh","iswan@z83-server.tail2a1291.ts.net","curl -s http://localhost:8222/varz"], capture_output=True)
    conn.execute("INSERT OR REPLACE INTO service VALUES ('nats', 'radar', ?, ?)", ("ONLINE" if "server_id" in n.stdout.decode() else "OFFLINE", ts))

    # RAM Scout
    ram = subprocess.run(["free","-m"], capture_output=True, text=True)
    avail = [l for l in ram.stdout.split("\n") if "Mem:" in l][0].split()[6]
    conn.execute("INSERT OR REPLACE INTO service VALUES ('ram', 'scout', ?, ?)", (f"{avail}MB", ts))

    conn.commit(); conn.close()

observe()
print("✅ State updated.")
PYEOF
chmod +x ~/mico_jdeq/scripts/state_observer.py

# 3. Action Engine
echo "[3/4] Membuat Action Engine..."
cat > ~/mico_jdeq/scripts/action_engine.py << 'PYEOF'
import sqlite3, os, subprocess, time
DB = os.path.expanduser("~/mico_jdeq/state/state.db")
LOG = os.path.expanduser("~/mico_jdeq/journal/action.log")

def act():
    conn = sqlite3.connect(DB)
    cur = conn.execute("SELECT name, status FROM node WHERE status='OFFLINE'")
    for (node, status) in cur.fetchall():
        msg = f"[{time.strftime('%H:%M:%S')}] ACTION: {node} OFFLINE → notifikasi"
        with open(LOG, "a") as f: f.write(msg + "\n")
    conn.close()

act()
print("✅ Actions checked.")
PYEOF
chmod +x ~/mico_jdeq/scripts/action_engine.py

# 4. Crown Job
echo "[4/4] Memasang Crown Job State Observer..."
(crontab -l 2>/dev/null | grep -v state_observer; echo "*/3 * * * * python3 ~/mico_jdeq/scripts/state_observer.py && python3 ~/mico_jdeq/scripts/action_engine.py") | crontab -

# Verifikasi
python3 ~/mico_jdeq/scripts/state_observer.py
python3 ~/mico_jdeq/scripts/action_engine.py

# Commit
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0023: State-Driven Orchestrator - Observer & Action Engine" && echo "✅ State-Driven Orchestrator terkunci."

echo "=========================================="
echo " STATE-DRIVEN ORCHESTRATOR AKTIF"
echo " Observer: setiap 3 menit"
echo " Database: ~/mico_jdeq/state/state.db"
echo "=========================================="
