#!/data/data/com.termux/files/usr/bin/bash
LOG="$HOME/mico_jdeq/journal/security_audit.log"
echo "==========================================" >> $LOG
echo " AUDIT KEAMANAN $(date '+%Y-%m-%d %H:%M:%S')" >> $LOG
PASS=0; FAIL=0

# 1. Stempel DOLA
if ssh iswan@z83-server.tail2a1291.ts.net "[ -f /srv/jdeq/storage/authority/dola_seal.json ]" 2>/dev/null; then
    echo "✅ Stempel DOLA" >> $LOG; PASS=$((PASS+1))
else
    echo "❌ Stempel DOLA HILANG!" >> $LOG; FAIL=$((FAIL+1))
fi

# 2. Registry Agen
if ssh iswan@z83-server.tail2a1291.ts.net "[ -f /srv/jdeq/authority/agent_registry.json ]" 2>/dev/null; then
    echo "✅ Registry Agen" >> $LOG; PASS=$((PASS+1))
else
    echo "❌ Registry Agen HILANG!" >> $LOG; FAIL=$((FAIL+1))
fi

# 3. Kunci Kriptografi
KEY_COUNT=$(ssh iswan@z83-server.tail2a1291.ts.net "ls /srv/jdeq/authority/keys/ 2>/dev/null | wc -l")
if [ "$KEY_COUNT" -ge 8 ]; then
    echo "✅ Kunci Kriptografi ($KEY_COUNT)" >> $LOG; PASS=$((PASS+1))
else
    echo "❌ Kunci Kriptografi hanya $KEY_COUNT/8!" >> $LOG; FAIL=$((FAIL+1))
fi

# 4. Seragam Akses
if ssh iswan@z83-server.tail2a1291.ts.net "[ -f /srv/jdeq/authority/uniforms/tier_policy.json ]" 2>/dev/null; then
    echo "✅ Seragam Akses" >> $LOG; PASS=$((PASS+1))
else
    echo "❌ Seragam Akses HILANG!" >> $LOG; FAIL=$((FAIL+1))
fi

# 5. Terowongan Tailscale
if ssh -o ConnectTimeout=3 iswan@z83-server.tail2a1291.ts.net "echo OK" 2>/dev/null | grep -q OK; then
    echo "✅ Terowongan Tailscale" >> $LOG; PASS=$((PASS+1))
else
    echo "❌ Terowongan Tailscale PUTUS!" >> $LOG; FAIL=$((FAIL+1))
fi

# Ringkasan
echo "------------------------------------------" >> $LOG
echo "PASS: $PASS | FAIL: $FAIL" >> $LOG

# Kirim notifikasi hanya jika ada kegagalan
if [ $FAIL -gt 0 ]; then
    bash ~/mico_jdeq/scripts/send_alert.sh "🚨 AUDIT KEAMANAN: $FAIL kegagalan terdeteksi! Cek ~/mico_jdeq/journal/security_audit.log" 2>/dev/null
fi
echo "==========================================" >> $LOG
