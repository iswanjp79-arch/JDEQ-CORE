# m4_recommendation_engine.py — L6-M4 Recommendation Engine
# READ-ONLY. No L4/L5 mutation. No DB. No broker. No cloud.
# Reads verified M3 analysis result. Classifies findings. Generates recommendations.
# Each recommendation MUST carry: recommendation_id, evidence_ref, fact, reasoning,
#                                 action, confidence, mode.
# MODE SEPARATION: PRODUCTION vs TEST_FIXTURE — never mixed.

import json
import hashlib
import sys
from pathlib import Path
from dataclasses import dataclass, asdict, field
from datetime import datetime
from typing import Optional

sys.path.insert(0, r"D:\MICO_SSOT\L6-modules")
from m3_cognitive_analyzer import (
    analyze_production as m3_analyze_production,
    analyze_fixture    as m3_analyze_fixture,
    MODE_PRODUCTION,
    MODE_TEST_FIXTURE,
)

L6_ROOT = Path(r"D:\MICO_SSOT\09_GOVERNANCE\L6-ANALYTICS")
AUDIT_LOG = L6_ROOT / "m4_recommender_audit.log"

MEMORY_GUARD_MAX_FINDINGS = 10_000

# Confidence thresholds
CONF_LOW  = 0.30
CONF_HIGH = 0.75


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


@dataclass
class Recommendation:
    recommendation_id: str
    evidence_ref: str
    fact: str
    reasoning: str
    action: str
    confidence: float
    mode: str
    source_finding: Optional[str] = None


@dataclass
class RecommendationResult:
    run_id: str
    timestamp: str
    mode: str
    input_findings: int
    status: str          # OK | PENDING_REAL_DATA | BLOCKED
    recommendations: list
    blocked_findings: list
    reason: Optional[str]


def _hash_rec_id(mode: str, evidence_ref: str, action: str) -> str:
    h = hashlib.sha256(f"{mode}|{evidence_ref}|{action}".encode("utf-8")).hexdigest()
    return "REC_" + h[:12]


def _classify_finding(f):
    """Return classification string based on finding text. No fabrication."""
    text = (f.get("finding") or "").lower()
    if "gap" in text:           return "TEMPORAL"
    if "dominant" in text:      return "DISTRIBUTION"
    if "anomal" in text:        return "ANOMALY"
    return "GENERIC"


def _validate_finding(f):
    """Return None if valid, else reason for block."""
    if not isinstance(f, dict):
        return "finding_not_dict"
    if not f.get("evidence_ref"):
        return "missing_evidence_ref"
    if not f.get("fact"):
        return "missing_fact"
    conf = f.get("confidence")
    if conf is None or not isinstance(conf, (int, float)):
        return "missing_or_invalid_confidence"
    if not (0.0 <= float(conf) <= 1.0):
        return "confidence_out_of_range"
    return None


def _action_for(classification: str, f: dict) -> str:
    if classification == "TEMPORAL":
        return "Review ingest schedule; verify producer node uptime around gap window."
    if classification == "ANOMALY":
        return "Review anomalous entries; consider quarantine until schema verified."
    if classification == "DISTRIBUTION":
        return "Monitor distribution drift; compare with baseline when more data is available."
    return "Log for future review; insufficient classification signal."


def _generate_recommendation(f, mode: str):
    classification = _classify_finding(f)
    evidence_ref = f.get("evidence_ref", "")
    fact = f.get("fact", "")
    conf = float(f.get("confidence", 0.0))
    reasoning = f"finding='{classification}' fact='{fact}' source_finding='{f.get('finding')}'"
    action = _action_for(classification, f)
    rid = _hash_rec_id(mode, evidence_ref, action)
    return Recommendation(
        recommendation_id=rid,
        evidence_ref=evidence_ref,
        fact=fact,
        reasoning=reasoning,
        action=action,
        confidence=conf,
        mode=mode,
        source_finding=f.get("finding"),
    )


