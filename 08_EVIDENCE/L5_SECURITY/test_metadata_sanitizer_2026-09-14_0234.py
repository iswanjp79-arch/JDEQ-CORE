# test_metadata_sanitizer.py
import sys, hashlib
sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\security")
from metadata_sanitizer import sanitize_string, sanitize_metadata

results = []
def check(name, cond, detail=""):
    mark = "PASS" if cond else "FAIL"
    results.append((mark, name))
    print(f"[{mark}] {name}  {detail}")

# T01 clean ASCII
r = sanitize_string("hello world")
check("T01 clean ASCII", r.value == "hello world" and r.label == "OK" and r.changed == False)

# T02 NFC normalize (é composed vs decomposed)
nfc = "\u00e9"          # é
nfd = "e\u0301"         # e + combining acute
r = sanitize_string(nfd)
check("T02 NFC normalize", r.value == nfc and r.changed == True, f"got={r.value!r}")

# T03 strip control chars
r = sanitize_string("abc\x00def\x01ghi")
check("T03 strip control", "\x00" not in r.value and "\x01" not in r.value and r.removed_chars == 2,
      f"value={r.value!r} removed={r.removed_chars}")

# T04 escape injection <? sequence
r = sanitize_string("<?xml version='1.0'?>")
check("T04 escape <?", "<?xml" not in r.value and "%3C%3F" in r.value, f"value={r.value!r}")

# T05 escape {{ }}
r = sanitize_string("template {{ name }} here")
check("T05 escape {{ }}", "{{" not in r.value and "}}" not in r.value and "%7B%7B" in r.value,
      f"value={r.value!r}")

# T06 backtick escape
r = sanitize_string("cmd `whoami`")
check("T06 escape backtick", "`" not in r.value and "%60" in r.value, f"value={r.value!r}")

# T07 truncate long
long_in = "A" * 5000
r = sanitize_string(long_in, max_len=2048)
check("T07 truncate", r.sanitized_len <= 2048 and r.value.endswith("[TRUNC]"),
      f"len={r.sanitized_len}")

# T08 SANITIZATION_HIGH label
r = sanitize_string("\x00" * 100 + "abc")
check("T08 SANITIZATION_HIGH", r.label == "SANITIZATION_HIGH",
      f"removed={r.removed_chars} original={r.original_len} label={r.label}")

# T09 deterministic checksum
a = sanitize_string("payload abc", max_len=2048)
b = sanitize_string("payload abc", max_len=2048)
check("T09 deterministic", a.checksum == b.checksum and a.value == b.value)

# T10 checksum is sha256 of sanitized value
r = sanitize_string("test value")
expected = hashlib.sha256(r.value.encode("utf-8")).hexdigest()
check("T10 checksum match", r.checksum == expected, f"got={r.checksum[:16]}... expect={expected[:16]}...")

# T11 sanitize_metadata dict
md = {"name": "test\x00", "path": "{{bad}}"}
out = sanitize_metadata(md)
check("T11 sanitize_metadata", "\x00" not in out["name"]["value"] and "{{" not in out["path"]["value"],
      f"name={out['name']['value']!r} path={out['path']['value']!r}")

# T12 non-string value
md2 = {"count": 42, "flag": True}
out2 = sanitize_metadata(md2)
check("T12 non-string passthrough", out2["count"]["label"] == "NON_STRING" and out2["count"]["value"] == 42)

# T13 shell metachar $(
r = sanitize_string("echo $(whoami)")
check("T13 escape $(", "$(" not in r.value and "%24%28" in r.value, f"value={r.value!r}")

print("-" * 80)
p = sum(1 for m,_ in results if m == "PASS")
f = sum(1 for m,_ in results if m == "FAIL")
print(f"TOTAL: {p} PASS, {f} FAIL")
sys.exit(0 if f == 0 else 1)