# STRUKTUR KOLOM MICO — Spesifikasi Teknis

## Status: DRAFT — MENUNGGU AUDIT L0
## Node: KAPAL-INDUK (PC-i5)

---

## 1. TUJUAN
Dokumen ini menetapkan spesifikasi kolom vertikal untuk beban kerja dan peletakan folder.
Setiap kolom adalah modul layanan ringan yang berdiri sendiri dan dikendalikan oleh TREE-L.

---

## 2. TABEL PERHITUNGAN BEBAN & PELETAKAN

| Kode | Nama Kolom | Fungsi | Letak Folder | Beban Max RAM | Sifat |
|------|------------|--------|--------------|---------------|-------|
| K1 | Pos Jaga / API Gateway | Zero Trust Gate, routing port/socket | 05_PIPELINE\GATEWAY_DAEMON | 150 MB | Always-on, ringan |
| K2 | Tandon Server | Local HTTP/Sinkron TANDON_UPDATE | 04_APLIKASI\LOCAL_SERVER | 100 MB | On-demand / idle |
| KP1 | Sanitation Daemon | Bio tank, bersihkan log/staging | 06_RUNTIME\SANITATION_DAEMON | 20 MB | Event-driven |
| KP2 | Rclone Sync | Sinkron cadangan ke cloud/remote | 05_PIPELINE\SYNC_RCLONE | 50 MB | Idle / periodic |

---

## 3. ANALISIS BEBAN STRUKTUR

### K1 — Pos Jaga / API Gateway
- **Fungsi utama:** Menerima dan memvalidasi setiap permintaan masuk.
- **Alur:** Menerima socket → periksa token → teruskan ke pipeline.
- **Risiko:** Port konflik jika tidak dikunci.
- **Proteksi:** Terapkan Zero Trust Policy, hanya bind ke IP Tailscale/localhost.

### K2 — Tandon Server
- **Fungsi utama:** Menyajikan file tandon lokal saat offline.
- **Alur:** Hidup saat dibutuhkan, mati setelah selesai.
- **Risiko:** Beban RAM jika dibiarkan hidup terus.
- **Proteksi:** Aktifkan hanya saat permintaan, berhenti otomatis.

### KP1 — Sanitation Daemon
- **Fungsi utama:** Membersihkan log tua dan file staging.
- **Alur:** Idle-state triggered.
- **Risiko:** Hapus file penting jika salah sasaran.
- **Proteksi:** Batas retensi, hash sebelum hapus, hanya folder tertentu.

### KP2 — Rclone Sync
- **Fungsi utama:** Sinkronisasi backup ke cloud/remote.
- **Alur:** Periodic / idle triggered.
- **Risiko:** Kebocoran kredensial.
- **Proteksi:** Credential hanya di Vault, token berumur pendek.

---

## 4. ATURAN MUTLAK
1. Tidak boleh membuat folder fisik sebelum ACC L0.
2. Beban RAM total kolom tidak boleh melebihi 320 MB saat idle.
3. Semua kolom wajib tercatat di MASTER_ROADMAP.json.
4. Setiap perubahan wajib evidence SHA256.
5. Kolom tidak boleh saling bertabrakan port/socket.

---

## 5. REKOMENDASI
- Mulai dari K1 dan K2 sebagai kolom utama.
- KP1 dan KP2 menyusul setelah K1-K2 stabil.
- Audit dilakukan per kolom, bukan langsung semua.

---

**Dokumen ini siap diaudit. Eksekusi fisik ditunda sampai ACC L0.**

DISAHKAN OLEH L0: ISWAN JUMAN PANCORO, ST. 2026-09-08 16:56:05
