# metadata_sanitizer.py — L5 Security Module
# Deterministic in-memory sanitization of metadata strings.
# - NFC normalize
# - Strip/neutralize control chars
# - Escape code-injection-like sequences
# - Enforce max length
# - Compute checksum (SHA-256) SEPARATE from sanitized value
# - Does NOT touch source files (L4 read-only)

import hashlib
import unicodedata
import re
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path

AUDIT_LOG = Path(r"D:\MICO_SSOT\08_EVIDENCE\L5_SECURITY\metadata_sanitizer_audit.log")

DEFAULT_MAX_LEN = 2048
TRUNC_SUFFIX = "…[TRUNC]"

# Sequences that look like code injection / template injection / shell
INJECTION_PATTERNS = [
    r"<\?",
    r"</",
    r"\{\{",
    r"\}\}",
    r"`",
    r"\$\(",
    r"\$\{",
    r"\\x[0-9a-fA-F]{2}",
    r"\\u[0-9a-fA-F]{4}",
]

_INJ_RE = re.compile("|".join(INJECTION_PATTERNS))


@dataclass
class SanitizeResult:
    original_len: int
    sanitized_len: int
    value: str
    checksum: str
    label: str              # "OK" | "SANITIZATION_HIGH"
    removed_chars: int
    changed: bool


def _audit(entry: dict) -> None:
    try:
        AUDIT_LOG.parent.mkdir(parents=True, exist_ok=True)
        line = (
            f"[{datetime.now().isoformat(timespec='seconds')}]"
            f" label={entry.get('label')}"
            f" original_len={entry.get('original_len')}"
            f" sanitized_len={entry.get('sanitized_len')}"
            f" removed={entry.get('removed_chars')}"
            f" changed={entry.get('changed')}\n"
        )
        with open(AUDIT_LOG, "a", encoding="utf-8") as f:
            f.write(line)
    except Exception:
        pass


def _strip_control(s: str) -> tuple[str, int]:
    removed = 0
    out = []
    for ch in s:
        c = ord(ch)
        if c < 0x20 or c == 0x7F:
            removed += 1
            continue
        out.append(ch)
    return "".join(out), removed


def _escape_injection(s: str) -> tuple[str, int]:
    # Replace dangerous sequences with safe escaped form
    changed = 0
    def repl(m):
        nonlocal changed
        changed += 1
        return "".join(f"%{ord(c):02X}" for c in m.group(0))
    out = _INJ_RE.sub(repl, s)
    return out, changed


def sanitize_string(s: str, max_len: int = DEFAULT_MAX_LEN) -> SanitizeResult:
    """Deterministic sanitization. Order: NFC -> control strip -> injection escape -> length clamp."""
    if s is None:
        s = ""
    if not isinstance(s, str):
        s = str(s)

    original_len = len(s)

    # 1. NFC normalize
    step = unicodedata.normalize("NFC", s)

    # 2. strip control chars
    step, removed_ctrl = _strip_control(step)

    # 3. escape injection patterns
    step, escaped_count = _escape_injection(step)

    # 4. length clamp
    truncated = False
    if len(step) > max_len:
        keep = max_len - len(TRUNC_SUFFIX)
        if keep < 0:
            keep = 0
        step = step[:keep] + TRUNC_SUFFIX
        truncated = True

    # 5. metrics
    sanitized_len = len(step)
    removed_chars = original_len - sanitized_len
    changed = (step != s) or truncated

    # 6. label
    removed_ratio = (removed_chars / original_len) if original_len > 0 else 0.0
    label = "SANITIZATION_HIGH" if removed_ratio > 0.30 else "OK"

    # 7. checksum (of sanitized value)
    checksum = hashlib.sha256(step.encode("utf-8")).hexdigest()

    result = SanitizeResult(
        original_len=original_len,
        sanitized_len=sanitized_len,
        value=step,
        checksum=checksum,
        label=label,
        removed_chars=removed_chars,
        changed=changed,
    )
    _audit({
        "label": label,
        "original_len": original_len,
        "sanitized_len": sanitized_len,
        "removed_chars": removed_chars,
        "changed": changed,
    })
    return result


def sanitize_metadata(meta: dict, max_len: int = DEFAULT_MAX_LEN) -> dict:
    """Sanitize all string values of a metadata dict. Keys untouched (must be validated separately)."""
    out = {}
    for k, v in meta.items():
        if isinstance(v, str):
            r = sanitize_string(v, max_len=max_len)
            out[k] = {"value": r.value, "checksum": r.checksum, "label": r.label}
        else:
            out[k] = {"value": v, "checksum": None, "label": "NON_STRING"}
    return out