#!/data/data/com.termux/files/usr/bin/bash
# SymThink Router — mengirim notifikasi ke semua agen saat SSOT diperbarui
MSG="🧠 SymThink: SSOT MICO-JDEQ telah diperbarui. Semua agen harap membaca ulang ~/current."
bash ~/mico_jdeq/scripts/send_alert.sh "$MSG" 2>/dev/null
echo "[$(date)] SymThink broadcast: $MSG" >> ~/mico_jdeq/journal/symthink.log
