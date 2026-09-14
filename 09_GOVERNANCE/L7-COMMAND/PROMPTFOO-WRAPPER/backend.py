"""Promptfoo wrapper - backend with STATE fields"""
import json, os, subprocess, tempfile, uuid, hashlib
from datetime import datetime, timezone

PF = "promptfoo"
EVIDENCE_DIR = "D:/MICO_SSOT/08_EVIDENCE/PROMPTFOO-RUNS"

def build_prompt_text(rule, action, context, expectation, recipient, purpose, depth):
    lines = [
        "RULE: " + rule,
        "ACTION: " + action,
        "CONTEXT: " + context,
        "EXPECTATION: " + expectation,
        "",
        "FOR: " + recipient,
        "PURPOSE: " + purpose,
        "DEPTH: " + depth,
    ]
    return "\n".join(lines)

def build_config(rule, action, context, expectation, recipient, purpose, depth, provider="echo"):
    return {
        "description": "RACE+STATE evaluation",
        "prompts": ["{{prompt_text}}"],
        "providers": [provider],
        "tests": [{"vars": {"prompt_text": build_prompt_text(rule, action, context, expectation, recipient, purpose, depth)}}]
    }

def save_evidence(result):
    os.makedirs(EVIDENCE_DIR, exist_ok=True)
    ts = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
    rid = result.get("run_id", "unknown")
    fname = "race_" + ts + "_" + rid + ".json"
    fpath = os.path.join(EVIDENCE_DIR, fname)
    payload = json.dumps(result, indent=2, sort_keys=True)
    h = hashlib.sha256(payload.encode("utf-8")).hexdigest()
    with open(fpath, "w", encoding="utf-8") as fh:
        fh.write(payload)
    return fpath, h

def run_eval(rule, action, context, expectation, recipient, purpose, depth, provider="echo"):
    cfg = build_config(rule, action, context, expectation, recipient, purpose, depth, provider)
    tmp = tempfile.mkdtemp(prefix="pf_")
    cfg_path = os.path.join(tmp, "config.json")
    out_path = os.path.join(tmp, "out.json")
    with open(cfg_path, "w", encoding="utf-8") as fh:
        json.dump(cfg, fh, indent=2)
    cmd = [PF, "eval", "-c", cfg_path, "-o", out_path, "--no-cache", "--no-progress-bar"]
    r = subprocess.run(cmd, capture_output=True, encoding="utf-8", errors="replace", timeout=300, shell=True)
    result = {
        "run_id": str(uuid.uuid4())[:8],
        "ts": datetime.now(timezone.utc).isoformat(),
        "returncode": r.returncode,
        "stdout_tail": (r.stdout or "")[-500:],
        "stderr_tail": (r.stderr or "")[-500:],
        "config": cfg,
        "output_file": out_path,
        "output_exists": os.path.exists(out_path),
    }
    if result["output_exists"]:
        try:
            with open(out_path, encoding="utf-8") as fh:
                result["output"] = json.load(fh)
        except Exception as e:
            result["output_error"] = str(e)
    try:
        epath, ehash = save_evidence(result)
        result["evidence_path"] = epath
        result["evidence_sha256"] = ehash
    except Exception as e:
        result["evidence_error"] = str(e)
    return result

if __name__ == "__main__":
    import sys
    if len(sys.argv) >= 2 and sys.argv[1] == "selftest":
        r = run_eval("test_rule", "test_action", "test_context", "test_expectation",
                     "Iswan pribadi", "Uji pemahaman", "1 paragraf teknis")
        print(json.dumps(r, indent=2))
