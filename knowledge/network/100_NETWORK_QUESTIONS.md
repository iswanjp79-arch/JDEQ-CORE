# 100 SOAL DASAR JARINGAN — MODUL PENGETAHUAN PERMANEN MICO-JDEQ
**Status:** LOCKED PERMANEN
**Sumber:** DOLA — Penjaga Doktrin
**Fungsi:** Kerangka tulang belakang Arsitektur MICO-JDEQ

## BAGIAN A: ISI LENGKAP 100 SOAL & PENJELASAN JARINGAN

### 1-20: Fondasi Jaringan
1. **OSI Model** — Kerangka 7 lapisan: Application, Presentation, Session, Transport, Network, Data Link, Physical. Ini adalah cetak biru 8 Lapisan MICO-JDEQ (7 OSI + 1 Awareness).
2. **TCP vs UDP** — TCP: andal,ACK, handshake, untuk SSH/HTTP. UDP: cepat, tanpa ACK, untuk DNS/VoIP/streaming.
3. **Subnetting** — Membagi jaringan besar menjadi kecil. 192.168.1.0/24 → 4 subnet /26. Seperti membagi kota jadi kecamatan.
4. **VLAN** — Jaringan virtual di switch fisik. VLAN 10,20,30 di hardware sama. Seperti rumah-rumah dalam satu kompleks.
5. **Access Port vs Trunk Port** — Access: 1 VLAN, end device. Trunk: banyak VLAN, antar switch.
6. **STP** — Mencegah loop Layer 2. Port states: Blocking, Listening, Learning, Forwarding.
7. **EtherChannel** — Gabung 2+ link fisik jadi 1 logis. LACP/PAgP.
8. **Routing** — Memilih jalur terbaik antar jaringan. Router pakai tabel routing.
9. **Static vs Dynamic Route** — Static: manual. Dynamic: belajar otomatis (OSPF, BGP).
10. **OSPF** — Link State, SPF Dijkstra, AD 110, fast convergence.
11. **OSPF Neighbor States** — Down, Init, 2-Way, ExStart, Exchange, Loading, Full.
12. **BGP** — Exterior Gateway, antar AS. ISP & internet backbone.
13. **BGP Path Selection** — Weight, Local Pref, AS Path, MED, eBGP/iBGP.
14. **NAT** — Private → Public IP. Static, Dynamic, PAT.
15. **ACL** — Filter lalu lintas. Standard (IP), Extended (IP+Port+Protokol).
16. **HSRP/VRRP/GLBP** — Redundansi gateway. HSRP (Cisco), VRRP (Open), GLBP (Load Balance).
17. **Administrative Distance** — Trustworthiness. Connected=0, Static=1, OSPF=110, BGP=200.
18. **Troubleshoot Internet** — Cek IP → Ping Gateway → DNS → Route → NAT → Firewall → ISP.
19. **OSPF Neighbor Down** — Cek Interface, IP, Area, Auth, MTU, Hello Timer.
20. **Current Project** — NIC project: Cisco routers, switches, VLAN, OSPF, BGP, monitoring.

### 21-40: Protokol & Layanan
21. **DHCP** — Otomatis IP. Discover → Offer → Request → Ack.
22. **DNS** — Nama → IP. www.google.com → 142.250.192.78.
23. **HTTP/HTTPS** — Web. Port 80/443. HTTPS = TLS.
24. **ICMP** — Error reporting, ping, traceroute.
25. **TTL** — Hop count. Windows 128, Linux 64, Cisco 255.
26. **MTU** — Paket terbesar. Ethernet 1500 byte.
27. **ARP** — IP → MAC. Cari alamat fisik.
28. **Ping** — Test konektivitas ICMP.
29. **Port** — Nomor logis layanan. SSH 22, HTTP 80, HTTPS 443.
30. **TCP vs UDP** — TCP andal, UDP cepat.
31. **STP Root Bridge** — Switch pusat. Bridge ID terendah.
32. **BPDU** — Frame STP untuk komunikasi topologi.
33. **STP Port Role** — Root, Designated, Alternate, Backup.
34. **Loopback** — Virtual, tak pernah mati. Testing & manajemen.
35. **Route Redistribution** — Berbagi rute antar protokol.
36. **Static Route** — Manual. `ip route 192.168.2.0 255.255.255.0 192.168.1.1`
37. **Default Route** — 0.0.0.0/0 → Next Hop.
38. **NAT** — Private → Public.
39. **PAT** — NAT Overload. Banyak IP private → 1 IP public.
40. **SNAT/DNAT** — Source NAT / Destination NAT.

