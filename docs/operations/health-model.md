# Health Model

## Objective
Define what “healthy” means for the foundation baseline.

## Healthy State
The environment is considered healthy when:
- CloudTrail is enabled and delivering logs
- VPC Flow Logs are enabled
- AWS Config recorder is enabled
- the delivery channel is configured
- the audit bucket remains encrypted and private
- the NAT Gateway is not showing operational error signals

## Watch Signals
### Audit Plane
- CloudTrail exists and remains active
- CloudWatch log group receives events
- S3 bucket remains encrypted with CMK

### Governance Plane
- AWS Config recorder is enabled
- delivery channel remains configured

### Network Plane
- NAT Gateway error metrics remain at zero
- packet drop count remains at zero or near-zero baseline

## Deferred Expansion
Future phases may add:
- SNS routing
- Config rules
- Security Hub
- GuardDuty
- centralized dashboards
