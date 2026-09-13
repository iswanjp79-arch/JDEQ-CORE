# test_safe_path_resolver.py
import sys
from pathlib import Path
sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\security")
from safe_path_resolver import resolve_safe, ROOT_08_EVIDENCE

CASES = [
    ("T01 valid relative",     "LIVE/HP_Mini/test.json",   True,  "OK"),
    ("T02 path traversal",     "../secret.txt",            False, "INTEGRITY_CONFLICT"),
    ("T03 deep traversal",     "LIVE/../../../etc/passwd", False, "INTEGRITY_CONFLICT"),
    ("T04 absolute drive",     r"C:\Windows\test.txt",     False, "INTEGRITY_CONFLICT"),
    ("T05 UNC path",           r"\\server\share\file",     False, "INTEGRITY_CONFLICT"),
    ("T06 URI scheme",         "file:///etc/passwd",       False, "INTEGRITY_CONFLICT"),
    ("T07 null byte",          "test\x00.json",            False, "INTEGRITY_CONFLICT"),
    ("T08 control char",       "test\x01.json",            False, "INTEGRITY_CONFLICT"),
    ("T09 empty string",       "",                         False, "INTEGRITY_CONFLICT"),
    ("T10 buffer path",        "BUFFER/HP_Mini/file.tmp",  True,  "OK"),
]

passed = 0
failed = 0
print(f"ROOT = {ROOT_08_EVIDENCE}")
print("-" * 80)
for name, inp, exp_safe, exp_label in CASES:
    r = resolve_safe(inp)
    ok = (r.is_safe == exp_safe) and (r.label == exp_label)
    mark = "PASS" if ok else "FAIL"
    if ok: passed += 1
    else:  failed += 1
    print(f"[{mark}] {name}")
    print(f"        input   = {inp!r}")
    print(f"        safe    = {r.is_safe}  label = {r.label}  reason = {r.reason}")
    if not ok:
        print(f"        EXPECT  = safe={exp_safe}  label={exp_label}")

print("-" * 80)
print(f"TOTAL: {passed} PASS, {failed} FAIL")
sys.exit(0 if failed == 0 else 1)
