REQUIRED_FIELDS = ["command_id","correlation_id","issuer","action","issued_at","nonce","sequence"]

def validate(cmd):
    if not isinstance(cmd, dict):
        return False, "not_a_dict"
    for f in REQUIRED_FIELDS:
        if f not in cmd:
            return False, "missing:" + f
    if not isinstance(cmd["sequence"], int) or cmd["sequence"] < 0:
        return False, "invalid_sequence"
    if not isinstance(cmd["nonce"], str) or len(cmd["nonce"]) < 4:
        return False, "invalid_nonce"
    return True, "ok"
