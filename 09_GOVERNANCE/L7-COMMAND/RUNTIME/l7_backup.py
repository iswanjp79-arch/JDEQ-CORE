import json, os, shutil, hashlib
from datetime import datetime, timezone

def _hash_file(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()

def backup(src, dst):
    if not os.path.isdir(src):
        return False, "src_not_found"
    if os.path.isdir(dst):
        shutil.rmtree(dst)
    os.makedirs(dst, exist_ok=True)
    manifest = {}
    for root, _, files in os.walk(src):
        for fn in files:
            fp = os.path.join(root, fn)
            rel = os.path.relpath(fp, src)
            target = os.path.join(dst, rel)
            os.makedirs(os.path.dirname(target) or dst, exist_ok=True)
            shutil.copy2(fp, target)
            manifest[rel] = _hash_file(fp)
    mf = os.path.join(dst, "MANIFEST.sha256.json")
    with open(mf, "w", encoding="utf-8") as f:
        json.dump({"ts": datetime.now(timezone.utc).isoformat(),
                   "files": manifest}, f, indent=2)
    return True, mf

def restore(src, dst):
    mf = os.path.join(src, "MANIFEST.sha256.json")
    if not os.path.isfile(mf):
        return False, "manifest_missing"
    with open(mf, encoding="utf-8") as f:
        data = json.load(f)
    files = data.get("files", {})
    bad = []
    for rel, expected in files.items():
        fp = os.path.join(src, rel)
        if not os.path.isfile(fp):
            bad.append((rel, "missing")); continue
        if _hash_file(fp) != expected:
            bad.append((rel, "hash_mismatch"))
    if bad:
        return False, "verify_failed:" + str(bad)
    if os.path.isdir(dst):
        shutil.rmtree(dst)
    os.makedirs(dst, exist_ok=True)
    for rel in files:
        s = os.path.join(src, rel)
        d = os.path.join(dst, rel)
        os.makedirs(os.path.dirname(d) or dst, exist_ok=True)
        shutil.copy2(s, d)
    return True, "restored"
