# test_m2_path_hash_validator.py (v2 — accommodates empty ledger)
import sys, json, hashlib, shutil
from pathlib import Path
sys.path.insert(0, r"D:\MICO_SSOT\L6-modules")
from m2_path_hash_validator import (
    validate_entry, validate_all, save_summary,
    ROOT_08_EVIDENCE, L6_ROOT
)
import m1_ledger_reader

results = []
def check(name, cond, detail=""):
    mark = "PASS" if cond else "FAIL"
    results.append((mark, name))
    print(f"[{mark}] {name}  {detail}")

# Setup
live = ROOT_08_EVIDENCE / "LIVE" / "HP_Mini"
live.mkdir(parents=True, exist_ok=True)
testfile = live / "m2_test.json"
content = json.dumps({"k": "v", "n": 42})
testfile.write_text(content, encoding="utf-8")
sha_ok = hashlib.sha256(content.encode("utf-8")).hexdigest()

# T01 validate_entry OK
e = {"artifact_id": "test01", "file_path": "LIVE/HP_Mini/m2_test.json", "sha256_hash": sha_ok}
r = validate_entry(e)
check("T01 entry OK", r.status == "OK" and r.actual_sha256 == sha_ok, f"status={r.status}")

# T02 missing file
e2 = {"artifact_id": "test02", "file_path": "LIVE/HP_Mini/nonexistent.json", "sha256_hash": sha_ok}
r2 = validate_entry(e2)
check("T02 missing file", r2.status == "MISSING", f"status={r2.status}")

# T03 hash mismatch
e3 = {"artifact_id": "test03", "file_path": "LIVE/HP_Mini/m2_test.json", "sha256_hash": "deadbeef"*8}
r3 = validate_entry(e3)
check("T03 hash mismatch", r3.status == "MISMATCH", f"status={r3.status}")

# T04 path traversal
e4 = {"artifact_id": "test04", "file_path": "../etc/passwd", "sha256_hash": sha_ok}
r4 = validate_entry(e4)
check("T04 traversal unsafe", r4.status == "PATH_UNSAFE" and r4.reason == "traversal",
      f"status={r4.status} reason={r4.reason}")

# T05 missing fields
e5 = {"artifact_id": "test05", "file_path": "", "sha256_hash": ""}
r5 = validate_entry(e5)
check("T05 missing fields", r5.status == "PATH_UNSAFE", f"status={r5.status}")

# T06 validate_all against REAL ledger (whatever its state)
summary = validate_all()
# PASS means: no MISSING/MISMATCH/PATH_UNSAFE/UNREADABLE
check("T06 validate_all not BLOCKED", summary.overall == "PASS",
      f"overall={summary.overall} total={summary.total}")

# T07 consistency: summary.total must equal len(ledger.entries)
lr = m1_ledger_reader.read_ledger()
ledger_count = (lr.ledger_doc or {}).get("count", 0)
check("T07 summary consistent with ledger",
      summary.total == ledger_count and summary.ok + summary.mismatch + summary.missing + summary.path_unsafe + summary.unreadable == summary.total,
      f"summary.total={summary.total} ledger.count={ledger_count}")

# T08 save summary + L4 unchanged
out_dir = L6_ROOT / "M2-EVIDENCE"
before = sum(1 for _ in ROOT_08_EVIDENCE.rglob("*") if _.is_file())
p = save_summary(summary, out_dir)
after = sum(1 for _ in ROOT_08_EVIDENCE.rglob("*") if _.is_file())
check("T08 save + L4 unmutated", Path(p).exists() and before == after, f"file={Path(p).name}")

# cleanup
try: testfile.unlink()
except Exception: pass

print("-" * 80)
p = sum(1 for m,_ in results if m == "PASS")
f = sum(1 for m,_ in results if m == "FAIL")
print(f"TOTAL: {p} PASS, {f} FAIL")
sys.exit(0 if f == 0 else 1)