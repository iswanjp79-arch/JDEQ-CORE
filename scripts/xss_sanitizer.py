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
