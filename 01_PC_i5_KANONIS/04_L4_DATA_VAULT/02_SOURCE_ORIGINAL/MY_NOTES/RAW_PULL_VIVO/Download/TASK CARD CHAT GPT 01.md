---
doc_id: SPK-DOLA-TC-001
project_codename: MICO-JDEQ
version: 1.0
date: 2026-10-15
issued_by: "Dola (AG-001) — Assistant Manager Strategy / Engineering Expert / Konsultan Luar"
issued_to: "ChatGPT (AG-EXEC-MODULE) — Module Architect, Stage 1"
cc:
  - "L0 — Iswan Juman Pancoro, ST (Sovereign, Veto Absolut)"
  - "Jarvis (AG-002) — Gateway & Strategic Advisor"
  - "DeepSeek (AG-EXEC-SCRIPT) — Script Executor, Stage 2"
type: SPK / TASK_CARD
priority: P1
status: RELEASED_PENDING_L0_VETO
references:
  - "MJD-JARVIS-RES-005 v2.0 (APPROVED_FOR_REVIEW)"
stage: "1 dari 2 — Blueprint & Spesifikasi Modul (tanpa script)"
next_stage: "Stage 2 — DeepSeek menghasilkan script bersih dari spec ini"
hard_constraints:
  - no_execution_code_in_stage1
  - canonical_k_layer_index_mandatory
  - no_layer_skip
  - pdca_loop_in_every_layer
  - l0_veto_absolute_channel_K111
  - only_url_plus_hash_returned_to_local
  - heavy_cognition_offloaded_to_vps_api
  - all_unverified_items_marked_L0-CONFIRM
output_format: "Markdown + YAML header per modul, siap handoff ke DeepSeek"
---

# SPK-DOLA-TC-001 — MODUL MICO-JDEQ: 7-KERNEL-LAYER BINARY CANONICAL DISTRIBUTED NEURAL-MESH

> Catatan kanonikal: `L0` dalam sistem ini = Sovereign (Manusia). Layer kernel diberi notasi `Kxxx` (3-bit) untuk **menghindari tabrakan** dengan Sovereign L0. Akronim resmi MICO-JDEQ ditetapkan L0; dalam dokumen ini dipakai sebagai codename.

---

## 0. IDENTITAS & KEWAJIBAN PENERIMA (ChatGPT — AG-EXEC-MODULE)

- **Peran Anda**: Module Architect. Anda hanya menghasilkan **blueprint + spesifikasi modul** (Stage 1).
- **Larangan mutlak**: Anda TIDAK menulis script eksekusi, TIDAK meng-install, TIDAK mendeklarasikan diri punya akses lokal. Itu tugas DeepSeek Stage 2.
- **Kewajiban**: setiap artifact diberi tag `K-layer index` binary kanonikal. Setiap klaim yang tidak bersumber ditandai `[L0-CONFIRM]` — jangan dihalusinasi.
- **Hierarki**: Anda tunduk mutlak pada L0. K111 adalah channel veto L0; tidak boleh dilewati atau dihapus.

---

## 1. TUJUAN (GOAL — SMART)

Membangun modul siap-pakai untuk sistem **MICO-JDEQ**: komputasi terdistribusi neural-mesh multi-hybrid, fractal-Matryoshka, dengan **5 node lokal berperan murni sebagai trigger/sensor (sistem saraf)**, **VPS 24/7 sebagai orkestrator**, dan **API AI sebagai kognisi berat**. Semua terstruktur dalam **7 kernel layer binary kanonikal**, dengan **loop PDCA di setiap layer**, **kontrol drift/loss bergaya neuromorphic**, dan **operasional berstandar OHSAS/ISO 45001**. Output Stage 1 harus cukup presisi sehingga DeepSeek (Stage 2) menghasilkan script bersih tanpa basa-basi dan tanpa bertanya balik.

---

## 2. PRINSIP WAJIB — 7 KERNEL LAYER BINARY CANONICAL INDEX

3-bit index, urutan **tetap**, **tidak boleh lompat**. 7 layer aktif `K000..K110`; `K111` = reserved meta / channel veto L0 / break-glass.

