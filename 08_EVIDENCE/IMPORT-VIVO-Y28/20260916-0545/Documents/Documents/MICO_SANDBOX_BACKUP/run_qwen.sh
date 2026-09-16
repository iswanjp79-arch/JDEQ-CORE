#!/data/data/com.termux/files/usr/bin/bash
# run_qwen.sh - Jalankan Qwen GGUF di Termux

MODEL="$HOME/models/qwen/Qwen2.5-3B-Instruct-Q4_K_M.gguf"

# Cek keberadaan model
if [ ! -f "$MODEL" ]; then
    echo "❌ ERROR: Model tidak ditemukan di $MODEL"
    exit 1
fi

# Prompt user
read -p "Masukkan prompt untuk model: " PROMPT

# Jalankan llama-gguf
~/llama.cpp/build/bin/llama-gguf \
  -m "$MODEL" \
  -p "$PROMPT" \
  -n 128
