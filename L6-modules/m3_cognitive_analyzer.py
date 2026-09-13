# m3_cognitive_analyzer.py — L6-M3 Cognitive Analyzer
# Read-only. No L4/L5 mutation. No DB. No external deps.
# MODE SEPARATION:
#   PRODUCTION   -> reads L5 ledger, may return PENDING_REAL_DATA
#   TEST_FIXTURE -> pure in-memory, never reads ledger
# Every insight MUST carry evidence_ref (epistemic contract).

import json
import hashlib
import sys
from pathlib import Path
from dataclasses import dataclass, asdict, field
from datetime import datetime
from typing import Optional
from collections import Counter, defaultdict

sys.path.insert(0, r"D:\MICO_SSOT\L6-modules")
from m1_ledger_reader import read_ledger, L6_ROOT

AUDIT_LOG = L6_ROOT / "m3_analyzer_audit.log"

MODE_PRODUCTION   = "PRODUCTION"
MODE_TEST_FIXTURE = "TEST_FIXTURE"

NODES_EXPECTED = {"HP_Mini", "Z83", "Vivo", "Infinix", "Aspire"}
ZONES_EXPECTED = {"LIVE", "RETAIN", "STAGING", "QUARANTINE"}

TEMPORAL_GAP_HOURS       = 24
MEMORY_GUARD_MAX_ENTRIES = 100_000


def _audit(entry: dict) -> None:
    try:
        AUDIT_LOG.parent.mkdir(parents=True, exist_ok=True)
        line = (
            f"[{datetime.now().isoformat(timespec='seconds')}]"
            f" event={entry.get('event')}"
            f" label={entry.get('label')}"
            f" mode={entry.get('mode')}"
            f" reason={entry.get('reason')!r}"
            f" detail={entry.get('detail')!r}\n"
        )
        with open(AUDIT_LOG, "a", encoding="utf-8") as f:
            f.write(line)
    except Exception:
        pass


def _parse_iso(s):
    if not s:
        return None
    try:
        return datetime.fromisoformat(str(s).replace("Z", ""))
    except Exception:
        return None


# --- Analyzers (pure) ---
def analyze_zones(entries):
    c = Counter(e.get("zone") or "UNKNOWN" for e in entries)
    total = len(entries)
    dist = {z: {"count": n, "pct": round(100.0 * n / total, 2) if total else 0.0}
            for z, n in c.items()}
    return {"total": total, "distribution": dist}


def analyze_nodes(entries):
    c = Counter(e.get("source_node") or "UNKNOWN" for e in entries)
    total = len(entries)
    dist = {n: {"count": cnt, "pct": round(100.0 * cnt / total, 2) if total else 0.0}
            for n, cnt in c.items()}
    unexpected = sorted(set(c.keys()) - NODES_EXPECTED - {"UNKNOWN"})
    return {"total": total, "distribution": dist, "unexpected_nodes": unexpected}


def analyze_temporal(entries, gap_hours=TEMPORAL_GAP_HOURS):
    times = []
    for e in entries:
        t = _parse_iso(e.get("last_write_time"))
        if t is not None:
            times.append((e.get("artifact_id") or "?", t))
    times.sort(key=lambda x: x[1])
    gaps = []
    for i in range(1, len(times)):
        dt = (times[i][1] - times[i-1][1]).total_seconds()
        if dt >= gap_hours * 3600:
            gaps.append({
                "after":     times[i-1][1].isoformat(timespec="seconds"),
                "before":    times[i][1].isoformat(timespec="seconds"),
                "gap_hours": round(dt / 3600.0, 2),
                "from_id":   times[i-1][0],
                "to_id":     times[i][0],
            })
    return {
        "parsed_timestamps":  len(times),
        "unparseable":        len(entries) - len(times),
        "first":              times[0][1].isoformat(timespec="seconds")  if times else None,
        "last":               times[-1][1].isoformat(timespec="seconds") if times else None,
        "gaps":               gaps,
        "gap_threshold_hours": gap_hours,
    }


def analyze_correlation(entries):
    groups = defaultdict(list)
    for e in entries:
        ch = e.get("correlation_hash") or "MISSING"
        groups[ch].append(e.get("artifact_id"))
    dist = {k: {"count": len(v), "artifact_ids": v[:10]} for k, v in groups.items()}
    return {"group_count": len(groups), "groups": dist}


def detect_anomalies(entries):
    anomalies = []
    node_c = Counter(e.get("source_node") or "UNKNOWN" for e in entries)
    for n, c in node_c.items():
        if n not in NODES_EXPECTED and n != "UNKNOWN":
            anomalies.append({"type": "unexpected_node", "value": n, "count": c})
    zone_c = Counter(e.get("zone") or "UNKNOWN" for e in entries)
    for z, c in zone_c.items():
        if z not in ZONES_EXPECTED and z != "UNKNOWN":
            anomalies.append({"type": "unexpected_zone", "value": z, "count": c})
    for e in entries:
        if not e.get("sha256_hash"):
            anomalies.append({"type": "missing_sha256", "artifact_id": e.get("artifact_id")})
    return anomalies


