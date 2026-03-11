# Phase 5 Evidence Notes

## Objective

Deploy cost controls and quotas baseline including AWS Budget, SNS alerts, tag-based filtering, quota strategy documentation, and estimated cost sheet.

## Files Modified

- infra/terraform/envs/dev/variables.tf
- infra/terraform/envs/dev/main.tf
- infra/terraform/envs/dev/outputs.tf
- docs/adr/ADR-006-budget-alerts-in-foundation-layer.md
- docs/operations/quota-strategy.md
- docs/costs/estimated-costs.md
- diagrams/technical-detail.mmd

## Commands Executed

Document all PowerShell and Terraform commands used in this phase.

## Expected Result

- SNS topic created
- email subscription created
- AWS Budget created
- CloudWatch alarms connected to SNS
- quota strategy documented
- estimated cost sheet documented

## Actual Result

Pending

## CLI Evidence

- terraform fmt
- terraform init
- terraform validate
- terraform plan
- terraform apply
- terraform output
- aws sns list-topics
- aws sns list-subscriptions-by-topic
- aws budgets describe-budget

## Console Screenshots

- SNS topic
- SNS subscription confirmation
- budget summary
- updated technical diagram

## Issues Found

Pending

## Fix Applied

Pending

## Next Phase Gate

CI/CD pipeline and artifact publishing can begin in Phase 6.
