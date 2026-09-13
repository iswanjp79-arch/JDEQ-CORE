#!/usr/bin/env python3
# M3 - PC5 Collector
# Pull-only telemetry. Dead-Path Circuit Breaker enforced.
import json
from datetime import datetime
from pathlib import Path

LOG_DIR = Path(r"D:\MICO_SSOT\08_EVIDENCE\pc5_collector")
LOG_DIR.mkdir(parents=True, exist_ok=True)
LOG_FILE = LOG_DIR / "pc5_collector.log"
STATE_FILE = LOG_DIR / "state.json"

def _log(line):
    ts = datetime.now().isoformat(timespec="seconds")
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write("[" + ts + "] " + line + "\n")

def _state(state):
    with open(STATE_FILE, "w", encoding="utf-8") as f:
        json.dump({"state": state, "ts": datetime.now().isoformat()}, f)

def pull_data(source_func):
    # Dead-Path Circuit Breaker: error -> 1 log -> BLOCKED -> return None
    try:
        record = source_func()
        if record is None:
            raise ValueError("source returned None")
        out = LOG_DIR / ("pull_" + datetime.now().strftime("%Y%m%d_%H%M%S") + ".json")
        with open(out, "w", encoding="utf-8") as f:
            json.dump(record, f, indent=2, ensure_ascii=False)
        _log("OK pulled -> " + out.name)
        _state("HEALTHY")
        return record
    except Exception as e:
        _log("BLOCKED: " + type(e).__name__ + ": " + str(e))
        _state("BLOCKED")
        return None