def _process_findings(findings, mode, run_id):
    if len(findings) > MEMORY_GUARD_MAX_FINDINGS:
        _audit({"event":"process","label":"BLOCKED","mode":mode,
                "reason":"memory_guard_exceeded","detail":len(findings)})
        return RecommendationResult(
            run_id=run_id, timestamp=datetime.now().isoformat(timespec="seconds"),
            mode=mode, input_findings=len(findings), status="BLOCKED",
            recommendations=[], blocked_findings=[{"reason":"memory_guard_exceeded"}],
            reason="memory_guard_exceeded",
        )

    recs = []
    blocked = []
    for f in findings:
        err = _validate_finding(f)
        if err:
            blocked.append({
                "source_finding": (f.get("finding") if isinstance(f, dict) else None),
                "reason": err,
            })
            _audit({"event":"validate_finding","label":"BLOCKED","mode":mode,
                    "reason":err,"detail":(f.get("finding") if isinstance(f, dict) else None)})
            continue
        rec = _generate_recommendation(f, mode)
        recs.append(asdict(rec))

    return RecommendationResult(
        run_id=run_id,
        timestamp=datetime.now().isoformat(timespec="seconds"),
        mode=mode,
        input_findings=len(findings),
        status="OK",
        recommendations=recs,
        blocked_findings=blocked,
        reason=None,
    )


def recommend_from_m3_production():
    """Reads M3 production result (which reads L5 ledger).
       Empty ledger -> M3 returns PENDING_REAL_DATA -> M4 returns PENDING_REAL_DATA."""
    run_id = datetime.now().strftime("L6M4_PRO_%Y%m%d_%H%M%S")

    m3 = m3_analyze_production()
    if m3.status == "PENDING_REAL_DATA":
        _audit({"event":"recommend","label":"PENDING_REAL_DATA","mode":MODE_PRODUCTION,
                "reason":"m3_production_empty","detail":m3.ledger_count})
        return RecommendationResult(
            run_id=run_id, timestamp=datetime.now().isoformat(timespec="seconds"),
            mode=MODE_PRODUCTION, input_findings=0, status="PENDING_REAL_DATA",
            recommendations=[], blocked_findings=[], reason="m3_production_empty",
        )
    if m3.status != "OK":
        _audit({"event":"recommend","label":"BLOCKED","mode":MODE_PRODUCTION,
                "reason":"m3_status_" + str(m3.status),"detail":None})
        return RecommendationResult(
            run_id=run_id, timestamp=datetime.now().isoformat(timespec="seconds"),
            mode=MODE_PRODUCTION, input_findings=0, status="BLOCKED",
            recommendations=[], blocked_findings=[], reason="m3_status_" + str(m3.status),
        )

    findings = m3.insights or []
    return _process_findings(findings, MODE_PRODUCTION, run_id)


def recommend_from_m3_fixture(fixture_findings):
    """Pure: takes already-shaped findings. Never reads ledger.
       Use M3 fixture helpers to build findings if needed."""
    run_id = datetime.now().strftime("L6M4_FIX_%Y%m%d_%H%M%S")
    findings = list(fixture_findings or [])
    return _process_findings(findings, MODE_TEST_FIXTURE, run_id)


def save_result(result: RecommendationResult, out_dir: Path) -> str:
    out_dir.mkdir(parents=True, exist_ok=True)
    sub = "PRODUCTION" if result.mode == MODE_PRODUCTION else "TEST_FIXTURE"
    dest = out_dir / sub
    dest.mkdir(parents=True, exist_ok=True)
    out = dest / f"recommendation_{result.run_id}.json"
    out.write_text(json.dumps(asdict(result), indent=2, ensure_ascii=False), encoding="utf-8")
    _audit({"event":"save_result","label":"OK","mode":result.mode,"reason":None,"detail":out.name})
    return str(out)