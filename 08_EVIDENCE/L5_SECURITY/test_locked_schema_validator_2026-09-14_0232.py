# test_locked_schema_validator.py
import sys, os, tempfile
from pathlib import Path
sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\security")
from locked_schema_validator import (
    create_safe_model, scan_source_for_forbidden, scan_tree
)

results = []
def check(name, cond, detail=""):
    mark = "PASS" if cond else "FAIL"
    results.append((mark, name, detail))
    print(f"[{mark}] {name}  {detail}")

# T01: create_safe_model with declarative fields
try:
    M = create_safe_model("TestModel", {
        "artifact_id": (str, ...),
        "source_node": (str, ...),
        "size_bytes":  (int, ...),
    })
    inst = M(artifact_id="a1", source_node="HP_Mini", size_bytes=42)
    check("T01 declarative model", inst.artifact_id == "a1", f"parsed={inst.model_dump()}")
except Exception as e:
    check("T01 declarative model", False, f"exc={e}")

# T02: reject callable field spec (would be validator/factory)
try:
    create_safe_model("BadModel", {"f": (str, lambda: "x")})
    check("T02 reject callable field", False, "no exception")
except ValueError:
    check("T02 reject callable field", True)
except Exception as e:
    check("T02 reject callable field", False, f"wrong exc={type(e).__name__}")

# T03: AST scan clean file
clean = tempfile.NamedTemporaryFile("w", suffix=".py", delete=False, encoding="utf-8")
clean.write("def hello():\n    return 1\n")
clean.close()
r = scan_source_for_forbidden(clean.name)
check("T03 scan clean", r["status"] == "OK", f"status={r['status']}")
os.unlink(clean.name)

# T04: AST scan file with forbidden decorator
bad = tempfile.NamedTemporaryFile("w", suffix=".py", delete=False, encoding="utf-8")
bad.write("from pydantic import field_validator\n@field_validator('x')\ndef v(cls, x):\n    return x\n")
bad.close()
r = scan_source_for_forbidden(bad.name)
check("T04 detect field_validator", r["status"] == "VIOLATION" and any("field_validator" in v for v in r["violations"]),
      f"status={r['status']} violations={r['violations']}")
os.unlink(bad.name)

# T05: AST scan forbidden call (eval)
bad2 = tempfile.NamedTemporaryFile("w", suffix=".py", delete=False, encoding="utf-8")
bad2.write("x = eval('1+1')\n")
bad2.close()
r = scan_source_for_forbidden(bad2.name)
check("T05 detect eval call", r["status"] == "VIOLATION" and any("eval" in v for v in r["violations"]),
      f"status={r['status']} violations={r['violations']}")
os.unlink(bad2.name)

# T06: AST scan subprocess.run
bad3 = tempfile.NamedTemporaryFile("w", suffix=".py", delete=False, encoding="utf-8")
bad3.write("import subprocess\nsubprocess.run(['ls'])\n")
bad3.close()
r = scan_source_for_forbidden(bad3.name)
check("T06 detect subprocess.run", r["status"] == "VIOLATION" and any("subprocess.run" in v for v in r["violations"]),
      f"status={r['status']} violations={r['violations']}")
os.unlink(bad3.name)

# T07: scan tree of security folder (should be OK)
r = scan_tree(r"D:\MICO_SSOT\L5-modules\security")
check("T07 scan security folder", r["status"] == "OK",
      f"scanned={r['files_scanned']} violations={r['files_with_violations']}")

# T08: scan tree with one bad file
tmpdir = tempfile.mkdtemp()
with open(os.path.join(tmpdir, "bad.py"), "w", encoding="utf-8") as f:
    f.write("import os\nos.system('dir')\n")
with open(os.path.join(tmpdir, "good.py"), "w", encoding="utf-8") as f:
    f.write("x = 1\n")
r = scan_tree(tmpdir)
check("T08 scan tree with violation", r["status"] == "VIOLATION" and r["files_with_violations"] == 1,
      f"scanned={r['files_scanned']} violations={r['files_with_violations']}")

# Summary
print("-" * 80)
p = sum(1 for m,_,_ in results if m == "PASS")
f = sum(1 for m,_,_ in results if m == "FAIL")
print(f"TOTAL: {p} PASS, {f} FAIL")
sys.exit(0 if f == 0 else 1)
