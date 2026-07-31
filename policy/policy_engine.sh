#!/data/data/com.termux/files/usr/bin/bash
ACTION="$1"
POLICY="$HOME/mico_jdeq/policy/policy.json"
DECISION=$(python3 -c "import json,sys; d=json.load(open('$POLICY')); r=[x for x in d['rules'] if x['action']=='$ACTION']; print(r[0]['decision'] if r else d['default'])")
echo "$DECISION"
