# Phase 2 Evidence Notes

## Objective

Deploy the network foundation baseline including VPC, public and private subnets, route tables, Internet Gateway, NAT Gateway, base security groups, and bastion access pattern.

## Files Modified

- infra/terraform/envs/dev/variables.tf
- infra/terraform/envs/dev/providers.tf
- infra/terraform/envs/dev/terraform.tfvars
- infra/terraform/envs/dev/main.tf
- infra/terraform/envs/dev/outputs.tf
- diagrams/technical-detail.mmd
- docs/adr/ADR-002-single-nat-vs-per-az-nat.md

## Commands Executed

Document all PowerShell and Terraform commands used in this phase.

## Expected Result

- VPC created
- public and private subnets created
- IGW and NAT configured
- route tables associated
- security groups created
- outputs available
- Terraform plan and validation successful

## Actual Result

Pending

## CLI Evidence

- terraform fmt
- terraform init
- terraform validate
- terraform plan
- terraform apply
- terraform output

## Console Screenshots

- VPC
- subnets
- route tables
- Internet Gateway
- NAT Gateway
- Security Groups

## Issues Found

Pending

## Fix Applied

Pending

## Next Phase Gate

Logging, encryption, and audit baseline can begin.
