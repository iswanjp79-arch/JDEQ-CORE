#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: SYMLINK & SYMTHINK ROUTER"
echo "=========================================="

# 1. Symlink /current → state terbaru
echo "[1/3] Membangun Symlink /current..."
ln -sf ~/mico_jdeq ~/current && echo "✅ /current → ~/mico_jdeq"

# 2. SymThink Router
echo "[2/3] Membangun SymThink Router..."
cat > ~/mico_jdeq/scripts/symthink_router.sh << 'ROUTER'
#!/data/data/com.termux/files/usr/bin/bash
# SymThink Router — mengirim notifikasi ke semua agen saat SSOT diperbarui
MSG="🧠 SymThink: SSOT MICO-JDEQ telah diperbarui. Semua agen harap membaca ulang ~/current."
bash ~/mico_jdeq/scripts/send_alert.sh "$MSG" 2>/dev/null
echo "[$(date)] SymThink broadcast: $MSG" >> ~/mico_jdeq/journal/symthink.log
ROUTER
chmod +x ~/mico_jdeq/scripts/symthink_router.sh && echo "✅ SymThink Router siap."

# 3. MATT Notifikasi (khusus saat diminta)
echo "[3/3] Membangun MATT Notifier..."
cat > ~/mico_jdeq/scripts/matt_notify.sh << 'MATT'
#!/data/data/com.termux/files/usr/bin/bash
# MATT — hanya mengirim notifikasi saat diminta (on-demand)
bash ~/mico_jdeq/scripts/send_alert.sh "📋 MATT: $1"
echo "[$(date)] MATT: $1" >> ~/mico_jdeq/journal/matt.log
MATT
chmod +x ~/mico_jdeq/scripts/matt_notify.sh && echo "✅ MATT Notifier siap."

# Commit
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0025: Symlink /current, SymThink Router, MATT Notifier" && echo "✅ Semua terkunci."

echo "=========================================="
echo " SYMLINK & SYMTHINK AKTIF"
echo " /current → ~/mico_jdeq"
echo " SymThink: broadcast ke semua agen"
echo " MATT: notifikasi on-demand"
echo "=========================================="
