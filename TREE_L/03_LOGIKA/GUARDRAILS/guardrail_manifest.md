# GUARDRAIL MANIFEST — 03_LOGIKA

## Prinsip
- Epistemic label: FACT, OBSERVED, INFERRED, ASSUMPTION, UNKNOWN.
- Dilarang hardcoded secret.
- Semua perubahan logika wajib terversi Git.

## Batas
- AI boleh memberi saran, tidak boleh eksekusi tanpa Task Card.
- Logika harus deterministic, bukan narasi bebas.
- Semua alur wajib JSON output.
