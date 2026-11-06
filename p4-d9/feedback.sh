#!/bin/bash
echo "P4-D9 FEEDBACK"
echo "[$(date -Iseconds)] P4-D9_FEEDBACK_OK" >> p4-d9/feedback.log
cat p4-d9/feedback.log
echo "TIME: $(date -Iseconds)"
