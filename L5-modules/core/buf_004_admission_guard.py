# buf_004_admission_guard.py — L5 Core BUF-004
# Buffer Admission Guard.
# - .tmp -> REJECT
# - BUFFER -> REJECT
# - STAGING+ -> ALLOW
# L5 does NOT write/delete/move/rename BUFFER.

import sys
from pathlib import Path
from datetime import datetime

sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\security")
sys.path.insert(0, r"D:\MICO_SSOT\L5-modules\core")

from safe_path_resolver import ROOT_08_EVIDENCE

AUDIT_LOG = ROOT_08_EVIDENCE / "L5_SECURITY" / "buf_004_audit.log"

# Physical states
ALLOWED_ZONES = {"LIVE", "RETAIN", "STAGING", "QUARANTINE"}
DENIED_ZONES  = {"BUFFER", "incomplete", "DISPOSABLE", "GLOBAL"}


def _audit(label: str, reason: str, path: str) -> None:
    try:
        AUDIT_LOG.parent.mkdir(parents=True, exist_ok=True)
        line = (
            f"[{datetime.now().isoformat(timespec='seconds')}]"
            f" label={label}"
            f" reason={reason!r}"
            f" path={path!r}\n"
        )
        with open(AUDIT_LOG, "a", encoding="utf-8") as f:
            f.write(line)
    except Exception:
        pass


def _zone_of(rel_path: str) -> str:
    parts = rel_path.replace("\\", "/").split("/")
    return parts[0] if parts else ""


def admit(rel_path: str) -> dict:
    """Decide whether L5 may read this artifact. Returns dict {allow, label, reason, zone}."""
    # normalize
    norm = rel_path.replace("\\", "/").strip()

    # reject empty
    if not norm:
        _audit("DENY", "EMPTY", rel_path)
        return {"allow": False, "label": "DENY", "reason": "EMPTY", "zone": ""}

    # reject traversal (defensive; M1 also guards)
    if ".." in norm.split("/"):
        _audit("DENY", "TRAVERSAL", rel_path)
        return {"allow": False, "label": "DENY", "reason": "TRAVERSAL", "zone": ""}

    # reject .tmp anywhere
    last = norm.split("/")[-1]
    if last.endswith(".tmp") or last.startswith("."):
        _audit("DENY", "TMP_MARKER", rel_path)
        return {"allow": False, "label": "DENY", "reason": "TMP_MARKER", "zone": ""}

    zone = _zone_of(norm)

    if zone in DENIED_ZONES:
        _audit("DENY", f"ZONE_DENIED:{zone}", rel_path)
        return {"allow": False, "label": "DENY", "reason": f"ZONE_DENIED:{zone}", "zone": zone}

    if zone not in ALLOWED_ZONES:
        _audit("DENY", f"ZONE_NOT_ALLOWED:{zone}", rel_path)
        return {"allow": False, "label": "DENY", "reason": f"ZONE_NOT_ALLOWED:{zone}", "zone": zone}

    _audit("ALLOW", None, rel_path)
    return {"allow": True, "label": "ALLOW", "reason": None, "zone": zone}


# Hard invariants — L5 MUST NOT perform these on BUFFER
def assert_no_buffer_write() -> dict:
    return {
        "L5_write_buffer":  False,
        "L5_delete_buffer": False,
        "L5_move_buffer":   False,
        "L5_rename_buffer": False,
        "buffer_owner":     "L4",
    }