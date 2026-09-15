# ADR-005: PENYATUAN TATA KELOLA MENJADI SATU RUJUKAN SAH V.21

**Kode:** ADR-005
**Tanggal:** 2026-09-15
**Otoritas:** L0 - Iswan Juman Pancoro, ST
**Pelaksana:** DeepSeek (AG-003)
**Status:** DISAHKAN L0 - 2026-09-15

---

## 1. MASALAH

Terdapat 3 tempat penyimpanan tata kelola yang berjalan bersamaan:

1. `09_GOVERNANCE/` - dokumen aktif
2. `TREE_L/09_GOVERNANCE/` - salinan lama
3. `UU_MICO_JDEQ.md`, `MANUAL_BOOK_MICO_JDEQ.md` - salinan lama di akar

Kondisi ini melanggar prinsip Satu Sumber Kebenaran (SSOT).
Skor kelayakan audit: 49.75/100.

---

## 2. KEPUTUSAN

1. **Dokumen Sah Tunggal:**
   `MICO-P1-DEL03-GOV-001_CETAK-BIRU-V21.md`
   Menjadi SATU-SATUNYA aturan tata kelola yang berlaku.

2. **Berkas di akar (`UU_MICO_JDEQ.md`, `MANUAL_BOOK_MICO_JDEQ.md`):**
   Tetap disimpan sebagai arsip sejarah. Tunduk pada V.21. Tidak dipakai sebagai aturan berlaku.

3. **Berkas di `TREE_L/`:**
   Dianggap arsip pendukung. Bukan sumber aturan.

4. **Cara Pembaruan:**
   Selalu edit V.21. Salin ke tempat lain sebagai arsip.
   Jangan jadikan salinan lama sebagai aturan baru.

---

## 3. HASIL YANG DIHARAPKAN

Setelah disahkan L0, seluruh sistem merujuk ke V.21.
Tidak boleh ada aturan berbeda di tempat lain.
Skor kelayakan audit diharapkan menjadi 100/100.

---

## 4. PROVENANCE

- Dokumen acuan: MICO-P1-DEL03-GOV-001_CETAK-BIRU-V21.md
- SHA256 V.21 : 61DF1D881B329E88DEA85CE71965652D8F4754DBEFD58F480C6F031818373A58
- Disusun oleh: DeepSeek (AG-003)
- Tanggal     : 2026-09-15
- Status      : MENUNGGU PERSETUJUAN L0