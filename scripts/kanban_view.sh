#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ KANBAN BOARD"
echo "=========================================="
echo "📋 TODO:"
ssh iswan@z83-server.tail2a1291.ts.net "ls ~/mico_jdeq/kanban/todo/" 2>/dev/null
echo ""
echo "🔄 IN PROGRESS:"
ssh iswan@z83-server.tail2a1291.ts.net "ls ~/mico_jdeq/kanban/in_progress/" 2>/dev/null
echo ""
echo "👀 REVIEW:"
ssh iswan@z83-server.tail2a1291.ts.net "ls ~/mico_jdeq/kanban/review/" 2>/dev/null
echo ""
echo "✅ DONE:"
ssh iswan@z83-server.tail2a1291.ts.net "ls ~/mico_jdeq/kanban/done/" 2>/dev/null
echo "=========================================="