### 41-60: OSPF & EIGRP
41. **Dead Time OSPF** — 4x Hello. Hello 10s → Dead 40s.
42. **Hello Interval OSPF** — 10s broadcast, 30s NBMA.
43. **LSA** — Link State Advertisement. Type 1-5.
44. **LSDB** — Database LSA seluruh OSPF domain.
45. **SPF Algorithm** — Dijkstra. Hitung jalur terbaik.
46. **Passive Interface** — Tak kirim hello, tetap advertise network.
47. **Route Summarization** — Ringkas rute. 192.168.0.0/24 + /25 → /22.
48. **Floating Static** — AD lebih tinggi dari dynamic. Backup.
49. **Feasible Successor** — Backup path EIGRP. Loop-free.
50. **Stub Area** — Blok LSA Type 5. Kurangi LSDB.
51. **Totally Stub** — Blok Type 5 & 3.
52. **NSSA** — Izinkan ASBR. Type 7 → Type 5.
53. **EIGRP** — Cisco proprietary. DUAL algorithm.
54. **DUAL** — Diffusing Update Algorithm. Loop-free, fast convergence.
55. **AD Values** — Connected=0, Static=1, EIGRP=90, OSPF=110, BGP=200.
56. **Default Route OSPF** — ASBR inject 0.0.0.0/0.
57. **NAT Overload** — PAT.
58. **PAT** — Port Address Translation.
59. **SNAT** — Source NAT.
60. **DNAT** — Destination NAT.

### 61-80: Keamanan & Redundansi
61. **IPSec** — Enkripsi IP. Transport/Tunnel mode.
62. **GRE Tunnel** — Enkapsulasi protokol dalam IP.
63. **VPN** — Tunnel aman via internet publik.
64. **MPLS** — Forwarding berbasis label.
65. **QoS** — Prioritas lalu lintas. Classification, Marking, Queuing.
66. **DiffServ** — QoS model. DSCP bits.
67. **CoS** — Layer 2 marking. 802.1Q header.
68. **STP Port States** — Blocking, Listening, Learning, Forwarding, Disabled.
69. **VTP** — Sinkronisasi VLAN database. Server/Client/Transparent.
70. **ERPS** — Ring protection < 50ms.
71. **BFD** — Deteksi kegagalan milidetik.
72. **HSRP** — Cisco gateway redundancy. Active/Standby.
73. **VRRP** — Open standard gateway redundancy.
74. **GLBP** — Gateway load balancing.
75. **NetFlow** — Statistik lalu lintas. Source/Dest IP, Port, Bytes.
76. **Syslog** — Log ke server pusat.
77. **AAA** — Authentication, Authorization, Accounting.
78. **TACACS+** — Cisco AAA. Enkripsi penuh.
79. **RADIUS** — Open standard AAA.
80. **802.1X** — Port-based authentication.

