#!/data/data/com.termux/files/usr/bin/bash
echo "=== MICO-JDEQ HEALTH CHECK $(date +%H:%M:%S) ==="
echo "Scout  : ✅"
ssh iswan@z83-server.tail2a1291.ts.net 'curl -s http://localhost:8222/varz >/dev/null 2>&1 && echo "✅" || echo "❌"' | xargs -I{} echo "Radar  : {}"
ssh -p 8022 iswan@100.103.39.81 'pgrep sshd >/dev/null 2>&1 && echo "✅" || echo "❌"' | xargs -I{} echo "Penjaga: {}"
