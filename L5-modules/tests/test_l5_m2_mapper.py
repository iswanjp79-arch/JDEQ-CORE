# test_l5_m2_mapper.py
import sys, json, hashlib
from pathlib import Path
sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\core")
sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\security")
from l5_m2_mapper import build_envelope, envelope_to_dict, envelope_validate, _derive_correlation_hash
from safe_path_resolver import ROOT_08_EVIDENCE

results = []
def check(name, cond, detail=""):
    mark = "PASS" if cond else "FAIL"
    results.append((mark, name))
    print(f"[{mark}] {name}  {detail}")

live = ROOT_08_EVIDENCE / "LIVE" / "HP_Mini"
live.mkdir(parents=True, exist_ok=True)

# T01 envelope basic shape
f = live / "env_test.json"
f.write_text(json.dumps({"k": "v"}), encoding="utf-8")
env = build_envelope("LIVE/HP_Mini/env_test.json")
check("T01 envelope basic", env.status == "ABSTRACTION_READY" and env.source_node == "HP_Mini",
      f"status={env.status} node={env.source_node}")

# T02 required fields present
d = envelope_to_dict(env)
req = ["artifact_id","source_node","physical_locator","classification","integrity","temporal","correlation","payload","status"]
check("T02 fields present", all(k in d for k in req), f"keys={list(d.keys())}")

# T03 sha256 matches M1
import hashlib
sha_expected = hashlib.sha256(f.read_bytes()).hexdigest()
check("T03 sha256 match", env.integrity["sha256_hash"] == sha_expected)

# T04 retention class derived from zone
check("T04 retention LIVE", env.classification["retention_class"] == "LIVE")

# T05 virtual normalization: whitespace collapse in strings
f2 = live / "ws.json"
f2.write_text(json.dumps({"msg": "  hello   world   "}), encoding="utf-8")
env2 = build_envelope("LIVE/HP_Mini/ws.json")
check("T05 whitespace collapsed", env2.payload["msg"] == "hello world",
      f"got={env2.payload['msg']!r}")

# T06 physical source unchanged (raw bytes still with spaces)
raw = f2.read_text(encoding="utf-8")
check("T06 physical unchanged", "  hello   world   " in raw)

# T07 correlation hash deterministic
a = _derive_correlation_hash("HP_Mini", "2026-09-14T02:00:00", "json")
b = _derive_correlation_hash("HP_Mini", "2026-09-14T02:00:00", "json")
check("T07 correlation deterministic", a == b)

# T08 correlation changes with time bucket
c = _derive_correlation_hash("HP_Mini", "2026-09-14T03:00:00", "json")
check("T08 correlation bucket-sensitive", a != c)

# T09 envelope_validate clean
v = envelope_validate(env)
check("T09 envelope valid", v["ok"], f"issues={v['issues']}")

# T10 reject build for BUFFER
buf = ROOT_08_EVIDENCE / "BUFFER" / "HP_Mini"
buf.mkdir(parents=True, exist_ok=True)
fb = buf / "should_reject.json"
fb.write_text("{}", encoding="utf-8")
envB = build_envelope("BUFFER/HP_Mini/should_reject.json")
check("T10 BUFFER rejected", envB.status == "REJECTED", f"status={envB.status}")

# T11 quarantine virtual if node unknown
unknown = ROOT_08_EVIDENCE / "LIVE" / "UnknownNode"
unknown.mkdir(parents=True, exist_ok=True)
fu = unknown / "u.json"
fu.write_text(json.dumps({"x": 1}), encoding="utf-8")
envU = build_envelope("LIVE/UnknownNode/u.json")
check("T11 quarantine unknown node", envU.status == "QUARANTINE_VIRTUAL",
      f"status={envU.status} node={envU.source_node}")

# T12 artifact_id derived deterministic
env2b = build_envelope("LIVE/HP_Mini/env_test.json")
check("T12 artifact_id deterministic", env.artifact_id == env2b.artifact_id)

# cleanup
for p in [f, f2, fb, fu]:
    try: p.unlink()
    except Exception: pass
try: unknown.rmdir()
except Exception: pass

print("-" * 80)
p = sum(1 for m,_ in results if m == "PASS")
f = sum(1 for m,_ in results if m == "FAIL")
print(f"TOTAL: {p} PASS, {f} FAIL")
sys.exit(0 if f == 0 else 1)