# Estimated Costs

## Objective

Provide a practical cost estimate for the Sentinel-Foundation-AWS baseline.

## Cost Components

### NAT Gateway

- fixed hourly cost even at low traffic
- additional data processing cost
- this is usually the most visible idle baseline cost

### CloudWatch Logs

- ingestion cost depends on telemetry volume
- storage cost depends on retention settings

### KMS

- key storage is low cost
- request cost depends on encryption activity

### CloudTrail

- management events baseline is relatively lightweight
- additional delivery and storage costs depend on volume

### AWS Config

- cost depends on the number of configuration items recorded
- continuous recording increases visibility and cost

### SNS

- usually low cost at this scale
- notification volume is expected to be small

## Cost Model Notes

- idle cost and ingest cost are different
- NAT introduces meaningful baseline cost even with light usage
- logs and Config scale with activity and retention
- budget thresholds should be tuned after observing one billing cycle

## Practical Foundation View

This foundation is intentionally small, but not free.
The main baseline cost drivers are:

1. NAT Gateway
2. logging ingestion and storage
3. AWS Config recording volume
