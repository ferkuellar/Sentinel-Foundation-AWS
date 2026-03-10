# ADR-002: Single NAT Gateway vs NAT Gateway per Availability Zone

## Status

Accepted

## Context

The network foundation requires outbound internet access for private subnets.
Two common design options are:

1. one NAT Gateway shared by multiple private subnets
2. one NAT Gateway per Availability Zone

## Decision

This project uses a single NAT Gateway in the initial foundation baseline.

## Rationale

This option was selected because it provides:

- lower baseline cost
- simpler Terraform topology
- easier demo reproducibility
- enough functionality for a portfolio foundation

## Trade-offs

### Positive

- cheaper to keep alive
- fewer moving parts
- easier to explain in interview settings

### Negative

- reduced resilience compared to per-AZ NAT
- cross-AZ dependency for one private subnet
- not the preferred pattern for high-availability production workloads

## Follow-up

A future production-grade evolution may introduce:

- one NAT Gateway per AZ
- private route table split per AZ
- stronger fault isolation
