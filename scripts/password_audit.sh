#!/data/data/com.termux/files/usr/bin/bash
echo "=============================================="
echo " MICO-JDEQ PASSWORD STRENGTH AUDITOR"
echo "=============================================="
echo ""
echo "Masukkan password untuk diuji kekuatannya:"
read -s PASSWORD
echo ""

# Uji panjang
LENGTH=${#PASSWORD}
if [ "$LENGTH" -lt 8 ]; then
    echo "❌ GAGAL: Password terlalu pendek (minimal 8 karakter)."
    exit 1
fi

# Uji kompleksitas
HAS_UPPER=$(echo "$PASSWORD" | grep -q "[A-Z]" && echo 1 || echo 0)
HAS_LOWER=$(echo "$PASSWORD" | grep -q "[a-z]" && echo 1 || echo 0)
HAS_DIGIT=$(echo "$PASSWORD" | grep -q "[0-9]" && echo 1 || echo 0)
HAS_SPECIAL=$(echo "$PASSWORD" | grep -q "[!@#$%^&*()_+\-=\[\]{};':\"\\|,.<>\/?]" && echo 1 || echo 0)
COMPLEXITY=$((HAS_UPPER + HAS_LOWER + HAS_DIGIT + HAS_SPECIAL))

if [ "$COMPLEXITY" -lt 3 ]; then
    echo "❌ GAGAL: Password harus mengandung minimal 3 jenis karakter."
    exit 1
fi

# Uji dictionary
COMMON_WORDS="password 123456 qwerty admin letmein welcome monkey dragon master"
for WORD in $COMMON_WORDS; do
    if echo "$PASSWORD" | grep -qi "$WORD"; then
        echo "❌ GAGAL: Password mengandung kata umum '$WORD'."
        exit 1
    fi
done

# Estimasi waktu crack
if [ "$LENGTH" -ge 16 ] && [ "$COMPLEXITY" -eq 4 ]; then
    CRACK_TIME="Berabad-abad (Sangat Aman)"
elif [ "$LENGTH" -ge 12 ] && [ "$COMPLEXITY" -ge 3 ]; then
    CRACK_TIME="Tahunan (Aman)"
elif [ "$LENGTH" -ge 8 ] && [ "$COMPLEXITY" -ge 2 ]; then
    CRACK_TIME="Harian (Kurang Aman)"
else
    CRACK_TIME="Instan (Sangat Lemah)"
fi

echo "✅ PASSWORD KUAT!"
echo "   Panjang: $LENGTH karakter"
echo "   Kompleksitas: $COMPLEXITY/4"
echo "   Estimasi waktu crack: $CRACK_TIME"
echo ""
echo "=============================================="
