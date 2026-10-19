import socket
import subprocess
import time
from datetime import datetime

# Daftar node lokal (Tailscale IP)
NODES = {
    "PC-i5": "100.124.50.70",
    "Z83": "100.67.36.31",
    "HP-Mini": "100.92.105.35",
    "Vivo": "100.127.153.2",
    "Infinix": "100.79.91.60"
}

def check_node_status(ip, port=22):
    """Cek status node via TCP Ping (Port SSH default 22)"""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(2)
        result = sock.connect_ex((ip, port))
        sock.close()
        return "ONLINE" if result == 0 else "OFFLINE"
    except:
        return "OFFLINE"

def main():
    print(f"\n[{datetime.now().strftime('%H:%M:%S')}] MEGA ZORD ORCHESTRATOR AKTIF")
    print("="*50)
    print("Memindai 5 Node Lokal via Tailscale...")
    print("-"*50)
    
    for name, ip in NODES.items():
        status = check_node_status(ip)
        color = "\033[92m" if status == "ONLINE" else "\033[91m" # Green / Red
        print(f"  [{color}{status}\033[0m] {name.ljust(10)} ({ip})")
        
    print("="*50)
    print("Sinkronisasi SSOT: Menunggu perintah L0.")

if __name__ == "__main__":
    main()
