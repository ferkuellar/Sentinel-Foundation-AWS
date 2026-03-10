# ADR-004: CloudTrail and VPC Flow Logs as Mandatory Baseline Telemetry

## Status
Accepted

## Context
The secure foundation baseline requires minimum viable telemetry for security, operations, and troubleshooting.

## Decision
This project treats CloudTrail and VPC Flow Logs as mandatory foundation telemetry.

## Rationale
This option was selected because it provides:
- API-level audit visibility through CloudTrail
- network-level visibility through Flow Logs
- better troubleshooting capability
- a stronger security baseline from the start

## Consequences
### Positive
- improved observability baseline
- stronger audit posture
- better support for incident review
- better enterprise readiness narrative

### Negative
- additional storage and ingestion cost
- more resources to maintain
- retention decisions must be documented

## Follow-up
A future evolution can add:
- AWS Config
- SNS alerting
- Security Hub
- GuardDuty
- centralized multi-account log aggregation
