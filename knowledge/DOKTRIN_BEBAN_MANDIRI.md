# DOKTRIN BEBAN MANDIRI — SETIAP PERANGKAT PUNYA BEBAN SENDIRI
**Status:** LOCKED PERMANENT
**Tanggal:** 31 Juli 2026

## Prinsip Utama
Setiap perangkat di ekosistem MICO-JDEQ wajib memikul bebannya sendiri. Tidak ada perangkat yang boleh membebani perangkat lain untuk mengunduh model AI atau data.

## Aturan Mutlak
1. Setiap perangkat mengunduh model AI-nya langsung dari internet (Ollama/HuggingFace).
2. Setiap perangkat menyimpan model AI-nya di penyimpanan lokalnya sendiri.
3. Tidak ada perangkat yang menjadi "server unduhan" untuk perangkat lain.
4. Internet 30 Mbps sudah dibayar — tidak ada alasan teknis untuk bergantung pada perangkat lain.
5. Kabel ghoib (LAN/SSH/Tailscale) hanya untuk komunikasi perintah, bukan untuk transfer model.

## Implementasi
| Perangkat | AI Lokal | Sumber Unduhan | Beban Sendiri |
|-----------|----------|----------------|---------------|
| Vivo Y28 | Qwen 2.5 3B | Ollama (WiFi) | ✅ Mandiri |
| Z83 | Phi-3 Mini | Ollama (LAN) | ✅ Mandiri |
| Infinix | Gemma 2B | Ollama (WiFi) | ✅ Mandiri |
| PC i5 | Llama 3.2 3B | Ollama (LAN) | ✅ Mandiri |
