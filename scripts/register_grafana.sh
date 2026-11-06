#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: JIN BOTOL — REGISTER GRAFANA"
echo "=========================================="

# Daftar nama domain prioritas
DOMAINS=("mico-jdeq" "mico-jdeq-dashboard" "mico-jdeq-iswan" "iswanjp79-mico")

for DOMAIN in "${DOMAINS[@]}"; do
    echo "🔧 Mencoba: $DOMAIN"
    RESPONSE=$(curl -s -X POST "https://grafana.com/api/signup" \
        -H "Content-Type: application/json" \
        -d "{\"email\":\"iswanjp79@gmail.com\",\"username\":\"$DOMAIN\",\"password\":\"$(openssl rand -base64 16)\",\"orgName\":\"MICO-JDEQ\"}" 2>&1)
    
    if echo "$RESPONSE" | grep -q "success\|already exists\|created"; then
        echo "✅ BERHASIL: https://$DOMAIN.grafana.net"
        # Simpan ke SSOT
        cat > ~/mico_jdeq/registry/grafana.json <<< "{\"domain\":\"$DOMAIN\",\"url\":\"https://$DOMAIN.grafana.net\",\"status\":\"active\",\"registered_at\":\"$(date)\"}"
        cd ~/mico_jdeq && git add registry/grafana.json && git commit -m "ADR-0063: Register Grafana — $DOMAIN" && git push origin main
        echo "✅ Tersimpan di SSOT."
        break
    fi
    sleep 2
done

echo "=========================================="
echo " JIN BOTOL: GRAFANA REGISTERED"
echo "=========================================="
