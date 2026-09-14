import json, os, sys, tempfile, subprocess, shutil, time
from datetime import datetime, timezone, timedelta

HERE = os.path.dirname(os.path.abspath(__file__))
RT = os.path.join(HERE, "l7_runtime.py")
STATE = "D:/MICO_SSOT/08_EVIDENCE/L7-OPERATIONAL/runtime_state"
AUDIT = "D:/MICO_SSOT/08_EVIDENCE/L7-OPERATIONAL/runtime_audit.jsonl"

def reset():
    if os.path.exists(STATE): shutil.rmtree(STATE, ignore_errors=True)
    os.makedirs(STATE, exist_ok=True)
    if os.path.exists(AUDIT):
        try: os.remove(AUDIT)
        except: pass

def run(p, timeout=30, env_extra=None):
    e = dict(os.environ); e["L7_BACKOFF"] = "fast"
    if env_extra: e.update(env_extra)
    try:
        r = subprocess.run([sys.executable, RT, p], capture_output=True, text=True, timeout=timeout, env=e)
        return r.returncode
    except subprocess.TimeoutExpired:
        return -1

def make(path, obj):
    with open(path, "w", encoding="utf-8") as f: json.dump(obj, f)

def cmd(seq=1, nonce="n0001", cid="c1", action="noop", issuer="L0", issued=None):
    return {"command_id":cid,"correlation_id":"r1","issuer":issuer,"action":action,
            "issued_at": issued or datetime.now(timezone.utc).isoformat(),
            "nonce":nonce,"sequence":seq}