### 81-100: Nirkabel & Modern
81. **802.11** — Wi-Fi. a/b/g/n/ac/ax.
82. **NTP** — Sinkronisasi waktu.
83. **TFTP** — File transfer ringan. UDP 69.
84. **BootP** — DHCP pendahulu.
85. **TACACS+** — AAA Cisco.
86. **RADIUS** — AAA open.
87. **802.1X** — Autentikasi port.
88. **LLDP** — Discovery neighbors.
89. **CDP** — Cisco Discovery Protocol.
90. **Netmask** — Pisahkan network & host.
91. **Wildcard Mask** — Inverse subnet mask.
92. **VLSM** — Variable Length Subnet Masking.
93. **CIDR** — Classless Inter-Domain Routing.
94. **Link Aggregation** — EtherChannel, LACP.
95. **Microsegmentation** — Zona sangat kecil. Batasi penyebaran.
96. **Zero Trust** — Never trust, always verify.
97. **SDN** — Software Defined Networking.
98. **NFV** — Network Functions Virtualization.
99. **API in Networking** — Interface otomatisasi.
100. **Telemetry** — Monitoring real-time.

## BAGIAN B: PENJELASAN AWAM & SKEPTIS-ANALITIS
Jaringan adalah jalan raya data. OSI adalah cetak biru kota. VLAN adalah kompleks perumahan. Subnetting adalah pembagian kecamatan. OSPF adalah Google Maps-nya router. BGP adalah penerbangan internasional. QoS adalah jalur prioritas ambulans. Firewall adalah pos penjagaan. VPN adalah terowongan bawah tanah. Zero Trust adalah kota tanpa kepercayaan buta. SDN adalah mengubah jalan dengan pikiran.

**Skeptis:** Teknologi berubah, tapi aturan dasar (jalan, rambu, penjagaan) tidak pernah berubah. Ini adalah kerangka tulang belakang MICO-JDEQ.

## BAGIAN C: PETA HUBUNGAN DENGAN 8 LAPISAN MICO-JDEQ
| Lapisan MICO-JDEQ | Konsep Jaringan Terkait |
|-------------------|-------------------------|
| 1. Connection | TCP/UDP, Subnetting, VLAN, Routing, NAT, ACL, VPN, MPLS |
| 2. Storage | TFTP, BootP, Syslog, NetFlow |
| 3. OS | Loopback, NTP, TTL |
| 4. Service | DHCP, DNS, HTTP/HTTPS, AAA, RADIUS, TACACS+ |
| 5. Data | SNMP, Telemetry, NetFlow, Syslog |
| 6. Automation | SDN, NFV, API, Route Redistribution |
| 7. AI | QoS, BGP Path Selection, STP, OSPF SPF, DUAL |
| 8. Awareness | Zero Trust, 802.1X, Microsegmentation, IPSec, BFD, ERPS |

## BAGIAN D: KESADARAN DIGITAL & HEURISTIK
- Kesadaran Digital bergantung pada pengetahuan penuh tentang batas wilayah, kondisi jalan, dan aturan main (OSI, Subnetting, ACL).
- Otomasi Alur Kerja Agen butuh aturan lalu lintas jelas (VLAN, QoS, STP).
- Pemicu Kejadian Otomatis butuh sinyal yang benar dari jalur yang sah (ARP, ICMP, BFD).
- Keputusan Cerdas Sendiri (heuristik) butuh belajar dari pola lalu lintas (NetFlow, Telemetry).
- Pengembangan Kuantum tetap melewati aturan dasar ini; kuantum hanya mempercepat mobil, bukan mengubah aturan jalan.

## BAGIAN E: DAFTAR PEMICU & CARA PANGGIL
| Pemicu | Perintah |
|--------|---------|
| Cek koneksi | `health_check_enterprise.sh` |
| Cek subnet | `python3 subnet_calc.py 192.168.1.0/24` |
| Audit keamanan | `auto_audit_weekly.sh` |
| Muat arsenal | `load_arsenal.sh` |
| Semantic cache | `python3 gemini_cache.py "pertanyaan"` |
| Connection pool | `connection_pool.sh` |
| Kill-Switch | `killswitch.sh` |
| Beacon status | `beacon_status.sh` |
