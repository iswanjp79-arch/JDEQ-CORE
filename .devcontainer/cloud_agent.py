#!/usr/bin/env python3
"""cloud_agent.py - Worker cloud MICO-JDEQ (v2)
Eksekusi kode dari field 'code' task.
"""
import json, os, subprocess, time, hashlib, sys
from pathlib import Path
from datetime import datetime, timezone

REPO = Path("/workspaces/JDEQ-CORE")
TASKS = REPO / "memory" / "tasks.jsonl"
EVID  = REPO / "08_EVIDENCE"
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
    caps = set(task.get("capability_required", []))
    if "cloud_compute" not in caps:
        return None, "not cloud capability"

    code = task.get("code", "").strip()
    if not code:
        code = f'print("goal: {task.get("goal","")}")'

    ts = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S")
    ev_path = EVID / f"cloud_result_{task['task_id']}_{ts}.json"
    EVID.mkdir(parents=True, exist_ok=True)

    t0 = datetime.now(timezone.utc)
    try:
        r = subprocess.run([sys.executable, "-c", code],
                           capture_output=True, text=True, timeout=60)
        rc, out, err = r.returncode, r.stdout, r.stderr
        status = "OK" if rc == 0 else "FAIL"
    except subprocess.TimeoutExpired:
        rc, out, err, status = -1, "", "TIMEOUT", "TIMEOUT"
    except Exception as e:
        rc, out, err, status = -1, "", str(e), "ERROR"
    t1 = datetime.now(timezone.utc)

    payload = {
        "task_id": task["task_id"],
        "worker": "cloud_agent_v1",
        "executed_at": t1.isoformat(),
        "goal": task.get("goal", ""),
        "code": code,
        "return_code": rc,
        "stdout": out,
        "stderr": err,
        "elapsed_ms": (t1-t0).total_seconds() * 1000,
        "status": status,
    }
    ev_path.write_text(json.dumps(payload, indent=2, ensure_ascii=False), encoding="utf-8")
    h = hashlib.sha256(ev_path.read_bytes()).hexdigest()
    return str(ev_path), h

def loop():
    log("cloud_agent v2 start")
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
