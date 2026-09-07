# TASK CARD — FASE 0 & FASE 1 — PC-i5

- Task ID: MICO-PC5-TASK-001
- Class: B (Read-only audit + struktur)
- Status: Draft

## Objective
Membuat 14 folder pilar dan baseline audit sistem.

## Scope
- Struktur folder TREE_L 14 pilar.
- Audit read-only: OS, hardware, network, resource.

## Forbidden
- Instalasi software
- Mutasi sistem
- Hapus/format
- Akses Drive E tanpa health check

## Evidence Required
- baseline_audit_*.json di 01_FISIK/RESOURCE_BASELINE
- SHA256 manifest untuk file kunci

## Acceptance Criteria
- 14 folder ada
- baseline audit json ada
- hash SHA256 tercatat
