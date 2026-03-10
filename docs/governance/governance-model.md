# Governance Model

## Purpose
This document defines the governance baseline for Sentinel-Foundation-AWS.

## Scope
This project demonstrates an enterprise-style AWS secure foundation with:
- multi-account thinking
- reusable governance patterns
- baseline network design
- audit and logging controls
- cost awareness
- CI/CD validation
- architectural decision records

## Organizational Model
The foundation uses a logical AWS Organizations model with the following structure:

- Root
  - Management OU
    - management account
  - Security OU
    - security account
    - log-archive account (conceptual or future-state)
  - Workloads OU
    - shared-services account (future-state)
    - workloads-dev account
    - workloads-prod account

## Account Strategy
### Management Account
Used for:
- repository ownership
- IaC lifecycle coordination
- governance documentation
- platform-level administration

### Security Account
Used for:
- audit baseline
- encryption ownership
- centralized security evolution
- logging and monitoring alignment

### Workloads Accounts
Used for:
- business applications
- data platforms
- isolated deployment environments
- blast-radius control
- cost separation

## Project Boundary
### Included in this phase
- OU/account blueprint
- naming standard
- tagging standard
- security model baseline
- executive architecture diagram
- ADR 001

### Excluded from this phase
- full AWS Control Tower rollout
- SCP implementation
- Account Factory
- federated identity platform
- Security Hub and GuardDuty rollout
- centralized multi-account logging deployment

## Governance Principles
- least privilege
- traceability by tagging
- reproducibility through Terraform
- explicit architectural decisions
- evidence by phase
- cost awareness from the foundation layer

## Security Model Summary
- administrative access restricted by known IP where applicable
- least privilege by default
- logs encrypted with customer managed KMS key
- CloudTrail as baseline audit plane
- AWS Config for configuration visibility
- VPC Flow Logs for network visibility
- budgets and alerts for financial exposure awareness
- future evolution toward centralized security services
