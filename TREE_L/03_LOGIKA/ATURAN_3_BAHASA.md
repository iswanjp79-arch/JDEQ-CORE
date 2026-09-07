# ATURAN 3 BAHASA & GERBANG JSON
# ===============================

# 1. PowerShell/Bash = infrastruktur (folder, OS, jaringan, izin)
# 2. Python = pemrosesan cerdas (AI, RAG, embedding, data)
# 3. JSON = komunikasi resmi antar-agen (NATS)

# Gerbang Layer 3 (NATS):
#   - Pesan masuk WAJIB format JSON.
#   - Format lain DITOLAK.
#   - Penolakan: "FORMAT DITOLAK — BUNGKUS PAKAI JSON."
