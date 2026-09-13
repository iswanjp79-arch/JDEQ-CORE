# stress_runner.py — L5 Security M4
# Sequential reader. Measure RSS. Pass = post-GC RSS <= baseline * 1.10
# Uses psutil. No parallelism. Deterministic input.

import gc
import json
import os
import sys
import time
import platform
from pathlib import Path
from datetime import datetime

try:
    import psutil
except ImportError:
    print("ERROR: psutil not installed")
    sys.exit(2)

sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\security")
from locked_schema_validator import create_safe_model

INPUT = Path(r"D:\MICO_SSOT\08_EVIDENCE\L5_SECURITY\stress_input")
OUT_JSON = Path(r"D:\MICO_SSOT\08_EVIDENCE\L5_SECURITY\stress_results.json")
OUT_LOG  = Path(r"D:\MICO_SSOT\08_EVIDENCE\L5_SECURITY\stress_log.txt")
CHECKPOINT_EVERY = 1000

ArtifactModel = create_safe_model("ArtifactStress", {
    "artifact_id": (str, ...),
    "source_node": (str, ...),
    "size_bytes":  (int, ...),
    "ts":          (str, ...),
    "seq":         (int, ...),
    "filler":      (str, ...),
})

def rss_mb():
    return psutil.Process(os.getpid()).memory_info().rss / (1024 * 1024)

def log(msg):
    print(msg)
    with open(OUT_LOG, "a", encoding="utf-8") as f:
        f.write(msg + "\n")

# fresh run — truncate log
OUT_LOG.write_text("", encoding="utf-8")
log(f"=== L5 Memory Stress Test ===")
log(f"timestamp : {datetime.now().isoformat(timespec='seconds')}")
log(f"host      : {platform.node()}")
log(f"python    : {sys.version.split()[0]}")
log(f"input     : {INPUT}")

files = sorted(INPUT.glob("*.json"))
log(f"files     : {len(files)}")
if len(files) == 0:
    log("BLOCKED: no input files")
    sys.exit(3)

gc.collect()
baseline = rss_mb()
log(f"baseline RSS: {baseline:.2f} MB")

samples = [{"seq": 0, "files_processed": 0, "rss_mb": baseline, "phase": "baseline"}]
peak = baseline
t0 = time.time()
errors = 0

for idx, fp in enumerate(files, 1):
    try:
        with open(fp, "r", encoding="utf-8") as f:
            data = json.load(f)
        ArtifactModel(**data)
    except Exception:
        errors += 1

    cur = rss_mb()
    if cur > peak:
        peak = cur

    if idx % CHECKPOINT_EVERY == 0:
        gc.collect()
        post_gc = rss_mb()
        samples.append({
            "seq": idx,
            "files_processed": idx,
            "rss_mb": round(post_gc, 3),
            "phase": "checkpoint_after_gc"
        })
        log(f"  [{idx:>5}/{len(files)}] rss={post_gc:7.2f} MB (peak={peak:.2f})")

duration = time.time() - t0
gc.collect()
final = rss_mb()

delta_pct = ((final - baseline) / baseline) * 100.0 if baseline > 0 else 0.0
pass_criteria = delta_pct <= 10.0 and errors == 0

result = {
    "test": "L5-M4-memory-stress",
    "timestamp": datetime.now().isoformat(timespec="seconds"),
    "host": platform.node(),
    "python": sys.version.split()[0],
    "input_dir": str(INPUT),
    "file_count": len(files),
    "errors": errors,
    "baseline_rss_mb": round(baseline, 3),
    "peak_rss_mb": round(peak, 3),
    "final_rss_mb": round(final, 3),
    "delta_pct": round(delta_pct, 3),
    "threshold_pct": 10.0,
    "duration_sec": round(duration, 2),
    "samples": samples,
    "result": "PASS" if pass_criteria else "FAIL",
}

with open(OUT_JSON, "w", encoding="utf-8") as f:
    json.dump(result, f, indent=2)

log("")
log(f"baseline : {baseline:.2f} MB")
log(f"peak     : {peak:.2f} MB")
log(f"final    : {final:.2f} MB")
log(f"delta    : {delta_pct:+.2f}% (threshold +10.00%)")
log(f"errors   : {errors}")
log(f"duration : {duration:.2f} s")
log(f"RESULT   : {result['result']}")

sys.exit(0 if pass_criteria else 1)