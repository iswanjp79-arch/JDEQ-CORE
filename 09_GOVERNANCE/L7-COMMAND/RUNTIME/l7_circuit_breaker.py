import json, os, time

class CircuitBreaker:
    def __init__(self, path, max_failures=3, window_seconds=60):
        self.path = path
        self.max = max_failures
        self.window = window_seconds

    def _load(self):
        if not os.path.exists(self.path):
            return []
        try:
            with open(self.path, "r", encoding="utf-8") as f:
                data = json.load(f)
                return data.get("events", [])
        except Exception:
            return []

    def _save(self, events):
        os.makedirs(os.path.dirname(self.path), exist_ok=True)
        with open(self.path, "w", encoding="utf-8") as f:
            json.dump({"events": events}, f)

    def _prune(self, events, now):
        return [t for t in events if now - t < self.window]

    def is_open(self):
        now = time.time()
        return len(self._prune(self._load(), now)) >= self.max

    def record_failure(self):
        now = time.time()
        events = self._prune(self._load(), now)
        events.append(now)
        self._save(events)
        return len(events) >= self.max
