# SPESIFIKASI PAKET MONUMEN — MICO-JDEQ
Kode   : MICO-P1-MONUMENT-SPEC-001
Status : DRAFT — MENUNGGU ACC L0
Mode   : PLANNING ONLY (ZIP belum dibuat)

## PRINSIP UTAMA
Monument = immutable snapshot dari artefak yang telah disahkan.
Monument BUKAN sumber otoritas baru. Monument BUKAN SSOT kedua.
Jika ada konflik antara monument dan SSOT → SSOT yang berlaku.
Monument hanya untuk: recovery, referensi historis, verifikasi integritas.

## STRUKTUR TARGET
01_GOVERNANCE_AND_DOCTRINE/
  V.21 · ADR-005 · ADR-005-REV1 · ADR-006 · Decree 2026-09-12
02_ARCHITECTURE_7_LAYERS/
  MICO-L7-IOT-AWARENESS-001 · OSI-LAYER-MAP · DEVICE-ROLES
03_BEHAVIOR_CONTRACTS/
  (MISSING_IN_SSOT — belum ada file formal)
04_MULTI_AGENT_DNA/
  PROMPT-AG001/003/004
09_GOVERNANCE/P1-PLANNING/MASTER-PLAN-v1.0/
  Master Plan · Core Logic · System Manifest · Key Manifest · Anchor Registry

## ATURAN MASUK / KELUAR
Masuk: hanya file SHA256-terverifikasi · tanpa plaintext secret · dalam scope
Keluar: provenance path · hash · kategori (Aktif/Historis/Referensi)

## YANG BELUM DILAKUKAN
ZIP belum dibuat · hash monument belum dihitung · belum ada kunci · belum commit.

**STATUS AKHIR: DRAFT — MENUNGGU ACC L0**