import json, os, sys, tempfile, subprocess, shutil, time
from datetime import datetime, timezone

HERE = os.path.dirname(os.path.abspath(__file__))
RT   = os.path.join(HERE, "l7_runtime.py")
BASE = "D:/MICO_SSOT/08_EVIDENCE/L7-OPERATIONAL"
STATE= BASE + "/runtime_state"
AUDIT= BASE + "/runtime_audit.jsonl"

def reset():
    if os.path.exists(STATE): shutil.rmtree(STATE, ignore_errors=True)
    os.makedirs(STATE, exist_ok=True)
    if os.path.exists(AUDIT):
        try: os.remove(AUDIT)
        except: pass

_seq = [int(time.time())]
def nseq():
    _seq[0] += 1
    return _seq[0]

def cmd(action="noop", issuer="L0", seq=None, nonce=None, cid=None):
    s = seq if seq is not None else nseq()
    return {"command_id": cid or ("e2e-"+str(s)), "correlation_id":"e2e-r1",
            "issuer":issuer,"action":action,
            "issued_at":datetime.now(timezone.utc).isoformat(),
            "nonce": nonce or ("n-"+str(s)), "sequence": s}

def run(path, timeout=30):
    e = dict(os.environ); e["L7_BACKOFF"]="fast"
    r = subprocess.run([sys.executable, RT, path], capture_output=True, text=True,
                       timeout=timeout, env=e)
    return r.returncode

def main():
    reset()
    tmp = tempfile.mkdtemp(prefix="e2e_")
    R = {}

    # E2E-1: full chain success
    p = os.path.join(tmp,"e2e1.json"); json.dump(cmd("noop"), open(p,"w"))
    R["E2E_1_success"] = run(p)

    # E2E-2: unauthorized (bukan dari L0)
    p = os.path.join(tmp,"e2e2.json"); json.dump(cmd("noop", issuer="UNKNOWN"), open(p,"w"))
    R["E2E_2_unauthorized"] = run(p)

    # E2E-3: duplicate command_id
    p = os.path.join(tmp,"e2e3a.json"); json.dump(cmd("noop", cid="e2e3", nonce="n-e2e3a"), open(p,"w"))
    run(p)
    p = os.path.join(tmp,"e2e3b.json"); json.dump(cmd("noop", cid="e2e3", nonce="n-e2e3b"), open(p,"w"))
    R["E2E_3_duplicate"] = run(p)

    # E2E-4: replay nonce
    p = os.path.join(tmp,"e2e4a.json"); json.dump(cmd("noop", cid="e2e4a", nonce="n-e2e4"), open(p,"w"))
    run(p)
    p = os.path.join(tmp,"e2e4b.json"); json.dump(cmd("noop", cid="e2e4b", nonce="n-e2e4"), open(p,"w"))
    R["E2E_4_replay"] = run(p)

    # E2E-5: stale
    old = (datetime.now(timezone.utc).replace(year=2020)).isoformat()
    c = cmd("noop", cid="e2e5", nonce="n-e2e5")
    c["issued_at"] = old
    p = os.path.join(tmp,"e2e5.json"); json.dump(c, open(p,"w"))
    R["E2E_5_stale"] = run(p)

    # E2E-6: recovery path (fail_once)
    p = os.path.join(tmp,"e2e6.json"); json.dump(cmd("fail_once", cid="e2e6", nonce="n-e2e6"), open(p,"w"))
    R["E2E_6_recovered"] = run(p)

    # E2E-7: escalation + CB
    for i in range(3):
        p = os.path.join(tmp, "e2e7_%d.json"%i)
        json.dump(cmd("fail_always", cid="e2e7_%d"%i, nonce="n-e2e7_%d"%i), open(p,"w"))
        run(p)
    p = os.path.join(tmp,"e2e7b.json"); json.dump(cmd("noop", cid="e2e7b", nonce="n-e2e7b"), open(p,"w"))
    R["E2E_7_cb_blocked"] = run(p)

    # E2E-8: audit chain integrity
    lines = 0
    if os.path.exists(AUDIT):
        with open(AUDIT) as f: lines = len(f.readlines())
    R["E2E_8_audit_lines"] = lines
    R["E2E_8_audit_ok"]   = lines > 0

    expect = {
        "E2E_1_success":0, "E2E_2_unauthorized":10, "E2E_3_duplicate":5,
        "E2E_4_replay":4,  "E2E_5_stale":6, "E2E_6_recovered":0,
        "E2E_7_cb_blocked":8, "E2E_8_audit_ok":True,
    }
    ok = all(R.get(k) == v for k,v in expect.items())
    out = {"suite":"L7-E2E","mode":"TEST_FIXTURE",
           "timestamp_utc":datetime.now(timezone.utc).isoformat(),
           "host":os.environ.get("COMPUTERNAME","?"),
           "agent":"AG-003/DeepSeek","actor":"L0:Iswan",
           "results":R,"expected":expect,"pass":ok,
           "overall":"PASS" if ok else "FAIL"}
    print(json.dumps(out))
    return 0 if ok else 1

if __name__ == "__main__":
    sys.exit(main())
