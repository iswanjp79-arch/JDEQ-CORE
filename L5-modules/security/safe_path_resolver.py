# safe_path_resolver.py — L5 Security Module
# Reject-first path confinement under ROOT_08_EVIDENCE.
# No exceptions on suspect input. 1-line audit log per decision.

import os
import stat
from pathlib import Path
from dataclasses import dataclass
from typing import Optional
from datetime import datetime

ROOT_08_EVIDENCE = Path(r"D:\MICO_SSOT\08_EVIDENCE").resolve()
AUDIT_LOG = ROOT_08_EVIDENCE / "L5_SECURITY" / "safe_path_audit.log"
FILE_ATTRIBUTE_REPARSE_POINT = 0x400


@dataclass
class SafePathResult:
    is_safe: bool
    resolved_path: Optional[str]
    reason: Optional[str]
    label: str  # "OK" | "INTEGRITY_CONFLICT"


def _has_control_chars(s: str) -> bool:
    if not s:
        return True
    for ch in s:
        c = ord(ch)
        if c < 0x20 or c == 0x7F:
            return True
    return False


def _is_unc_or_uri(s: str) -> bool:
    # UNC: \\server\share  or //server/share
    if s.startswith("\\\\") or s.startswith("//"):
        return True
    # URI: scheme://
    if "://" in s:
        return True
    return False


def _is_reparse_point(p: Path) -> bool:
    try:
        st = os.lstat(str(p))
    except OSError:
        return False
    if stat.S_ISLNK(st.st_mode):
        return True
    attrs = getattr(st, "st_file_attributes", 0)
    if attrs & FILE_ATTRIBUTE_REPARSE_POINT:
        return True
    return False


def _is_descendant(child: Path, parent: Path) -> bool:
    try:
        c = os.path.normcase(str(child))
        p = os.path.normcase(str(parent))
        if c == p:
            return True
        if not p.endswith(os.sep):
            p += os.sep
        return c.startswith(p)
    except Exception:
        return False


def _audit(entry: dict) -> None:
    try:
        AUDIT_LOG.parent.mkdir(parents=True, exist_ok=True)
        line = (
            f"[{datetime.now().isoformat(timespec='seconds')}]"
            f" label={entry.get('label')}"
            f" reason={entry.get('reason')}"
            f" input={entry.get('input')!r}"
            f" resolved={entry.get('resolved')!r}\n"
        )
        with open(AUDIT_LOG, "a", encoding="utf-8") as f:
            f.write(line)
    except Exception:
        pass


def resolve_safe(path_str: str) -> SafePathResult:
    """Confinement gate. Returns SafePathResult. Never raises on suspect input."""

    # 1. Null / empty
    if path_str is None or path_str == "":
        r = SafePathResult(False, None, "NULL_OR_EMPTY", "INTEGRITY_CONFLICT")
        _audit({"input": path_str, "label": r.label, "reason": r.reason})
        return r

    # 2. Control chars
    if _has_control_chars(path_str):
        r = SafePathResult(False, None, "CONTROL_CHARS", "INTEGRITY_CONFLICT")
        _audit({"input": path_str, "label": r.label, "reason": r.reason})
        return r

    # 3. UNC / URI
    if _is_unc_or_uri(path_str):
        r = SafePathResult(False, None, "UNC_OR_URI", "INTEGRITY_CONFLICT")
        _audit({"input": path_str, "label": r.label, "reason": r.reason})
        return r

    # 4. Absolute path
    try:
        p_in = Path(path_str)
    except Exception as e:
        r = SafePathResult(False, None, f"PATH_PARSE_ERROR:{type(e).__name__}", "INTEGRITY_CONFLICT")
        _audit({"input": path_str, "label": r.label, "reason": r.reason})
        return r

    if p_in.is_absolute():
        r = SafePathResult(False, None, "ABSOLUTE_PATH", "INTEGRITY_CONFLICT")
        _audit({"input": path_str, "label": r.label, "reason": r.reason})
        return r

    # 5. Resolve candidate under ROOT
    try:
        candidate = (ROOT_08_EVIDENCE / path_str).resolve(strict=False)
    except Exception as e:
        r = SafePathResult(False, None, f"RESOLVE_ERROR:{type(e).__name__}", "INTEGRITY_CONFLICT")
        _audit({"input": path_str, "label": r.label, "reason": r.reason})
        return r

    # 6. Descendant check
    if not _is_descendant(candidate, ROOT_08_EVIDENCE):
        r = SafePathResult(False, None, "ESCAPE_ATTEMPT", "INTEGRITY_CONFLICT")
        _audit({"input": path_str, "label": r.label, "reason": r.reason, "resolved": str(candidate)})
        return r

    # 7. Reparse point check — candidate itself
    if candidate.exists() and _is_reparse_point(candidate):
        r = SafePathResult(False, None, "REPARSE_POINT_SELF", "INTEGRITY_CONFLICT")
        _audit({"input": path_str, "label": r.label, "reason": r.reason, "resolved": str(candidate)})
        return r

    # 8. Reparse point check — ancestor chain (stop at ROOT)
    parent = candidate.parent
    while True:
        if parent == ROOT_08_EVIDENCE or parent == parent.parent:
            break
        if parent.exists() and _is_reparse_point(parent):
            r = SafePathResult(False, None, f"REPARSE_POINT_ANCESTOR:{parent.name}", "INTEGRITY_CONFLICT")
            _audit({"input": path_str, "label": r.label, "reason": r.reason, "resolved": str(candidate)})
            return r
        parent = parent.parent

    # OK
    r = SafePathResult(True, str(candidate), None, "OK")
    _audit({"input": path_str, "label": r.label, "reason": None, "resolved": str(candidate)})
    return r
