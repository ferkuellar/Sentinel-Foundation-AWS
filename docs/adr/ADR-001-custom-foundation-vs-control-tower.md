# ADR-001: Custom Foundation vs AWS Control Tower Full Landing Zone

## Status
Accepted

## Context
Sentinel-Foundation-AWS aims to demonstrate an enterprise-ready AWS secure foundation baseline with Terraform, governance controls, auditability, cost awareness, and CI/CD validation.

A core architectural choice is whether to start with:
1. a custom-built foundation baseline, or
2. a full AWS Control Tower landing zone from the beginning.

## Decision
The project will start with a custom-built foundation baseline.

## Rationale
This option was selected because it provides:
- greater implementation control
- better learning visibility
- clearer resource-level understanding
- easier portfolio reproducibility
- cleaner phase-based evidence capture
- lower initial complexity

## Consequences
### Positive
- explicit architecture decisions are visible
- Terraform structure stays understandable
- easier to defend in technical interviews
- lower barrier to iterative expansion

### Negative
- fewer managed guardrails out of the box
- more manual governance documentation
- less enterprise-native than Control Tower on day one
- some controls remain roadmap items

## Alternatives Considered
### AWS Control Tower Full Deployment
Pros:
- enterprise-native starting point
- strong guardrail model
- aligned with mature multi-account environments

Cons:
- more opinionated
- heavier starting complexity
- less transparent for learning-focused portfolio work
- harder to keep narrowly scoped at first

## Follow-up
This project should retain a future migration path toward:
- AWS Control Tower
- Landing Zone Accelerator alignment
- centralized security services
