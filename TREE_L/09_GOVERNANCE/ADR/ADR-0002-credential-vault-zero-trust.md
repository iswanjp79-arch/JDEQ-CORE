# ADR-0002: Credential Vault & Zero Trust Dasar

## Status: ACCEPTED

## Context
- Kunci API, kredensial, token tidak boleh tersebar.
- Prinsip Zero Trust: tidak percaya berdasarkan lokasi jaringan saja.

## Decision
- Kredensial TIDAK BOLEH di Git, TIDAK BOLEH di skrip hardcode.
- Lokasi brankas: Infinix (node satpam) terenkripsi, atau folder terenkripsi lokal dengan ACL ketat.
- Setiap akses kredensial: diverifikasi identitas, batas waktu singkat, dicatat audit.
- Prinsip: hak akses paling sedikit yang dibutuhkan.

## Consequences
- Positif: tidak ada kebocoran kunci, akses terkontrol.
- Negatif: butuh prosedur tambahan saat membutuhkan kredensial.

## Compliance
- NIST SP 800-207 Zero Trust
- OWASP Top 10 Agentic

## Evidence
- Hash file ini + catatan baseline keamanan.

## Timestamp + Author + SHA256
- Waktu: 2026-09-08 01:15 WIB
- Author: DeepSeek AG-003 / L0
- SHA256: E0025C0E073FB0FCD074A9A79B8DCFF998DC19203B12158E708A27DB7B3CF79E
