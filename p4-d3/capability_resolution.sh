#!/bin/bash
echo "P4-D3 CAPABILITY RESOLUTION"
echo "CAPABILITY_REGISTRY:"
cat /home/iswanjp/mico/JDEQ-CORE-repo/registry/capability_registry.json
echo "NODE_REGISTRY:"
cat /home/iswanjp/mico/JDEQ-CORE-repo/registry/node_registry.json
echo "TIME: $(date -Iseconds)"
