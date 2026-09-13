#!/usr/bin/env python3
# M2 - Path Safety Controller
# Cek path sebelum dipakai. Error -> BLOCKED sekali -> berhenti.
import json
from datetime import datetime
from pathlib import Path

LOG_DIR = Path(r"D:\MICO_SSOT\08_EVIDENCE\path_safety")
LOG_DIR.mkdir(parents=True, exist_ok=True)
LOG_FILE = LOG_DIR / "path_safety.log"
STATE_FILE = LOG_DIR / "state.json"

def _log(line):
    ts = datetime.now().isoformat(timespec="seconds")
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write("[" + ts + "] " + line + "\n")

def _state(state):
    with open(STATE_FILE, "w", encoding="utf-8") as f:
        json.dump({"state": state, "ts": datetime.now().isoformat()}, f)

def check_path(path, mode="r"):
    p = Path(path)
    if not p.exists():
        _log("BLOCKED PATH: " + str(path) + " (not found)")
        _state("BLOCKED")
        return False
    if mode == "w":
        if p.is_dir():
            test_file = p / ".mico_write_test"
            try:
                test_file.touch()
                test_file.unlink()
            except Exception as e:
                _log("BLOCKED PATH: " + str(path) + " (not writable: " + str(e) + ")")
                _state("BLOCKED")
                return False
        elif not p.parent.exists():
            _log("BLOCKED PATH: " + str(path) + " (parent missing)")
            _state("BLOCKED")
            return False
    _log("VALID PATH: " + str(path) + " (mode=" + mode + ")")
    _state("HEALTHY")
    return True
