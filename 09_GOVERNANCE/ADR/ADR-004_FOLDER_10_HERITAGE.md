# ADR-004 — Status Folder 10_HERITAGE

- **Status**: ACCEPTED
- **Tanggal**: 2026-09-11
- **Konteks**: Folder 10_HERITAGE dibuat ad-hoc pada sesi rescue Vivo Y28 malam ini. Belum tercatat di struktur SSOT.
- **Keputusan**: 10_HERITAGE ditetapkan sebagai folder resmi SSOT untuk menyimpan aset warisan (heritage) yang bersumber dari node edge (Vivo Y28, HP Mini, dsb) sebelum diklasifikasi lebih lanjut.
- **Alasan**: Aset ini memiliki nilai historis dan bukti forensik yang tidak boleh tersebar atau terhapus.
- **Konsekuensi**:
  - 10_HERITAGE masuk daftar folder aktif SSOT
  - Isi 10_HERITAGE tidak boleh dihapus tanpa ADR baru
  - Setiap subfolder wajib punya README.md yang menjelaskan sumber dan tanggal
- **Bukti**: Sesi rescue 2026-09-11, manifest SHA256 di 10_HERITAGE\Vivo_Rescue\MANIFEST_SHA256.txt

## Struktur Saat Ini

```
10_HERITAGE/
  WARISAN_MADINA/          (3 file)
  MICO_OBSERVABILITY/      (6.034 file + analysis + manifest)
  Vivo_Rescue/             (~12,8 GB, 14 file + MANIFEST_SHA256)
```


