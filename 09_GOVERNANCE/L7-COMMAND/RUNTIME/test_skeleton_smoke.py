import json, os, tempfile, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
RT = os.path.join(HERE, "l7_runtime.py")

def make(path, obj):
    with open(path, "w", encoding="utf-8") as f:
        json.dump(obj, f)

def run(cmd_path):
    p = subprocess.run([sys.executable, RT, cmd_path], capture_output=True, text=True)
    return p.returncode

def main():
    tmp = tempfile.mkdtemp(prefix="l7s1_")
    valid = {"command_id":"c1","correlation_id":"r1","issuer":"L0",
             "action":"noop","issued_at":"2026-09-14T00:00:00Z",
             "nonce":"n001","sequence":1}
    p1 = os.path.join(tmp,"t1.json"); make(p1, valid)
    r1 = run(p1)
    bad = dict(valid); del bad["nonce"]
    p2 = os.path.join(tmp,"t2.json"); make(p2, bad)
    r2 = run(p2)
    p3 = os.path.join(tmp,"t3.json")
    with open(p3,"w",encoding="utf-8") as f: f.write("{not json")
    r3 = run(p3)
    out = {"T1_valid":r1,"T2_missing_field":r2,"T3_bad_json":r3,
           "pass": r1==0 and r2==3 and r3==2}
    print(json.dumps(out))
    return 0 if out["pass"] else 1

if __name__ == "__main__":
    sys.exit(main())
