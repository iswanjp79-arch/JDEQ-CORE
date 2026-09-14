import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from l7_circuit_breaker import CircuitBreaker
CB_PATH = "D:/MICO_SSOT/08_EVIDENCE/L7-OPERATIONAL/runtime_state/circuit_breaker.json"
window = int(os.environ.get("L7_CB_WINDOW", "60"))
max_f  = int(os.environ.get("L7_CB_MAX", "3"))
cb = CircuitBreaker(CB_PATH, max_failures=max_f, window_seconds=window)
print("OPEN" if cb.is_open() else "CLOSED")
sys.exit(0 if cb.is_open() else 1)
