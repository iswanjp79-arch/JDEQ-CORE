"""L7 Control Room v0 - node status via Tailscale"""
import subprocess, json, os, hashlib
from datetime import datetime, timezone

EVID = "D:/MICO_SSOT/08_EVIDENCE/L7-OPERATIONAL/control_room"

def run(cmd):
    r = subprocess.run(cmd, capture_output=True, text=True,
                       encoding="utf-8", errors="replace", shell=True)
    return r.stdout.strip(), r.returncode

def main():
    ts = datetime.now(timezone.utc).isoformat()
    out, rc = run("tailscale status")
    print("=== L7 CONTROL ROOM v0 ===")
    print("Time    : " + ts)
    print("Command : tailscale status (rc=" + str(rc) + ")")
    print()
    print(out)
    os.makedirs(EVID, exist_ok=True)
    fname = EVID + "/status_" + ts[:10].replace("-","") + ".json"
    payload = {"ts": ts, "tailscale": out, "rc": rc}
    with open(fname, "w", encoding="utf-8") as f:
        json.dump(payload, f, indent=2)
    h = hashlib.sha256(json.dumps(payload, sort_keys=True).encode()).hexdigest()
    print()
    print("Evidence: " + fname)
    print("SHA256  : " + h)

if __name__ == "__main__":
    main()
