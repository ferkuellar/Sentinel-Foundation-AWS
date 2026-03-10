# Phase 3 Evidence Notes

## Objective
Deploy the logging, encryption, and audit baseline including KMS CMK, CloudTrail, S3 audit bucket, CloudWatch log groups, and VPC Flow Logs.

## Files Modified
- infra/terraform/envs/dev/variables.tf
- infra/terraform/envs/dev/main.tf
- infra/terraform/envs/dev/outputs.tf
- docs/adr/ADR-003-cmk-vs-aws-managed-keys.md
- docs/adr/ADR-004-cloudtrail-plus-flowlogs.md
- diagrams/technical-detail.mmd

## Commands Executed
Document all PowerShell and Terraform commands used in this phase.

## Expected Result
- KMS key created
- encrypted S3 bucket created
- CloudTrail created
- CloudWatch log groups created
- VPC Flow Logs enabled
- outputs available
- Terraform validation successful

## Actual Result
Pending

## CLI Evidence
- terraform fmt
- terraform init
- terraform validate
- terraform plan
- terraform apply
- terraform output
- aws cloudtrail describe-trails
- aws logs describe-log-groups
- aws ec2 describe-flow-logs
- aws s3api get-bucket-encryption
- aws kms describe-key

## Console Screenshots
- CloudTrail summary
- S3 bucket encryption
- KMS key
- log groups
- Flow Logs
- updated technical diagram

## Issues Found
Pending

## Fix Applied
Pending

## Next Phase Gate
AWS Config, delivery channel, and recorder can be implemented in Phase 4.
