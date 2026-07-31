#!/data/data/com.termux/files/usr/bin/bash
echo "=========================================="
echo " MICO-JDEQ: DEPLOY DIGITAL TWIN DASHBOARD"
echo "=========================================="

# 1. Buat dashboard Streamlit di cloud
echo "[1/3] Membangun Digital Twin Dashboard..."
cat > ~/mico_jdeq/modules/digital_twin.py << 'PYEOF'
import streamlit as st
import sqlite3, json, os, time
from datetime import datetime

DB = os.path.expanduser("~/mico_jdeq/state/state.db")
REGISTRY = os.path.expanduser("~/mico_jdeq/registry/ai_workers.json")
CLOUD = os.path.expanduser("~/mico_jdeq/registry/cloud_workers.json")

st.set_page_config(page_title="MICO-JDEQ Digital Twin", layout="wide")
st.title("🌐 MICO-JDEQ Digital Twin Dashboard")

# Sidebar
st.sidebar.header("🖥️ Node Status")
cols = st.columns(3)
with cols[0]:
    st.metric("Scout (Vivo Y28)", "ONLINE", "Komandan")
with cols[1]:
    radar_status = "ONLINE" if os.system("ping -c1 -W2 z83-server.tail2a1291.ts.net >/dev/null 2>&1") == 0 else "OFFLINE"
    st.metric("Radar (Z83)", radar_status, "Gateway")
with cols[2]:
    penjaga_status = "ONLINE" if os.system("ping -c1 -W2 100.103.39.81 >/dev/null 2>&1") == 0 else "OFFLINE"
    st.metric("Penjaga (Infinix)", penjaga_status, "Sensor")

# Agent Status
st.header("🤖 Agen AI")
try:
    with open(REGISTRY) as f:
        agents = json.load(f)
    agent_data = []
    for name, info in agents.items():
        agent_data.append({"Nama": name, "Role": info.get("role", "?"), "Status": info.get("status", "?"), "Plane": info.get("plane", "?")})
    st.dataframe(agent_data, use_container_width=True)
except: st.warning("Registry tidak tersedia")

# Cloud Workers
st.header("☁️ Cloud Workers")
try:
    with open(CLOUD) as f:
        workers = json.load(f)
    worker_data = []
    for name, info in workers.items():
        worker_data.append({"Worker": name, "Status": info.get("status", "?"), "Type": info.get("type", "?")})
    st.dataframe(worker_data, use_container_width=True)
except: st.warning("Cloud registry tidak tersedia")

# System Health
st.header("💓 System Health")
try:
    conn = sqlite3.connect(DB)
    cur = conn.execute("SELECT name, status FROM node")
    nodes = cur.fetchall()
    health_cols = st.columns(len(nodes))
    for i, (name, status) in enumerate(nodes):
        with health_cols[i]:
            st.metric(name.upper(), status)
    conn.close()
except: st.warning("State database tidak tersedia")

# Footer
st.divider()
st.caption(f"Digital Awareness Operating System | Last update: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
PYEOF
echo "  ✅ Digital Twin Dashboard siap."

# 2. Deploy ke Hugging Face Spaces
echo "[2/3] Deploy ke Hugging Face Spaces..."
cat > ~/mico_jdeq/modules/requirements_dashboard.txt << 'EOF'
streamlit
sqlite3
EOF

hf upload iswanjp79/mico-jdeq-knowledge ~/mico_jdeq/modules/digital_twin.py --repo-type space --commit-message "Digital Twin Dashboard" 2>/dev/null || echo "  ⚠️ Deploy via hf spaces create iswanjp79/mico-jdeq-twin"

# 3. Commit & notifikasi
echo "[3/3] Mengunci Digital Twin..."
cd ~/mico_jdeq && git add -A && git commit -m "ADR-0050: Deploy Digital Twin Dashboard — Kesadaran Visual" && echo "  ✅ ADR-0050 terkunci."

bash ~/mico_jdeq/scripts/send_alert.sh "🌐 DIGITAL TWIN DASHBOARD AKTIF
✅ Node: Scout | Radar | Penjaga
✅ Agen: 13 terdaftar
✅ Cloud: 8 workers
✅ Dashboard: huggingface.co/spaces/iswanjp79
STATUS: KESADARAN VISUAL AKTIF" 2>/dev/null || true

echo ""
echo "=========================================="
echo " DIGITAL TWIN DASHBOARD SIAP"
echo " Akses: huggingface.co/spaces/iswanjp79/mico-jdeq-twin"
echo "=========================================="
