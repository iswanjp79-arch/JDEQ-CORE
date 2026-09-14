import time

BACKOFF = [2, 8, 32]
MAX_ATTEMPTS = 3

def recover(operation, max_attempts=MAX_ATTEMPTS, backoff=None):
    backoff = backoff if backoff is not None else BACKOFF
    history = []
    for attempt in range(max_attempts):
        ok, result = operation()
        history.append({"attempt": attempt + 1, "ok": ok, "result": str(result)})
        if ok:
            return "RECOVERED", history
        if attempt < max_attempts - 1:
            time.sleep(backoff[attempt])
    return "ESCALATED", history
