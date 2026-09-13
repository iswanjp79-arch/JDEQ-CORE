# FIXTURE EXECUTION PROVENANCE

- Timestamp : 2026-09-14_0530

## Target

Fixture T01-T12, harness di L7-modules/fixture/l7_fixture_harness.py

## Evidence Search

- Harness file     : D:\MICO_SSOT\L7-modules\fixture\l7_fixture_harness.py
  exists          : True
  mtime           : 09/14/2026 04:35:17
  sha256          : A00BE7CC288934EABD7C105F154CB96AE9F2EBBA562ACE5FC8B3DA8EFEBB1CAB
- Summary file     : D:\MICO_SSOT\09_GOVERNANCE\L7-COMMAND\RELIABILITY\FIXTURE-EVIDENCE\FIXTURE-TEST-SUMMARY.json
  exists          : True
  mtime           : 09/14/2026 04:35:30
  sha256          : 24C39295085126EF26A174DC623DF884475B5A349E6ED556042AA46091925388

## Search for per-test exit code traces

- Matching files in 08_EVIDENCE: 10
  D:\MICO_SSOT\08_EVIDENCE\L2\Z83\T05_resolution.md
  D:\MICO_SSOT\08_EVIDENCE\paralel\NET01_adapter_20260910_035141.txt
  D:\MICO_SSOT\08_EVIDENCE\paralel\NET01_ip_20260910_035141.txt
  D:\MICO_SSOT\08_EVIDENCE\paralel\NET01_resolv_wsl_20260910_035157.txt
  D:\MICO_SSOT\08_EVIDENCE\paralel\NET01_route_20260910_035141.txt
  D:\MICO_SSOT\08_EVIDENCE\paralel\TEST01_folders_20260910_035141.txt
  D:\MICO_SSOT\08_EVIDENCE\paralel\TEST01_mico_path_20260910_035141.txt
  D:\MICO_SSOT\08_EVIDENCE\paralel\TEST01_napak_syntax_20260910_035157.txt
  D:\MICO_SSOT\08_EVIDENCE\paralel\TEST01_payload_exist_20260910_035157.txt
  D:\MICO_SSOT\08_EVIDENCE\paralel\TEST01_syntax_20260910_035157.txt

## Scheduler History (Windows Task)

- Matching scheduled tasks : 23
  MICO-Boot | LastRun=08/24/2026 21:50:50 | Result=0
  MICO-L3-M1 | LastRun=09/14/2026 05:02:02 | Result=0
  MICO-L3-M2 | LastRun=09/14/2026 04:32:32 | Result=0
  MICO-L3-M3 | LastRun=09/14/2026 04:32:32 | Result=0
  MICO-L3-M4 | LastRun=09/14/2026 04:32:32 | Result=0
  MICO-PCi5-Monitor | LastRun=08/10/2026 23:46:46 | Result=1073807364
  MICO-PCi5-TaskExecutor | LastRun=08/11/2026 00:01:01 | Result=1073807364
  MICO-WSL-Wake | LastRun=09/14/2026 01:17:17 | Result=3221225786
  MICO_AI_DeepMonitor | LastRun=08/24/2026 22:50:50 | Result=0
  MICO_Background_Junk_Cleaner | LastRun=09/14/2026 01:20:20 | Result=4294770688
  MICO_Heartbeat | LastRun=09/14/2026 05:29:29 | Result=2147946720
  MICO_Master_Optimizer_Pro | LastRun=09/14/2026 01:20:20 | Result=4294770688
  MICO_Orchestrator | LastRun=09/08/2026 12:18:18 | Result=0
  MICO_PC5_INFINIX_HEARTBEAT | LastRun=08/24/2026 22:44:44 | Result=1
  MICO_Permanent_HDD_Optimizer | LastRun=09/06/2026 06:16:16 | Result=4294770688
  MICO_PowerBridge_Task | LastRun=11/30/1999 00:00:00 | Result=267011
  MICO_StorageWatchdog | LastRun=09/12/2026 15:37:37 | Result=4294770688
  MICO_Sync_Mercusuar | LastRun=09/14/2026 01:20:20 | Result=0
  MICO_TripSwitch | LastRun=09/14/2026 05:29:29 | Result=2147946720
  MICO_WinShizuku_Service | LastRun=09/14/2026 01:17:17 | Result=4294770688
  MICO_ZERO_TOUCH_STARTUP | LastRun=08/24/2026 22:40:40 | Result=1
  Microsoft-Windows-DiskDiagnosticDataCollector | LastRun=10/31/2025 21:45:45 | Result=0
  PLUGScheduler | LastRun=09/14/2026 05:17:17 | Result=0

## Verdict

Status : EXECUTION_PROOF_MISSING untuk per-test exit code trace.
SUPPORTED (bukan VERIFIED).
Upgrade SUPPORTED->VERIFIED tidak diizinkan tanpa trace per-test.