def _build_insights(entries, zones, nodes, temporal, correlation, anomalies):
    insights = []
    if not entries:
        return insights
    if zones["distribution"]:
        top = max(zones["distribution"].items(), key=lambda x: x[1]["count"])
        insights.append({
            "finding":          "Dominant zone",
            "evidence_ref":     "zones.distribution",
            "fact":             f"zone={top[0]} count={top[1]['count']} pct={top[1]['pct']}",
            "interpretation":   "Storage activity concentrated in one zone",
            "recommendation":   None,
            "confidence":       0.5,
        })
    if temporal.get("gaps"):
        insights.append({
            "finding":          "Temporal gaps detected",
            "evidence_ref":     "temporal.gaps",
            "fact":             f"count={len(temporal['gaps'])} threshold_hours={temporal['gap_threshold_hours']}",
            "interpretation":   "Possible ingest interruption or low-activity window",
            "recommendation":   "Review schedule / check producer nodes around gap window",
            "confidence":       0.4,
        })
    if anomalies:
        insights.append({
            "finding":          "Anomalies detected",
            "evidence_ref":     "anomalies",
            "fact":             f"count={len(anomalies)}",
            "interpretation":   "Entries deviate from expected schema/distribution",
            "recommendation":   "Review anomalies before downstream analytics",
            "confidence":       0.6,
        })
    return insights


# --- Result dataclass ---
@dataclass
class AnalysisResult:
    run_id: str
    timestamp: str
    mode: str
    ledger_count: int
    status: str                # OK | PENDING_REAL_DATA | BLOCKED
    zones: dict
    nodes: dict
    temporal: dict
    correlation: dict
    anomalies: list
    insights: list
    input_ledger_sha256: Optional[str]
    reason: Optional[str]


def _run(entries, mode, run_id, ts, ledger_sha, empty_status):
    if len(entries) > MEMORY_GUARD_MAX_ENTRIES:
        _audit({"event":"run","label":"BLOCKED","mode":mode,"reason":"memory_guard_exceeded","detail":len(entries)})
        return AnalysisResult(run_id, ts, mode, len(entries), "BLOCKED",
            {}, {}, {}, {}, [], [], ledger_sha, "memory_guard_exceeded")
    if len(entries) == 0 and empty_status == "PENDING_REAL_DATA":
        _audit({"event":"run","label":"PENDING_REAL_DATA","mode":mode,"reason":"empty_ledger","detail":0})
        return AnalysisResult(run_id, ts, mode, 0, "PENDING_REAL_DATA",
            analyze_zones([]), analyze_nodes([]), analyze_temporal([]),
            analyze_correlation([]), [], [],
            ledger_sha, "empty_ledger")
    zones = analyze_zones(entries)
    nodes = analyze_nodes(entries)
    temporal = analyze_temporal(entries)
    correlation = analyze_correlation(entries)
    anomalies = detect_anomalies(entries)
    insights = _build_insights(entries, zones, nodes, temporal, correlation, anomalies)
    _audit({"event":"run","label":"OK","mode":mode,"reason":None,
            "detail":f"count={len(entries)} anomalies={len(anomalies)} insights={len(insights)}"})
    return AnalysisResult(run_id, ts, mode, len(entries), "OK",
        zones, nodes, temporal, correlation, anomalies, insights, ledger_sha, None)


def analyze_production():
    """Reads L5 ledger. Empty ledger -> PENDING_REAL_DATA."""
    ts = datetime.now().isoformat(timespec="seconds")
    run_id = datetime.now().strftime("L6M3_PRO_%Y%m%d_%H%M%S")
    lr = read_ledger()
    if lr.status != "OK":
        _audit({"event":"analyze_production","label":"BLOCKED","mode":MODE_PRODUCTION,
                "reason":"ledger_read_failed","detail":lr.reason})
        return AnalysisResult(run_id, ts, MODE_PRODUCTION, 0, "BLOCKED",
            {}, {}, {}, {}, [], [], None, "ledger_read_failed:" + str(lr.reason))
    entries = (lr.ledger_doc or {}).get("entries", [])
    return _run(entries, MODE_PRODUCTION, run_id, ts, lr.ledger_sha256, "PENDING_REAL_DATA")


def analyze_fixture(fixture_entries):
    """Pure in-memory. NEVER reads ledger. Fixture empty -> OK."""
    ts = datetime.now().isoformat(timespec="seconds")
    run_id = datetime.now().strftime("L6M3_FIX_%Y%m%d_%H%M%S")
    entries = list(fixture_entries or [])
    return _run(entries, MODE_TEST_FIXTURE, run_id, ts, None, "OK")


def save_result(result: AnalysisResult, out_dir: Path) -> str:
    out_dir.mkdir(parents=True, exist_ok=True)
    sub = "PRODUCTION" if result.mode == MODE_PRODUCTION else "TEST_FIXTURE"
    dest = out_dir / sub
    dest.mkdir(parents=True, exist_ok=True)
    out = dest / f"analysis_{result.run_id}.json"
    out.write_text(json.dumps(asdict(result), indent=2, ensure_ascii=False), encoding="utf-8")
    _audit({"event":"save_result","label":"OK","mode":result.mode,"reason":None,"detail":out.name})
    return str(out)