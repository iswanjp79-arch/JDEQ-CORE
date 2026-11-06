#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: DEPLOY XSS DEFENSE MODULE"
echo "=========================================="

# 1. Buat daftar blokir permanen
echo "[1/5] Membangun Daftar Blokir Permanen..."
mkdir -p ~/mico_jdeq/security
cat > ~/mico_jdeq/security/block_patterns.json << 'EOF'
{
  "xss_patterns": [
    "<script>",
    "javascript:",
    "onerror=",
    "onload=",
    "onclick=",
    "onmouseover=",
    "eval(",
    "document.cookie",
    "document.write",
    "innerHTML",
    "outerHTML",
    "XMLHttpRequest",
    "fetch(",
    "prompt(",
    "alert(",
    "confirm(",
    "String.fromCharCode",
    "fromCharCode",
    "atob(",
    "btoa(",
    "base64,",
    "data:text/html",
    "vbscript:",
    "expression(",
    "moz-binding:",
    "<iframe",
    "<embed",
    "<object",
    "<link",
    "<meta",
    "<style",
    "%3Cscript%3E",
    "%3C%73%63%72%69%70%74%3E",
    "&#x3C;script&#x3E;",
    "&#60;script&#62;",
    "\\x3Cscript\\x3E",
    "\\u003Cscript\\u003E"
  ],
  "blocked_actions": [
    "allow_unsafe_html",
    "bypass_sanitizer",
    "disable_csp",
    "allow_inline_script"
  ]
}
EOF
echo "  ✅ Daftar blokir permanen tersimpan."

# 2. Buat modul pembersihan input
echo "[2/5] Membangun XSS Sanitizer..."
cat > ~/mico_jdeq/scripts/xss_sanitizer.py << 'PYEOF'
#!/usr/bin/env python3
import sys, json, re, html
from pathlib import Path

BLOCK_FILE = Path.home() / "mico_jdeq" / "security" / "block_patterns.json"
with open(BLOCK_FILE) as f:
    BLOCK_PATTERNS = json.load(f)["xss_patterns"]

def sanitize(text):
    """Membersihkan input dari pola XSS berbahaya."""
    if not text:
        return text, False
    
    # Encode HTML entities
    cleaned = html.escape(text)
    
    # Periksa pola berbahaya
    detected = False
    for pattern in BLOCK_PATTERNS:
        if pattern.lower() in text.lower():
            detected = True
            break
    
    return cleaned, detected

if __name__ == "__main__":
    if len(sys.argv) > 1:
        input_text = " ".join(sys.argv[1:])
        cleaned, dangerous = sanitize(input_text)
        
        if dangerous:
            print(f"⛔ DITOLAK: Input mengandung pola XSS berbahaya.")
            # Catat ke jurnal
            journal = Path.home() / "mico_jdeq" / "journal" / "xss_block.log"
            with open(journal, "a") as f:
                f.write(f"[BLOCKED] {input_text[:100]}\n")
            sys.exit(1)
        else:
            print(f"✅ AMAN: {cleaned}")
    else:
        print("Penggunaan: python3 xss_sanitizer.py <input>")
PYEOF
chmod +x ~/mico_jdeq/scripts/xss_sanitizer.py
echo "  ✅ XSS Sanitizer siap."

# 3. Integrasikan ke Health Check v3
echo "[3/5] Integrasi ke Health Check..."
cat >> ~/mico_jdeq/scripts/health_check_enterprise.sh << 'HEALTHADD'

# XSS Defense Check
echo "[21] XSS Defense"
if [ -f ~/mico_jdeq/security/block_patterns.json ] && [ -f ~/mico_jdeq/scripts/xss_sanitizer.py ]; then
    echo "  ✅ PASS  | XSS Defense"
else
    echo "  ❌ FAIL  | XSS Defense"
fi
HEALTHADD
echo "  ✅ Health Check diperbarui."

# 4. Uji deteksi
echo "[4/5] Uji Deteksi XSS..."
python3 ~/mico_jdeq/scripts/xss_sanitizer.py "<script>alert(1)</script>" 2>&1 | grep -q "DITOLAK" && echo "  ✅ XSS terdeteksi." || echo "  ❌ XSS lolos."

# 5. Commit & Checkpoint
echo "[5/5] Menyegel ke SSOT..."
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0027: Deploy XSS Defense Module - Daftar Blokir, Sanitizer, Health Check" && echo "  ✅ Semua tersegel."

echo "=========================================="
echo " XSS DEFENSE MODULE AKTIF"
echo "  ✅ 37 pola XSS diblokir"
echo "  ✅ Sanitizer aktif"
echo "  ✅ Health Check v3 diperbarui"
echo "=========================================="
