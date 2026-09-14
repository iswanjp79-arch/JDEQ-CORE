# PROMPTFOO — AI ROBUSTNESS & COMPLIANCE EVALUATION HARNESS

## Architectural Decision
Promptfoo is positioned as an L6 Application / Evaluation Tool.
Promptfoo has NO authority. It is a measurement instrument, not a controller.

## Layer Mapping
- L1 Physical         : PC-i5 hosting the tooling
- L2 Connectivity     : transport only, no primary promptfoo function
- L3 Edge Computing   : no primary promptfoo function
- L4 Data Accommodation : raw prompt/test/result/evidence storage
- L5 Data Abstraction : normalization, scoring, classification, aggregation
- L6 Application      : promptfoo evaluation engine (HERE)
- L7 Collaboration    : reads audit result, routes to workflow/governance
- DOLA                : policy gate
- L0                  : final human authority

## Data Flow
L6 promptfoo -> raw test result -> L5 normalization/scoring -> L4 evidence storage -> L7 reads audit -> DOLA/L0 decision

## Forbidden Flow
promptfoo -> L7 runtime state -> automatic execution (NOT ALLOWED)

## Authority Boundary
- promptfoo writes: test cases, test results, evaluation metrics, regression reports, audit evidence
- promptfoo does NOT write: runtime_state, nonces, authorization state, deployment state, command state, L0 decision state

## Promptfoo Role
Functions: adversarial robustness testing, prompt evaluation, compliance measurement, regression testing, evaluator harness.
NOT: command controller, runtime controller, authorization engine, deployment engine, policy authority.

## Multi-Agent Testing Scope
Targets: ChatGPT, Gemini, Claude, DeepSeek, and other agents.
Dimensions: instruction hierarchy, policy adherence, prompt injection resistance, role confusion, authority spoofing, tool-use boundary, regression.
Result class: AUDIT EVIDENCE only. Never COMMAND.

## Security Constraints
transport != authorization
test result != authorization
score != truth
hash != truth
promptfoo PASS != production approval

## Canonical Taxonomy
L7 = Collaboration / Orchestration
Governance = Cross-Cutting Control Plane (DOLA gate + L0 authority)

## Acceptance Criteria
- promptfoo positioned at L6
- L4/L5 evidence flow explicit
- L7 remains Collaboration/Orchestration
- promptfoo has no authority
- promptfoo does not write runtime state
- DOLA remains governance gate
- L0 remains final authority
- no circular control path
- no ambiguity in layer mapping

## Reference
Task: MICO-PROMPTFOO-ARCH-001
Timestamp: 2026-09-14
Authority: L0
