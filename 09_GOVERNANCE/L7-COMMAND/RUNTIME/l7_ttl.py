from datetime import datetime, timezone

def parse_iso(s):
    if s.endswith("Z"):
        s = s[:-1] + "+00:00"
    return datetime.fromisoformat(s)

def check_stale(issued_at, ttl_seconds=900, now=None):
    try:
        t0 = parse_iso(issued_at)
    except Exception:
        return False, "invalid_issued_at"
    n = now or datetime.now(timezone.utc)
    if t0.tzinfo is None:
        t0 = t0.replace(tzinfo=timezone.utc)
    delta = (n - t0).total_seconds()
    if delta < 0:
        return False, "issued_in_future"
    if delta > ttl_seconds:
        return False, "stale_command"
    return True, "ok"
