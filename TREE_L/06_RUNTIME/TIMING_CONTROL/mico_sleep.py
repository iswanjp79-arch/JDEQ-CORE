import time
import random
import os

def get_cpu_load():
    try:
        if os.name == "nt":
            return 0  # placeholder, PowerShell handles CPU on Windows
        else:
            load = os.getloadavg()[0] * 100
            return int(load)
    except Exception:
        return 0

def mico_sleep(base_min=1, base_max=15, backoff_level=0):
    if backoff_level > 0:
        backoff = min(2 ** backoff_level, 30)
        min_sleep = 1
        max_sleep = int(backoff)
    else:
        min_sleep = base_min
        max_sleep = base_max

    cpu = get_cpu_load()
    if cpu > 50:
        max_sleep = max(max_sleep, 30)

    sleep_time = random.randint(min_sleep, max_sleep)
    time.sleep(sleep_time)
