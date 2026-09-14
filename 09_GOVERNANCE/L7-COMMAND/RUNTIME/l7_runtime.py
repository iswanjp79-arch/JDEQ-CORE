import sys, json, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from l7_command_schema import validate
from l7_state_machine import StateMachine
from l7_audit import emit

AUDIT = "D:/MICO_SSOT/08_EVIDENCE/L7-OPERATIONAL/runtime_audit.jsonl"

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
    sm.transition("AUTHORIZED")
    emit(AUDIT, {"event":"authorized","state":sm.state,"command_id":cmd["command_id"]})
    sm.transition("ACCEPTED")
    emit(AUDIT, {"event":"accepted","state":sm.state,"command_id":cmd["command_id"]})
    return 0

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)
    sys.exit(run(sys.argv[1]))
