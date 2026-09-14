import sys, json, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from l7_command_schema import validate
from l7_state_machine import StateMachine
from l7_audit import emit
from l7_replay_guard import check_nonce, check_duplicate
from l7_ttl import check_stale
from l7_sequence import check_sequence

BASE = "D:/MICO_SSOT/08_EVIDENCE/L7-OPERATIONAL"
AUDIT = BASE + "/runtime_audit.jsonl"
STATE = BASE + "/runtime_state"

def run(command_path):
    sm = StateMachine()
    emit(AUDIT, {"event":"intake","state":sm.state,"source":command_path})
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

    # nonce
    ok, reason = check_nonce(STATE + "/nonces.jsonl", cmd["nonce"])
    if not ok:
        sm.transition("REJECTED")
        emit(AUDIT, {"event":"reject","reason":reason,"state":sm.state,"nonce":cmd["nonce"]})
        return 4

    # duplicate
    ok, reason = check_duplicate(STATE + "/commands.jsonl", cmd)
    if not ok:
        sm.transition("REJECTED")
        emit(AUDIT, {"event":"reject","reason":reason,"state":sm.state})
        return 5

    # ttl
    ok, reason = check_stale(cmd["issued_at"], ttl_seconds=900)
    if not ok:
        sm.transition("REJECTED")
        emit(AUDIT, {"event":"reject","reason":reason,"state":sm.state})
        return 6

    # sequence
    ok, reason = check_sequence(STATE + "/sequence.jsonl", cmd["sequence"])
    if not ok:
        sm.transition("REJECTED")
        emit(AUDIT, {"event":"reject","reason":reason,"state":sm.state,"sequence":cmd["sequence"]})
        return 7

    sm.transition("AUTHORIZED")
    emit(AUDIT, {"event":"authorized","state":sm.state,"command_id":cmd["command_id"]})
    sm.transition("ACCEPTED")
    emit(AUDIT, {"event":"accepted","state":sm.state,"command_id":cmd["command_id"]})
    return 0

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)
    sys.exit(run(sys.argv[1]))
