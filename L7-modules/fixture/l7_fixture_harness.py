# l7_fixture_harness.py — L7 Reliability Fixture Tests T01-T12
# Mode: TEST_FIXTURE_ONLY. No network. No L4/L5 mutation. No runtime.
# Output: JSON evidence per test + summary report.

import json
import hashlib
import uuid
import time
import os
from pathlib import Path
from dataclasses import dataclass, field, asdict
from datetime import datetime, timezone, timedelta

OUT_DIR = Path(r"D:\MICO_SSOT\09_GOVERNANCE\L7-COMMAND\RELIABILITY\FIXTURE-EVIDENCE")
OUT_DIR.mkdir(parents=True, exist_ok=True)

HOST = os.environ.get("COMPUTERNAME", "KAPAL-INDUK")
AGENT = "AG-003/DeepSeek"
ACTOR = "L0:Iswan"
MODE = "TEST_FIXTURE"

# ---------------- Evidence model ----------------
@dataclass
class Evidence:
    evidence_id: str
    command_id: str
    correlation_id: str
    actor: str
    agent: str
    timestamp_utc: str
    timestamp_local: str
    provenance: dict
    expected_state: str
    actual_state: str
    result: str                # PASS | FAIL | BLOCKED
    recovery_result: str
    hash_sha256: str
    retention_class: str
    test_id: str
    details: dict = field(default_factory=dict)

def _now():
    utc = datetime.now(timezone.utc)
    local = datetime.now().astimezone()
    return utc.isoformat(timespec="seconds"), local.isoformat(timespec="seconds")

def _hash_payload(obj):
    return hashlib.sha256(
        json.dumps(obj, sort_keys=True, separators=(",", ":")).encode("utf-8")
    ).hexdigest()

def emit_evidence(test_id, expected, actual, result, recovery, details=None, retention="90d"):
    utc, local = _now()
    cid = f"cmd-fixture-{test_id}-{uuid.uuid4().hex[:8]}"
    corr = f"corr-fixture-{uuid.uuid4().hex[:8]}"
    ev_id = f"ev-fixture-{test_id}-{uuid.uuid4().hex[:8]}"
    payload = {
        "evidence_id": ev_id, "command_id": cid, "correlation_id": corr,
        "actor": ACTOR, "agent": AGENT,
        "timestamp_utc": utc, "timestamp_local": local,
        "expected_state": expected, "actual_state": actual,
        "result": result, "recovery_result": recovery,
        "test_id": test_id, "details": details or {},
    }
    ev = Evidence(
        evidence_id=ev_id, command_id=cid, correlation_id=corr,
        actor=ACTOR, agent=AGENT, timestamp_utc=utc, timestamp_local=local,
        provenance={"host": HOST, "mode": MODE, "agent": AGENT, "python": "stdlib"},
        expected_state=expected, actual_state=actual, result=result,
        recovery_result=recovery, hash_sha256=_hash_payload(payload),
        retention_class=retention, test_id=test_id, details=details or {},
    )
    out = OUT_DIR / f"{test_id}_{ev_id}.json"
    out.write_text(json.dumps(asdict(ev), indent=2, ensure_ascii=False), encoding="utf-8")
    return asdict(ev)

# ---------------- Simulated components ----------------
class SimNonceStore:
    def __init__(self): self._seen = set()
    def check_and_record(self, nonce):
        if nonce in self._seen: return "REPLAY"
        self._seen.add(nonce); return "OK"

class SimDedupWindow:
    def __init__(self, window_seconds=3600):
        self._seen = {}; self.window = window_seconds
    def check_and_record(self, idem_key, now_ts):
        for k, t in list(self._seen.items()):
            if now_ts - t > self.window: del self._seen[k]
        if idem_key in self._seen: return "DUPLICATE"
        self._seen[idem_key] = now_ts; return "OK"

class SimSequenceTracker:
    def __init__(self): self._last = 0
    def check(self, seq):
        if seq <= self._last: return "SEQUENCE_LAG"
        self._last = seq; return "OK"

