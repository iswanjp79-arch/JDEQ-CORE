#!/usr/bin/env python3
"""MICO-SSOT L2 Network Sentinel (verified build)."""
import subprocess, socket, platform, sys
from datetime import datetime

NODES = [
    ("PC-i5",        "127.0.0.1",        None),
    ("Z83",          "100.67.36.31",     22),
    ("Aspire",       "100.123.139.63",   22),
    ("HP_Mini",      "100.92.105.35",    22),
    ("Vivo",         "100.127.153.2",    8022),
    ("Infinix",      "100.79.91.60",     None),
]

def ping(h):
    p = "-n" if platform.system().lower()=="windows" else "-c"
    try:
        return 1 if subprocess.run(["ping",p,"1","-w","1000",h],
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL).returncode==0 else 0
    except Exception:
        return 0

def tcp(h, port):
    if port is None: return "-"
    s = socket.socket(); s.settimeout(1.5)
    try:
        s.connect((h, port)); s.close(); return 1
    except Exception:
        return 0

ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
print(f"=== L2 SENTINEL | {ts} ===")
for name, ip, port in NODES:
    print(f"{name:<10} {ip:<18} ICMP={ping(ip)}  TCP:{port or '-'}={tcp(ip,port)}")
