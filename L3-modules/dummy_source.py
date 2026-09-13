# dummy_source.py - test harness
def ok_source():
    return {"temp": 42, "cpu": 15, "status": "OK"}

def bad_source():
    raise Exception("Simulated failure")
