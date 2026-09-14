TRANSITIONS = {
    "PROPOSED":   ["AUTHORIZED", "REJECTED"],
    "AUTHORIZED": ["ACCEPTED", "REJECTED"],
    "ACCEPTED":   ["EXECUTING", "REJECTED"],
    "EXECUTING":  ["SUCCEEDED", "FAILED"],
    "SUCCEEDED":  ["VERIFIED"],
    "FAILED":     ["RECOVERING", "ESCALATED"],
    "VERIFIED":   [],
    "RECOVERING": ["RECOVERED", "ESCALATED"],
    "RECOVERED":  [],
    "ESCALATED":  [],
    "REJECTED":   [],
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
