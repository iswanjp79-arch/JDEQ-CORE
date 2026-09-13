#!/usr/bin/env python3
# M1 - Local Observer
# Snapshot CPU/RAM/disk/net. Read-only. Tanpa dependensi eksternal.
import json
import os
import shutil
from datetime import datetime
from pathlib import Path

LOG_DIR = Path(r"D:\MICO_SSOT\08_EVIDENCE\observer")
LOG_DIR.mkdir(parents=True, exist_ok=True)
LOG_FILE = LOG_DIR / "observer.log"
SNAP_DIR = LOG_DIR / "snapshots"
SNAP_DIR.mkdir(parents=True, exist_ok=True)

def _log(line):
    ts = datetime.now().isoformat(timespec="seconds")
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write("[" + ts + "] " + line + "\n")

def _try_psutil():
    try:
        import psutil
        return psutil
    except Exception:
        return None

def snapshot():
    try:
        ps = _try_psutil()
        cpu = None
        ram_used = None
        ram_total = None
        if ps is not None:
            cpu = ps.cpu_percent(interval=0.5)
            vm = ps.virtual_memory()
            ram_used = int(vm.used / (1024 * 1024))
            ram_total = int(vm.total / (1024 * 1024))

        disk = shutil.disk_usage("D:\\")
        record = {
            "ts": datetime.now().isoformat(),
            "host": os.environ.get("COMPUTERNAME", "unknown"),
            "cpu_percent": cpu,
            "ram_used_mb": ram_used,
            "ram_total_mb": ram_total,
            "disk_used_mb": int(disk.used / (1024 * 1024)),
            "disk_total_mb": int(disk.total / (1024 * 1024)),
            "note": "psutil_tersedia" if ps else "psutil_tidak_ada",
        }
        out = SNAP_DIR / ("snap_" + datetime.now().strftime("%Y%m%d_%H%M%S") + ".json")
        with open(out, "w", encoding="utf-8") as f:
            json.dump(record, f, indent=2, ensure_ascii=False)
        _log("OK snapshot -> " + out.name)
        return record
    except Exception as e:
        _log("BLOCKED: " + type(e).__name__ + ": " + str(e))
        return None
