#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# BRIDGE_MICO v3.0 - STABLE PRODUCTION
# Termux ↔ Llama.cpp ↔ Ubuntu (proot)
# Zero crash design
# ==========================================================

set -u

# ===== 1. KONFIGURASI =====
DISTRO="ubuntu"
MODEL_PATH="$HOME/models/qwen/Qwen2.5-3B-Instruct-Q4_K_M.gguf"
LLAMA_SEARCH_PATH="$HOME/llama.cpp"
LOG_FILE="$HOME/mico_bridge.log"

# ===== 2. VALIDASI ENVIRONMENT =====
if [ -n "${PROOT_DISTRO_NAME:-}" ]; then
    echo "ERROR: Jangan jalankan dari dalam proot."
    exit 1
fi

if [ ! -f "$MODEL_PATH" ]; then
    echo "ERROR: Model tidak ditemukan:"
    echo "$MODEL_PATH"
    exit 1
fi

if ! command -v proot-distro >/dev/null 2>&1; then
    echo "ERROR: proot-distro tidak terinstall di Termux."
    exit 1
fi

# ===== 3. DETEKSI BINARY LLAMA =====
LLAMA_EXEC=$(find "$LLAMA_SEARCH_PATH" -type f -executable \( -name "llama-cli" -o -name "main" -o -name "llama-main" \) 2>/dev/null | head -n 1)

if [ -z "$LLAMA_EXEC" ]; then
    echo "ERROR: Binary llama tidak ditemukan."
    exit 1
fi

# ===== 4. FUNGSI EKSEKUSI UBUNTU =====
run_in_ubuntu() {
    CMD="$1"

    echo ""
    echo "[UBUNTU EXEC]"
    echo "$CMD"
    echo ""

    echo "[`date`] $CMD" >> "$LOG_FILE"

    proot-distro login "$DISTRO" -- /bin/bash -c "$CMD"
}

# ===== 5. SYSTEM PROMPT =====
SYSTEM_PROMPT="Anda adalah MICO.
Jika perlu menjalankan perintah Ubuntu,
gunakan format tepat:
EXEC_START[perintah]EXEC_END
Tanpa penjelasan di dalam blok."

# ===== 6. HEADER =====
clear
echo "=============================================="
echo "   MICO ↔ UBUNTU BRIDGE v3.0 ACTIVE"
echo "=============================================="
echo "Binary  : $LLAMA_EXEC"
echo "Model   : $MODEL_PATH"
echo "Logfile : $LOG_FILE"
echo "Ketik 'exit' untuk keluar."
echo ""

# ===== 7. LOOP UTAMA =====
while true
do
    echo -n "Input> "
    read USER_INPUT || break

    if [ "$USER_INPUT" = "exit" ]; then
        break
    fi

    FULL_PROMPT="$SYSTEM_PROMPT
User: $USER_INPUT
MICO:"

    RESPONSE=$("$LLAMA_EXEC" \
        -m "$MODEL_PATH" \
        -p "$FULL_PROMPT" \
        -n 160 2>/dev/null)

    if [ -z "$RESPONSE" ]; then
        echo "[ERROR] Model tidak mengembalikan output."
        continue
    fi

    echo ""
    echo "[MICO]"
    echo "$RESPONSE"
    echo ""

    # ===== 8. PARSING NON-GREEDY AMAN =====
    EXEC_BLOCK=$(echo "$RESPONSE" | grep -o 'EXEC_START\[[^]]*\]EXEC_END')

    if [ -n "$EXEC_BLOCK" ]; then
        CMD=$(echo "$EXEC_BLOCK" | sed 's/EXEC_START\[//;s/\]EXEC_END//')
        run_in_ubuntu "$CMD"
    fi
done

echo ""
echo "Bridge dihentikan."
