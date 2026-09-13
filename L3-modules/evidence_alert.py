#!/usr/bin/env python3
# M4 - Evidence & Alert Engine
# Evaluasi ambang batas -> status diskrit. Input rusak -> BLOCKED.
import json
from datetime import datetime
from pathlib import Path

LOG_DIR = Path(r"D:\MICO_SSOT\08_EVIDENCE\alert_engine")
LOG_DIR.mkdir(parents=True, exist_ok=True)
LOG_FILE = LOG_DIR / "alert_engine.log"
STATE_FILE = LOG_DIR / "state.json"

# Thresholds
CPU_DEGRADED = 60
CPU_FAULT = 85
RAM_DEGRADED = 60
RAM_FAULT = 85

def _log(line):
    ts = datetime.now().isoformat(timespec="seconds")
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write("[" + ts + "] " + line + "\n")

def _write_state(state, detail=""):
    with open(STATE_FILE, "w", encoding="utf-8") as f:
        json.dump({"state": state, "detail": detail, "ts": datetime.now().isoformat()}, f)

def evaluate_metrics(metrics):
    # Dead-Path: input rusak -> BLOCKED
    try:
        if not isinstance(metrics, dict):
            raise ValueError("input bukan dict")
        cpu = metrics.get("cpu_percent")
        used = metrics.get("ram_used_mb")
        total = metrics.get("ram_total_mb")
        if cpu is None or used is None or total is None:
            raise ValueError("field wajib tidak lengkap")
        if cpu < 0 or cpu > 100:
            raise ValueError("cpu_percent di luar rentang")
        if total <= 0:
            raise ValueError("ram_total_mb tidak valid")
        if used < 0 or used > total:
            raise ValueError("ram_used_mb tidak masuk akal")
    except Exception as e:
        _log("BLOCKED: " + type(e).__name__ + ": " + str(e))
        _write_state("BLOCKED", str(e))
        return "BLOCKED"

    ram_pct = int(used / total * 100)
    if cpu >= CPU_FAULT or ram_pct >= RAM_FAULT:
        status = "FAULT"
    elif cpu >= CPU_DEGRADED or ram_pct >= RAM_DEGRADED:
        status = "DEGRADED"
    else:
        status = "HEALTHY"

    _log(status + " cpu=" + str(cpu) + "% ram=" + str(ram_pct) + "%")
    _write_state(status, "cpu=" + str(cpu) + " ram_pct=" + str(ram_pct))
    return status
