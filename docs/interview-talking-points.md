
# Interview Talking Points

## 1. What this project demonstrates

This project demonstrates how to build an AWS secure foundation baseline that combines networking, logging, governance, monitoring, cost awareness, and CI/CD validation.

## 2. Why it is more than a VPC lab

The project includes architecture decisions, risk documentation, budget controls, AWS Config, CloudTrail, Flow Logs, and an enterprise roadmap.

## 3. Key design decisions

- custom foundation instead of full Control Tower
- single NAT for cost and simplicity
- CMK for explicit encryption ownership
- CloudTrail plus Flow Logs as baseline telemetry
- bastion access pattern with future path toward Session Manager

## 4. Cost-awareness story

The project documents baseline cost drivers such as NAT Gateway, logs, KMS, AWS Config, CloudTrail, SNS, and storage, while also including a destroy procedure.

## 5. Governance story

The project captures naming standards, tagging strategy, ADRs, risk register, quota strategy, and evidence by phase.

## 6. How it scales

The roadmap evolves toward:

- centralized logging
- security account separation
- Control Tower or Landing Zone Accelerator alignment
- workload onboarding patterns

## 7. What I would improve next

- replace bastion pattern with Session Manager
- introduce centralized security services
- move from single-account implementation to stronger multi-account realization
- expand compliance and detective controls
