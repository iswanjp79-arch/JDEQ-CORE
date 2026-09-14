import sys, json, os
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
AUDIT = BASE + "/runtime_audit.jsonl"
STATE = BASE + "/runtime_state"
CB_PATH = STATE + "/circuit_breaker.json"

def _backoff():
    if os.environ.get("L7_BACKOFF") == "fast":
        return (0, 0, 0)
    return (2, 8, 32)

def execute_stub(action):
    if action == "noop":
        return True, "ok"
    if action == "fail_once":
        sentinel = STATE + "/fail_once_sentinel"
        if os.path.exists(sentinel):
            return True, "ok_after_retry"
        with open(sentinel, "w", encoding="utf-8") as f:
            f.write("1")
        return False, "simulated_failure"
    if action == "fail_always":
        return False, "always_fails"
    return False, "unknown_action"

def run(command_path):
    sm = StateMachine()
    cb = CircuitBreaker(CB_PATH)
    emit(AUDIT, {"event":"intake","state":sm.state,"source":command_path})

    if cb.is_open():
        emit(AUDIT, {"event":"reject","reason":"circuit_breaker_open","state":"BLOCKED"})
        return 8

    try:
        with open(command_path, "r", encoding="utf-8") as f:
            cmd = json.load(f)
    except Exception as e:
        emit(AUDIT, {"event":"reject","reason":"parse_error","detail":str(e)})
        return 2
    ok, reason = validate(cmd)
    if not ok:
        sm.transition("REJECTED")
        emit(AUDIT, {"event":"reject","reason":reason,"state":sm.state})
        return 3
    ok, reason = check_nonce(STATE + "/nonces.jsonl", cmd["nonce"])
    if not ok:
        sm.transition("REJECTED")
        emit(AUDIT, {"event":"reject","reason":reason,"state":sm.state})
        return 4
    ok, reason = check_duplicate(STATE + "/commands.jsonl", cmd)
    if not ok:
        sm.transition("REJECTED")
        emit(AUDIT, {"event":"reject","reason":reason,"state":sm.state})
        return 5
    ok, reason = check_stale(cmd["issued_at"], ttl_seconds=900)
    if not ok:
        sm.transition("REJECTED")
        emit(AUDIT, {"event":"reject","reason":reason,"state":sm.state})
        return 6
    ok, reason = check_sequence(STATE + "/sequence.jsonl", cmd["sequence"])
    if not ok:
        sm.transition("REJECTED")
        emit(AUDIT, {"event":"reject","reason":reason,"state":sm.state})
        return 7

    sm.transition("AUTHORIZED")
    emit(AUDIT, {"event":"authorized","state":sm.state,"command_id":cmd["command_id"]})
    sm.transition("ACCEPTED")
    emit(AUDIT, {"event":"accepted","state":sm.state,"command_id":cmd["command_id"]})
    sm.transition("EXECUTING")
    emit(AUDIT, {"event":"executing","state":sm.state,"command_id":cmd["command_id"]})

    action = cmd.get("action","noop")
    final_state, history = recover(lambda: execute_stub(action), backoff=_backoff())
    emit(AUDIT, {"event":"execution_done","state":final_state,"history":history})

    if final_state == "RECOVERED":
        sm.transition("SUCCEEDED")
        sm.transition("VERIFIED")
        emit(AUDIT, {"event":"verified","state":sm.state,"command_id":cmd["command_id"]})
        return 0
    else:
        sm.transition("FAILED")
        sm.transition("RECOVERING")
        sm.transition("ESCALATED")
        cb.record_failure()
        emit(AUDIT, {"event":"escalated","state":sm.state,"cb_open":cb.is_open()})
        return 9

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)
    sys.exit(run(sys.argv[1]))
