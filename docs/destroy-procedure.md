# Destroy Procedure

## Objective

Describe how to safely reduce cost when the environment is idle, while preserving enough material for demos and interviews.

## Before Destroy

- confirm screenshots and CLI evidence are already captured
- confirm Terraform state is healthy
- confirm artifacts and diagrams are committed
- confirm SNS and budget evidence has been saved

## Recommended Destroy Order

1. review what must be kept for demo
2. export latest Terraform plan or outputs
3. destroy ephemeral foundation resources
4. keep documentation, diagrams, and evidence in GitHub

## What to Destroy When Idle

- NAT Gateway
- test workload resources
- optional high-cost telemetry if not needed for demonstration

## What to Keep for Demo

- repository
- diagrams
- markdown docs
- ADR pack
- screenshots evidence
- pipeline definition

## Terraform Command

Use carefully from the environment directory:

terraform destroy

## Operational Note

Destroying the environment reduces cost, especially NAT-related baseline cost. Always capture evidence first.