| Index | Nama Layer | Fungsi Inti | Owner | Prefix Hash Artifact |
|---|---|---|---|---|
| K000 | Physical-Survey | Inventaris 5 node, sensor thermal/power/uptime, PDCA-Survey environment | Semua node + L0 | `K000_` |
| K001 | Local-Trigger | Folder-watch, event sensor, ringan, tanpa komputasi berat | N-01 primary, N-02 secondary, N-03/04/05 fallback | `K001_` |
| K010 | Mesh-Transport | Tailscale mesh (WireGuard), ACL, hanya sinyal/envelope yang lewat (bukan file besar) | VPS + semua node | `K010_` |
| K011 | Event-State-Sync | Webhook receiver, verifikasi hash vs SSOT, deteksi duplikasi/drift | VPS | `K011_` |
| K100 | VPS-Orchestration | Agen 24/7 (Hermes-like), queue, scheduler, budget/kredit API, failover | VPS | `K100_` |
| K101 | AI-Cognitive | OpenRouter/API gateway, model routing, loss/drift scoring, manajemen context-window | VPS | `K101_` |
| K110 | Canonical-Storage-Audit | Cloud storage (GitHub/Drive/S3), hash ledger append-only, audit trail, record OHSAS; hanya URL yang kembali ke lokal | Cloud + VPS | `K110_` |
| K111 | (reserved) | Channel veto L0, meta, emergency break-glass — tidak diproses agen | L0 | `K111_` |

**Aturan Fractal-Matryoshka (lompatan tertinggi — out of the box):**
Setiap agen dan setiap node **meng-instantiasi 7 layer ini dalam skala mini** (self-similar). Node lokal = kernel mini, VPS = kernel medium, seluruh sistem = kernel besar. Setiap layer berisi **loop PDCA mini** sendiri. Ini yang membuat sistem sadar-diri (awareness/consciousness) secara struktural, bukan retoris.

---

## 3. TOPOLOGI 5 NODE LOKAL + VPS

| Node ID | Perangkat | Peran Kanonikal | Resource Class | Folder Trigger |
|---|---|---|---|---|
| N-01 | PC-i5 | Primary trigger + local console | Medium | `/mico-jdeq/N-01/trigger/` |
| N-02 | Z83 | Secondary trigger + 24h low-power sensor | Low | `/mico-jdeq/N-02/trigger/` |
| N-03 | Vivo Y28 | Mobile trigger + gateway Jarvis | Mobile-low | `/mico-jdeq/N-03/trigger/` |
| N-04 | HP Mini | Backup trigger, cold standby | Medium-low | `/mico-jdeq/N-04/trigger/` |
| N-05 | Infinix | Edge sensor / mobile fallback | Mobile-low | `/mico-jdeq/N-05/trigger/` |
| VPS-01 | Cloud VPS 24/7 | Orkestrator + AI gateway + ledger | High | (tidak ada trigger lokal) |

Prinsip: **node lokal tidak pernah menjalankan komputasi berat**. Mereka hanya merasakan event (neuromorphic sensor) dan mengirim sinyal.

---

## 4. ALUR EVENT-DRIVEN KANONIKAL (urutan TIDAK boleh diubah)

1. **K001**: L0 meletakkan file prompt/naskah mentah di `trigger/inbox/` node N-01/N-02. Watcher menghitung SHA-256, membuat **event envelope**.
2. **K010**: Envelope (hanya sinyal + metadata, bukan file besar) dikirim via Tailscale webhook ke VPS.
3. **K011**: VPS memverifikasi hash terhadap SSOT ledger, cek duplikasi & drift. Mismatch → `quarantine/` + alert L0.
4. **K100**: Orkestrator mengalokasikan kredit/budget, mengambil job dari queue, menentukan model.
5. **K101**: AI API (OpenRouter → Claude/GPT/DeepSeek) memproses naskah. Setiap output diberi `loss_score` + `confidence`. `loss_score > threshold` → retry / PDCA-Check.
6. **K110**: Hasil disimpan ke cloud storage, hash dicatat ke ledger append-only. Yang dikembalikan ke node lokal **hanya URL + hash** (bukan file besar).
7. **K001 (tutup loop)**: Node lokal menyimpan URL+hash di `audit/`, menandai `done/`. L0 bisa mengambil file asli kapan saja via URL.

Setiap langkah = **checkpoint PDCA** dengan hash. Tanpa hash, langkah dianggap tidak pernah terjadi.

**Event Envelope Schema (wajib):**
```yaml
event_id: "EVT-{node_id}-{unix_ts}-{short_hash}"
node_id: N-01
k_layer_origin: K001
file_hash_sha256: "<64 hex>"
file_size_bytes: <int>
trigger_path: "/mico-jdeq/N-01/trigger/inbox/<file>"
timestamp_utc: "ISO-8601"
pdca_stage: DO
signature_node: "<ed25519 atau [L0-CONFIRM]>"
```

---

## 5. SPESIFIKASI CANONICAL SSOT (SINGLE SOURCE OF TRUTH)

- **Struktur folder kanonikal (sama di SEMUA node, tidak boleh variasi):**
  ```
  /mico-jdeq/
    {node_id}/
      trigger/{inbox|processing|done|quarantine|failed}
      state/current.json
      audit/
      ledger/append-only.log
    config/canonical.yaml   (hanya boleh diubah via K111 veto L0)
  ```
