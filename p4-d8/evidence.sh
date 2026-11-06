#!/bin/bash
echo "P4-D8 EVIDENCE"
sha256sum registry/capability_registry.json registry/node_registry.json registry/policy_registry.json state/binding_state.json > p4-d8/evidence_manifest.sha256
cat p4-d8/evidence_manifest.sha256
echo "TIME: $(date -Iseconds)"
