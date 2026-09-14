import time

BACKOFF = [2, 8, 32]
MAX_ATTEMPTS = 3

def recover(operation, max_attempts=MAX_ATTEMPTS):
    """operation: callable returning (ok, result). Return (final_state, history)."""
    history = []
    for attempt in range(max_attempts):
        ok, result = operation()
        history.append({"attempt": attempt + 1, "ok": ok, "result": str(result)})
        if ok:
            return "RECOVERED", history
        if attempt < max_attempts - 1:
            time.sleep(BACKOFF[attempt])
    return "ESCALATED", history
