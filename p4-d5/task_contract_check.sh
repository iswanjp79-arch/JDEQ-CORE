#!/bin/bash
echo "P4-D5 TASK CONTRACT CHECK"
echo "TASK_CONTRACT_TAIL:"
tail -n 3 /var/log/mico-jdeq/TASK_CONTRACT.jsonl 2>/dev/null || echo "TASK_CONTRACT_NOT_FOUND"
echo "EVIDENCE_CHAIN_TAIL:"
tail -n 3 /var/log/mico-jdeq/EVIDENCE_CHAIN.sha256 2>/dev/null || echo "EVIDENCE_CHAIN_NOT_FOUND"
echo "TIME: $(date -Iseconds)"
