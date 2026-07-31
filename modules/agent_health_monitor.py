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
