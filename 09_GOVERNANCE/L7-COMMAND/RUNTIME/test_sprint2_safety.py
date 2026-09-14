import json, os, sys, tempfile, subprocess, shutil
from datetime import datetime, timezone, timedelta

HERE = os.path.dirname(os.path.abspath(__file__))
RT = os.path.join(HERE, "l7_runtime.py")
STATE = "D:/MICO_SSOT/08_EVIDENCE/L7-OPERATIONAL/runtime_state"

def reset_state():
    if os.path.exists(STATE):
        shutil.rmtree(STATE, ignore_errors=True)
    os.makedirs(STATE, exist_ok=True)

def run(p):
    r = subprocess.run([sys.executable, RT, p], capture_output=True, text=True)
    return r.returncode

def make(path, obj):
    with open(path, "w", encoding="utf-8") as f:
        json.dump(obj, f)

def base_cmd(**over):
    c = {"command_id":"c1","correlation_id":"r1","issuer":"L0",
         "action":"noop","issued_at":datetime.now(timezone.utc).isoformat(),
         "nonce":"n0001","sequence":1}
    c.update(over)
    return c

def main():
    reset_state()
    tmp = tempfile.mkdtemp(prefix="l7s2_")
    results = {}

    # S1 valid -> 0
    p = os.path.join(tmp,"s1.json"); make(p, base_cmd())
    results["S1_valid"] = run(p)

    # S2 nonce reuse -> 4
    p = os.path.join(tmp,"s2.json"); make(p, base_cmd(command_id="c2", sequence=2))
    results["S2_nonce_reuse"] = run(p)

    # S3 duplicate -> 5
    reset_state()
    p = os.path.join(tmp,"s3a.json"); make(p, base_cmd(command_id="c3", nonce="naaa", sequence=1))
    results["S3_first"] = run(p)
    p = os.path.join(tmp,"s3b.json"); make(p, base_cmd(command_id="c3", nonce="nbbb", sequence=1))
    results["S3_duplicate"] = run(p)

    # S4 stale -> 6
    reset_state()
    old = (datetime.now(timezone.utc) - timedelta(hours=1)).isoformat()
    p = os.path.join(tmp,"s4.json"); make(p, base_cmd(command_id="c4", nonce="n4444", sequence=1, issued_at=old))
    results["S4_stale"] = run(p)

    # S5 sequence rollback -> 7
    reset_state()
    p = os.path.join(tmp,"s5a.json"); make(p, base_cmd(command_id="c5a", nonce="n555a", sequence=10))
    results["S5_first_seq10"] = run(p)
    p = os.path.join(tmp,"s5b.json"); make(p, base_cmd(command_id="c5b", nonce="n555b", sequence=5))
    results["S5_rollback"] = run(p)

    expect = {"S1_valid":0,"S2_nonce_reuse":4,"S3_first":0,"S3_duplicate":5,
              "S4_stale":6,"S5_first_seq10":0,"S5_rollback":7}
    ok = all(results.get(k) == v for k, v in expect.items())
    print(json.dumps({"results":results,"expected":expect,"pass":ok}))
    return 0 if ok else 1

if __name__ == "__main__":
    sys.exit(main())
