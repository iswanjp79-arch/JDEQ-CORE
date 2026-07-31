#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: DEPLOY KANBAN BOARD DI Z83"
echo "=========================================="

# 1. Buat struktur Kanban di Z83
echo "[1/3] Membangun struktur Kanban..."
ssh iswan@z83-server.tail2a1291.ts.net "mkdir -p ~/mico_jdeq/kanban/{todo,in_progress,review,done} && echo '✅ Struktur Kanban siap.'"

# 2. Isi dengan tugas-tugas dari roadmap
echo "[2/3] Mengisi kartu tugas..."
ssh iswan@z83-server.tail2a1291.ts.net "cat > ~/mico_jdeq/kanban/todo/01_storage_broker.md << 'EOF'
# Tugas: Storage Broker
- [ ] Buat modul pemilih cloud otomatis
- [ ] Integrasikan dengan policy engine
- [ ] Uji dengan 2 akun Google Drive
EOF

cat > ~/mico_jdeq/kanban/todo/02_job_scheduler.md << 'EOF'
# Tugas: Distributed Job Scheduler
- [ ] Rancang sistem antrian job
- [ ] Buat worker pool di Radar
- [ ] Integrasikan dengan NATS
EOF

cat > ~/mico_jdeq/kanban/in_progress/03_state_manager.md << 'EOF'
# Tugas: Central State Manager
- [x] Buat state_manager.py
- [ ] Jalankan sebagai service 24/7
- [ ] Integrasikan dengan health_check.sh
EOF

cat > ~/mico_jdeq/kanban/done/04_health_check.md << 'EOF'
# Tugas: Health Check ✅
- [x] Perbaiki bug false negative
- [x] Verifikasi semua node ONLINE
- [x] Commit ke SSOT
EOF

echo '✅ Kartu tugas terisi.'"

# 3. Pasang Kanban Viewer (akses cepat)
echo "[3/3] Memasang Kanban Viewer..."
cat > ~/mico_jdeq/scripts/kanban_view.sh << 'EOF'
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
EOF
chmod +x ~/mico_jdeq/scripts/kanban_view.sh

# Commit
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0013: Deploy Kanban Board - Papan Kerja MICO-JDEQ di Z83" && echo "✅ Kanban Board terkunci."

echo "=========================================="
echo " KANBAN BOARD SIAP"
echo " Lihat: bash ~/mico_jdeq/scripts/kanban_view.sh"
echo "=========================================="
