#!/bin/bash
sudo bash /home/iswanjp/mico/p2/mico_task_contract.sh "$@" || exit 1
sudo cp /var/log/mico-jdeq/LAST_AUDIT_STAMP.json /home/iswanjp/mico/JDEQ-CORE-repo/p2/ 2>/dev/null
sudo cp /var/log/mico-jdeq/TASK_CONTRACT.jsonl /home/iswanjp/mico/JDEQ-CORE-repo/p2/ 2>/dev/null
sudo cp /var/log/mico-jdeq/EVIDENCE_CHAIN.sha256 /home/iswanjp/mico/JDEQ-CORE-repo/p2/ 2>/dev/null
echo "SYNC_OK"
