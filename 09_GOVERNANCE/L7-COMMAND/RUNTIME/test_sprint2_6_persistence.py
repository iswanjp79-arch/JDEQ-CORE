import json, os, sys, subprocess, shutil, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from l7_circuit_breaker import CircuitBreaker

HERE = os.path.dirname(os.path.abspath(__file__))
CHECK = os.path.join(HERE, "helper_check_cb.py")
CB_PATH = "D:/MICO_SSOT/08_EVIDENCE/L7-OPERATIONAL/runtime_state/circuit_breaker.json"

def reset():
    d = os.path.dirname(CB_PATH)
    if os.path.exists(d):
        shutil.rmtree(d, ignore_errors=True)
    os.makedirs(d, exist_ok=True)

def check_cb_new_process(window):
    e = dict(os.environ)
    e["L7_CB_WINDOW"] = str(window)
    e["L7_CB_MAX"] = "3"
    r = subprocess.run([sys.executable, CHECK], capture_output=True, text=True, env=e)
    return r.returncode == 0

def main():
    results = {}

    # W5: jendela 60s, sekring turun 3x, cek dari proses baru -> harus OPEN
    reset()
    cb = CircuitBreaker(CB_PATH, max_failures=3, window_seconds=60)
    for _ in range(3):
        cb.record_failure()
    results["W5_ingat_antar_restart"] = check_cb_new_process(60)

    # W6: jendela 2s, sekring turun 3x, tunggu 3s, cek dari proses baru -> harus CLOSED
    reset()
    cb = CircuitBreaker(CB_PATH, max_failures=3, window_seconds=2)
    for _ in range(3):
        cb.record_failure()
    time.sleep(3)
    results["W6_reset_setelah_waktu"] = not check_cb_new_process(2)

    ok = results["W5_ingat_antar_restart"] and results["W6_reset_setelah_waktu"]
    print(json.dumps({"results":results, "pass":ok}))
    return 0 if ok else 1

if __name__ == "__main__":
    sys.exit(main())
