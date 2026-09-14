import sys, json, os, threading, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from l7_command_schema import validate
from l7_state_machine import StateMachine
from l7_audit import emit
from l7_replay_guard import check_nonce, check_duplicate
from l7_ttl import check_stale
from l7_sequence import check_sequence
from l7_circuit_breaker import CircuitBreaker
from l7_recovery import recover

BASE = "D:/MICO_SSOT/08_EVIDENCE/L7-OPERATIONAL"
AUDIT = os.environ.get("L7_AUDIT_PATH", BASE + "/runtime_audit.jsonl")
STATE = BASE + "/runtime_state"
CB_PATH = STATE + "/circuit_breaker.json"
AUTHORIZED_ISSUERS = ["L0"]
EXEC_TIMEOUT = int(os.environ.get("L7_EXEC_TIMEOUT", "30"))

def _backoff():
    if os.environ.get("L7_BACKOFF") == "fast":
        return (0,0,0)
    return (2,8,32)

def _safe_emit(rec):
    try:
        emit(AUDIT, rec)
        return True
    except Exception:
        return False

def execute_stub(action):
    if action == "noop": return True, "ok"
    if action == "fail_once":
        s = STATE + "/fail_once_sentinel"
        if os.path.exists(s): return True, "ok_after_retry"
        with open(s,"w") as f: f.write("1")
        return False, "simulated_failure"
    if action == "fail_always": return False, "always_fails"
    if action == "dependency_unavailable": return False, "dependency_down"
    if action == "verify_fail": return True, "ok"
    if action == "sleep_long": time.sleep(10); return True, "ok"
    return False, "unknown_action"

def _run_with_timeout(action):
    box = [None]
    def tgt():
        try: box[0] = execute_stub(action)
        except Exception as e: box[0] = (False, str(e))
    t = threading.Thread(target=tgt, daemon=True); t.start(); t.join(EXEC_TIMEOUT)
    if t.is_alive(): return None
    return box[0]

def run(command_path):
    sm = StateMachine()
    cb = CircuitBreaker(CB_PATH)
    if not _safe_emit({"event":"intake","state":sm.state,"source":command_path}): return 14
    if cb.is_open():
        _safe_emit({"event":"reject","reason":"circuit_breaker_open","state":"BLOCKED"})
        return 8
    try:
        with open(command_path,"r",encoding="utf-8") as f: cmd = json.load(f)
    except Exception as e:
        _safe_emit({"event":"reject","reason":"parse_error","detail":str(e)}); return 2
    ok, reason = validate(cmd)
    if not ok:
        sm.transition("REJECTED"); _safe_emit({"event":"reject","reason":reason}); return 3
    if cmd.get("issuer") not in AUTHORIZED_ISSUERS:
        sm.transition("REJECTED")
        _safe_emit({"event":"reject","reason":"unauthorized_issuer","issuer":cmd.get("issuer")})
        return 10
    ok, reason = check_nonce(STATE + "/nonces.jsonl", cmd["nonce"])
    if not ok:
        sm.transition("REJECTED"); _safe_emit({"event":"reject","reason":reason}); return 4
    ok, reason = check_duplicate(STATE + "/commands.jsonl", cmd)
    if not ok:
        sm.transition("REJECTED"); _safe_emit({"event":"reject","reason":reason}); return 5
    ok, reason = check_stale(cmd["issued_at"], ttl_seconds=900)
    if not ok:
        sm.transition("REJECTED"); _safe_emit({"event":"reject","reason":reason}); return 6
    ok, reason = check_sequence(STATE + "/sequence.jsonl", cmd["sequence"])
    if not ok:
        sm.transition("REJECTED"); _safe_emit({"event":"reject","reason":reason}); return 7
    sm.transition("AUTHORIZED"); _safe_emit({"event":"authorized","state":sm.state})
    sm.transition("ACCEPTED");   _safe_emit({"event":"accepted","state":sm.state})
    sm.transition("EXECUTING");  _safe_emit({"event":"executing","state":sm.state})
    action = cmd.get("action","noop")
    result = _run_with_timeout(action)
    if result is None:
        sm.transition("FAILED")
        _safe_emit({"event":"timeout","state":sm.state,"action":action})
        return 11
    ok_exec, msg = result
    if ok_exec:
        sm.transition("SUCCEEDED")
        if action == "verify_fail":
            sm.transition("VERIFICATION_FAILED")
            _safe_emit({"event":"verification_failed","state":sm.state})
            cb.record_failure()
            return 13
        sm.transition("VERIFIED")
        _safe_emit({"event":"verified","state":sm.state})
        return 0
    else:
        sm.transition("FAILED")
        final_state, history = recover(lambda: execute_stub(action), backoff=_backoff())
        _safe_emit({"event":"recovery","state":final_state,"history":history})
        if final_state == "RECOVERED":
            sm.transition("RECOVERING"); sm.transition("RECOVERED")
            _safe_emit({"event":"recovered","state":sm.state})
            return 0
        else:
            sm.transition("RECOVERING"); sm.transition("ESCALATED")
            cb.record_failure()
            code = 12 if action == "dependency_unavailable" else 9
            _safe_emit({"event":"escalated","state":sm.state,"cb_open":cb.is_open()})
            return code

if __name__ == "__main__":
    if len(sys.argv) < 2: sys.exit(1)
    sys.exit(run(sys.argv[1]))
