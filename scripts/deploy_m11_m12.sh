#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: DEPLOY M11 & M12"
echo "=========================================="

# ===== M11: EMERGENCY KILL-SWITCH HUD =====
echo "[M11] Membangun Emergency Kill-Switch..."
cat > ~/mico_jdeq/scripts/killswitch.sh << 'KILL'
#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ EMERGENCY KILL-SWITCH"
echo "=========================================="
echo "[!] MEMUTUS SEMUA KONEKSI..."
tailscale down 2>/dev/null || echo "   Tailscale tidak aktif."

echo "[!] MEMBERSIHKAN CACHE & TOKEN..."
rm -rf ~/.cache/mico_tmp/* 2>/dev/null
rm -rf __pycache__ 2>/dev/null
pkill -f "python3" 2>/dev/null || true

echo "[!] MENGUNCI STATE DATABASE..."
[ -f ~/mico_jdeq/state/state.db ] && chmod 400 ~/mico_jdeq/state/state.db 2>/dev/null

echo "[!] MENGIRIM NOTIFIKASI DARURAT..."
bash ~/mico_jdeq/scripts/send_alert.sh "🚨 KILL-SWITCH DIAKTIFKAN! Semua koneksi diputus. Sistem terkunci." 2>/dev/null || true

echo ""
echo "=========================================="
echo " BENTENG DITUTUP TOTAL."
echo " VIVO Y28 ADHEM & AMAN."
echo "=========================================="
KILL
chmod +x ~/mico_jdeq/scripts/killswitch.sh
echo "  ✅ Kill-Switch siap: ~/mico_jdeq/scripts/killswitch.sh"

# ===== M12: SELF-HEALING STEALTH BEACON =====
echo "[M12] Membangun Self-Healing Beacon..."

# Beacon di Z83: pantau heartbeat Vivo
ssh iswan@z83-server.tail2a1291.ts.net "cat > ~/mico_jdeq/stealth_beacon.sh << 'BEACON'
#!/bin/bash
# Self-Healing Stealth Beacon - berjalan di Z83
LOG=\"\$HOME/mico_jdeq/journal/beacon.log\"
VIVO_IP=\"100.122.97.37\"
SILENT_MODE=false
FAIL_COUNT=0

while true; do
    if ping -c1 -W3 \$VIVO_IP > /dev/null 2>&1; then
        FAIL_COUNT=0
        if [ \"\$SILENT_MODE\" = true ]; then
            echo \"\$(date): VIVO KEMBALI - Bangun dari stealth mode\" >> \$LOG
            sudo systemctl start nats-server 2>/dev/null
            tailscale up 2>/dev/null
            SILENT_MODE=false
            echo \"\$(date): LAPORAN: Sistem normal, \$(uptime -p)\" >> \$LOG
        fi
        sleep 60
    else
        FAIL_COUNT=\$((FAIL_COUNT + 1))
        if [ \$FAIL_COUNT -ge 360 ] && [ \"\$SILENT_MODE\" = false ]; then
            echo \"\$(date): VIVO HILANG >6 JAM - Masuk stealth mode\" >> \$LOG
            sudo systemctl stop nats-server 2>/dev/null
            tailscale down 2>/dev/null
            tar -czf /tmp/state_backup_\$(date +%Y%m%d).tar.gz \$HOME/mico_jdeq/state/ 2>/dev/null
            SILENT_MODE=true
        fi
        sleep 10
    fi
done
BEACON
chmod +x ~/mico_jdeq/stealth_beacon.sh
echo '✅ Beacon Z83 siap.'"

# Pasang beacon sebagai service di Z83
ssh iswan@z83-server.tail2a1291.ts.net "sudo tee /etc/systemd/system/mico-beacon.service > /dev/null << 'SVC'
[Unit]
Description=MICO-JDEQ Self-Healing Stealth Beacon
After=network.target

[Service]
ExecStart=/home/iswan/mico_jdeq/stealth_beacon.sh
Restart=always
User=iswan

[Install]
WantedBy=multi-user.target
SVC
sudo systemctl daemon-reload && sudo systemctl enable mico-beacon --now && echo '✅ Beacon service aktif.'"

# Buat laporan beacon untuk HUD Vivo
cat > ~/mico_jdeq/scripts/beacon_status.sh << 'STATUS'
#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ STEALTH BEACON STATUS"
echo "=========================================="
echo "Z83 Beacon:"
ssh iswan@z83-server.tail2a1291.ts.net "tail -5 ~/mico_jdeq/journal/beacon.log 2>/dev/null || echo '  Belum ada log.'"
echo ""
echo "Kill-Switch:"
echo "  Ketik: bash ~/mico_jdeq/scripts/killswitch.sh"
echo "=========================================="
STATUS
chmod +x ~/mico_jdeq/scripts/beacon_status.sh
echo "  ✅ Beacon status siap: ~/mico_jdeq/scripts/beacon_status.sh"

# Commit
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0031: Deploy M11 (Kill-Switch) & M12 (Stealth Beacon)" && echo "✅ M11 & M12 terkunci."

# Kirim notifikasi
bash ~/mico_jdeq/scripts/send_alert.sh "🛡️ M11 & M12 AKTIF
✅ Emergency Kill-Switch siap
✅ Self-Healing Beacon Z83 aktif
✅ Stealth mode: auto saat Vivo hilang
STATUS: AMAN — Jarvis & DOLA mengawasi" 2>/dev/null || true

echo ""
echo "=========================================="
echo " M11 & M12 SELESAI"
echo " Kill-Switch : bash ~/mico_jdeq/scripts/killswitch.sh"
echo " Beacon      : Z83 memantau Vivo 24/7"
echo "=========================================="
