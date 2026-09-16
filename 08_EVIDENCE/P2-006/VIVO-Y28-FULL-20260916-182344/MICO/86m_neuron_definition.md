# Definisi 86 Miliar Neuron — MICO-JDEQ

**BUKAN:** 86 miliar proses yang berjalan bersamaan.
**MELAINKAN:** Jumlah total siklus eksekusi (neuron) yang lahir dan mati sepanjang umur sistem.

**Satu Neuron Digital:**
1. Menerima STATE saat ini.
2. Menerapkan satu ATURAN (policy/reasoning/verification).
3. Menghasilkan STATE baru yang terverifikasi.
4. Neuron mati setelah siklus selesai.

**Lifecycle Neuron:**
- Spawn: Saat event terdeteksi.
- Execute: Menjalankan aturan.
- Verify: Memeriksa hasil.
- Destroy: Neuron dihapus, hanya log yang tersisa.

**Scheduler:** Autopilot (setiap 60 detik).
**Pool Worker:** Heartbeat, Policy, Reasoning, Verification.
