#!/bin/bash
echo "P4-D10 REPLAN"
echo "REPLAN: PC-I5_UNREACHABLE -> KEEP_LOCAL_Z83_ONLY" > p4-d10/replan.txt
cat p4-d10/replan.txt
echo "TIME: $(date -Iseconds)"
