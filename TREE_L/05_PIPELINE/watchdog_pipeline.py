import os, json, time, datetime, hashlib

BASE = r"D:\MICO_SSOT\TREE_L\05_PIPELINE"
INBOX = os.path.join(BASE, "INBOX")
OUTBOX = os.path.join(BASE, "OUTBOX")
ERROR = os.path.join(BASE, "ERROR")
ARCHIVE = os.path.join(BASE, "ARCHIVE")
QUARANTINE = os.path.join(BASE, "QUARANTINE")
PEST = os.path.join(BASE, "PEST_CONTROL")
WASTE = os.path.join(BASE, "WASTE_OUTLET")
EVIDENCE = r"D:\MICO_SSOT\TREE_L\08_EVIDENCE\RUNTIME"
MAX_SIZE = 1024  # 1 KB

def now():
    return datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def write_evidence(event):
    fname = "pipeline_event_" + datetime.datetime.now().strftime("%Y%m%d_%H%M%S") + ".json"
    with open(os.path.join(EVIDENCE, fname), "w", encoding="utf-8") as f:
        json.dump(event, f, indent=2)

def filter_process(path):
    name = os.path.basename(path)

    # Saringan kasar: ekstensi berbahaya
    ext = os.path.splitext(name)[1].lower()
    if ext in ['.exe', '.bat', '.cmd', '.vbs', '.js', '.scr']:
        os.replace(path, os.path.join(PEST, name))
        write_evidence({"type": "PEST_CONTROL", "file": name, "status": "BLOCKED", "reason": "ekstensi berbahaya", "time": now()})
        return

    # Hanya proses file .json setelah lolos saringan ekstensi
    if not name.endswith(".json"):
        os.replace(path, os.path.join(QUARANTINE, name))
        write_evidence({"type": "QUARANTINE", "file": name, "status": "REJECTED", "reason": "bukan JSON", "time": now()})
        return

    # Saringan ukuran
    size = os.path.getsize(path)
    if size > MAX_SIZE:
        os.replace(path, os.path.join(WASTE, name))
        write_evidence({"type": "WASTE", "file": name, "status": "REJECTED", "reason": f"ukuran {size} > {MAX_SIZE}", "time": now()})
        return

    # Saringan JSON dan field
    try:
        with open(path, "r", encoding="utf-8-sig") as f:
            data = json.load(f)
        if not any(k in data for k in ("task_type", "task")):
            raise ValueError("Field task_type/task tidak ditemukan")
    except Exception as e:
        os.replace(path, os.path.join(QUARANTINE, name))
        write_evidence({"type": "QUARANTINE", "file": name, "status": "REJECTED", "reason": str(e), "time": now()})
        return

    # Saringan hash + forward
    try:
        h = hashlib.sha256()
        with open(path, "rb") as f:
            for chunk in iter(lambda: f.read(4096), b""):
                h.update(chunk)
        sha = h.hexdigest()

        out_name = os.path.splitext(name)[0] + "_forwarded.json"
        out_path = os.path.join(OUTBOX, out_name)
        with open(out_path, "w", encoding="utf-8") as f:
            json.dump({"source": name, "forwarded_at": now(), "sha256": sha, "payload": data}, f, indent=2)

        os.replace(path, os.path.join(ARCHIVE, name))
        write_evidence({"type": "PIPELINE_FORWARD", "file": name, "status": "OK", "sha256": sha, "time": now()})
    except Exception as e:
        os.replace(path, os.path.join(ERROR, name))
        write_evidence({"type": "PIPELINE_ERROR", "file": name, "status": "ERROR", "reason": str(e), "time": now()})

def main():
    while True:
        try:
            files = [f for f in os.listdir(INBOX)]
            for f in files:
                filter_process(os.path.join(INBOX, f))
        except Exception as e:
            write_evidence({"type": "PIPELINE_LOOP", "status": "WATCHDOG_ERROR", "reason": str(e), "time": now()})
        time.sleep(30)

if __name__ == "__main__":
    main()
