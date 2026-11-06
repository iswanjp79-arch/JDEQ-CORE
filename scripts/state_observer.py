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