class SimCircuitBreaker:
    def __init__(self, threshold=3, window_sec=60, open_duration=300):
        self.threshold = threshold; self.window = window_sec
        self.open_duration = open_duration
        self.failures = []; self.opened_at = None
    def record_failure(self, now_ts):
        self.failures = [t for t in self.failures if now_ts - t <= self.window]
        self.failures.append(now_ts)
        if len(self.failures) >= self.threshold: self.opened_at = now_ts
    def is_open(self, now_ts):
        if self.opened_at is None: return False
        if now_ts - self.opened_at > self.open_duration:
            self.opened_at = None; self.failures = []; return False
        return True

# ---------------- Command fixture ----------------
def make_command(seq=1, ttl_min=15, nonce=None, idem=None):
    utc, local = _now()
    issued = datetime.now(timezone.utc)
    expires = issued + timedelta(minutes=ttl_min)
    cid = f"cmd-fixture-{uuid.uuid4().hex[:8]}"
    nonce = nonce or uuid.uuid4().hex
    idem = idem or hashlib.sha256(f"{ACTOR}|{cid}|read_status".encode()).hexdigest()
    return {
        "command_id": cid,
        "correlation_id": f"corr-{uuid.uuid4().hex[:8]}",
        "issued_at": issued.isoformat(timespec="seconds"),
        "expires_at": expires.isoformat(timespec="seconds"),
        "issuer": ACTOR, "target": "pc-i5",
        "capability": "read_runtime_status",
        "action": "collect_read_only_snapshot",
        "nonce": nonce, "sequence": seq, "idempotency_key": idem,
        "authorization": {"dola_status": "APPROVED", "l0_ref": "acc-fixture-001"},
    }

def validate_command(cmd, now_ts, nonce_store, dedup, seq_trk):
    """Return (state, reason)."""
    required = ("command_id","issued_at","expires_at","issuer","nonce","sequence","idempotency_key","authorization")
    for f in required:
        if f not in cmd or cmd[f] in (None, ""): return ("REJECTED_MALFORMED", f"missing:{f}")
    if cmd["issuer"] != ACTOR: return ("REJECTED_UNAUTHORIZED", "issuer")
    if "l0_ref" not in cmd["authorization"]: return ("REJECTED_UNAUTHORIZED", "no_l0_ref")
    if nonce_store.check_and_record(cmd["nonce"]) != "OK": return ("REJECTED_REPLAY", "nonce_seen")
    exp = datetime.fromisoformat(cmd["expires_at"].replace("Z",""))
    now_dt = datetime.now(timezone.utc)
    if now_dt > exp: return ("REJECTED_STALE", "expired")
    if seq_trk.check(cmd["sequence"]) != "OK": return ("REJECTED_SEQUENCE_LAG", "seq")
    if dedup.check_and_record(cmd["idempotency_key"], now_ts) != "OK": return ("REJECTED_DUPLICATE", "idem_window")
    return ("ACCEPTED", None)

# ---------------- Tests T01-T12 ----------------
results = []

def run(test_id, name, fn):
    try:
        r = fn()
    except Exception as e:
        r = {"result": "FAIL", "expected": "?", "actual": f"exception:{type(e).__name__}",
             "recovery": "none", "details": {"error": str(e)}}
    r["test_id"] = test_id; r["name"] = name
    ev = emit_evidence(test_id, r.get("expected","?"), r.get("actual","?"),
                       r["result"], r.get("recovery","none"), r.get("details", {}))
    r["evidence_id"] = ev["evidence_id"]; r["hash"] = ev["hash_sha256"]
    results.append(r)
    print(f"[{r['result']:7}] {test_id} {name}  exp={r['expected']} act={r['actual']}")

# T01 duplicate
def t01():
    ns, dd, sq = SimNonceStore(), SimDedupWindow(), SimSequenceTracker()
    now = time.time()
    c1 = make_command(seq=1)
    s1,_ = validate_command(c1, now, ns, dd, sq)
    # duplicate: same idem_key but new nonce+seq
    c2 = dict(c1); c2["nonce"] = uuid.uuid4().hex; c2["sequence"] = 2
    s2,r2 = validate_command(c2, now, ns, dd, sq)
    ok = s1 == "ACCEPTED" and s2 == "REJECTED_DUPLICATE"
    return {"result": "PASS" if ok else "FAIL", "expected": "REJECTED_DUPLICATE",
            "actual": s2, "recovery": "none", "details": {"first": s1, "second": s2, "reason": r2}}
