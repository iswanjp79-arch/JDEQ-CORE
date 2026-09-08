import json, os, datetime, urllib.request

BASE = r"D:\MICO_SSOT\TREE_L"
STATUS_FILE = os.path.join(BASE, "08_EVIDENCE", "RUNTIME", "RINGBALK_CORE_20260908_184343.txt")

print("MEZANINE STATUS")
try:
    with open(STATUS_FILE, "r", encoding="utf-8") as f:
        for line in f:
            print(line.rstrip())
except Exception as e:
    print("Belum ada laporan. Jalankan orchestrator_core.ps1 dulu.")
