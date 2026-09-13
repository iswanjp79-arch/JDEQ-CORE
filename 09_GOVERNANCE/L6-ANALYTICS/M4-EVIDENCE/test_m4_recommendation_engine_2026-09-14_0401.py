# test_m4_recommendation_engine.py
import sys, json, importlib
from pathlib import Path
from datetime import datetime

sys.path.insert(0, r"D:\MICO_SSOT\L6-modules")
mod = importlib.import_module("m4_recommendation_engine")

MODE_PRODUCTION   = mod.MODE_PRODUCTION
MODE_TEST_FIXTURE = mod.MODE_TEST_FIXTURE
L6_ROOT           = mod.L6_ROOT
ROOT_08_EVIDENCE  = Path(r"D:\MICO_SSOT\08_EVIDENCE").resolve()

results = []
def check(name, cond, detail=""):
    mark = "PASS" if cond else "FAIL"
    results.append((mark, name))
    print(f"[{mark}] {name}  {detail}")

def mkf(finding, ref="x.ref", fact="some fact", conf=0.5):
    return {
        "finding":         finding,
        "evidence_ref":    ref,
        "fact":            fact,
        "interpretation":  "test interp",
        "recommendation":  None,
        "confidence":      conf,
    }

# T01 valid finding -> recommendation
r1 = mod.recommend_from_m3_fixture([mkf("Temporal gaps detected", conf=0.6)])
ok1 = (r1.status == "OK" and len(r1.recommendations) == 1
       and r1.recommendations[0]["recommendation_id"].startswith("REC_")
       and r1.recommendations[0]["evidence_ref"] == "x.ref")
check("T01 valid finding -> rec", ok1,
      f"status={r1.status} n_rec={len(r1.recommendations)}")

# T02 finding without evidence_ref -> BLOCK (blocked_findings, not added)
bad = {"finding":"Anomalies detected","fact":"some","confidence":0.5}  # no evidence_ref
r2 = mod.recommend_from_m3_fixture([bad])
ok2 = (r2.status == "OK" and len(r2.recommendations) == 0
       and len(r2.blocked_findings) == 1
       and r2.blocked_findings[0]["reason"] == "missing_evidence_ref")
check("T02 no evidence -> block", ok2,
      f"recs={len(r2.recommendations)} blocked={r2.blocked_findings}")

# T03 low-confidence finding preserved as low-conf recommendation
r3 = mod.recommend_from_m3_fixture([mkf("Anomalies detected", conf=0.20)])
ok3 = (r3.status == "OK" and len(r3.recommendations) == 1
       and r3.recommendations[0]["confidence"] == 0.20)
check("T03 low-conf preserved", ok3,
      f"conf={r3.recommendations[0]['confidence'] if r3.recommendations else None}")

# T04 conflicting findings (both survive with distinct rec ids)
f_a = mkf("Dominant zone", ref="zones.distribution", fact="LIVE dominant", conf=0.5)
f_b = mkf("Anomalies detected", ref="anomalies", fact="anom present", conf=0.6)
r4 = mod.recommend_from_m3_fixture([f_a, f_b])
ids = [r["recommendation_id"] for r in r4.recommendations]
ok4 = (r4.status == "OK" and len(r4.recommendations) == 2 and ids[0] != ids[1])
check("T04 conflicting findings -> 2 recs", ok4, f"ids={ids}")

# T05 empty production ledger -> PENDING_REAL_DATA
rp = mod.recommend_from_m3_production()
ok5 = (rp.status == "PENDING_REAL_DATA" and rp.mode == MODE_PRODUCTION
       and len(rp.recommendations) == 0)
check("T05 empty production -> PENDING_REAL_DATA", ok5,
      f"status={rp.status} mode={rp.mode} recs={len(rp.recommendations)}")

# T06 fixture/production separation
ok6 = (r1.mode == MODE_TEST_FIXTURE and rp.mode == MODE_PRODUCTION)
check("T06 mode separation", ok6, f"fix={r1.mode} prod={rp.mode}")

# T07 L4/L5 mutation = 0 (file count in 08_EVIDENCE unchanged)
before = sum(1 for _ in ROOT_08_EVIDENCE.rglob("*") if _.is_file())
_ = mod.recommend_from_m3_fixture([mkf("Temporal gaps detected")])
_ = mod.recommend_from_m3_production()
after = sum(1 for _ in ROOT_08_EVIDENCE.rglob("*") if _.is_file())
check("T07 L4/L5 mutation = 0", before == after, f"before={before} after={after}")

# T08 memory/resource guard
big = [mkf(f"finding_{i}", ref=f"r{i}", fact=f"f{i}", conf=0.5)
       for i in range(mod.MEMORY_GUARD_MAX_FINDINGS + 1)]
r8 = mod.recommend_from_m3_fixture(big)
ok8 = (r8.status == "BLOCKED" and r8.reason == "memory_guard_exceeded")
check("T08 memory guard BLOCKED", ok8, f"status={r8.status} reason={r8.reason}")

print("-" * 80)
p = sum(1 for m,_ in results if m == "PASS")
f = sum(1 for m,_ in results if m == "FAIL")
print(f"TOTAL: {p} PASS, {f} FAIL")
sys.exit(0 if f == 0 else 1)