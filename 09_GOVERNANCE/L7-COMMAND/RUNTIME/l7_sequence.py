import json, os

def _load(path):
    if not os.path.exists(path):
        return 0
    last = 0
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line: continue
            try:
                rec = json.loads(line)
                if rec.get("sequence", 0) > last:
                    last = rec["sequence"]
            except Exception:
                continue
    return last

def check_sequence(path, sequence):
    last = _load(path)
    if sequence <= last:
        return False, "sequence_rollback"
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "a", encoding="utf-8") as f:
        f.write(json.dumps({"sequence": sequence}) + "\n")
    return True, "ok"
