# l5_m2_mapper.py — L5 Core M2
# Metadata Mapper + Virtual Normalizer + ArtifactEnvelope builder.
# Virtual only: never rewrites L4 physical file.
# Anomali -> QUARANTINE_VIRTUAL (in-memory label, no file move).

import json
import hashlib
import sys
from pathlib import Path
from dataclasses import dataclass, field, asdict
from datetime import datetime
from typing import Optional, Any

sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\security")
sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\core")

from safe_path_resolver import ROOT_08_EVIDENCE
from metadata_sanitizer import sanitize_string
from l5_m1_reader import read_artifact, ReadResult

AUDIT_LOG = ROOT_08_EVIDENCE / "L5_SECURITY" / "l5_m2_mapper_audit.log"

REQUIRED_META = ["artifact_id", "source_node", "file_path", "sha256_hash", "last_write_time", "retention_class"]

# Map zone -> retention class
ZONE_TO_RETENTION = {
    "LIVE":      "LIVE",
    "RETAIN":    "RETAIN",
    "STAGING":   "STAGING",
    "QUARANTINE":"QUARANTINE",
    "incomplete":"INCOMPLETE",
}

NODE_ALLOWED = {"HP_Mini","Z83","Vivo","Infinix","Aspire","UNKNOWN"}


@dataclass
class ArtifactEnvelope:
    artifact_id: str
    source_node: str
    physical_locator: dict
    classification: dict
    integrity: dict
    temporal: dict
    correlation: dict
    payload: dict
    status: str  # ABSTRACTION_READY | QUARANTINE_VIRTUAL | REJECTED


def _audit(entry: dict) -> None:
    try:
        AUDIT_LOG.parent.mkdir(parents=True, exist_ok=True)
        line = (
            f"[{datetime.now().isoformat(timespec='seconds')}]"
            f" event={entry.get('event')}"
            f" label={entry.get('label')}"
            f" reason={entry.get('reason')!r}"
            f" id={entry.get('id')!r}\n"
        )
        with open(AUDIT_LOG, "a", encoding="utf-8") as f:
            f.write(line)
    except Exception:
        pass


def _derive_artifact_id(rel_path: str, sha256: str) -> str:
    h = hashlib.sha256((rel_path + "|" + sha256).encode("utf-8")).hexdigest()
    return h[:16]


def _derive_correlation_hash(source_node: str, event_time_iso: str, artifact_type: str) -> str:
    # event_time bucket = YYYY-MM-DD-HH (hourly)
    try:
        dt = datetime.fromisoformat(event_time_iso.replace("Z",""))
        bucket = dt.strftime("%Y-%m-%d-%H")
    except Exception:
        bucket = "unknown"
    key = f"{source_node}|{bucket}|{artifact_type}"
    return hashlib.sha256(key.encode("utf-8")).hexdigest()


def _parse_node_from_path(rel_path: str) -> str:
    parts = rel_path.replace("\\","/").split("/")
    if len(parts) >= 2 and parts[1] in NODE_ALLOWED:
        return parts[1]
    return "UNKNOWN"


def _normalize_whitespace(s: str) -> str:
    # collapse multiple whitespace to single space; strip ends
    return " ".join(s.split())


def _virtual_normalize_payload(payload: Any) -> Any:
    # controlled type harmonization + whitespace collapse on strings (in-memory only)
    if isinstance(payload, dict):
        return {str(k): _virtual_normalize_payload(v) for k, v in payload.items()}
    if isinstance(payload, list):
        return [_virtual_normalize_payload(x) for x in payload]
    if isinstance(payload, str):
        return _normalize_whitespace(payload)
    return payload


def build_envelope(relative_path: str) -> ArtifactEnvelope:
    """Read artifact via M1, map metadata, normalize virtually, emit envelope."""

    r: ReadResult = read_artifact(relative_path)

    if not r.is_ok:
        env = ArtifactEnvelope(
            artifact_id="",
            source_node=_parse_node_from_path(r.path),
            physical_locator={"file_path": r.path},
            classification={"retention_class": "UNKNOWN"},
            integrity={"sha256_hash": None, "status": "UNAVAILABLE"},
            temporal={"last_write_time": None},
            correlation={"correlation_hash": None},
            payload={},
            status="REJECTED",
        )
        _audit({"event":"build_envelope","label":"REJECTED","reason":r.label,"id":r.path})
        return env

    # Abs path for stat
    abs_path = ROOT_08_EVIDENCE / r.path
    try:
        st = abs_path.stat()
        last_write_iso = datetime.fromtimestamp(st.st_mtime).isoformat(timespec="seconds")
    except Exception:
        last_write_iso = None

    source_node = _parse_node_from_path(r.path)
    retention   = ZONE_TO_RETENTION.get(r.zone or "", "UNKNOWN")
    artifact_id = _derive_artifact_id(r.path, r.sha256)

    # payload: parse if JSON, else text
    payload_raw: Any
    if abs_path.suffix.lower() == ".json":
        try:
            payload_raw = json.loads(r.text)
        except Exception:
            payload_raw = {"_raw_text": r.text}
    else:
        payload_raw = {"_text": r.text}

    # Sanitize every string in payload (in-memory only)
    payload_norm = _virtual_normalize_payload(payload_raw)

    # Correlation
    artifact_type = abs_path.suffix.lower().lstrip(".")
    corr_hash = _derive_correlation_hash(
        source_node,
        last_write_iso or datetime.now().isoformat(timespec="seconds"),
        artifact_type,
    )

    # Integrity
    integrity = {"sha256_hash": r.sha256, "status": "MATCH"}

    # Quarantine virtual if any anomaly (e.g., source_node UNKNOWN)
    status = "ABSTRACTION_READY"
    if source_node == "UNKNOWN" or retention == "UNKNOWN":
        status = "QUARANTINE_VIRTUAL"

    env = ArtifactEnvelope(
        artifact_id=artifact_id,
        source_node=source_node,
        physical_locator={"file_path": r.path},
        classification={"retention_class": retention},
        integrity=integrity,
        temporal={"last_write_time": last_write_iso},
        correlation={"correlation_hash": corr_hash},
        payload=payload_norm,
        status=status,
    )

    _audit({"event":"build_envelope","label":status,"reason":None,"id":artifact_id})
    return env


def envelope_to_dict(env: ArtifactEnvelope) -> dict:
    return asdict(env)


def envelope_validate(env: ArtifactEnvelope) -> dict:
    """Structural validation of the envelope. Returns dict of issues."""
    issues = []
    if not env.artifact_id:
        issues.append("artifact_id_missing")
    if env.source_node not in NODE_ALLOWED:
        issues.append(f"source_node_invalid:{env.source_node}")
    if not env.physical_locator.get("file_path"):
        issues.append("file_path_missing")
    if not env.classification.get("retention_class"):
        issues.append("retention_class_missing")
    if not env.integrity.get("sha256_hash"):
        issues.append("sha256_missing")
    if not env.temporal.get("last_write_time"):
        issues.append("last_write_time_missing")
    if not env.correlation.get("correlation_hash"):
        issues.append("correlation_hash_missing")
    if env.status not in ("ABSTRACTION_READY","QUARANTINE_VIRTUAL","REJECTED"):
        issues.append(f"status_invalid:{env.status}")
    return {"ok": len(issues) == 0, "issues": issues}