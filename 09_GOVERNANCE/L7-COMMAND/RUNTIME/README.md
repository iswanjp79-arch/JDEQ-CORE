# L7 RUNTIME - SPRINT 1 SKELETON

- Generated: 2026-09-14_1238
- Scope: command intake + schema validation + state machine + audit emission
- Not in scope: nonce/replay/duplicate/stale/circuit-breaker/recovery

## Files
- l7_runtime.py           : entry point
- l7_command_schema.py    : required-field validation
- l7_state_machine.py     : explicit transitions
- l7_audit.py             : append-only JSONL with sha256
- test_skeleton_smoke.py  : 3-case smoke test

## Run
python l7_runtime.py <path_to_command.json>
python test_skeleton_smoke.py

## Status
IMPLEMENTED (sprint 1 only) - no activation
