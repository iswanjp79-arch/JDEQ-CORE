# m2_path_hash_validator.py — L6-M2 Path + Hash Validator
# READ-ONLY. No L4 mutation. No L5 mutation. No DB.
# Fungsi:
#   1. Untuk setiap ledger entry, validasi path (di bawah 08_EVIDENCE, no traversal)
#   2. Cek file existence
#   3. Hitung SHA-256 file aktual
#   4. Bandingkan dengan entry.sha256_hash
#   5. Emit per-entry status
#   6. Hard-stop jika ada MISMATCH atau MISSING (configurable)

import json
import hashlib
import sys
from pathlib import Path
from dataclasses import dataclass, asdict, field
from datetime import datetime
from typing import Optional

sys.path.insert(0, r"D:\MICO_SSOT\L6-modules")
from m1_ledger_reader import read_ledger, L6_ROOT

ROOT_08_EVIDENCE = Path(r"D:\MICO_SSOT\08_EVIDENCE").resolve()
AUDIT_LOG = L6_ROOT / "m2_validator_audit.log"


# --- Result types ---
@dataclass
class EntryValidation:
    artifact_id: str
    file_path: str
    status: str          # OK | MISMATCH | MISSING | PATH_UNSAFE | UNREADABLE
    reason: Optional[str]
    ledger_sha256: str
    actual_sha256: Optional[str]
    size_bytes: Optional[int]


@dataclass
class ValidationSummary:
    run_id: str
    timestamp: str
    total: int
    ok: int
    mismatch: int
    missing: int
    path_unsafe: int
    unreadable: int
    overall: str         # PASS | BLOCKED
    entries: list = field(default_factory=list)


def _audit(entry: dict) -> None:
    try:
        AUDIT_LOG.parent.mkdir(parents=True, exist_ok=True)
        line = (
            f"[{datetime.now().isoformat(timespec='seconds')}]"
            f" event={entry.get('event')}"
            f" label={entry.get('label')}"
            f" reason={entry.get('reason')!r}"
            f" detail={entry.get('detail')!r}\n"
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


def _path_safe(abs_path: Path) -> bool:
    try:
        rp = abs_path.resolve(strict=False)
        rr = ROOT_08_EVIDENCE
        return str(rp).lower().startswith(str(rr).lower())
    except Exception:
        return False


def validate_entry(entry: dict) -> EntryValidation:
    rel = entry.get("file_path", "")
    ledger_sha = entry.get("sha256_hash", "")
    aid = entry.get("artifact_id", "")

    if not rel or not ledger_sha:
        _audit({"event":"validate_entry","label":"PATH_UNSAFE","reason":"missing_fields","detail":aid})
        return EntryValidation(aid, rel, "PATH_UNSAFE", "missing_fields", ledger_sha, None, None)

    # Path relative → abs
    norm_rel = rel.replace("\\", "/").strip()
    if ".." in norm_rel.split("/"):
        _audit({"event":"validate_entry","label":"PATH_UNSAFE","reason":"traversal","detail":aid})
        return EntryValidation(aid, rel, "PATH_UNSAFE", "traversal", ledger_sha, None, None)

    abs_path = (ROOT_08_EVIDENCE / norm_rel).resolve(strict=False)

    if not _path_safe(abs_path):
        _audit({"event":"validate_entry","label":"PATH_UNSAFE","reason":"outside_root","detail":aid})
        return EntryValidation(aid, rel, "PATH_UNSAFE", "outside_root", ledger_sha, None, None)

    # Existence
    if not abs_path.exists():
        _audit({"event":"validate_entry","label":"MISSING","reason":"file_not_found","detail":aid})
        return EntryValidation(aid, rel, "MISSING", "file_not_found", ledger_sha, None, None)

    # SHA-256
    try:
        actual = _sha256_file(abs_path)
        size = abs_path.stat().st_size
    except Exception as e:
        _audit({"event":"validate_entry","label":"UNREADABLE","reason":type(e).__name__,"detail":aid})
        return EntryValidation(aid, rel, "UNREADABLE", type(e).__name__, ledger_sha, None, None)

    if actual.lower() != ledger_sha.lower():
        _audit({"event":"validate_entry","label":"MISMATCH","reason":"hash_diff","detail":aid})
        return EntryValidation(aid, rel, "MISMATCH", "hash_diff", ledger_sha, actual, size)

    _audit({"event":"validate_entry","label":"OK","reason":None,"detail":aid})
    return EntryValidation(aid, rel, "OK", None, ledger_sha, actual, size)


def validate_all(hard_stop_on_fail: bool = True) -> ValidationSummary:
    ts = datetime.now().isoformat(timespec="seconds")
    run_id = datetime.now().strftime("L6M2_%Y%m%d_%H%M%S")

    lr = read_ledger()
    if lr.status != "OK":
        _audit({"event":"validate_all","label":"BLOCKED","reason":"ledger_read_failed","detail":lr.reason})
        return ValidationSummary(
            run_id=run_id, timestamp=ts, total=0, ok=0, mismatch=0,
            missing=0, path_unsafe=0, unreadable=0, overall="BLOCKED",
            entries=[],
        )

    entries = (lr.ledger_doc or {}).get("entries", [])
    results = []
    counts = {"OK":0, "MISMATCH":0, "MISSING":0, "PATH_UNSAFE":0, "UNREADABLE":0}

    for e in entries:
        r = validate_entry(e)
        counts[r.status] = counts.get(r.status, 0) + 1
        results.append(asdict(r))

    overall = "PASS"
    if counts["MISMATCH"] > 0 or counts["MISSING"] > 0 or counts["PATH_UNSAFE"] > 0 or counts["UNREADABLE"] > 0:
        overall = "BLOCKED"

    summary = ValidationSummary(
        run_id=run_id, timestamp=ts,
        total=len(entries),
        ok=counts["OK"],
        mismatch=counts["MISMATCH"],
        missing=counts["MISSING"],
        path_unsafe=counts["PATH_UNSAFE"],
        unreadable=counts["UNREADABLE"],
        overall=overall,
        entries=results,
    )

    _audit({
        "event":"validate_all",
        "label": overall,
        "reason": None,
        "detail": f"total={summary.total} ok={summary.ok} mismatch={summary.mismatch} missing={summary.missing}",
    })
    return summary


def save_summary(summary: ValidationSummary, out_dir: Path) -> str:
    out_dir.mkdir(parents=True, exist_ok=True)
    out = out_dir / f"validation_summary_{summary.run_id}.json"
    payload = asdict(summary)
    out.write_text(json.dumps(payload, indent=2, ensure_ascii=False), encoding="utf-8")
    return str(out)