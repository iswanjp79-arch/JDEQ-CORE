#!/data/data/com.termux/files/usr/bin/bash
PROMPT="${1:-Sebutkan 3 prinsip MICO-JDEQ.}"
LOG="$HOME/mico_jdeq/state/ai_gateway.log"

echo "[$(date)] PROMPT: $PROMPT" >> "$LOG"

# Cek model yang tersedia dan gunakan yang paling ringan dulu
if ollama list 2>/dev/null | grep -q "qwen"; then
    MODEL=$(ollama list 2>/dev/null | grep "qwen" | head -1 | awk '{print $1}')
    echo "[$(date)] ROUTING: $MODEL" >> "$LOG"
    ollama run "$MODEL" "$PROMPT" 2>/dev/null
elif ollama list 2>/dev/null | grep -q "phi"; then
    MODEL=$(ollama list 2>/dev/null | grep "phi" | head -1 | awk '{print $1}')
    echo "[$(date)] ROUTING: $MODEL" >> "$LOG"
    ollama run "$MODEL" "$PROMPT" 2>/dev/null
elif ollama list 2>/dev/null | grep -q "gemma"; then
    MODEL=$(ollama list 2>/dev/null | grep "gemma" | head -1 | awk '{print $1}')
    echo "[$(date)] ROUTING: $MODEL" >> "$LOG"
    ollama run "$MODEL" "$PROMPT" 2>/dev/null
else
    echo "No local model found." >> "$LOG"
    echo "⚠️ No local AI model available."
fi
