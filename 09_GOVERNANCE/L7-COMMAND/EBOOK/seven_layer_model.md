# SEVEN LAYER MODEL

Status: DRAFT
Versi: v1.0

## DEFINISI
7 Layer = model arsitektur internal MICO-JDEQ.
Bukan standar industri. Bukan pengganti OSI/TOGAF.

## DAFTAR LAYER

### L1 - Physical / Device
Perangkat fisik, sensor, aktuator, controller.
Contoh: PC-i5, Z83, HP Mini, Vivo Y28.

### L2 - Connectivity / Gateway
Komunikasi, transport, gateway.
Contoh: Tailscale, SSH, HTTPS, IPC lokal.

### L3 - Edge / Node
Node edge, runtime compute.
Contoh: PC-i5 worker, antiX edge.

### L4 - Raw Data / Evidence / Buffer
Data mentah, evidence, buffer.
Contoh: 08_EVIDENCE, log, raw telemetry.

### L5 - Logical Data / Processing
Data terstruktur, normalisasi, abstraksi.
Contoh: 02_DATA, index, schema.

### L6 - Application / Compute / AI
Aplikasi, compute, AI, analytical.
Contoh: Python script, local LLM.

### L7 - Collaboration / Workflow / Command
Kolaborasi, workflow, command.
Contoh: task contract, dashboard.

## GOVERNANCE = OVERLAY
Governance bukan layer ke-8. Overlay menyelimuti L1-L7.

## ATURAN PEMETAAN
Setiap capability HARUS dipetakan ke salah satu layer.
Kalau tidak bisa -> belum masuk arsitektur inti.

## PEMISAHAN
7 Layer != Management Cycle != Digital Awareness
!= Behavior Contract != 13 Subsystem != 16 Modul E-book