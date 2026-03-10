# Naming and Tagging Standard

## Naming Convention
Format:

<org>-<platform>-<env>-<resource>-<suffix>

## Naming Rules
- lowercase only
- hyphen-separated
- short, deterministic names
- suffix only when required for uniqueness
- environment must be explicit

## Examples
- nbf-sentinel-dev-vpc-core
- nbf-sentinel-dev-subnet-public-a
- nbf-sentinel-dev-subnet-private-a
- nbf-sentinel-dev-sg-bastion
- nbf-sentinel-dev-kms-logs
- nbf-sentinel-dev-cw-flowlogs
- nbf-sentinel-dev-budget-monthly

## Logical Account Names
- nbf-management
- nbf-security
- nbf-logarchive
- nbf-workloads-dev
- nbf-workloads-prod

## Mandatory Tags
- Project
- Environment
- Owner
- ManagedBy
- CostCenter
- DataClassification
- SecurityTier
- BusinessUnit

## Tag Values for this Project
- Project = Sentinel-Foundation-AWS
- Environment = dev
- Owner = Fernando
- ManagedBy = Terraform
- CostCenter = Platform
- DataClassification = Internal
- SecurityTier = Foundation
- BusinessUnit = Northbound

## Governance Rules
- all supported resources must receive mandatory tags
- default_tags in the AWS provider must be used
- unsupported resources must be documented as exceptions
- untagged resources are considered governance drift
- cost controls assume correct tag inheritance
