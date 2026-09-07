# NETWORK BOUNDARY — 10_SECURITY

[Cloud] --(Tailscale)--> [Z83 Mandor] --(NATS JSON)--> [PC-i5]
[Vivo Y28] --(Tailscale/SSH)--> [Z83/PC-i5]

# Aturan:
- Cloud tidak boleh akses TREE_L langsung.
- Semua akses remote lewat Tailscale.
