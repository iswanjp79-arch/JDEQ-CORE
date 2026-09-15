# MICO-JDEQ AGENT ROLE CONTRACT v1.0
Kontrak peran per provider AI.

## PRINSIP
Logical role ≠ provider binding.
Kalau provider diganti, arsitektur tidak berubah.

## LOGICAL ROLES

### 1. PLANNER
- Fungsi: strukturisasi ide makro, penyusunan awal
- Contoh provider: ChatGPT
- Batasan: tidak eksekusi, tidak commit, tidak akses terminal
- Output: dokumen draft

### 2. GATEWAY / TRANSLATOR
- Fungsi: terjemah niat L0 → instruksi teknis
- Contoh provider: Jarvis
- Batasan: tidak menambah interpretasi, hanya salurkan
- Output: instruksi terstruktur

### 3. POLICY ENGINE
- Fungsi: verifikasi kepatuhan, gate kebijakan
- Contoh provider: DOLA (Pengawas)
- Batasan: tidak eksekusi, tidak putus sendiri
- Output: PASS / BLOCK / MENUNGGU_L0

### 4. EXECUTOR
- Fungsi: eksekusi teknis, patch, verifikasi
- Contoh provider: DeepSeek
- Batasan: hanya eksekusi Task Card tertulis
- Output: bukti (hash, log, commit)

### 5. AUDITOR
- Fungsi: audit independen, verifikasi klaim
- Contoh provider: Claude, KIMI (candidate)
- Batasan: tidak menjadi bagian eksekusi
- Output: verdict + temuan + rekomendasi

### 6. RESEARCHER
- Fungsi: pencarian eksternal on-demand
- Contoh provider: Perplexity
- Batasan: output = referensi, bukan keputusan
- Output: sumber + ringkasan

### 7. COMPUTE PROVIDER
- Fungsi: komputasi berat on-demand
- Contoh provider: Gemini, cloud worker
- Batasan: hanya komputasi, bukan otoritas
- Output: hasil komputasi

## FORMAT HANDOFF ANTAR AGEN
1. Dari (role + provider)
2. Ke (role + provider)
3. Konteks (task_id)
4. Bukti (path, hash, commit)
5. Yang dibutuhkan (keputusan / eksekusi / audit)

## CATATAN
- Satu provider bisa multi-role (dengan pembatasan ketat)
- Satu role bisa multi-provider (untuk redundansi)
- Tidak ada role yang boleh self-approve