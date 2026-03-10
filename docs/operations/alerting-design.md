# Alerting Design

## Objective
Describe the alerting approach for the foundation baseline.

## Phase 4 Design
In this phase, the project creates alarms without notification targets.
This allows:
- alarm structure validation
- metric validation
- dashboard integration
- low-risk iterative rollout

## Alert Categories
- NAT Gateway operational errors
- packet drops
- telemetry visibility checks

## Notification Strategy
Notification wiring is intentionally deferred to Phase 5, where SNS alerts and budget notifications are introduced.

## Future-State Design
A later phase should connect alarms to:
- SNS topic
- email subscription
- optional ChatOps integration