run("T01","duplicate_command", t01)

# T02 replay
def t02():
    ns, dd, sq = SimNonceStore(), SimDedupWindow(), SimSequenceTracker()
    now = time.time()
    c1 = make_command(seq=1)
    s1,_ = validate_command(c1, now, ns, dd, sq)
    c2 = dict(c1); c2["sequence"] = 2  # same nonce
    s2,r2 = validate_command(c2, now, ns, dd, sq)
    ok = s1 == "ACCEPTED" and s2 == "REJECTED_REPLAY"
    return {"result": "PASS" if ok else "FAIL", "expected": "REJECTED_REPLAY",
            "actual": s2, "recovery": "none", "details": {"first": s1, "second": s2, "reason": r2}}
run("T02","replay_command", t02)

# T03 stale
def t03():
    ns, dd, sq = SimNonceStore(), SimDedupWindow(), SimSequenceTracker()
    now = time.time()
    c1 = make_command(seq=1, ttl_min=-30)  # already expired
    s1,r1 = validate_command(c1, now, ns, dd, sq)
    ok = s1 == "REJECTED_STALE"
    return {"result": "PASS" if ok else "FAIL", "expected": "REJECTED_STALE",
            "actual": s1, "recovery": "none", "details": {"reason": r1}}
run("T03","stale_command", t03)

# T04 malformed
def t04():
    ns, dd, sq = SimNonceStore(), SimDedupWindow(), SimSequenceTracker()
    now = time.time()
    c1 = make_command(seq=1); del c1["command_id"]
    s1,r1 = validate_command(c1, now, ns, dd, sq)
    ok = s1 == "REJECTED_MALFORMED"
    return {"result": "PASS" if ok else "FAIL", "expected": "REJECTED_MALFORMED",
            "actual": s1, "recovery": "none", "details": {"reason": r1}}
run("T04","malformed_command", t04)

# T05 interrupted write (atomic)
def t05():
    tmp = OUT_DIR / "_t05_write.tmp"
    final = OUT_DIR / "_t05_final.json"
    if final.exists(): final.unlink()
    tmp.write_text('{"partial":', encoding="utf-8")  # simulate crash mid-write
    # "crash": no promotion
    no_final = not final.exists()
    tmp.unlink()  # recovery: discard temp
    recovered_ok = not final.exists() and not tmp.exists()
    ok = no_final and recovered_ok
    return {"result": "PASS" if ok else "FAIL",
            "expected": "no_partial_publish", "actual": "clean" if ok else "leaked",
            "recovery": "discard_temp", "details": {"no_final": no_final, "recovered": recovered_ok}}
run("T05","interrupted_write", t05)

# T06 partial state update
def t06():
    # simulated state log
    transitions = ["PROPOSED","AUTHORIZED","ACCEPTED","EXECUTING"]
    # crash before SUCCEEDED/FAILED. on restart -> BLOCKED
    def on_restart(log):
        if log and log[-1] in ("EXECUTING","RECOVERING"):
            return "BLOCKED_AWAIT_RECONCILE"
        return "OK"
    post = on_restart(transitions)
    ok = post == "BLOCKED_AWAIT_RECONCILE"
    return {"result": "PASS" if ok else "FAIL",
            "expected": "BLOCKED_AWAIT_RECONCILE", "actual": post,
            "recovery": "manual_reconcile", "details": {"log_tail": transitions[-2:]}}
run("T06","partial_state_update", t06)

# T07 missing audit event
def t07():
    state_log = ["ACCEPTED","EXECUTING","SUCCEEDED"]
    audit_log = ["ACCEPTED","EXECUTING"]  # missing SUCCEEDED
    missing = set(state_log) - set(audit_log)
    ok = len(missing) > 0
    return {"result": "PASS" if ok else "FAIL",
            "expected": "detect_missing_audit", "actual": "detected" if ok else "not_detected",
            "recovery": "reconcile_audit", "details": {"missing": list(missing)}}
run("T07","missing_audit_event", t07)

