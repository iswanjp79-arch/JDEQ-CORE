#!/data/data/com.termux/files/usr/bin/bash
MODEL="/data/data/com.termux/files/home/models/qwen/Qwen2.5-3B-Instruct-Q4_K_M.gguf"
# Goleki biner kanthi otomatis
EXEC=$(find $HOME/llama.cpp -name "llama-cli" -type f -executable | head -n 1)

if [ -z "$EXEC" ]; then
    EXEC=$(find $HOME/llama.cpp -name "llama-main" -type f -executable | head -n 1)
fi

if [ -f "$MODEL" ] && [ -x "$EXEC" ]; then
    echo "--- QWEN 3B READY (VIVO Y28) ---"
    read -p "Niat/Prompt: " PROMPT
    "$EXEC" -m "$MODEL" -p "$PROMPT" -n 128 --color
else
    echo "❌ ERROR: Model utawa Biner mboten ketemu."
    echo "Cek Model: $MODEL"
    echo "Cek Biner: $EXEC"
fi
