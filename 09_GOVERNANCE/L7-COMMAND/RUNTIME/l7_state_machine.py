TRANSITIONS = {
    "PROPOSED":   ["AUTHORIZED", "REJECTED", "BLOCKED"],
    "AUTHORIZED": ["ACCEPTED", "REJECTED", "BLOCKED"],
    "ACCEPTED":   ["EXECUTING", "REJECTED", "BLOCKED"],
    "EXECUTING":  ["SUCCEEDED", "FAILED", "BLOCKED"],
    "SUCCEEDED":  ["VERIFIED"],
    "FAILED":     ["RECOVERING", "ESCALATED", "BLOCKED"],
    "VERIFIED":   [],
    "RECOVERING": ["RECOVERED", "ESCALATED", "BLOCKED"],
    "RECOVERED":  [],
    "ESCALATED":  [],
    "REJECTED":   [],
    "BLOCKED":    [],
}

class StateMachine:
    def __init__(self, initial="PROPOSED"):
        if initial not in TRANSITIONS:
            raise ValueError("invalid initial: " + initial)
        self.state = initial
        self.history = [initial]

    def transition(self, to):
        allowed = TRANSITIONS.get(self.state, [])
        if to not in allowed:
            raise ValueError("invalid transition: " + self.state + " -> " + to)
        self.state = to
        self.history.append(to)
        return self.state
