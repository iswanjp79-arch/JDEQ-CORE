import json, hashlib, os
from datetime import datetime, timezone

def emit(path, record):
    record = dict(record)
    record["ts"] = datetime.now(timezone.utc).isoformat()
    payload = json.dumps(record, sort_keys=True, separators=(",", ":"))
    record["hash"] = hashlib.sha256(payload.encode("utf-8")).hexdigest()
    line = json.dumps(record, sort_keys=True, separators=(",", ":"))
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "a", encoding="utf-8") as f:
        f.write(line + "\n")
    return record["hash"]
