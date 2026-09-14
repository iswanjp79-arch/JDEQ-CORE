import time

class CircuitBreaker:
    def __init__(self, max_failures=3, window_seconds=60):
        self.max = max_failures
        self.window = window_seconds
        self.events = []

    def _prune(self, now):
        self.events = [t for t in self.events if now - t < self.window]

    def record_failure(self):
        now = time.time()
        self._prune(now)
        self.events.append(now)
        return len(self.events) >= self.max

    def is_open(self):
        now = time.time()
        self._prune(now)
        return len(self.events) >= self.max
