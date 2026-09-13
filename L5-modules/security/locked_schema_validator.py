# locked_schema_validator.py â€” L5 Security Module
# Pydantic deklaratif saja. No custom validators. No dynamic code.
# - create_safe_model(): build model from declarative field spec
# - scan_source_for_forbidden(): AST scan for @field_validator etc.
# - scan_runtime_model(): inspect model for attached validators

import ast
import os
from pathlib import Path
from datetime import datetime
from typing import Any
from pydantic import create_model

AUDIT_LOG = Path(r"D:\MICO_SSOT\08_EVIDENCE\L5_SECURITY\pydantic_lock_audit.log")

FORBIDDEN_DECORATORS = {
    "field_validator",
    "model_validator",
    "root_validator",
    "validator",
}

FORBIDDEN_CALLS = {
    "eval",
    "exec",
    "compile",
    "subprocess.run",
    "subprocess.Popen",
    "subprocess.call",
    "subprocess.check_output",
    "subprocess.check_call",
    "os.system",
    "os.popen",
    "__import__",
    "importlib.import_module",
    "pickle.loads",
    "pickle.load",
    "marshal.loads",
}


def _audit(entry: dict) -> None:
    try:
        AUDIT_LOG.parent.mkdir(parents=True, exist_ok=True)
        line = (
            f"[{datetime.now().isoformat(timespec='seconds')}]"
            f" event={entry.get('event')}"
            f" target={entry.get('target')!r}"
            f" status={entry.get('status')}"
            f" detail={entry.get('detail')!r}\n"
        )
        with open(AUDIT_LOG, "a", encoding="utf-8") as f:
            f.write(line)
    except Exception:
        pass


def create_safe_model(name: str, fields: dict):
    """Build a pydantic model from declarative fields only.

    fields: dict of {field_name: (type, ...)} compatible with pydantic.create_model
    No callbacks, no validators, no default_factory importing modules.
    """
    if not name or not isinstance(name, str):
        _audit({"event": "create_model", "target": name, "status": "REJECT", "detail": "bad name"})
        raise ValueError("model name required")

    if not isinstance(fields, dict):
        _audit({"event": "create_model", "target": name, "status": "REJECT", "detail": "fields not dict"})
        raise ValueError("fields must be dict")

    # reject any callables in field spec (would indicate factory / validator)
    for fname, spec in fields.items():
        if callable(spec):
            _audit({"event": "create_model", "target": f"{name}.{fname}", "status": "REJECT", "detail": "callable field spec"})
            raise ValueError(f"callable field spec not allowed: {fname}")
        if isinstance(spec, tuple):
            for item in spec:
                if callable(item) and not isinstance(item, type):
                    _audit({"event": "create_model", "target": f"{name}.{fname}", "status": "REJECT", "detail": "callable in tuple"})
                    raise ValueError(f"callable not allowed in field: {fname}")

    try:
        model = create_model(name, **fields)
    except Exception as e:
        _audit({"event": "create_model", "target": name, "status": "ERROR", "detail": str(e)})
        raise

    # runtime inspection: ensure no validators got attached
    has_v = _model_has_validators(model)
    if has_v:
        _audit({"event": "create_model", "target": name, "status": "REJECT", "detail": f"validators: {has_v}"})
        raise ValueError(f"model has attached validators: {has_v}")

    _audit({"event": "create_model", "target": name, "status": "OK", "detail": f"fields={list(fields.keys())}"})
    return model


def _model_has_validators(model_cls) -> list:
    found = []
    try:
        cfg = getattr(model_cls, "model_config", None) or {}
        for k in ("field_validator", "model_validator"):
            if k in cfg:
                found.append(k)
    except Exception:
        pass

    # pydantic v2 stores decorators in __pydantic_decorators__
    try:
        decs = getattr(model_cls, "__pydantic_decorators__", None)
        if decs is not None:
            for attr in ("field_validators", "model_validators", "root_validators"):
                store = getattr(decs, attr, None)
                if store:
                    try:
                        found.extend(list(store.keys()))
                    except Exception:
                        found.append(attr)
    except Exception:
        pass

    return found


