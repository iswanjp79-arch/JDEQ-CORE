# l5_m3_ledger.py — L5 Core M3
# SSOT Alignment + Integrity + Derived Ledger.
# Ledger = derived JSON. NOT authoritative. Rebuildable.
# No SQLite. No DB engine.

import json
import hashlib
import sys
from pathlib import Path
from dataclasses import dataclass, asdict, field
from datetime import datetime
from typing import Optional

sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\security")
sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\core")

from safe_path_resolver import ROOT_08_EVIDENCE
from l5_m1_reader import read_artifact
from l5_m2_mapper import build_envelope, envelope_to_dict, envelope_validate, ArtifactEnvelope

LEDGER_DIR = Path(r"D:\MICO_SSOT\09_GOVERNANCE\L5-LEDGER")
LEDGER_FILE = LEDGER_DIR / "ledger.json"
LEDGER_STATE_FILE = LEDGER_DIR / "ledger_state.json"
AUDIT_LOG = ROOT_08_EVIDENCE / "L5_SECURITY" / "l5_m3_ledger_audit.log"


def _audit(entry: dict) -> None:
    try:
        AUDIT_LOG.parent.mkdir(parents=True, exist_ok=True)
        line = (
            f"[{datetime.now().isoformat(timespec='seconds')}]"
            f" event={entry.get('event')}"
            f" label={entry.get('label')}"
            f" detail={entry.get('detail')!r}\n"
        )
        with open(AUDIT_LOG, "a", encoding="utf-8") as f:
            f.write(line)
    except Exception:
        pass


def verify_integrity(relative_path: str, expected_sha256: Optional[str] = None) -> dict:
    """Verify a physical file vs M1 hash. Returns status dict."""
    r = read_artifact(relative_path)
    if not r.is_ok:
        _audit({"event":"integrity","label":"UNAVAILABLE","detail":r.label})
        return {"status": "UNAVAILABLE", "reason": r.label, "sha256_hash": None}

    if expected_sha256 is None:
        status = "MATCH"
    elif r.sha256 == expected_sha256:
        status = "MATCH"
    else:
        status = "MISMATCH"

    _audit({"event":"integrity","label":status,"detail":f"path={r.path}"})
    return {"status": status, "reason": None, "sha256_hash": r.sha256}


def _iter_mature_files():
    """Enumerate files under LIVE / RETAIN / STAGING / QUARANTINE. No BUFFER."""
    for zone in ("LIVE", "RETAIN", "STAGING", "QUARANTINE"):
        zone_dir = ROOT_08_EVIDENCE / zone
        if not zone_dir.exists():
            continue
        for node_dir in zone_dir.iterdir():
            if not node_dir.is_dir():
                continue
            for fp in node_dir.rglob("*"):
                if not fp.is_file():
                    continue
                if fp.name.startswith(".") or fp.name.endswith(".tmp"):
                    continue
                if fp.suffix.lower() not in (".json", ".md", ".txt"):
                    continue
                rel = fp.relative_to(ROOT_08_EVIDENCE).as_posix()
                yield rel


def build_ledger() -> dict:
    """Rebuild ledger from physical files. Deterministic. Derived only."""
    entries = []
    zone_counts = {}
    for rel in _iter_mature_files():
        env = build_envelope(rel)
        if env.status == "REJECTED":
            continue
        zone = rel.split("/")[0]
        zone_counts[zone] = zone_counts.get(zone, 0) + 1
        entries.append({
            "artifact_id":        env.artifact_id,
            "source_node":        env.source_node,
            "file_path":          env.physical_locator.get("file_path"),
            "sha256_hash":        env.integrity.get("sha256_hash"),
            "last_write_time":    env.temporal.get("last_write_time"),
            "retention_class":    env.classification.get("retention_class"),
            "correlation_hash":   env.correlation.get("correlation_hash"),
            "zone":               zone,
        })

    entries.sort(key=lambda e: e["file_path"])

    ledger = {
        "derived":          True,
        "authoritative":    False,
        "rebuildable":      True,
        "contains_full_payload": False,
        "generated_at":     datetime.now().isoformat(timespec="seconds"),
        "host":             Path.home().name if Path.home() else "KAPAL-INDUK",
        "root":             str(ROOT_08_EVIDENCE),
        "count":            len(entries),
        "zone_counts":      zone_counts,
        "entries":          entries,
    }
    return ledger


def save_ledger(ledger: dict) -> str:
    LEDGER_DIR.mkdir(parents=True, exist_ok=True)
    tmp = LEDGER_FILE.with_suffix(".json.tmp")
    tmp.write_text(json.dumps(ledger, indent=2, ensure_ascii=False), encoding="utf-8")
    if LEDGER_FILE.exists():
        LEDGER_FILE.unlink()
    tmp.replace(LEDGER_FILE)

    # state hash
    sha = hashlib.sha256(LEDGER_FILE.read_bytes()).hexdigest()
    state = {
        "ledger_path": str(LEDGER_FILE),
        "sha256": sha,
        "count": ledger.get("count"),
        "generated_at": ledger.get("generated_at"),
        "derived": True,
        "rebuildable": True,
    }
    LEDGER_STATE_FILE.write_text(json.dumps(state, indent=2), encoding="utf-8")
    _audit({"event":"save_ledger","label":"OK","detail":f"count={ledger.get('count')} sha={sha[:16]}"})
    return str(LEDGER_FILE)


def ledger_status() -> dict:
    if not LEDGER_FILE.exists():
        return {"exists": False}
    data = json.loads(LEDGER_FILE.read_text(encoding="utf-8"))
    sha = hashlib.sha256(LEDGER_FILE.read_bytes()).hexdigest()
    return {
        "exists": True,
        "count": data.get("count"),
        "generated_at": data.get("generated_at"),
        "sha256": sha,
        "derived": data.get("derived", False),
        "authoritative": data.get("authoritative", True),
        "rebuildable": data.get("rebuildable", False),
    }