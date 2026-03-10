# Phase 4 Evidence Notes

## Objective
Deploy governance controls and monitoring baseline including AWS Config, delivery channel, recorder, CloudWatch dashboard, alarms, and monitoring documentation.

## Files Modified
- infra/terraform/envs/dev/variables.tf
- infra/terraform/envs/dev/main.tf
- infra/terraform/envs/dev/outputs.tf
- docs/adr/ADR-005-config-baseline-before-advanced-controls.md
- docs/operations/monitoring-notes.md
- docs/operations/health-model.md
- docs/operations/alerting-design.md
- diagrams/technical-detail.mmd

## Commands Executed
Document all PowerShell and Terraform commands used in this phase.

## Expected Result
- AWS Config recorder created
- delivery channel created
- recorder enabled
- CloudWatch dashboard created
- CloudWatch alarms created
- updated technical diagram completed

## Actual Result
Pending

## CLI Evidence
- terraform fmt
- terraform init
- terraform validate
- terraform plan
- terraform apply
- terraform output
- aws configservice describe-configuration-recorders
- aws configservice describe-delivery-channels
- aws configservice describe-configuration-recorder-status
- aws cloudwatch list-dashboards
- aws cloudwatch describe-alarms

## Console Screenshots
- AWS Config recorder
- delivery channel
- CloudWatch dashboard
- CloudWatch alarms
- updated technical diagram

## Issues Found
Pending

## Fix Applied
Pending

## Next Phase Gate
Budgets, SNS alert wiring, quota strategy, and estimated cost sheet can begin in Phase 5.
