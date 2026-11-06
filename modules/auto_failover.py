#!/usr/bin/env python3
"""Jika agen utama mati, alihkan ke cadangan"""
import sqlite3, os, subprocess, json

DB = os.path.expanduser("~/mico_jdeq/state/state.db")
REGISTRY = os.path.expanduser("~/mico_jdeq/registry/ai_workers.json")
LOG = os.path.expanduser("~/mico_jdeq/journal/failover.log")

def failover(primary, task):
    """Cek primary, jika OFFLINE, alihkan ke secondary."""
    conn = sqlite3.connect(DB)
    cur = conn.execute("SELECT status FROM agent_health WHERE id=?", (primary,))
    row = cur.fetchone()
    conn.close()
    
    if row and row[0] == "ONLINE":
        return primary
    else:
        # Fallback ke DeepSeek sebagai default
        with open(LOG, "a") as f:
            f.write(f"[{__import__('time').strftime('%H:%M:%S')}] FAILOVER: {primary} OFFLINE → deepseek_agent\n")
        return "deepseek_agent"

if __name__ == "__main__":
    import sys
    primary = sys.argv[1] if len(sys.argv) > 1 else "groq"
    task = sys.argv[2] if len(sys.argv) > 2 else "ping"
    result = failover(primary, task)
    print(json.dumps({"routed_to": result}))
