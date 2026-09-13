# test_l5_integration.py
# Full chain: L4 file -> M1 read -> M2 envelope -> M3 ledger -> BUF admission -> L6 contract

import sys, os, json, hashlib, shutil
from pathlib import Path
from datetime import datetime

sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\core")
sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\security")

from safe_path_resolver import ROOT_08_EVIDENCE
from l5_m1_reader import read_artifact
from l5_m2_mapper import build_envelope, envelope_to_dict, envelope_validate
from l5_m3_ledger import verify_integrity, build_ledger, save_ledger
from buf_004_admission_guard import admit, assert_no_buffer_write

AUDIT_LOG = ROOT_08_EVIDENCE / "L5_SECURITY" / "l5_integration_audit.log"

def log(msg):
    print(msg)
    with open(AUDIT_LOG, "a", encoding="utf-8") as f:
        f.write(msg + "\n")

results = []
def check(name, cond, detail=""):
    mark = "PASS" if cond else "FAIL"
    results.append((mark, name))
    log(f"[{mark}] {name}  {detail}")

log("=" * 80)
log("L5 INTEGRATION TEST — START")
log(f"timestamp : {datetime.now().isoformat(timespec='seconds')}")
log(f"host      : {os.environ.get('COMPUTERNAME','?')}")
log("=" * 80)

# --- Setup ---
live = ROOT_08_EVIDENCE / "LIVE" / "HP_Mini"
live.mkdir(parents=True, exist_ok=True)

# --- E2E Test 1: happy path ---
f1 = live / "e2e_ok.json"
content1 = json.dumps({"artifact": "test", "value": 42})
f1.write_text(content1, encoding="utf-8")
sha1 = hashlib.sha256(content1.encode("utf-8")).hexdigest()

# Step A: BUF admit
a = admit("LIVE/HP_Mini/e2e_ok.json")
check("I01 BUF admit LIVE", a["allow"], f"reason={a['reason']}")

# Step B: M1 read
r = read_artifact("LIVE/HP_Mini/e2e_ok.json")
check("I02 M1 read OK", r.is_ok and r.sha256 == sha1)

# Step C: M2 envelope
env = build_envelope("LIVE/HP_Mini/e2e_ok.json")
check("I03 M2 envelope ready", env.status == "ABSTRACTION_READY",
      f"status={env.status}")
d = envelope_to_dict(env)
check("I04 envelope valid", envelope_validate(env)["ok"], f"issues={envelope_validate(env)['issues']}")

# Step D: M3 integrity
v = verify_integrity("LIVE/HP_Mini/e2e_ok.json", sha1)
check("I05 M3 integrity MATCH", v["status"] == "MATCH")

# Step E: physical L4 unchanged
f1_after = f1.read_bytes()
check("I06 physical L4 unchanged", f1_after.decode("utf-8") == content1)

# --- E2E Test 2: 5-node matrix ---
for node in ["HP_Mini","Z83","Vivo","Infinix","Aspire"]:
    d2 = ROOT_08_EVIDENCE / "LIVE" / node
    d2.mkdir(parents=True, exist_ok=True)
    fp = d2 / f"e2e_{node.lower()}.json"
    fp.write_text(json.dumps({"node": node}), encoding="utf-8")

envs = []
for node in ["HP_Mini","Z83","Vivo","Infinix","Aspire"]:
    e = build_envelope(f"LIVE/{node}/e2e_{node.lower()}.json")
    envs.append((node, e))
check("I07 5-node envelopes ready", all(e.status == "ABSTRACTION_READY" for _, e in envs))
check("I08 5-node source match", all(e.source_node == n for n, e in envs))

# --- E2E Test 3: BUFFER rejected across chain ---
buf = ROOT_08_EVIDENCE / "BUFFER" / "HP_Mini"
buf.mkdir(parents=True, exist_ok=True)
fb = buf / "e2e_buf.json"
fb.write_text("{}", encoding="utf-8")
ab = admit("BUFFER/HP_Mini/e2e_buf.json")
rb = read_artifact("BUFFER/HP_Mini/e2e_buf.json")
eb = build_envelope("BUFFER/HP_Mini/e2e_buf.json")
check("I09 BUFFER rejected all layers",
      (not ab["allow"]) and (not rb.is_ok) and eb.status == "REJECTED")

# --- E2E Test 4: full ledger rebuild ---
led = build_ledger()
check("I10 ledger rebuild OK", led["count"] >= 6 and led["derived"] and not led["authoritative"])
check("I11 ledger zone_counts", "LIVE" in led["zone_counts"] and led["zone_counts"]["LIVE"] >= 6,
      f"zones={led['zone_counts']}")

# --- E2E Test 5: deterministic correlation for same file ---
e1 = build_envelope("LIVE/HP_Mini/e2e_ok.json")
e2 = build_envelope("LIVE/HP_Mini/e2e_ok.json")
check("I12 correlation deterministic", e1.correlation["correlation_hash"] == e2.correlation["correlation_hash"])
check("I13 artifact_id deterministic", e1.artifact_id == e2.artifact_id)

# --- E2E Test 6: L4 boundary invariants ---
inv = assert_no_buffer_write()
check("I14 no buffer write", inv["L5_write_buffer"] is False and inv["buffer_owner"] == "L4")

# --- E2E Test 7: no sqlite in L5 scope ---
l5_scope = [
    Path(r"D:\MICO_SSOT\L5-modules"),
    Path(r"D:\MICO_SSOT\09_GOVERNANCE\L5-LEDGER"),
]
hits = []
for p in l5_scope:
    if p.exists():
        hits += list(p.rglob("*.db")) + list(p.rglob("*.sqlite")) + list(p.rglob("*.sqlite3"))
check("I15 no sqlite", len(hits) == 0, f"hits={len(hits)}")

# --- E2E Test 8: no broker/cloud references ---
l5_core = Path(r"D:\MICO_SSOT\L5-modules\core")
broker_patterns = ["kafka","rabbitmq","redis","sqs"]
found_broker = []
for fp in l5_core.glob("*.py"):
    txt = fp.read_text(encoding="utf-8", errors="ignore").lower()
    for bp in broker_patterns:
        if bp in txt:
            found_broker.append(f"{fp.name}:{bp}")
check("I16 no broker refs", len(found_broker) == 0, f"found={found_broker}")

# --- E2E Test 9: envelope metadata/payload separation ---
d = envelope_to_dict(e1)
meta_keys = {"artifact_id","source_node","physical_locator","classification","integrity","temporal","correlation","status"}
check("I17 metadata/payload separated", meta_keys.issubset(set(d.keys())) and isinstance(d["payload"], dict))

# --- E2E Test 10: L6 contract shape ---
# L6 receives ArtifactEnvelope. Validate minimum required fields.
l6_required = ["artifact_id","source_node","physical_locator","classification","integrity","temporal","correlation","payload","status"]
check("I18 L6 contract ready", all(k in d for k in l6_required))

# --- Cleanup ---
for fp in [f1, fb]:
    try: fp.unlink()
    except Exception: pass
for node in ["HP_Mini","Z83","Vivo","Infinix","Aspire"]:
    p = ROOT_08_EVIDENCE / "LIVE" / node / f"e2e_{node.lower()}.json"
    try: p.unlink()
    except Exception: pass

log("=" * 80)
p = sum(1 for m,_ in results if m == "PASS")
f = sum(1 for m,_ in results if m == "FAIL")
log(f"TOTAL: {p} PASS, {f} FAIL")
log("=" * 80)
sys.exit(0 if f == 0 else 1)