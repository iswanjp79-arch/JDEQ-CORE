STATUS = INVALID_METHOD
EVIDENCE_CLASS = METHODOLOGY_ERROR
NOT_VALID_FOR_DETERMINISM_CLAIM = TRUE

ALASAN:
Tiga output (gen-A, gen-B, gen-C) ditulis manual oleh AG-003 dengan
struktur BERBEDA SENGAJA (bukan hasil 3 inference terpisah dari prompt
identik). Ini bukan test determinisme. Hash yang berbeda adalah
konsekuensi dari variasi manual, bukan dari sifat probabilistik model.

TINDAKAN:
- Jangan gunakan untuk klaim determinisme
- Jangan dihapus (jejak audit)
- Sumber pelajaran: metodologi probe harus mengontrol prompt + parameter
