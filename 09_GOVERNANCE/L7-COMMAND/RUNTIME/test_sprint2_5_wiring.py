import json, os, sys, tempfile, subprocess, shutil
from datetime import datetime, timezone

HERE = os.path.dirname(os.path.abspath(__file__))
RT = os.path.join(HERE, "l7_runtime.py")
STATE = "D:/MICO_SSOT/08_EVIDENCE/L7-OPERATIONAL/runtime_state"

def reset_state():
    if os.path.exists(STATE):
        shutil.rmtree(STATE, ignore_errors=True)
    os.makedirs(STATE, exist_ok=True)

def run(p):
    e = dict(os.environ)
    e["L7_BACKOFF"] = "fast"
    r = subprocess.run([sys.executable, RT, p], capture_output=True, text=True, env=e)
    return r.returncode

def make(path, obj):
    with open(path, "w", encoding="utf-8") as f:
        json.dump(obj, f)

def base_cmd(seq=1, **over):
    c = {"command_id":"c1","correlation_id":"r1","issuer":"L0",
         "action":"noop","issued_at":datetime.now(timezone.utc).isoformat(),
         "nonce":"n0001","sequence":seq}
    c.update(over)
    return c

def main():
    results = {}
    tmp = tempfile.mkdtemp(prefix="l7s25_")

    # W1: noop -> 0
    reset_state()
    p = os.path.join(tmp,"w1.json"); make(p, base_cmd())
    results["W1_noop_ok"] = run(p)

    # W2: fail_once -> 0 (recovered)
    reset_state()
    p = os.path.join(tmp,"w2.json"); make(p, base_cmd(action="fail_once", nonce="w2001"))
    results["W2_fail_once_recovered"] = run(p)

    # W3: fail_always -> 9 (escalated)
    reset_state()
    p = os.path.join(tmp,"w3.json"); make(p, base_cmd(action="fail_always", nonce="w3001"))
    results["W3_fail_always_escalated"] = run(p)

    # W4: CB opens after 3 failures
    reset_state()
    w4 = []
    for i in range(1, 5):
        p = os.path.join(tmp, "w4_%d.json" % i)
        make(p, base_cmd(action="fail_always", nonce="w4%03d" % i,
                         command_id="w4c%d" % i, sequence=i))
        w4.append(run(p))
    results["W4_seq"] = w4
    results["W4_first_three_escalated"] = (w4[:3] == [9,9,9])
    results["W4_fourth_blocked"] = (w4[3] == 8)

    expect = {"W1_noop_ok":0, "W2_fail_once_recovered":0, "W3_fail_always_escalated":9}
    ok_simple = all(results.get(k) == v for k, v in expect.items())
    ok_w4 = results["W4_first_three_escalated"] and results["W4_fourth_blocked"]
    ok = ok_simple and ok_w4

    print(json.dumps({"results":results, "pass":ok}))
    return 0 if ok else 1

if __name__ == "__main__":
    sys.exit(main())
