import json, os, sys, subprocess, shutil, tempfile, hashlib
from datetime import datetime, timezone

HERE = os.path.dirname(os.path.abspath(__file__))
BASE = "D:/MICO_SSOT/08_EVIDENCE/L7-OPERATIONAL"
STATE = BASE + "/runtime_state"
BACKUP = BASE + "/runtime_state_backup_test"
sys.path.insert(0, HERE)
from l7_backup import backup, restore

def _hash_dir(d):
    h = hashlib.sha256()
    for root, dirs, files in os.walk(d):
        dirs.sort()
        for f in sorted(files):
            p = os.path.join(root, f)
            h.update(os.path.relpath(p, d).encode())
            with open(p, "rb") as fh:
                h.update(fh.read())
    return h.hexdigest()

def run_rt(p):
    e = dict(os.environ); e["L7_BACKOFF"] = "fast"
    r = subprocess.run([sys.executable, os.path.join(HERE, "l7_runtime.py"), p],
                       capture_output=True, text=True, env=e)
    return r.returncode

def populate():
    tmp = tempfile.mkdtemp(prefix="rb_")
    seed = int(datetime.now().timestamp())
    for i in range(3):
        c = {"command_id":"rb-%d"%i, "correlation_id":"rb-r1", "issuer":"L0",
             "action":"noop", "issued_at":datetime.now(timezone.utc).isoformat(),
             "nonce":"rb-n-%d"%i, "sequence":seed + i}
        p = os.path.join(tmp, "rb_%d.json"%i)
        json.dump(c, open(p, "w"))
        run_rt(p)

def main():
    R = {}
    for d in (STATE, BACKUP):
        if os.path.exists(d): shutil.rmtree(d, ignore_errors=True)
    os.makedirs(STATE, exist_ok=True)

    populate()
    R["populated"] = os.path.isdir(STATE) and len(os.listdir(STATE)) > 0
    h_before = _hash_dir(STATE)
    R["hash_before"] = h_before[:16]

    ok, info = backup(STATE, BACKUP)
    R["backup_ok"] = ok
    R["backup_info"] = str(info)[:80]

    shutil.rmtree(STATE, ignore_errors=True)
    R["loss_simulated"] = not os.path.exists(STATE)

    ok, info = restore(BACKUP, STATE)
    R["restore_ok"] = ok
    R["restore_info"] = str(info)[:80]

    h_after = _hash_dir(STATE) if os.path.isdir(STATE) else "missing"
    R["hash_after"] = h_after[:16] if isinstance(h_after, str) else "missing"
    R["hash_matches"] = (h_before == h_after)

    r = subprocess.run([sys.executable, os.path.join(HERE, "test_rt_harness.py")],
                       capture_output=True, text=True,
                       env=dict(os.environ, L7_BACKOFF="fast"))
    R["rt_harness_rc"] = r.returncode
    R["rt_harness_pass"] = (r.returncode == 0)

    ok = all([R["populated"], R["backup_ok"], R["loss_simulated"],
              R["restore_ok"], R["hash_matches"], R["rt_harness_pass"]])
    out = {"suite":"L7-ROLLBACK","mode":"TEST_FIXTURE",
           "timestamp_utc":datetime.now(timezone.utc).isoformat(),
           "results":R,"pass":ok,"overall":"PASS" if ok else "FAIL"}
    print(json.dumps(out))
    return 0 if ok else 1

if __name__ == "__main__":
    sys.exit(main())
