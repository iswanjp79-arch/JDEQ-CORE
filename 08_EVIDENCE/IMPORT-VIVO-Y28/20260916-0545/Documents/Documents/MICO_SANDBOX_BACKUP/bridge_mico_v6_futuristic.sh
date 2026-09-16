#!/bin/bash
# ========================================================
# NAMA       : bridge_mico_v6_futuristic.sh
# FUNGSI     : MICO ↔ Ubuntu Bridge Futuristik Out-of-the-box
# AUTHOR     : Senior Software Engineer Mode
# ========================================================

MODEL_PATH="$HOME/models/qwen/Qwen2.5-3B-Instruct-Q4_K_M.gguf"
LLAMA_EXEC=$(find $HOME -name "llama-cli" -type f -executable | head -n 1)
DISTRO="ubuntu"
LOGFILE="$HOME/mico_bridge.log"

# ===================== WARNA ===========================
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; MAGENTA='\033[0;35m'; NC='\033[0m'

# ===================== FUNSI ===========================
run_in_ubuntu() {
    local cmd=$1
    echo -e "${CYAN}[SYSTEM] Mengeksekusi di Ubuntu:${NC} $cmd" | tee -a "$LOGFILE"
    proot-distro login $DISTRO -- /bin/bash -c "$cmd" | tee -a "$LOGFILE"
}

speak() {
    if command -v termux-tts-speak &>/dev/null; then
        termux-tts-speak "$1"
    fi
}

# ===================== ANIMASI FUTURISTIK LOADING ======
show_loading() {
    chars=("█" "▓" "▒" "░")
    for i in {1..15}; do
        clear
        echo -e "${BLUE}==============================================${NC}"
        echo -e "${CYAN}   MICO ↔ UBUNTU BRIDGE v6.0 FUTURISTIK${NC}"
        echo -e "${BLUE}==============================================${NC}"
        # Logo ASCII berubah tiap frame
        echo -e "${YELLOW}▄▄ ▄▄  ██ ██  ▀▀█▄ ███▄███▄  ▀▀█▄${NC}"
        # Progress bar neon
        bar=""
        for j in $(seq 1 $i); do
            bar+="${GREEN}${chars[$((j%4))]}${NC}"
        done
        echo -e "${MAGENTA}[${bar}]${NC}"
        # Efek Matrix rain mini
        for col in $(seq 1 2); do
            echo -ne "${CYAN}"
            for k in $(seq 1 $((RANDOM%5+2))); do
                echo -n $((RANDOM%10))
            done
            echo -e "${NC}"
        done
        sleep 0.15
    done
    clear
}

# ===================== HEADER ==========================
show_loading
echo -e "${GREEN}Binary  : $LLAMA_EXEC${NC}"
echo -e "${GREEN}Model   : $MODEL_PATH${NC}"
echo -e "${GREEN}Logfile : $LOGFILE${NC}"
echo -e "${YELLOW}Ketik 'exit' untuk keluar.${NC}\n"

# ===================== LOOP INTERAKSI ==================
SYSTEM_PROMPT="Anda adalah MICO, AI berdaulat tinggi.
Anda memiliki akses ke Ubuntu/Kali Linux. 
Jika perlu menjalankan perintah teknis, tuliskan dalam format:
EXEC_START[perintah]EXEC_END."

while true; do
    echo -ne "${GREEN}Input> ${NC}"
    read USER_INPUT
    [[ "$USER_INPUT" == "exit" ]] && break

    # Jalankan MICO & tangkap output
    RESPONSE=$("$LLAMA_EXEC" -m "$MODEL_PATH" -p "$SYSTEM_PROMPT\nUser: $USER_INPUT\nMICO:" -n 256 --color)

    # Tampilkan dengan warna & TTS
    echo -e "${YELLOW}[MICO]:${NC}"
    echo "$RESPONSE" | tee -a "$LOGFILE"
    speak "$RESPONSE"

    # Parsing EXEC dan jalankan di Ubuntu
    while [[ "$RESPONSE" =~ EXEC_START\[(.*)\]EXEC_END ]]; do
        CMD="${BASH_REMATCH[1]}"
        run_in_ubuntu "$CMD"
        RESPONSE="${RESPONSE/EXEC_START\[$CMD\]EXEC_END/}"
    done
done

echo -e "${BLUE}=== Bridge MICO Terminated ===${NC}"
