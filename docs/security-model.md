# Security Model

## Security Principles

- administrative access restricted by known IP where applicable
- least privilege by default
- explicit auditability
- encryption ownership
- progressive hardening
- financial exposure awareness

## Baseline Controls

### Access Control

- bastion access pattern restricted by trusted admin CIDR
- private workloads accept SSH only from bastion security group
- minimum viable exposure for public-facing patterns

### Encryption

- logging resources protected with customer managed KMS key
- encrypted audit storage in S3
- encrypted CloudWatch log groups where applicable

### Audit and Visibility

- CloudTrail multi-region enabled
- AWS Config recorder enabled
- VPC Flow Logs enabled
- CloudWatch used for telemetry and monitoring

### Governance

- consistent tagging
- naming conventions
- ADR documentation
- evidence captured per phase

### Cost-Aware Security

- AWS Budget alerts
- SNS notification path
- awareness of cost-driven operational risks

## Future-State Security Roadmap

- Security Hub
- GuardDuty
- centralized logging account
- stronger multi-account separation
- Session Manager pattern
