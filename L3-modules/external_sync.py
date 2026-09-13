#!/usr/bin/env python3
# M5 - External Sync
# Git commit dari PC-i5 SAJA. TIDAK auto-push.
# Dead-Path: git error -> 1 log -> BLOCKED.
import json
import subprocess
from datetime import datetime
from pathlib import Path

LOG_DIR = Path(r"D:\MICO_SSOT\08_EVIDENCE\external_sync")
LOG_DIR.mkdir(parents=True, exist_ok=True)
LOG_FILE = LOG_DIR / "external_sync.log"
STATE_FILE = LOG_DIR / "state.json"
REPO = Path(r"D:\MICO_SSOT")

def _log(line):
    ts = datetime.now().isoformat(timespec="seconds")
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write("[" + ts + "] " + line + "\n")

def _state(state, detail=""):
    with open(STATE_FILE, "w", encoding="utf-8") as f:
        json.dump({"state": state, "detail": detail, "ts": datetime.now().isoformat()}, f)

def _git(args):
    r = subprocess.run(["git"] + args, cwd=str(REPO),
                       capture_output=True, text=True, timeout=180)
    return r.returncode, r.stdout.strip(), r.stderr.strip()

def check_repo():
    try:
        rc, out, err = _git(["rev-parse", "--is-inside-work-tree"])
        if rc != 0 or out != "true":
            raise RuntimeError("not a git repo: " + err)
        rc2, branch, _ = _git(["rev-parse", "--abbrev-ref", "HEAD"])
        _log("OK repo branch=" + branch)
        _state("HEALTHY", "branch=" + branch)
        return branch
    except Exception as e:
        _log("BLOCKED: " + type(e).__name__ + ": " + str(e))
        _state("BLOCKED", str(e))
        return None

def commit_staged(message, paths=None):
    # Dead-Path: error -> 1 log -> BLOCKED
    try:
        if paths:
            rc, out, err = _git(["add"] + paths)
            if rc != 0:
                raise RuntimeError("git add failed: " + err)
        rc, out, err = _git(["commit", "-m", message])
        if rc != 0:
            # "nothing to commit" bukan error kritis
            if "nothing to commit" in out or "nothing to commit" in err:
                _log("OK nothing-to-commit")
                _state("HEALTHY", "nothing-to-commit")
                return "NOTHING"
            raise RuntimeError("git commit failed: " + err)
        _log("OK committed: " + message)
        _state("HEALTHY", "committed")
        return "COMMITTED"
    except Exception as e:
        _log("BLOCKED: " + type(e).__name__ + ": " + str(e))
        _state("BLOCKED", str(e))
        return "BLOCKED"

def push_remote(branch="master"):
    # TIDAK dipanggil otomatis. Hanya manual oleh L0.
    try:
        rc, out, err = _git(["push", "origin", branch])
        if rc != 0:
            raise RuntimeError("git push failed: " + err)
        _log("OK pushed to origin/" + branch)
        _state("HEALTHY", "pushed")
        return "PUSHED"
    except Exception as e:
        _log("BLOCKED: " + type(e).__name__ + ": " + str(e))
        _state("BLOCKED", str(e))
        return "BLOCKED"
