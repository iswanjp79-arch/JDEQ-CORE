#!/data/data/com.termux/files/usr/bin/bash
cat > ~/mico_jdeq/dashboard_web/health.json << EOF
{
  "nodes": {
    "scout": "$(pgrep sshd >/dev/null && echo 'ONLINE' || echo 'OFFLINE')",
    "radar": "$(ssh -o ConnectTimeout=2 iswan@z83-server.tail2a1291.ts.net 'echo ONLINE' 2>/dev/null || echo 'OFFLINE')",
    "penjaga": "$(ssh -o ConnectTimeout=2 -p 8022 iswan@100.103.39.81 'echo ONLINE' 2>/dev/null || echo 'OFFLINE')"
  },
  "timestamp": "$(date)",
  "commit": "$(git -C ~/mico_jdeq log --oneline -1 2>/dev/null || echo 'N/A')"
}
EOF
