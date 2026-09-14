# P2-TRANSPORT-DOCTRINE-RECONCILIATION

## Conflict
P2-2 asal menetapkan: transport: tailscale_mesh_only.
Doktrin MICO-DOC-MEGAZORD-001 menetapkan: Inner Zone tanpa Tailscale.
Konflik langsung antara desain baru dan doktrin lama.

## Governing Doctrine
MICO-DOC-MEGAZORD-001 tetap berlaku. Tidak diubah.
Doktrin lama mengikat seluruh desain P2.

## Affected Artifacts
- P2-2-alert_channel_spec.md   (transport field)
- P2-2-alert_delivery_policy.md (transport reference)
- P2-2-alert_message_schema.json (audit: tidak ada field transport — tidak diubah)
- SHA256SUMS.txt (regenerate)

## Decision
1. Alert Channel = GOVERNED_CHANNEL, bukan TAILSCALE_MESH_ONLY.
2. Inner Zone: channel lokal/gateway yang sesuai boundary.
3. Transport tidak boleh menjadi mekanisme otorisasi.
4. Tailscale: OPTIONAL / EXTERNAL TRANSPORT bila diotorisasi.

## Boundary
- Tailscale encryption != authorization
- Transport != identity
- Transport != policy
- Jalur internal tidak bergantung Tailscale.
- Jalur eksternal wajib otorisasi governance eksplisit.

## Migration Note
P2-2 menetapkan GOVERNED_CHANNEL sebagai baseline.
Jalur eksternal (termasuk Tailscale) dapat ditambahkan
sebagai ekstensi bila memperoleh ACC L0 tertulis, tercatat di ADR terpisah.

## Evidence
- Task Card MICO-L7-DEPLOY-FINAL-001 item 04 (asal)
- L0 perintah reconcile 2026-09-14 (dokumen ini)
- Revisi file: alert_channel_spec.md, alert_delivery_policy.md

## Final Status
p2_design: RECONCILED
p2_execution: NOT_STARTED
transport_conflict: RESOLVED
tailscale_inner_zone: FORBIDDEN
tailscale_outer_transport: OPTIONAL_AND_GOVERNED
