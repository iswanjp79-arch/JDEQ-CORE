#!/data/data/com.termux/files/usr/bin/bash
MSG="🚨 MICO-JDEQ ALERT: $1"
curl -s -X POST "https://api.telegram.org/bot8052456691:AAHCaHomQBTveuSwRje0DAWTxjGXMS6ZaKU/sendMessage" \
  -d "chat_id=MASUKKAN_CHAT_ID" -d "text=$MSG" -d "parse_mode=HTML" > /dev/null 2>&1 && echo "✅ Alert terkirim." || echo "⚠️ Alert gagal."
