import json, os, sys, subprocess, shutil
HERE = os.path.dirname(os.path.abspath(__file__))
ACT = os.path.join(HERE, "l7_activation.py")
BASE = "D:/MICO_SSOT/08_EVIDENCE/L7-OPERATIONAL"

def clean_state():
    s = os.path.join(BASE, "runtime_state")
    if os.path.exists(s): shutil.rmtree(s, ignore_errors=True)
    os.makedirs(s, exist_ok=True)

def run():
    r = subprocess.run([sys.executable, ACT], capture_output=True, text=True,
                       env=dict(os.environ, L7_BACKOFF="fast"))
    return r.returncode, r.stdout.strip()

def main():
    clean_state()
    rc, out = run()
    R = {"exit": rc, "stdout": out}
    try:
        data = json.loads(out)
        R["final_state"] = data.get("state")
        R["history"] = data.get("history", [])
    except Exception as e:
        R["parse_error"] = str(e)
    exp_hist = ["LOCKED","READY_FOR_ACTIVATION","ACTIVATION_TEST","ACTIVE_CONTROLLED","VERIFIED_OPERATION"]
    R["history_ok"] = R.get("history") == exp_hist
    R["state_ok"] = R.get("final_state") == "VERIFIED_OPERATION"
    R["pass"] = (rc == 0) and R["history_ok"] and R["state_ok"]
    print(json.dumps(R))
    return 0 if R["pass"] else 1

if __name__ == "__main__":
    sys.exit(main())
