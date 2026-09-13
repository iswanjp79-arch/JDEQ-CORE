# test_m1_ledger_reader.py
import sys, json, hashlib, shutil
from pathlib import Path
sys.path.insert(0, r"D:\MICO_SSOT\L6-modules")
from m1_ledger_reader import read_ledger, LEDGER_FILE, LEDGER_STATE_FILE, L5_LEDGER_DIR

results = []
def check(name, cond, detail=""):
    mark = "PASS" if cond else "FAIL"
    results.append((mark, name))
    print(f"[{mark}] {name}  {detail}")

# T01 happy path (using existing L5 ledger)
r = read_ledger()
check("T01 read OK", r.status == "OK", f"status={r.status} reason={r.reason}")
check("T02 count > 0", r.count > 0, f"count={r.count}")
check("T03 sha256 present", r.ledger_sha256 is not None and len(r.ledger_sha256) == 64)
check("T04 zone_counts present", isinstance(r.zone_counts, dict), f"zones={r.zone_counts}")
check("T05 ledger_doc loaded", r.ledger_doc is not None and "entries" in r.ledger_doc)

# T06 tamper ledger.json → hash mismatch should block
ledger_backup = LEDGER_FILE.read_text(encoding="utf-8")
try:
    tampered = json.loads(ledger_backup)
    tampered["count"] = tampered["count"] + 1
    LEDGER_FILE.write_text(json.dumps(tampered), encoding="utf-8")
    r2 = read_ledger()
    check("T06 detect tamper", r2.status == "BLOCKED", f"status={r2.status} reason={r2.reason}")
finally:
    LEDGER_FILE.write_text(ledger_backup, encoding="utf-8")

# T07 restore → OK again
r3 = read_ledger()
check("T07 restore OK", r3.status == "OK")

# T08 check L4 not touched (L5 dir file count unchanged)
l4_sample_dir = Path(r"D:\MICO_SSOT\08_EVIDENCE\LIVE")
count_before = sum(1 for _ in l4_sample_dir.rglob("*") if _.is_file()) if l4_sample_dir.exists() else 0
_ = read_ledger()
count_after  = sum(1 for _ in l4_sample_dir.rglob("*") if _.is_file()) if l4_sample_dir.exists() else 0
check("T08 L4 unmutated", count_before == count_after)

print("-" * 80)
p = sum(1 for m,_ in results if m == "PASS")
f = sum(1 for m,_ in results if m == "FAIL")
print(f"TOTAL: {p} PASS, {f} FAIL")
sys.exit(0 if f == 0 else 1)