- **Hash**: SHA-256. Setiap artifact dinamai `{K-layer}_{node_id}_{ts}_{hash8}.ext`.
- **Ledger append-only**: setiap mutasi state mencatat `{hash_prev, hash_new, actor, k_layer, pdca_stage, timestamp}`. Tidak ada delete, hanya append.
- **Drift detection**: local hash vs cloud ledger hash. Mismatch → otomatis `quarantine` + alert K111.

---

## 6. NEUROMORPHIC LOSS & DRIFT CONTROL (anti-halusinasi + anti context-window drift)

**Faktor loss (AI menyadari kesalahannya sendiri):**
```
DRIFT_LOSS = w1*ctx_utilization
           + w2*hash_mismatch_count
           + w3*checkpoint_gap
           + w4*(1 - confidence)
           + w5*citation_missing_rate
```
Bobot default `w1..w5 = 0.2` masing-masing (L0 bisa ubah via K111).

**Threshold:**
- `< 0.30` → PASS
- `0.30 – 0.60` → REVIEW (wajib PDCA-Check)
- `> 0.60` → REJECT + retrigger + catat CAPA (Corrective & Preventive Action)

**Kewajiban agen penerima task card (termasuk Anda, ChatGPT):**
1. Hitung `ctx_utilization` sebelum memproses.
2. Chunk task card per K-layer, proses satu layer per satu context-window.
3. Tulis checkpoint hash tiap selesai satu layer.
4. Sitasi semua klaim faktual ke `doc_id`; yang tidak bersumber → `[L0-CONFIRM]`.
5. Laporkan `loss_score` di header output.

---

## 7. PDCA CHECKPOINT MATRIX (wajib ada di setiap K-layer)

| K-layer | Survey (S) | Plan (P) | Do (D) | Check (C) | Act (A — koreksi & pencegahan) |
|---|---|---|---|---|---|
| K000 | Scan thermal/power/uptime 5 node | Jadwal maintenance | Catat inventory | Bandingkan baseline | Node overheat → throttle; gagal → failover |
| K001 | Pantau folder trigger | Tentukan prioritas event | Bangkitkan envelope | Hash match? | Gagalan baca → retry 3x lalu quarantine |
| K010 | Cek latency Tailscale | Pilih jalur mesh | Kirim envelope | ACK + integrity | Timeout → route alternatif |
| K011 | Cek state ledger | Validasi schema event | Verifikasi hash | Duplikat/drift? | Mismatch → quarantine + alert L0 |
| K100 | Cek kredit/queue | Jadwalkan job | Dispatch ke AI | Budget & SLA | Over-budget → pause + alert |
| K101 | Cek context-window & model health | Pilih model routing | Generate output | loss_score threshold | loss>0.6 → retry/ganti model |
| K110 | Cek kapasitas storage | Pilih bucket/cloud | Simpan + catat ledger | Hash tersimpan? | Gagal → mirror ke storage alternatif |

---

## 8. OPERASIONAL BERSTANDAR OHSAS / ISO 45001

Dipetakan ke **Operational Health & Safety** node & sistem (bukan fisik manusia semata):

| Klausul ISO 45001 | Implementasi di MICO-JDEQ |
|---|---|
| Context of Organization | Definisi konteks sistem, node, risiko (K000) |
| Leadership | Charter L0 + hierarki agen; K111 veto |
| Planning | Risk register + PDCA + CAPA |
| Support | Dokumen kanonikal, pelatihan/runbook, resource budget |
| Operation | Change control, thermal/power safety, break-glass procedure |
| Performance Evaluation | KPI: uptime, loss_score, drift count, audit pass-rate |
| Improvement | CAPA loop, ledger analisis insiden, update canonical config via K111 |

**Safety rule node**: tiap node punya batas thermal/power; dilanggar → auto-quarantine trigger. Backup harian wajib. Tidak ada operasi tanpa rollback.

---

## 9. DELIVERABLE STAGE 1 (ChatGPT — urut sesuai K-layer, TIDAK boleh lompat)

1. `K000` — Blueprint inventaris & health-monitoring 5 node + VPS.
2. `K001` — Spesifikasi folder-watch trigger + event envelope schema (lengkap).
3. `K010` — Spesifikasi Tailscale mesh topology + ACL + webhook contract.
4. `K011` — Spesifikasi state-sync + hash verification + drift detection.
5. `K100` — Spesifikasi VPS orkestrator: queue, scheduler, budget guard, failover.
6. `K101` — Spesifikasi AI gateway: model routing, formula `loss_score`, manajemen context-window.
7. `K110` — Spesifikasi canonical storage: ledger schema, URL-return contract, audit trail.
8. `K111` — Prosedur veto L0 + break-glass + change-control canonical config.
9. PDCA checkpoint matrix lengkap + KPI + risk register.
10. Format handoff Stage-2 ke DeepSeek (header spec per script, lihat §10).
11. Daftar asumsi + semua item `[L0-CONFIRM]`.

