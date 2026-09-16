#!/bin/bash
# MICO OMEGA STARTUP - Bangkitkan semua layanan
source ~/JDEQ/config/llama_params.conf

echo "[$(date)] MICO STARTUP DIMULAI"

# Matikan sisa proses lama
killall -9 llama-server mosquitto 2>/dev/null
sleep 2

# Hidupkan mosquitto
nohup mosquitto -c ~/JDEQ/config/mosquitto.conf > /dev/null 2>&1 &
sleep 2

# Hidupkan llama-server
nohup llama-server -m "$MODEL_PATH" \
    --host "$HOST" --port "$PORT" -c "$CONTEXT" -t "$THREADS" \
    --no-warmup -ngl 0 > /dev/null 2>&1 &
sleep 5

# Hidupkan Guardian
nohup ~/JDEQ/daemon/guardian_llama.sh > /dev/null 2>&1 &

echo "[$(date)] MICO STARTUP SELESAI"
