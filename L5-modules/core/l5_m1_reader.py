# l5_m1_reader.py — L5 Core M1 Logical Reader
# Read mature L4 artifacts. REJECT .tmp and BUFFER.
# Verify SHA-256. Emit in-memory representation. No mutation.

import json
import hashlib
import sys
from pathlib import Path
from dataclasses import dataclass, field
from datetime import datetime
from typing import Optional, Any

sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\security")
from safe_path_resolver import resolve_safe, ROOT_08_EVIDENCE

AUDIT_LOG = ROOT_08_EVIDENCE / "L5_SECURITY" / "l5_m1_reader_audit.log"

ALLOWED_EXT = {".json", ".md", ".txt"}
FORBIDDEN_ZONES = {"BUFFER", "incomplete", "DISPOSABLE"}


@dataclass
class ReadResult:
    path: str
    is_ok: bool
    content_bytes: Optional[bytes]
    text: Optional[str]
    sha256: Optional[str]
    size_bytes: int
    label: str          # OK | REJECTED_TMP | REJECTED_ZONE | INTEGRITY_CONFLICT | NOT_FOUND | UNREADABLE | ENCODING_ERROR | FORMAT_ERROR
    reason: Optional[str]
    zone: Optional[str]


def _audit(entry: dict) -> None:
    try:
        AUDIT_LOG.parent.mkdir(parents=True, exist_ok=True)
        line = (
            f"[{datetime.now().isoformat(timespec='seconds')}]"
            f" label={entry.get('label')}"
            f" path={entry.get('path')!r}"
            f" reason={entry.get('reason')!r}\n"
        )
        with open(AUDIT_LOG, "a", encoding="utf-8") as f:
            f.write(line)
    except Exception:
        pass


def _classify_zone(rel_path: str) -> Optional[str]:
    parts = rel_path.replace("\\", "/").split("/")
    if not parts:
        return None
    return parts[0]


def read_artifact(relative_path: str) -> ReadResult:
    """Read a mature L4 artifact. Never raises on suspect input."""

    r = resolve_safe(relative_path)
    if not r.is_safe:
        res = ReadResult(
            path=relative_path, is_ok=False, content_bytes=None, text=None,
            sha256=None, size_bytes=0,
            label="INTEGRITY_CONFLICT", reason=r.reason, zone=None
        )
        _audit({"label": res.label, "path": relative_path, "reason": res.reason})
        return res

    abs_path = Path(r.resolved_path)
    rel = abs_path.relative_to(ROOT_08_EVIDENCE).as_posix()
    zone = _classify_zone(rel)

    # Reject forbidden zones (BUFFER, incomplete, DISPOSABLE)
    if zone in FORBIDDEN_ZONES:
        res = ReadResult(
            path=rel, is_ok=False, content_bytes=None, text=None,
            sha256=None, size_bytes=0,
            label="REJECTED_ZONE", reason=f"zone={zone}", zone=zone
        )
        _audit({"label": res.label, "path": rel, "reason": res.reason})
        return res

    # Reject .tmp anywhere
    if abs_path.name.endswith(".tmp") or abs_path.name.startswith("."):
        res = ReadResult(
            path=rel, is_ok=False, content_bytes=None, text=None,
            sha256=None, size_bytes=0,
            label="REJECTED_TMP", reason="tmp_marker", zone=zone
        )
        _audit({"label": res.label, "path": rel, "reason": res.reason})
        return res

    # Extension whitelist
    if abs_path.suffix.lower() not in ALLOWED_EXT:
        res = ReadResult(
            path=rel, is_ok=False, content_bytes=None, text=None,
            sha256=None, size_bytes=0,
            label="FORMAT_ERROR", reason=f"ext={abs_path.suffix}", zone=zone
        )
        _audit({"label": res.label, "path": rel, "reason": res.reason})
        return res

    # Existence
    if not abs_path.exists():
        res = ReadResult(
            path=rel, is_ok=False, content_bytes=None, text=None,
            sha256=None, size_bytes=0,
            label="NOT_FOUND", reason="file_missing", zone=zone
        )
        _audit({"label": res.label, "path": rel, "reason": res.reason})
        return res

    # Read bytes
    try:
        data = abs_path.read_bytes()
    except Exception as e:
        res = ReadResult(
            path=rel, is_ok=False, content_bytes=None, text=None,
            sha256=None, size_bytes=0,
            label="UNREADABLE", reason=type(e).__name__, zone=zone
        )
        _audit({"label": res.label, "path": rel, "reason": res.reason})
        return res

    sha = hashlib.sha256(data).hexdigest()

    # Decode
    try:
        text = data.decode("utf-8", errors="strict")
    except UnicodeDecodeError as e:
        res = ReadResult(
            path=rel, is_ok=False, content_bytes=data, text=None,
            sha256=sha, size_bytes=len(data),
            label="ENCODING_ERROR", reason=f"utf8:{e.start}", zone=zone
        )
        _audit({"label": res.label, "path": rel, "reason": res.reason})
        return res

    # JSON structural check only if .json
    if abs_path.suffix.lower() == ".json":
        try:
            json.loads(text)
        except json.JSONDecodeError as e:
            res = ReadResult(
                path=rel, is_ok=False, content_bytes=data, text=text,
                sha256=sha, size_bytes=len(data),
                label="FORMAT_ERROR", reason=f"json:{e.msg}", zone=zone
            )
            _audit({"label": res.label, "path": rel, "reason": res.reason})
            return res

    res = ReadResult(
        path=rel, is_ok=True, content_bytes=data, text=text,
        sha256=sha, size_bytes=len(data),
        label="OK", reason=None, zone=zone
    )
    _audit({"label": res.label, "path": rel, "reason": None})
    return res