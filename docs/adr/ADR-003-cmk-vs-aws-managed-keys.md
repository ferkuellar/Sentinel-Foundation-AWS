# ADR-003: Customer Managed KMS Key vs AWS Managed Encryption

## Status
Accepted

## Context
The logging and audit baseline includes CloudTrail, CloudWatch log groups, and encrypted storage for audit data. The project requires a decision on whether to rely only on AWS managed encryption defaults or introduce a customer managed KMS key.

## Decision
This project uses a customer managed KMS key (CMK) for core logging resources.

## Rationale
This option was selected because it provides:
- explicit control over encryption ownership
- clearer architectural intent
- better interview defensibility
- stronger enterprise-style foundation patterns
- a visible security control in Terraform

## Consequences
### Positive
- stronger control over key lifecycle
- clearer security documentation
- better alignment with regulated-environment patterns
- reusable foundation for future centralized logging

### Negative
- extra cost for KMS requests
- more Terraform resources and policy complexity
- more moving parts than default managed encryption

## Alternatives Considered
### AWS Managed Encryption
Pros:
- simpler setup
- less policy complexity
- lower documentation burden

Cons:
- less explicit control
- weaker demonstration of security ownership
- less visible as a deliberate architectural choice
