# Monitoring Notes

## Scope
This document summarizes the monitoring baseline for Sentinel-Foundation-AWS.

## Monitoring Layer in Phase 4
The foundation monitoring layer includes:
- CloudWatch dashboard
- NAT Gateway operational alarms
- visibility of CloudTrail and VPC Flow Logs ingestion
- AWS Config baseline enablement
- health model and alerting design documentation

## Current State
Implemented:
- CloudTrail enabled
- VPC Flow Logs enabled
- AWS Config recorder enabled
- CloudWatch dashboard created
- CloudWatch alarms created without notification actions

Deferred:
- SNS alert routing
- email subscriptions
- budget notifications
- advanced service health integration

## Monitoring Philosophy
The monitoring baseline focuses on:
- visibility first
- low-noise alarms
- operational explainability
- progressive enhancement in later phases
