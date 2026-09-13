# m1_ledger_reader.py — L6-M1 Ledger Reader
# READ-ONLY. No L4 mutation. No L5 mutation. No DB.
# Validation order: PATH → FILE → SHA-256 → JSON → Pydantic

import json
import hashlib
import sys
import os
from pathlib import Path
from dataclasses import dataclass, asdict
from datetime import datetime
from typing import Optional
from pydantic import BaseModel, Field, ValidationError, create_model

# --- Constants ---
L5_LEDGER_DIR = Path(r"D:\MICO_SSOT\09_GOVERNANCE\L5-LEDGER")
LEDGER_FILE       = L5_LEDGER_DIR / "ledger.json"
LEDGER_STATE_FILE = L5_LEDGER_DIR / "ledger_state.json"

L6_ROOT = Path(r"D:\MICO_SSOT\09_GOVERNANCE\L6-ANALYTICS")
AUDIT_LOG = L6_ROOT / "m1_reader_audit.log"

# --- Pydantic v2 declarative models (NO @field_validator) ---
class LedgerEntry(BaseModel):
    artifact_id:      str
    source_node:      str
    file_path:        str
    sha256_hash:      str
    last_write_time:  Optional[str] = None
    retention_class:  Optional[str] = None
    correlation_hash: Optional[str] = None
    zone:             Optional[str] = None

class LedgerDoc(BaseModel):
    derived:          bool
    authoritative:    bool
    rebuildable:      bool
    contains_full_payload: Optional[bool] = None
    generated_at:     str
    host:             Optional[str] = None
    root:             Optional[str] = None
    count:            int
    zone_counts:      Optional[dict] = None
    entries:          list[LedgerEntry]

class LedgerState(BaseModel):
    ledger_path:  str
    sha256:       str
    count:        int
    generated_at: str
    derived:      bool
    rebuildable:  bool


# --- Result dataclass ---
@dataclass
class ReadResult:
    status: str                # OK | BLOCKED
    reason: Optional[str]
    ledger_path: str
    ledger_state_path: str
    ledger_sha256: Optional[str]
    state_sha256: Optional[str]
    count: int
    zone_counts: dict
    ledger_doc: Optional[dict]
    timestamp: str


def _audit(entry: dict) -> None:
    try:
        AUDIT_LOG.parent.mkdir(parents=True, exist_ok=True)
        line = (
            f"[{datetime.now().isoformat(timespec='seconds')}]"
            f" event={entry.get('event')}"
            f" label={entry.get('label')}"
            f" reason={entry.get('reason')!r}\n"
        )
        with open(AUDIT_LOG, "a", encoding="utf-8") as f:
            f.write(line)
    except Exception:
        pass


def _sha256_file(p: Path) -> str:
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def _path_safe(p: Path, root: Path) -> bool:
    try:
        rp = p.resolve(strict=False)
        rr = root.resolve(strict=False)
        return str(rp).lower().startswith(str(rr).lower())
    except Exception:
        return False


def read_ledger() -> ReadResult:
    ts = datetime.now().isoformat(timespec="seconds")

    # 1. PATH VALIDATION
    if not _path_safe(LEDGER_FILE, L5_LEDGER_DIR) or not _path_safe(LEDGER_STATE_FILE, L5_LEDGER_DIR):
        r = ReadResult("BLOCKED", "path_outside_l5_ledger_dir",
                       str(LEDGER_FILE), str(LEDGER_STATE_FILE),
                       None, None, 0, {}, None, ts)
        _audit({"event":"read_ledger","label":"BLOCKED","reason":r.reason})
        return r

    # 2. FILE EXISTENCE
    if not LEDGER_FILE.exists():
        r = ReadResult("BLOCKED", "ledger_file_missing",
                       str(LEDGER_FILE), str(LEDGER_STATE_FILE),
                       None, None, 0, {}, None, ts)
        _audit({"event":"read_ledger","label":"BLOCKED","reason":r.reason})
        return r
    if not LEDGER_STATE_FILE.exists():
        r = ReadResult("BLOCKED", "ledger_state_missing",
                       str(LEDGER_FILE), str(LEDGER_STATE_FILE),
                       None, None, 0, {}, None, ts)
        _audit({"event":"read_ledger","label":"BLOCKED","reason":r.reason})
        return r

    # 3. SHA-256 (both files)
    try:
        sha_ledger = _sha256_file(LEDGER_FILE)
        sha_state  = _sha256_file(LEDGER_STATE_FILE)
    except Exception as e:
        r = ReadResult("BLOCKED", f"hash_read_error:{type(e).__name__}",
                       str(LEDGER_FILE), str(LEDGER_STATE_FILE),
                       None, None, 0, {}, None, ts)
        _audit({"event":"read_ledger","label":"BLOCKED","reason":r.reason})
        return r

    # 4. JSON PARSE
    try:
        ledger_raw = json.loads(LEDGER_FILE.read_text(encoding="utf-8"))
        state_raw  = json.loads(LEDGER_STATE_FILE.read_text(encoding="utf-8"))
    except json.JSONDecodeError as e:
        r = ReadResult("BLOCKED", f"json_decode:{e.msg}",
                       str(LEDGER_FILE), str(LEDGER_STATE_FILE),
                       sha_ledger, sha_state, 0, {}, None, ts)
        _audit({"event":"read_ledger","label":"BLOCKED","reason":r.reason})
        return r

    # 5. Pydantic v2 declarative validation
    try:
        ledger_doc = LedgerDoc(**ledger_raw)
        state_doc  = LedgerState(**state_raw)
    except ValidationError as e:
        r = ReadResult("BLOCKED", f"pydantic:{e.error_count()}err",
                       str(LEDGER_FILE), str(LEDGER_STATE_FILE),
                       sha_ledger, sha_state, 0, {}, None, ts)
        _audit({"event":"read_ledger","label":"BLOCKED","reason":r.reason})
        return r

    # 6. INTEGRITY CROSS-CHECK (state.sha256 vs actual ledger hash)
    if state_doc.sha256.lower() != sha_ledger.lower():
        r = ReadResult("BLOCKED", "state_hash_mismatch",
                       str(LEDGER_FILE), str(LEDGER_STATE_FILE),
                       sha_ledger, sha_state, ledger_doc.count,
                       ledger_doc.zone_counts or {}, None, ts)
        _audit({"event":"read_ledger","label":"BLOCKED","reason":r.reason})
        return r

    # 7. COUNT CROSS-CHECK
    if state_doc.count != ledger_doc.count:
        r = ReadResult("BLOCKED", "state_count_mismatch",
                       str(LEDGER_FILE), str(LEDGER_STATE_FILE),
                       sha_ledger, sha_state, ledger_doc.count,
                       ledger_doc.zone_counts or {}, None, ts)
        _audit({"event":"read_ledger","label":"BLOCKED","reason":r.reason})
        return r

    # OK
    r = ReadResult(
        "OK", None,
        str(LEDGER_FILE), str(LEDGER_STATE_FILE),
        sha_ledger, sha_state,
        ledger_doc.count, ledger_doc.zone_counts or {},
        ledger_doc.model_dump(),
        ts,
    )
    _audit({"event":"read_ledger","label":"OK","reason":None})
    return r