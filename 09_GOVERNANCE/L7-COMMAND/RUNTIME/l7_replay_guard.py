import json, os

def _load(path):
    if not os.path.exists(path):
        return {}
    out = {}
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line: continue
            try:
                rec = json.loads(line)
                out[rec["key"]] = rec
            except Exception:
                continue
    return out

def _append(path, rec):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "a", encoding="utf-8") as f:
        f.write(json.dumps(rec, sort_keys=True) + "\n")

def check_nonce(path, nonce):
    seen = _load(path)
    if nonce in seen:
        return False, "nonce_reuse"
    _append(path, {"key": nonce, "kind": "nonce"})
    return True, "ok"

def check_duplicate(path, cmd):
    key = cmd.get("command_id")
    if not key:
        return False, "missing_command_id"
    seen = _load(path)
    if key in seen:
        return False, "duplicate_command_id"
    _append(path, {"key": key, "kind": "command_id"})
    return True, "ok"
