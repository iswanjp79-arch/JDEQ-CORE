# generate_stress_input.py — L5 Security M4
# Generate deterministic JSON files under 08_EVIDENCE/L5_SECURITY/stress_input/

import json
import os
import random
import hashlib
from pathlib import Path

OUT = Path(r"D:\MICO_SSOT\08_EVIDENCE\L5_SECURITY\stress_input")
OUT.mkdir(parents=True, exist_ok=True)

N = 10000
SEED = 20260914
random.seed(SEED)

# deterministic size range 2-8 KiB
def make_payload(i):
    target = 2048 + (i * 7) % 6144   # 2-8 KiB-ish
    filler = "x" * max(0, target - 256)
    return {
        "artifact_id": hashlib.sha256(f"art-{i}".encode()).hexdigest()[:16],
        "source_node": ["HP_Mini","Z83","Vivo","Infinix","Aspire"][i % 5],
        "size_bytes": target,
        "ts": f"2026-09-14T02:{i%60:02d}:00",
        "seq": i,
        "filler": filler,
    }

created = 0
for i in range(N):
    p = make_payload(i)
    fn = OUT / f"art_{i:05d}.json"
    with open(fn, "w", encoding="utf-8", newline="\n") as f:
        json.dump(p, f, ensure_ascii=False)
    created += 1
    if i % 2000 == 0 and i > 0:
        print(f"  generated {i}")

print(f"TOTAL: {created} files in {OUT}")