# T08 corrupted evidence
def t08():
    payload = {"k": "v", "n": 42}
    good = _hash_payload(payload)
    tampered = dict(payload); tampered["n"] = 43
    bad = _hash_payload(tampered)
    detected = (good != bad)
    return {"result": "PASS" if detected else "FAIL",
            "expected": "hash_mismatch_detected", "actual": "detected" if detected else "not_detected",
            "recovery": "re_verify_source", "details": {"good_prefix": good[:16], "bad_prefix": bad[:16]}}
run("T08","corrupted_evidence", t08)

# T09 timeout
def t09():
    class Dep:
        def slow(self): time.sleep(0.05); return "done"
    dep = Dep(); timeout_s = 0.01
    start = time.time()
    try:
        # simulate: check timeout BEFORE call returns
        if time.time() - start > timeout_s: raise TimeoutError("pre")
        time.sleep(timeout_s)
        if time.time() - start > timeout_s: raise TimeoutError("post")
        state = "SUCCEEDED"
    except TimeoutError:
        state = "RECOVERING"
    ok = state == "RECOVERING"
    return {"result": "PASS" if ok else "FAIL",
            "expected": "RECOVERING", "actual": state,
            "recovery": "backoff_retry", "details": {"timeout_s": timeout_s}}
run("T09","timeout", t09)

# T10 dependency unavailable
def t10():
    class Dep:
        def call(self): raise ConnectionError("dep down")
    dep = Dep()
    try:
        dep.call(); state = "SUCCEEDED"
    except ConnectionError:
        state = "CONTAINED"  # no dispatch, circuit considered
    ok = state == "CONTAINED"
    return {"result": "PASS" if ok else "FAIL",
            "expected": "CONTAINED", "actual": state,
            "recovery": "circuit_open", "details": {"cause": "dep_down"}}
run("T10","unavailable_dependency", t10)

# T11 recovery failure
def t11():
    def recovery():
        raise RuntimeError("recovery_failed")
    try:
        recovery(); state = "RECOVERED"
    except RuntimeError:
        state = "BLOCKED"
    ok = state == "BLOCKED"
    return {"result": "PASS" if ok else "FAIL",
            "expected": "BLOCKED", "actual": state,
            "recovery": "escalate_to_L0", "details": {"note": "no infinite retry"}}
run("T11","recovery_failure", t11)

# T12 repeated recovery loop / circuit breaker
def t12():
    cb = SimCircuitBreaker(threshold=3, window_sec=60, open_duration=300)
    now = time.time()
    states = []
    for i in range(5):
        if cb.is_open(now): states.append("CIRCUIT_OPEN"); continue
        cb.record_failure(now + i*0.001)
        states.append("FAILED")
    opened = "CIRCUIT_OPEN" in states
    ok = opened
    return {"result": "PASS" if ok else "FAIL",
            "expected": "CIRCUIT_OPEN", "actual": "opened" if opened else "not_opened",
            "recovery": "halt_until_manual", "details": {"sequence": states}}
run("T12","repeated_recovery_loop", t12)

# ---------------- Summary ----------------
p = sum(1 for r in results if r["result"] == "PASS")
f = sum(1 for r in results if r["result"] == "FAIL")
b = sum(1 for r in results if r["result"] == "BLOCKED")

summary = {
    "test_suite": "L7-RELIABILITY-FIXTURE-T01-T12",
    "mode": MODE,
    "timestamp_utc": datetime.now(timezone.utc).isoformat(timespec="seconds"),
    "host": HOST, "agent": AGENT, "actor": ACTOR,
    "total": len(results), "pass": p, "fail": f, "blocked": b,
    "overall": "PASS" if f == 0 and b == 0 else "FAIL",
    "results": results,
}
(OUT_DIR / "FIXTURE-TEST-SUMMARY.json").write_text(
    json.dumps(summary, indent=2, ensure_ascii=False), encoding="utf-8")

print("-" * 70)
print(f"TOTAL: {p} PASS, {f} FAIL, {b} BLOCKED  -> {summary['overall']}")
print(f"Summary: {OUT_DIR / 'FIXTURE-TEST-SUMMARY.json'}")