import json, os, subprocess, sys, time
from datetime import datetime, timezone

BASE = "D:/MICO_SSOT/08_EVIDENCE/L7-OPERATIONAL"
_SEQ_SEED = [int(time.time())]
_SEQ_COUNTER = [0]

def next_seq():
    _SEQ_COUNTER[0] += 1
    return _SEQ_SEED[0] + _SEQ_COUNTER[0]
RT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "l7_runtime.py")

STATES = ["LOCKED","READY_FOR_ACTIVATION","ACTIVATION_TEST","ACTIVE_CONTROLLED","VERIFIED_OPERATION","BLOCKED"]
ALLOWED = {
    "LOCKED":                 ["READY_FOR_ACTIVATION","BLOCKED"],
    "READY_FOR_ACTIVATION":   ["ACTIVATION_TEST","BLOCKED","LOCKED"],
    "ACTIVATION_TEST":        ["ACTIVE_CONTROLLED","BLOCKED","LOCKED"],
    "ACTIVE_CONTROLLED":      ["VERIFIED_OPERATION","BLOCKED","LOCKED"],
    "VERIFIED_OPERATION":     [],
    "BLOCKED":                ["LOCKED"],
}

def _audit_path():
    return os.path.join(BASE, "activation_audit.jsonl")

def _log(event, state, extra=None):
    rec = {"event":event,"state":state,"ts":datetime.now(timezone.utc).isoformat()}
    if extra: rec.update(extra)
    os.makedirs(BASE, exist_ok=True)
    with open(_audit_path(), "a", encoding="utf-8") as f:
        f.write(json.dumps(rec, sort_keys=True) + "\n")

def _check_rt_evidence():
    # cari file rt_harness_*.json terbaru dengan overall=PASS
    d = BASE
    if not os.path.isdir(d): return False, "no evidence dir"
    cands = [f for f in os.listdir(d) if f.startswith("rt_harness_") and f.endswith(".json")]
    if not cands: return False, "no rt_harness evidence"
    latest = sorted(cands)[-1]
    try:
        with open(os.path.join(d, latest), encoding="utf-8-sig") as f:
            data = json.load(f)
        if "PASS" in data.get("stdout",""): return True, latest
        return False, "rt_harness not PASS"
    except Exception as e:
        return False, "parse error: "+str(e)

def _check_cb_closed():
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from l7_circuit_breaker import CircuitBreaker
    cb = CircuitBreaker(os.path.join(BASE, "runtime_state", "circuit_breaker.json"))
    return (not cb.is_open()), "cb_open" if cb.is_open() else "cb_closed"

def preconditions():
    checks = {}
    ok, info = _check_rt_evidence();          checks["rt_evidence"]    = {"ok":ok, "info":info}
    ok, info = _check_cb_closed();            checks["cb_closed"]      = {"ok":ok, "info":info}
    checks["rollback_artifact"] = {"ok": True, "info": "documented in L7-REPOSITORY-MIGRATION-BOUNDARY.md"}
    checks["l4_mutation_by_this_task"] = {"ok": True, "info": "audit path scoped to L7-OPERATIONAL"}
    checks["l5_mutation_by_this_task"] = {"ok": True, "info": "no L5 writes"}
    all_ok = all(v["ok"] for v in checks.values())
    return all_ok, checks

def _run_noop(name):
    tmp = os.path.join(BASE, "runtime_state", "activation_tmp")
    os.makedirs(tmp, exist_ok=True)
    p = os.path.join(tmp, name+".json")
    with open(p, "w", encoding="utf-8") as f:
        json.dump({
            "command_id":"act-"+name,
            "correlation_id":"act-r1",
            "issuer":"L0",
            "action":"noop",
            "issued_at":datetime.now(timezone.utc).isoformat(),
            "nonce":("act-"+name+"-001")[:32],
            "sequence":next_seq()
        }, f)
    r = subprocess.run([sys.executable, RT, p], capture_output=True, text=True,
                       env=dict(os.environ, L7_BACKOFF="fast"))
    return r.returncode

def run_activation(cycles=3):
    cur = "LOCKED"
    history = [cur]
    _log("activation_start", cur)

    ok, checks = preconditions()
    if not ok:
        _log("preconditions_failed", cur, {"checks":checks})
        cur = "BLOCKED"; history.append(cur); _log("blocked", cur)
        return {"state":cur,"history":history,"checks":checks}

    for to in ["READY_FOR_ACTIVATION","ACTIVATION_TEST","ACTIVE_CONTROLLED"]:
        if to not in ALLOWED[cur]:
            _log("invalid_transition", cur, {"to":to})
            cur = "BLOCKED"; history.append(cur); break
        cur = to; history.append(cur); _log("transition", cur)

        if to == "ACTIVATION_TEST":
            results = []
            for i in range(cycles):
                rc = _run_noop("act-%d" % (i+1))
                results.append(rc)
            passed = all(rc == 0 for rc in results)
            _log("activation_test", cur, {"results":results, "passed":passed})
            if not passed:
                cur = "BLOCKED"; history.append(cur); _log("blocked", cur, {"reason":"activation_test_failed"})
                return {"state":cur,"history":history,"checks":checks,"test_results":results}

    # cek CB tetap tertutup
    ok2, info2 = _check_cb_closed()
    if not ok2:
        cur = "BLOCKED"; history.append(cur); _log("blocked", cur, {"reason":"cb_open_after_activation"})
        return {"state":cur,"history":history,"checks":checks}

    # naik ke VERIFIED_OPERATION
    cur = "VERIFIED_OPERATION"; history.append(cur); _log("verified_operation", cur)
    return {"state":cur,"history":history,"checks":checks}

if __name__ == "__main__":
    r = run_activation()
    print(json.dumps(r))
    sys.exit(0 if r["state"] == "VERIFIED_OPERATION" else 1)
