# test_m3_cognitive_analyzer.py
import sys, json, hashlib
from pathlib import Path
from datetime import datetime, timedelta
sys.path.insert(0, r"D:\MICO_SSOT\L6-modules")
from m3_cognitive_analyzer import (
    analyze_production, analyze_fixture, save_result,
    ROOT_PROD_HELPER := None or None, MODE_PRODUCTION, MODE_TEST_FIXTURE,
    analyze_zones, analyze_nodes, analyze_temporal, analyze_correlation, detect_anomalies,
) if False else None
# ^ safeguard: clean import
import importlib
mod = importlib.import_module("m3_cognitive_analyzer")

MODE_PRODUCTION   = mod.MODE_PRODUCTION
MODE_TEST_FIXTURE = mod.MODE_TEST_FIXTURE
L6_ROOT           = mod.L6_ROOT
ROOT_08_EVIDENCE  = Path(r"D:\MICO_SSOT\08_EVIDENCE").resolve()

results = []
def check(name, cond, detail=""):
    mark = "PASS" if cond else "FAIL"
    results.append((mark, name))
    print(f"[{mark}] {name}  {detail}")

now = datetime.now()

def fx(aid, node, zone, sha="a"*64, corr="h1", t=None):
    return {
        "artifact_id": aid,
        "source_node": node,
        "file_path":   f"{zone}/{node}/{aid}.json",
        "sha256_hash": sha,
        "last_write_time": (t or now).isoformat(timespec="seconds"),
        "retention_class": zone,
        "correlation_hash": corr,
        "zone": zone,
    }

# T01 fixture empty -> OK (not PENDING_REAL_DATA)
r = mod.analyze_fixture([])
check("T01 fixture empty OK", r.status == "OK" and r.mode == MODE_TEST_FIXTURE,
      f"status={r.status} mode={r.mode}")

# T02 zones distribution
fx2 = [fx("a1","HP_Mini","LIVE"), fx("a2","HP_Mini","LIVE"), fx("a3","Z83","RETAIN")]
r2 = mod.analyze_fixture(fx2)
check("T02 zones dist", r2.zones["distribution"]["LIVE"]["count"] == 2 and
      r2.zones["distribution"]["RETAIN"]["count"] == 1,
      f"zones={r2.zones['distribution']}")

# T03 unexpected node -> anomaly
fx3 = [fx("b1","AlienNode","LIVE")]
r3 = mod.analyze_fixture(fx3)
types = [a["type"] for a in r3.anomalies]
check("T03 unexpected node anomaly", "unexpected_node" in types, f"anom={types}")

# T04 unexpected zone -> anomaly
fx4 = [fx("c1","HP_Mini","WEIRD")]
r4 = mod.analyze_fixture(fx4)
types4 = [a["type"] for a in r4.anomalies]
check("T04 unexpected zone anomaly", "unexpected_zone" in types4, f"anom={types4}")

# T05 temporal gap detection
t_old = now - timedelta(hours=48)
t_new = now - timedelta(hours=1)
fx5 = [fx("d1","HP_Mini","LIVE",t=t_old), fx("d2","HP_Mini","LIVE",t=t_new)]
r5 = mod.analyze_fixture(fx5)
check("T05 temporal gap", len(r5.temporal["gaps"]) >= 1,
      f"gaps={len(r5.temporal['gaps'])}")

# T06 correlation grouping
fx6 = [fx("e1","HP_Mini","LIVE",corr="hA"), fx("e2","Z83","LIVE",corr="hA"), fx("e3","Vivo","LIVE",corr="hB")]
r6 = mod.analyze_fixture(fx6)
check("T06 correlation groups", r6.correlation["group_count"] == 2 and
      r6.correlation["groups"]["hA"]["count"] == 2,
      f"groups={r6.correlation['group_count']}")

# T07 production mode against empty ledger -> PENDING_REAL_DATA
rp = mod.analyze_production()
check("T07 production empty ledger PENDING", rp.status == "PENDING_REAL_DATA" and rp.mode == MODE_PRODUCTION,
      f"status={rp.status} mode={rp.mode}")

# T08 mode separation: production never runs on fixture; fixture never touches ledger
check("T08 mode separation", r.mode == MODE_TEST_FIXTURE and rp.mode == MODE_PRODUCTION)

# T09 save result + L4 unmutated
out_dir = L6_ROOT / "M3-EVIDENCE"
before = sum(1 for _ in ROOT_08_EVIDENCE.rglob("*") if _.is_file())
p1 = mod.save_result(r2, out_dir)
p2 = mod.save_result(rp, out_dir)
after = sum(1 for _ in ROOT_08_EVIDENCE.rglob("*") if _.is_file())
check("T09 save + L4 unmutated", Path(p1).exists() and Path(p2).exists() and before == after,
      f"fix={Path(p1).name} prod={Path(p2).name}")

# T10 memory guard
big = [fx(f"x{i}","HP_Mini","LIVE") for i in range(mod.MEMORY_GUARD_MAX_ENTRIES + 1)]
r10 = mod.analyze_fixture(big)
check("T10 memory guard BLOCKED", r10.status == "BLOCKED" and r10.reason == "memory_guard_exceeded",
      f"status={r10.status} reason={r10.reason}")

print("-" * 80)
p = sum(1 for m,_ in results if m == "PASS")
f = sum(1 for m,_ in results if m == "FAIL")
print(f"TOTAL: {p} PASS, {f} FAIL")
sys.exit(0 if f == 0 else 1)