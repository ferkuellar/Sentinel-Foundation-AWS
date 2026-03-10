# ADR-005: Establish AWS Config Baseline Before Advanced Governance Controls

## Status
Accepted

## Context
The project aims to build an enterprise-style AWS secure foundation baseline in progressive phases. A decision is required on whether to introduce AWS Config early as a foundational governance control or defer governance visibility until more advanced services are added.

## Decision
This project enables AWS Config in the foundation baseline before introducing more advanced governance and security services.

## Rationale
This option was selected because it provides:
- continuous visibility into resource configuration
- a stronger governance story early in the project
- better support for audit and change tracking
- a cleaner progression toward compliance-oriented controls

## Consequences
### Positive
- configuration state becomes part of the baseline
- stronger architecture defensibility in interviews
- easier path toward managed rules and conformance packs later
- better evidence for governance maturity

### Negative
- more IAM, bucket policy, and recorder setup
- additional service cost
- more baseline complexity than a network-only foundation

## Follow-up
A future phase can expand this baseline with:
- AWS Config managed rules
- conformance packs
- centralized aggregation
- security service integration
