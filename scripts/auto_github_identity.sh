#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: AUTO GITHUB IDENTITY & PAGES"
echo "=========================================="

TOKEN="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"
USER="iswanjp79-arch"
REPO="JDEQ-CORE"
API="https://api.github.com"

# 1. Update Profil GitHub
echo "[1/3] Memperbarui Profil GitHub..."
curl -s -X PATCH -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" \
  -d '{"name":"Iswan Juman Pancoro, ST","bio":"Arsitek MICO-JDEQ Awareness Digital | Digital Awareness Operating System | Warisan Madina","blog":"https://iswanjp79-arch.github.io/JDEQ-CORE","location":"Campurejo, Kendal, Jawa Tengah, Indonesia","company":"MICO-JDEQ"}' \
  "$API/user" | python3 -c "import json,sys; d=json.load(sys.stdin); print(f'  ✅ Profil: {d.get(\"login\",\"?\")} — {d.get(\"bio\",\"?\")}')" 2>/dev/null

# 2. Aktifkan GitHub Pages
echo "[2/3] Mengaktifkan GitHub Pages..."
curl -s -X POST -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" \
  -d '{"source":{"branch":"main","path":"/"}}' \
  "$API/repos/$USER/$REPO/pages" | python3 -c "import json,sys; d=json.load(sys.stdin); print(f'  ✅ Pages: {d.get(\"html_url\",\"?\")} — Status: {d.get(\"status\",\"?\")}')" 2>/dev/null || echo "  ⚠️ Pages sudah aktif atau perlu verifikasi manual."

# 3. Verifikasi
echo "[3/3] Verifikasi..."
PAGES_URL="https://$USER.github.io/$REPO"
echo "  🌐 Website: $PAGES_URL"
sleep 3
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$PAGES_URL")
if [ "$HTTP_CODE" = "200" ]; then
    echo "  ✅ Website AKTIF (HTTP $HTTP_CODE)"
else
    echo "  ⏳ Website dalam proses (HTTP $HTTP_CODE) — tunggu 1-2 menit."
fi

# Notifikasi
bash ~/mico_jdeq/scripts/send_alert.sh "🌐 GITHUB IDENTITY AUTO-DEPLOYED
✅ Profil: Iswan Juman Pancoro, ST
✅ Bio: Arsitek MICO-JDEQ
✅ Website: $PAGES_URL
STATUS: IDENTITAS DIGITAL SAH" 2>/dev/null || true

echo ""
echo "=========================================="
echo " IDENTITAS GITHUB & PAGES OTOMATIS"
echo " Website: $PAGES_URL"
echo "=========================================="
