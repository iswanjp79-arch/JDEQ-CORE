# test_l5_m1_reader.py
import sys, os, tempfile, json, hashlib
from pathlib import Path
sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\core")
sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\security")
from l5_m1_reader import read_artifact
from safe_path_resolver import ROOT_08_EVIDENCE

results = []
def check(name, cond, detail=""):
    mark = "PASS" if cond else "FAIL"
    results.append((mark, name))
    print(f"[{mark}] {name}  {detail}")

# setup: ensure LIVE/HP_Mini exists
live = ROOT_08_EVIDENCE / "LIVE" / "HP_Mini"
live.mkdir(parents=True, exist_ok=True)

# T01 valid JSON in LIVE
f1 = live / "test_valid.json"
f1.write_text(json.dumps({"a": 1, "b": "x"}), encoding="utf-8")
r = read_artifact("LIVE/HP_Mini/test_valid.json")
check("T01 valid JSON", r.is_ok and r.label == "OK" and r.sha256 is not None, f"label={r.label}")

# T02 reject BUFFER zone
buf = ROOT_08_EVIDENCE / "BUFFER" / "HP_Mini"
buf.mkdir(parents=True, exist_ok=True)
f2 = buf / "in_buffer.json"
f2.write_text(json.dumps({"x": 1}), encoding="utf-8")
r = read_artifact("BUFFER/HP_Mini/in_buffer.json")
check("T02 BUFFER rejected", (not r.is_ok) and r.label == "REJECTED_ZONE", f"label={r.label}")

# T03 reject .tmp file
f3 = live / "file.tmp"
f3.write_text("data", encoding="utf-8")
r = read_artifact("LIVE/HP_Mini/file.tmp")
check("T03 .tmp rejected", (not r.is_ok) and r.label == "REJECTED_TMP", f"label={r.label}")

# T04 reject non-whitelisted extension
f4 = live / "file.exe"
f4.write_text("binary", encoding="utf-8")
r = read_artifact("LIVE/HP_Mini/file.exe")
check("T04 .exe rejected", (not r.is_ok) and r.label == "FORMAT_ERROR", f"label={r.label}")

# T05 reject malformed JSON
f5 = live / "bad.json"
f5.write_text("{not json", encoding="utf-8")
r = read_artifact("LIVE/HP_Mini/bad.json")
check("T05 malformed JSON", (not r.is_ok) and r.label == "FORMAT_ERROR", f"label={r.label}")

# T06 missing file
r = read_artifact("LIVE/HP_Mini/nonexistent.json")
check("T06 missing file", (not r.is_ok) and r.label == "NOT_FOUND", f"label={r.label}")

# T07 path traversal rejected (safe_path_resolver)
r = read_artifact("../secret.txt")
check("T07 traversal rejected", (not r.is_ok) and r.label == "INTEGRITY_CONFLICT", f"label={r.label}")

# T08 SHA-256 matches
f8 = live / "hash_check.json"
content = json.dumps({"z": 9})
f8.write_text(content, encoding="utf-8")
r = read_artifact("LIVE/HP_Mini/hash_check.json")
expected = hashlib.sha256(content.encode("utf-8")).hexdigest()
check("T08 sha256 match", r.is_ok and r.sha256 == expected, f"got={r.sha256[:16]}...")

# T09 .md file allowed
f9 = live / "readme.md"
f9.write_text("# Header\n\ntext", encoding="utf-8")
r = read_artifact("LIVE/HP_Mini/readme.md")
check("T09 .md allowed", r.is_ok and r.label == "OK", f"label={r.label}")

# T10 L4 physical unchanged
before = f1.read_bytes()
_ = read_artifact("LIVE/HP_Mini/test_valid.json")
after = f1.read_bytes()
check("T10 L4 unmodified", before == after)

# cleanup test files
for p in [f1, f2, f3, f4, f5, f8, f9]:
    try: p.unlink()
    except Exception: pass

print("-" * 80)
p = sum(1 for m,_ in results if m == "PASS")
f = sum(1 for m,_ in results if m == "FAIL")
print(f"TOTAL: {p} PASS, {f} FAIL")
sys.exit(0 if f == 0 else 1)