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
