#!/bin/bash
OUT="/var/log/mico-jdeq/SECURITY_COMPLIANCE.json"
HASH_OUT="/var/log/mico-jdeq/SECURITY_COMPLIANCE.sha256"
ALERT_LOG="/var/log/mico-jdeq/ALERT.log"
mkdir -p "$(dirname "$OUT")"

TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S%z')
FAIL=""
STATUS="COMPLIANT"

# 1. UFW
if sudo ufw status | grep -q "Status: active"; then
  UFW="active"
else
  UFW="inactive"; FAIL="$FAIL firewall_ufw;"; STATUS="NON_COMPLIANT"
fi

# 2. SSH PasswordAuthentication
SSH_PASSWD=$(sudo grep -E '^PasswordAuthentication' /etc/ssh/sshd_config | awk 'NR==1 {print $2}')
if [ "$SSH_PASSWD" = "no" ]; then
  SSH_PASSWD_STATUS="ok"
else
  SSH_PASSWD_STATUS="vulnerable"; FAIL="$FAIL ssh_password_auth($SSH_PASSWD);"; STATUS="NON_COMPLIANT"
fi

# 3. PermitRootLogin
ROOT_LOGIN=$(sudo grep -E '^PermitRootLogin' /etc/ssh/sshd_config | awk 'NR==1 {print $2}'); [ -z "$ROOT_LOGIN" ] && ROOT_LOGIN="no"
if [ "$ROOT_LOGIN" = "no" ] || [ "$ROOT_LOGIN" = "prohibit-password" ]; then
  ROOT_LOGIN_STATUS="ok"
else
  ROOT_LOGIN_STATUS="weak($ROOT_LOGIN)"; FAIL="$FAIL ssh_permit_root($ROOT_LOGIN);"; STATUS="NON_COMPLIANT"
fi

# 4. Listener 8080
LISTEN=$(sudo ss -tuln | grep ':8080' | head -1)
if echo "$LISTEN" | grep -q '127.0.0.1'; then
  LISTENER_STATUS="local_only"
else
  LISTENER_STATUS="exposed($LISTEN)"; FAIL="$FAIL listener_8080_local;"; STATUS="NON_COMPLIANT"
fi

# 5. Failed SSH login 24 jam
FAILED_LOGIN=$(sudo journalctl -u ssh --since "24 hours ago" 2>/dev/null | grep -c "Failed password" | head -1 || echo 0)
if [ "$FAILED_LOGIN" -gt 5 ]; then
  FAIL="$FAIL failed_ssh_login_24h($FAILED_LOGIN);"; STATUS="NON_COMPLIANT"
fi

# 6. Verifier SAH
if tail -n 5 /var/log/mico-jdeq/VERIFIKASI_INDEPENDEN_20260817.log 2>/dev/null | grep -q "SAH"; then
  VERIFIER="SAH"
else
  VERIFIER="NOT_SAH"; FAIL="$FAIL verifier_sah;"; STATUS="NON_COMPLIANT"
fi

# 7. Evidence Chain Tail
EVIDENCE_LAST=$(tail -n 1 /var/log/mico-jdeq/EVIDENCE_CHAIN.sha256 | awk '{print $1}')
if [ -z "$EVIDENCE_LAST" ]; then
  FAIL="$FAIL evidence_chain_tail;"; STATUS="NON_COMPLIANT"
fi

cat > "$OUT" <<JSON
{
  "timestamp": "$TIMESTAMP",
  "ufw": "$UFW",
  "ssh_password_auth": "$SSH_PASSWD_STATUS",
  "ssh_permit_root": "$ROOT_LOGIN_STATUS",
  "listener_8080": "$LISTENER_STATUS",
  "failed_ssh_login_24h": "$FAILED_LOGIN",
  "verifier": "$VERIFIER",
  "evidence_chain_last_hash": "$EVIDENCE_LAST",
  "failures": "$FAIL",
  "status": "$STATUS"
}
JSON

sha256sum "$OUT" > "$HASH_OUT"

if [ "$STATUS" = "NON_COMPLIANT" ]; then
  echo "$(date '+%F %T %z') ALERT:security_compliance:$FAIL" >> "$ALERT_LOG"
fi

echo "=== SECURITY COMPLIANCE RESULT ==="
cat "$OUT"
echo ""
echo "=== HASH ==="
cat "$HASH_OUT"
