# MICO-JDEQ ROADMAP 4 TAHAP (Lokal 6 Node -> Cloud)

## ATURAN MUTLAK
- Mesin Generator HANYA boleh menyedot data dari D:\MICO_DROPZONE_EDUKASI.
- Dilarang memindai seluruh Drive C/D/E secara barbar.

## TAHAP 1: Pembuatan Mesin Generator Lokal
- Input: folder D:\MICO_DROPZONE_EDUKASI
- Proses: indexing, embedding, chunking
- Output: vector database lokal (candidate: Chroma/FAISS)

## TAHAP 2: Membuat Agents
- Memanfaatkan pengetahuan hasil indexing
- Menjawab, menyusun, memutus sesuai Task Card
- Output: agent registry

## TAHAP 3: Membuat Automation
- Alur otomatis: data masuk -> dikenali -> diproses -> disimpan
- Output: pipeline script, scheduler

## TAHAP 4: Membuat Orchestrator
- Routing, queue, failover, bounded automation
- Output: orchestrator utama

## STATUS
- [x] TAHAP 1 - PLAN: Folder, roadmap, index plan dibuat
- [ ] TAHAP 1 - DO: Mesin indexing
- [ ] TAHAP 2 - AGENTS
- [ ] TAHAP 3 - AUTOMATION
- [ ] TAHAP 4 - ORCHESTRATOR
