#!/bin/bash
echo "P4-D1 IDENTITY CHECK"
echo "NODE: $(hostname)"
echo "TAILSCALE_IP: $(tailscale ip -4 2>/dev/null | head -1)"
echo "TIME: $(date -Iseconds)"