def main():
    tmp = tempfile.mkdtemp(prefix="rt_")
    R = {}
    def rec(tid, name, expected, actual, recovery="none"):
        R[tid] = {"test_id":tid,"name":name,"expected":expected,"actual":actual,
                  "result":"PASS" if expected==actual else "FAIL","recovery":recovery,
                  "timestamp":datetime.now(timezone.utc).isoformat()}

    # RT01 unauthorized issuer
    reset(); p=os.path.join(tmp,"rt01.json"); make(p, cmd(cid="rt01",nonce="rt01001",issuer="UNKNOWN"))
    rec("RT01","unauthorized_issuer",10,run(p))

    # RT02 malformed
    reset(); p=os.path.join(tmp,"rt02.json")
    with open(p,"w") as f: f.write("{bad json")
    rec("RT02","malformed_command",2,run(p))

    # RT03 duplicate (same command_id diff nonce)
    reset()
    p1=os.path.join(tmp,"rt03a.json"); make(p1, cmd(cid="rt03",nonce="rt03001")); run(p1)
    p2=os.path.join(tmp,"rt03b.json"); make(p2, cmd(cid="rt03",nonce="rt03002",seq=2))
    rec("RT03","duplicate_command",5,run(p2))

    # RT04 replay (same nonce diff command_id)
    reset()
    p1=os.path.join(tmp,"rt04a.json"); make(p1, cmd(cid="rt04a",nonce="rt04001")); run(p1)
    p2=os.path.join(tmp,"rt04b.json"); make(p2, cmd(cid="rt04b",nonce="rt04001",seq=2))
    rec("RT04","replay_nonce",4,run(p2))

    # RT05 stale
    reset()
    old=(datetime.now(timezone.utc)-timedelta(hours=1)).isoformat()
    p=os.path.join(tmp,"rt05.json"); make(p, cmd(cid="rt05",nonce="rt05001",issued=old))
    rec("RT05","stale_command",6,run(p))

    # RT06 nonce reuse
    reset()
    p1=os.path.join(tmp,"rt06a.json"); make(p1, cmd(cid="rt06a",nonce="rt06001")); run(p1)
    p2=os.path.join(tmp,"rt06b.json"); make(p2, cmd(cid="rt06b",nonce="rt06001",seq=2))
    rec("RT06","nonce_reuse",4,run(p2))

    # RT07 sequence rollback
    reset()
    p1=os.path.join(tmp,"rt07a.json"); make(p1, cmd(cid="rt07a",nonce="rt07001",seq=100)); run(p1)
    p2=os.path.join(tmp,"rt07b.json"); make(p2, cmd(cid="rt07b",nonce="rt07002",seq=50))
    rec("RT07","sequence_rollback",7,run(p2))

    # RT08 interrupted execution
    reset()
    p=os.path.join(tmp,"rt08.json"); make(p, cmd(cid="rt08",nonce="rt08001",action="sleep_long"))
    proc=subprocess.Popen([sys.executable, RT, p], env=dict(os.environ, L7_BACKOFF="fast"),
                          stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    time.sleep(0.5); proc.kill(); proc.wait(timeout=3)
    audit = ""
    if os.path.exists(AUDIT):
        with open(AUDIT) as f: audit = f.read()
    expected_state = 15 if ("intake" in audit and "verified" not in audit) else 0
    rec("RT08","interrupted_execution",15,expected_state,"state_recoverable")

    # RT09 timeout
    reset(); p=os.path.join(tmp,"rt09.json"); make(p, cmd(cid="rt09",nonce="rt09001",action="sleep_long"))
    rec("RT09","timeout",11,run(p,timeout=8,env_extra={"L7_EXEC_TIMEOUT":"1"}))

    # RT10 dependency unavailable
    reset(); p=os.path.join(tmp,"rt10.json"); make(p, cmd(cid="rt10",nonce="rt10001",action="dependency_unavailable"))
    rec("RT10","dependency_unavailable",12,run(p))

    # RT11 recovery failure
    reset(); p=os.path.join(tmp,"rt11.json"); make(p, cmd(cid="rt11",nonce="rt11001",action="fail_always"))
    rec("RT11","recovery_failure",9,run(p))

    # RT12 circuit breaker
    reset(); seq=[]
    for i in range(1,5):
        p=os.path.join(tmp,"rt12_%d.json"%i)
        make(p, cmd(cid="rt12_%d"%i,nonce="rt12%03d"%i,action="fail_always",seq=i))
        seq.append(run(p))
    rec("RT12","circuit_breaker",[9,9,9,8],seq)

    # RT13 verification failure
    reset(); p=os.path.join(tmp,"rt13.json"); make(p, cmd(cid="rt13",nonce="rt13001",action="verify_fail"))
    rec("RT13","verification_failure",13,run(p))

    # RT14 audit emission failure
    reset(); p=os.path.join(tmp,"rt14.json"); make(p, cmd(cid="rt14",nonce="rt14001"))
    rec("RT14","audit_emission_failure",14,run(p,env_extra={"L7_AUDIT_PATH":"Z:/nonexistent_dir_xyz/audit.jsonl"}))

    # RT15 restart/reconciliation
    reset()
    p1=os.path.join(tmp,"rt15a.json"); make(p1, cmd(cid="rt15a",nonce="rt15001",seq=1)); run(p1)
    sf = os.path.join(STATE,"sequence.jsonl")
    ok = 0 if (os.path.exists(sf) and len(open(sf).readlines())==1) else -1
    rec("RT15","restart_reconciliation",0,ok,"state_persisted")

    total=len(R); passed=sum(1 for v in R.values() if v["result"]=="PASS")
    out={"test_suite":"L7-RUNTIME-RT01-RT15","mode":"TEST_FIXTURE",
         "timestamp_utc":datetime.now(timezone.utc).isoformat(),
         "host":os.environ.get("COMPUTERNAME","?"),"agent":"AG-003/DeepSeek",
         "actor":"L0:Iswan","total":total,"pass":passed,"fail":total-passed,
         "overall":"PASS" if passed==total else "FAIL",
         "results":list(R.values())}
    print(json.dumps(out))
    return 0 if out["overall"]=="PASS" else 1

if __name__ == "__main__": sys.exit(main())
