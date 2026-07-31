#!/usr/bin/env python3
# MICO-JDEQ ENTERPRISE RUNTIME ENGINE
# Vivo = Scout (Kendali 5%), Z83 = Worker (Eksekutor 95%), Infinix = Sensor

import subprocess, json, time, os

NODES = {
    "z83":     {"ip": "100.125.176.126", "user": "iswan"},
    "infinix": {"ip": "100.103.39.81",   "user": "iswan", "port": 8022},
}

CACHE = os.path.expanduser("~/mico_jdeq/cache")
os.makedirs(CACHE, exist_ok=True)

def run_ssh(node, cmd):
    n = NODES[node]
    port = n.get("port", 22)
    ssh_cmd = ["ssh", "-o", "ConnectTimeout=3", "-p", str(port), f"{n['user']}@{n['ip']}", cmd]
    r = subprocess.run(ssh_cmd, capture_output=True, text=True)
    return r.stdout.strip() if r.returncode == 0 else f"❌ {r.stderr.strip()[:50]}"

def cache_hasil(kunci, nilai):
    with open(f"{CACHE}/{kunci}.json", "w") as f:
        json.dump({"ts": time.time(), "data": nilai}, f)

def baca_cache(kunci, timeout=10):
    try:
        with open(f"{CACHE}/{kunci}.json", "r") as f:
            d = json.load(f)
            if time.time() - d["ts"] < timeout:
                return d["data"]
    except: pass
    return None

if __name__ == "__main__":
    print("🌐 MICO-JDEQ RUNTIME ENGINE — Scout Siap")
    print(f"   Cache  : {CACHE}")
    print(f"   Node   : Z83 ({NODES['z83']['ip']}), Infinix ({NODES['infinix']['ip']})")
    print("   Status : Menunggu printah...")