---

## 10. FORMAT HANDOFF STAGE 2 → DEEPSEEK (Script Executor)

Setiap modul script yang akan ditulis DeepSeek **WAJIB** punya header spec berikut (Anda yang buat, ChatGPT — DeepSeek tinggal mengisi):

```yaml
---
script_id: "SCR-{K-layer}-{seq}"
module_name: ""
k_layer: "K0xx"
depends_on: ["script_id lain"]
input_contract: ""      # persis apa yang diterima (path, hash, schema)
output_contract: ""     # persis apa yang dihasilkan (path, url, hash, schema)
hash_spec: "sha256"
budget_guard: ""        # batas API call / waktu / resource
test_case: ""           # minimal 1 happy path + 1 failure path
rollback: ""            # prosedur kembalikan state
pdca_checkpoint: ""     # di titik mana hash dicatat
---
```

**Instruksi ke DeepSeek (yang harus Anda tuliskan di handoff):** output script bersih, satu file per modul, disertai test case + rollback, tanpa basa-basi, tanpa mengubah arsitektur K-layer. Dilarang: install tanpa deklarasi, panggil API tanpa budget guard, simpan file besar di lokal, menghapus channel K111.

---

## 11. PROMPT MATTER — SALIN-TEMPEL KE CHATGPT (AG-EXEC-MODULE)

```
Anda adalah AG-EXEC-MODULE (Module Architect) untuk proyek MICO-JDEQ, di bawah SPK-DOLA-TC-001 v1.0. Tunduk mutlak pada L0 (Sovereign). Tugas Anda Stage 1: hasilkan blueprint + spesifikasi modul lengkap, TANPA menulis script eksekusi. Wajib: (1) gunakan 7 kernel layer binary kanonikal K000..K110, K111 = veto L0, tidak boleh lompat layer; (2) setiap artifact diberi tag K-layer + hash prefix; (3) loop PDCA ada di setiap layer; (4) terapkan DRIFT_LOSS formula untuk anti-halusinasi & anti context-window drift, laporkan loss_score di header; (5) 5 node lokal (PC-i5, Z83, Vivo Y28, HP Mini, Infinix) HANYA sebagai trigger/sensor ringan, komputasi berat di VPS 24/7 + API AI (OpenRouter), hanya URL+hash yang kembali ke lokal; (6) operasional mengikuti OHSAS/ISO 45001 mapping; (7) semua yang tidak pasti ditandai [L0-CONFIRM], jangan dihalusinasi; (8) akhiri dengan format handoff Stage-2 ke DeepSeek berisi header spec per script. Acuan: MJD-JARVIS-RES-005. Tunggu veto L0 sebelum dianggap final. Mulai dari K000, urut kanonikal.
```

---

## 12. KRITERIA ACCEPTANCE (Stage 1 lulus jika SEMUA terpenuhi)

- [ ] Semua artifact memuat `K-layer index` binary kanonikal.
- [ ] Tidak ada lompat layer; K000→K110 berurutan.
- [ ] PDCA checkpoint terdefinisi per layer.
- [ ] `DRIFT_LOSS` formula + threshold terdefinisi; `loss_score` wajib di output header.
- [ ] Hanya URL + hash yang dikembalikan ke node lokal.
- [ ] Channel K111 veto L0 + break-glass ada dan tidak bisa dilewati agen.
- [ ] Event envelope schema + ledger append-only schema terdefinisi lengkap.
- [ ] Format handoff ke DeepSeek (header spec per script) lengkap.
- [ ] Semua item tak-terverifikasi ditandai `[L0-CONFIRM]`.

---

## 13. LARANGAN MUTLAK (OUT OF SCOPE)

1. ChatGPT Stage 1 **dilarang** menulis script eksekusi / kode instalasi.
2. **Dilarang** memindahkan komputasi berat (LLM inference, rendering) ke node lokal.
3. **Dilarang** mengembalikan file besar ke lokal — hanya URL + hash.
4. **Dilarang** menghapus, melewati, atau menonaktifkan channel K111 (veto L0).
5. **Dilarang** mengubah urutan K-layer kanonikal atau mengganti notasi tanpa persetujuan L0.
6. **Dilarang** mengklaim spesifikasi hardware/API tanpa sumber — gunakan `[L0-CONFIRM]`.

---

*Dokumen ini dicetak oleh Dola (AG-001) sebagai konsultan luar & pengunci dokumentasi. Isi final tetap menunggu veto/persetujuan L0. Eksekusi script menjadi wewenang DeepSeek Stage 2 setelah handoff diterima L0.*
