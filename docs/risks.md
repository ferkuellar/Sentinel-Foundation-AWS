# Risk Register

## Technical Risks

### KMS policy misconfiguration

A bad KMS policy can block integration with CloudTrail, CloudWatch Logs, or other encrypted logging paths.

### Terraform and console drift

If resources are created or modified outside Terraform, state drift can break reproducibility and complicate plans.

### Inconsistent tagging

Budgets and cost reporting can become inaccurate when required tags are missing or inconsistent.

### Pipeline failure

A broken CI/CD pipeline can block validation and reduce trust in the deployment process.

## Operational Risks

### NAT Gateway continuous cost

The NAT Gateway introduces a persistent baseline cost even during low activity.

### Unconfirmed SNS subscription

If the email subscription is not confirmed, alerts will exist but remain effectively dead.

### Admin IP changes

If the trusted admin IP changes, bastion access can fail until the CIDR is updated.

## Design Risks

### Single-account baseline

This project demonstrates multi-account thinking, but the current implementation does not fully scale like a mature enterprise landing zone.

### Single NAT egress dependency

Using one NAT Gateway creates a single point of failure for private subnet egress.

### No Control Tower guardrails

A custom-built foundation gives control and learning value, but leaves out some managed guardrails available through Control Tower.

## Risk Posture

These risks are accepted because the project is intentionally scoped for reproducibility, portfolio value, and controlled demonstration rather than full production maturity.
