# PETA 7 LAYER RESMI MICO-JDEQ

## Prinsip
- Arsitektur logis = 7 Layer.
- Implementasi fisik = 14 Pilar TREE-L.
- Layer ≠ Folder. Satu layer dapat mencakup beberapa pilar.

## Pemetaan 7 Layer ke 14 Pilar
| Layer | Nama Layer | Pilar TREE-L |
|-------|------------|--------------|
| L1 | Physical Devices | 01_FISIK |
| L2 | Connectivity & Protocol | 05_PIPELINE (gateway, port, socket) |
| L3 | Edge Computing | 05_PIPELINE, 02_DATA (preprocessing lokal) |
| L4 | Data Accommodation | 02_DATA (RAW, STAGING, CURATED, TANDON_UPDATE) |
| L5 | Data Abstraction & Logic | 03_LOGIKA (RULES, STATE_MACHINE, GUARDRAILS) |
| L6 | Application Layer | 04_APLIKASI (CLI, SCRIPTS, WORKER) |
| L7 | Collaboration, Governance & Processing | 06_RUNTIME, 07_INDEX, 08_EVIDENCE, 09_GOVERNANCE, 10_SECURITY, 11_OBSERVABILITY, 12_BACKUP, 13_TEST, 99_ARCHIVE |

## Catatan
- Layer 3 dan Layer 4 berbagi peran preprocessing dan penyimpanan.
- Layer 7 adalah meta-layer yang menaungi seluruh sistem tata kelola.
- 14 pilar tidak boleh diubah tanpa Task Card + ACC L0.