def scan_source_for_forbidden(source_path: str) -> dict:
    """AST scan a single .py file for forbidden decorators/calls.

    Returns dict: {"path": str, "violations": [...], "status": "OK"|"VIOLATION"|"ERROR"}
    """
    result = {"path": source_path, "violations": [], "status": "OK"}
    try:
        src = Path(source_path).read_text(encoding="utf-8", errors="strict")
    except Exception as e:
        result["status"] = "ERROR"
        result["violations"].append(f"READ_ERROR:{type(e).__name__}")
        _audit({"event": "scan_source", "target": source_path, "status": "ERROR", "detail": str(e)})
        return result

    try:
        tree = ast.parse(src, filename=source_path)
    except SyntaxError as e:
        result["status"] = "ERROR"
        result["violations"].append(f"SYNTAX_ERROR:{e.msg}")
        _audit({"event": "scan_source", "target": source_path, "status": "ERROR", "detail": str(e)})
        return result

    for node in ast.walk(tree):
        # decorators
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef)):
            for dec in node.decorator_list:
                name = _decorator_name(dec)
                if name and name in FORBIDDEN_DECORATORS:
                    result["violations"].append(f"decorator:{name}@line{node.lineno}")
        # calls
        if isinstance(node, ast.Call):
            call_name = _call_name(node.func)
            if call_name and call_name in FORBIDDEN_CALLS:
                result["violations"].append(f"call:{call_name}@line{node.lineno}")

    if result["violations"]:
        result["status"] = "VIOLATION"

    _audit({
        "event": "scan_source",
        "target": source_path,
        "status": result["status"],
        "detail": f"violations={len(result['violations'])}"
    })
    return result


def _decorator_name(dec) -> str:
    # @field_validator  -> "field_validator"
    # @pydantic.field_validator -> "field_validator"
    # @field_validator("x") -> "field_validator"
    try:
        if isinstance(dec, ast.Call):
            dec = dec.func
        if isinstance(dec, ast.Name):
            return dec.id
        if isinstance(dec, ast.Attribute):
            return dec.attr
    except Exception:
        pass
    return ""


def _call_name(func) -> str:
    try:
        if isinstance(func, ast.Name):
            return func.id
        if isinstance(func, ast.Attribute):
            parts = []
            cur = func
            while isinstance(cur, ast.Attribute):
                parts.append(cur.attr)
                cur = cur.value
            if isinstance(cur, ast.Name):
                parts.append(cur.id)
            return ".".join(reversed(parts))
    except Exception:
        pass
    return ""


def scan_tree(root: str, exclude_dirs=None) -> dict:
    """Scan all .py under root. Returns summary dict."""
    if exclude_dirs is None:
        exclude_dirs = {"__pycache__", ".venv", "venv", ".git"}
    summary = {"root": root, "files_scanned": 0, "files_with_violations": 0, "details": []}
    root_p = Path(root)
    if not root_p.exists():
        summary["status"] = "ROOT_MISSING"
        _audit({"event": "scan_tree", "target": root, "status": "ERROR", "detail": "root missing"})
        return summary
    for dirpath, dirnames, filenames in os.walk(root_p):
        dirnames[:] = [d for d in dirnames if d not in exclude_dirs]
        for fn in filenames:
            if not fn.endswith(".py"):
                continue
            full = os.path.join(dirpath, fn)
            r = scan_source_for_forbidden(full)
            summary["files_scanned"] += 1
            if r["status"] in ("VIOLATION", "ERROR"):
                summary["files_with_violations"] += 1
                summary["details"].append(r)
    summary["status"] = "OK" if summary["files_with_violations"] == 0 else "VIOLATION"
    _audit({
        "event": "scan_tree",
        "target": root,
        "status": summary["status"],
        "detail": f"scanned={summary['files_scanned']} violations={summary['files_with_violations']}"
    })
    return summary
