#!/usr/bin/env python3
"""
cloud_agent.py - Worker cloud MICO-JDEQ
Cara kerja:
  1. Loop tiap 30 detik
  2. Pull repo (git pull)
  3. Baca memory/tasks.jsonl, cari state=QUEUED capability=cloud_compute
  4. Eksekusi (worker HTTP ke llama.cpp via Tailscale ATAU shell terbatas)
  5. Update state ke EXECUTED_UNVERIFIED + tulis evidence
  6. Commit + push
"""
import json, os, subprocess, time, hashlib, sys
from pathlib import Path
from datetime import datetime, timezone

REPO = Path("/workspaces/JDEQ-CORE")
TASKS = REPO / "memory" / "tasks.jsonl"
EVID  = REPO / "08_EVIDENCE"
ALERT = EVID / "alerts"
LOG   = Path("/tmp/cloud_agent.log")
INTERVAL = 30

def log(msg):
    ts = datetime.now(timezone.utc).isoformat()
    with LOG.open("a") as f:
        f.write(f"[{ts}] {msg}\n")
    print(f"[{ts}] {msg}", flush=True)

def sh(cmd, cwd=None):
    r = subprocess.run(cmd, shell=True, cwd=cwd, capture_output=True, text=True)
    return r.returncode, r.stdout, r.stderr

def load_tasks():
    if not TASKS.exists(): return []
    out = []
    for line in TASKS.read_text(encoding="utf-8").splitlines():
        if not line.strip(): continue
        try: out.append(json.loads(line))
        except Exception: pass
    return out

def save_tasks(tasks):
    TASKS.write_text("\n".join(json.dumps(t, ensure_ascii=False) for t in tasks) + "\n",
                     encoding="utf-8")

def run_task(task):
    """Cloud hanya boleh eksekusi capability yang aman & non-destruktif."""
    caps = set(task.get("capability_required", []))
    if "cloud_compute" not in caps:
        return None, "not cloud capability"
    goal = task.get("goal", "")
    # Placeholder: eksekusi sederhana — catat goal sebagai evidence
    # Nanti diganti dengan worker nyata (HTTP ke API, python komputasi, dll)
    ts = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S")
    ev_path = EVID / f"cloud_result_{task['task_id']}_{ts}.json"
    EVID.mkdir(parents=True, exist_ok=True)
    payload = {
        "task_id": task["task_id"],
        "worker": "cloud_agent_v1",
        "executed_at": datetime.now(timezone.utc).isoformat(),
        "goal": goal,
        "status": "PLACEHOLDER",
        "note": "Cloud worker terpasang. Ganti run_task() dengan logika nyata."
    }
    ev_path.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    h = hashlib.sha256(ev_path.read_bytes()).hexdigest()
    return str(ev_path), h

def loop():
    log("cloud_agent start")
    while True:
        try:
            sh("git pull --rebase --autostash", cwd=REPO)
            tasks = load_tasks()
            processed = 0
            for t in tasks:
                if t.get("state") != "QUEUED": continue
                if "cloud_compute" not in t.get("capability_required", []): continue
                log(f"picked {t['task_id']}")
                ev, info = run_task(t)
                if ev:
                    t["state"] = "EXECUTED_UNVERIFIED"
                    t["evidence_ref"] = str(ev)
                    t["evidence_hash"] = info
                    processed += 1
                    log(f"done {t['task_id']} -> {ev}")
                else:
                    log(f"skip {t['task_id']}: {info}")
            if processed:
                save_tasks(tasks)
                sh("git add -A", cwd=REPO)
                sh(f'git -c user.email=cloud@mico -c user.name=cloud commit -m "cloud: process {processed} task(s)"', cwd=REPO)
                sh("git push", cwd=REPO)
                log(f"pushed {processed} task(s)")
        except Exception as e:
            log(f"ERROR: {e}")
        time.sleep(INTERVAL)

if __name__ == "__main__":
    loop()
