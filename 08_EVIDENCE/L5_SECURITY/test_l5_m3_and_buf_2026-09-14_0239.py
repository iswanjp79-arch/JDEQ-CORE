# test_l5_m3_and_buf.py
import sys, os, json, hashlib, shutil
from pathlib import Path
sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\core")
sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\security")
from l5_m3_ledger import verify_integrity, build_ledger, save_ledger, ledger_status, LEDGER_FILE
from buf_004_admission_guard import admit, assert_no_buffer_write
from safe_path_resolver import ROOT_08_EVIDENCE

results = []
def check(name, cond, detail=""):
    mark = "PASS" if cond else "FAIL"
    results.append((mark, name))
    print(f"[{mark}] {name}  {detail}")

# Setup
live = ROOT_08_EVIDENCE / "LIVE" / "HP_Mini"
live.mkdir(parents=True, exist_ok=True)
f1 = live / "led_test.json"
content = json.dumps({"k": "v"})
f1.write_text(content, encoding="utf-8")
sha_ok = hashlib.sha256(content.encode("utf-8")).hexdigest()

# --- M3 Integrity ---
r = verify_integrity("LIVE/HP_Mini/led_test.json", sha_ok)
check("T01 integrity MATCH", r["status"] == "MATCH", f"status={r['status']}")

r = verify_integrity("LIVE/HP_Mini/led_test.json", "deadbeef")
check("T02 integrity MISMATCH", r["status"] == "MISMATCH", f"status={r['status']}")

r = verify_integrity("LIVE/HP_Mini/does_not_exist.json", sha_ok)
check("T03 integrity UNAVAILABLE", r["status"] == "UNAVAILABLE", f"status={r['status']}")

# --- Ledger ---
led = build_ledger()
check("T04 ledger derived", led["derived"] is True and led["authoritative"] is False,
      f"derived={led['derived']} auth={led['authoritative']}")
check("T05 ledger rebuildable", led["rebuildable"] is True)
check("T06 ledger no full payload", led["contains_full_payload"] is False)
check("T07 ledger has entries", led["count"] >= 1, f"count={led['count']}")

p1 = save_ledger(led)
check("T08 ledger file saved", Path(p1).exists() and Path(p1).stat().st_size > 0)

st = ledger_status()
check("T09 ledger status OK", st["exists"] and st["derived"] and not st["authoritative"] and st["rebuildable"],
      f"derived={st['derived']} auth={st['authoritative']}")

# Rebuild determinism: same physical files -> same count (not same bytes due to timestamp)
led2 = build_ledger()
check("T10 ledger rebuild same count", led2["count"] == led["count"])

# No SQLite in ledger dir
ldir = Path(r"D:\MICO_SSOT\09_GOVERNANCE\L5-LEDGER")
db_hits = list(ldir.rglob("*.db")) + list(ldir.rglob("*.sqlite")) if ldir.exists() else []
check("T11 no sqlite in ledger dir", len(db_hits) == 0, f"hits={len(db_hits)}")

# --- BUF-004 ---
a = admit("LIVE/HP_Mini/led_test.json")
check("T12 admit LIVE", a["allow"] and a["zone"] == "LIVE", f"{a}")

a = admit("RETAIN/Z83/old.json")
check("T13 admit RETAIN", a["allow"] and a["zone"] == "RETAIN")

a = admit("BUFFER/HP_Mini/pending.json")
check("T14 DENY BUFFER", (not a["allow"]) and a["reason"] == "ZONE_DENIED:BUFFER")

a = admit("LIVE/HP_Mini/file.tmp")
check("T15 DENY .tmp", (not a["allow"]) and a["reason"] == "TMP_MARKER")

a = admit("LIVE/HP_Mini/.hidden")
check("T16 DENY hidden", (not a["allow"]) and a["reason"] == "TMP_MARKER")

a = admit("STAGING/Vivo/in.json")
check("T17 admit STAGING", a["allow"])

a = admit("../escape/file.json")
check("T18 DENY traversal", (not a["allow"]) and a["reason"] == "TRAVERSAL")

a = admit("GLOBAL/ADR/x.md")
check("T19 DENY GLOBAL", (not a["allow"]) and a["reason"] == "ZONE_DENIED:GLOBAL")

a = admit("DISPOSABLE/junk.json")
check("T20 DENY DISPOSABLE", (not a["allow"]) and a["reason"] == "ZONE_DENIED:DISPOSABLE")

inv = assert_no_buffer_write()
check("T21 no buffer write invariants",
      inv["L5_write_buffer"] is False and inv["L5_delete_buffer"] is False and
      inv["L5_move_buffer"] is False and inv["L5_rename_buffer"] is False and
      inv["buffer_owner"] == "L4")

# Cleanup test file
try: f1.unlink()
except Exception: pass

print("-" * 80)
p = sum(1 for m,_ in results if m == "PASS")
f = sum(1 for m,_ in results if m == "FAIL")
print(f"TOTAL: {p} PASS, {f} FAIL")
sys.exit(0 if f == 0 else 1)