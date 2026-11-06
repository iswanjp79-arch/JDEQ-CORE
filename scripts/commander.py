#!/usr/bin/env python3
# MICO-JDEQ COMMANDER — Kendali Scout ke Semua Node

import sys, subprocess

NODES = {
    "z83":     {"ip": "100.125.176.126", "user": "iswan"},
    "infinix": {"ip": "100.103.39.81",   "user": "iswan", "port": 8022},
}

def run_ssh(node, cmd):
    n = NODES[node]
    port = n.get("port", 22)
    ssh_cmd = ["ssh", "-o", "ConnectTimeout=5", "-p", str(port), f"{n['user']}@{n['ip']}", cmd]
    r = subprocess.run(ssh_cmd, capture_output=True, text=True)
    return r.stdout.strip() if r.returncode == 0 else f"❌ {r.stderr.strip()[:50]}"

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("MICO COMMANDER — Pusat Kendali Scout")
        print("  cek             → Status semua node")
        print("  z83  <perintah> → Kirim perintah ke Z83")
        print("  inf  <perintah> → Kirim perintah ke Infinix")
    elif sys.argv[1] == "cek":
        for n in NODES:
            print(f"  {n.upper():8} → {run_ssh(n, 'echo ONLINE && hostname')}")
    elif sys.argv[1] in NODES and len(sys.argv) > 2:
        print(run_ssh(sys.argv[1], " ".join(sys.argv[2:])))
