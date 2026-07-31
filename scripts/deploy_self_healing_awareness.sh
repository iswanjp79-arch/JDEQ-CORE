#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: SELF-HEALING AWARENESS"
echo "=========================================="

# 1. Buat Health Monitor untuk semua agen
echo "[1/3] Membangun Agent Health Monitor..."
cat > ~/mico_jdeq/modules/agent_health_monitor.py << 'PYEOF'
#!/usr/bin/env python3
"""Memantau kesehatan semua agen dan mencatat ke state.db"""
import sqlite3, os, time, subprocess, json

DB = os.path.expanduser("~/mico_jdeq/state/state.db")
REGISTRY = os.path.expanduser("~/mico_jdeq/registry/ai_workers.json")

def check_agents():
    with open(REGISTRY) as f:
        agents = json.load(f)
    
    conn = sqlite3.connect(DB)
    conn.execute("CREATE TABLE IF NOT EXISTS agent_health (id TEXT PRIMARY KEY, status TEXT, checked TEXT)")
    
    for agent_id, info in agents.items():
        # Untuk agen cloud (Groq, ChatGPT, dll) — cek API endpoint
        # Untuk agen lokal — cek proses/SSH
        if agent_id in ["groq", "deepseek_agent"]:
            # Cek Groq sebagai representasi agen cloud
            try:
                r = subprocess.run(["python3", os.path.expanduser("~/mico_jdeq/scripts/groq_controller_v3.py"), "ping"], 
                                 capture_output=True, text=True, timeout=10)
                status = "ONLINE" if "error" not in r.stdout.lower() else "OFFLINE"
            except:
                status = "OFFLINE"
        else:
            status = info.get("status", "unknown")
        
        conn.execute("INSERT OR REPLACE INTO agent_health VALUES (?, ?, datetime('now'))", 
                    (agent_id, status))
    
    conn.commit()
    conn.close()
    print(f"✅ {len(agents)} agen diperiksa.")

check_agents()
PYEOF
chmod +x ~/mico_jdeq/modules/agent_health_monitor.py
echo "  ✅ Agent Health Monitor siap."

# 2. Buat Auto-Failover Router
echo "[2/3] Membangun Auto-Failover Router..."
cat > ~/mico_jdeq/modules/auto_failover.py << 'PYEOF'
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
PYEOF
chmod +x ~/mico_jdeq/modules/auto_failover.py
echo "  ✅ Auto-Failover Router siap."

# 3. Pasang di crontab (setiap 5 menit)
echo "[3/3] Memasang Agent Health Monitor di Crontab..."
(crontab -l 2>/dev/null | grep -v agent_health_monitor; echo "*/5 * * * * python3 ~/mico_jdeq/modules/agent_health_monitor.py >> ~/mico_jdeq/journal/agent_health.log 2>&1") | crontab -
echo "  ✅ Crontab terpasang."

# Jalankan sekarang
python3 ~/mico_jdeq/modules/agent_health_monitor.py

# Commit
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0038: Deploy Self-Healing Awareness — Agent Health Monitor + Auto-Failover" && echo "✅ Self-Healing Awareness terkunci."

echo "=========================================="
echo " SELF-HEALING AWARENESS AKTIF"
echo " Health Monitor: setiap 5 menit"
echo " Auto-Failover: alihkan jika agen mati"
echo "=========================================="
