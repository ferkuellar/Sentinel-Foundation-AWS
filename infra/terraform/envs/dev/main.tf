data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

locals {
  name_prefix       = "${var.org_prefix}-sentinel-${var.environment}"
  az_a              = data.aws_availability_zones.available.names[0]
  az_b              = data.aws_availability_zones.available.names[1]
  trail_bucket_name = lower(replace("${local.name_prefix}-audit-${data.aws_caller_identity.current.account_id}", "_", "-"))
}

# =========================================================
# Phase 2 - Network Foundation
# =========================================================

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name_prefix}-vpc-core"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-igw"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = local.az_a
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}-subnet-public-a"
    Tier = "public"
    AZ   = local.az_a
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = local.az_b
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}-subnet-public-b"
    Tier = "public"
    AZ   = local.az_b
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = local.az_a

  tags = {
    Name = "${local.name_prefix}-subnet-private-a"
    Tier = "private"
    AZ   = local.az_a
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = local.az_b

  tags = {
    Name = "${local.name_prefix}-subnet-private-b"
    Tier = "private"
    AZ   = local.az_b
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-rt-public"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${local.name_prefix}-eip-nat"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "${local.name_prefix}-nat-a"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-rt-private"
  }
}

resource "aws_route" "private_nat_egress" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "bastion" {
  name        = "${local.name_prefix}-sg-bastion"
  description = "Bastion security group with SSH access restricted to trusted admin IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from trusted admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-sg-bastion"
    Role = "bastion"
  }
}

resource "aws_security_group" "private_workload" {
  name        = "${local.name_prefix}-sg-private-workload"
  description = "Private workload SG allowing SSH only from bastion SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "SSH from bastion security group"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-sg-private-workload"
    Role = "private-workload"
  }
}

resource "aws_security_group" "alb_or_web" {
  name        = "${local.name_prefix}-sg-web"
  description = "Example web tier SG allowing HTTP and HTTPS"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-sg-web"
    Role = "web"
  }
}

# =========================================================
# Phase 3 - Logging, Encryption and Audit
# =========================================================

data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid    = "EnableRootPermissions"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowCloudTrailUseOfTheKey"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowCloudWatchLogsUseOfTheKey"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logs.${var.aws_region}.amazonaws.com"]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = ["*"]
  }
}

resource "aws_kms_key" "logs" {
  description             = "Customer managed KMS key for Sentinel foundation logging resources"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key_policy.json

  tags = {
    Name = "${local.name_prefix}-kms-logs"
    Role = "logging-encryption"
  }
}

resource "aws_kms_alias" "logs" {
  name          = "alias/${local.name_prefix}-logs"
  target_key_id = aws_kms_key.logs.key_id
}

resource "aws_s3_bucket" "audit_logs" {
  bucket = local.trail_bucket_name

  tags = {
    Name = "${local.name_prefix}-s3-audit-logs"
    Role = "audit-logs"
  }
}

resource "aws_s3_bucket_versioning" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.logs.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "cloudtrail_bucket_policy" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.audit_logs.arn]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.audit_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/aws/cloudtrail/${local.name_prefix}"
  retention_in_days = var.cloudtrail_log_retention_days
  kms_key_id        = aws_kms_key.logs.arn

  tags = {
    Name = "${local.name_prefix}-cw-cloudtrail"
    Role = "cloudtrail"
  }
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name              = "/aws/vpc/flowlogs/${local.name_prefix}"
  retention_in_days = var.flow_logs_retention_days
  kms_key_id        = aws_kms_key.logs.arn

  tags = {
    Name = "${local.name_prefix}-cw-flowlogs"
    Role = "flow-logs"
  }
}

data "aws_iam_policy_document" "cloudtrail_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cloudtrail_to_cloudwatch" {
  name               = "${local.name_prefix}-role-cloudtrail-cw"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_assume_role.json

  tags = {
    Name = "${local.name_prefix}-role-cloudtrail-cw"
  }
}

data "aws_iam_policy_document" "cloudtrail_to_cloudwatch" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
    ]
  }
}

resource "aws_iam_role_policy" "cloudtrail_to_cloudwatch" {
  name   = "${local.name_prefix}-policy-cloudtrail-cw"
  role   = aws_iam_role.cloudtrail_to_cloudwatch.id
  policy = data.aws_iam_policy_document.cloudtrail_to_cloudwatch.json
}

resource "aws_cloudtrail" "main" {
  name                          = "${local.name_prefix}-trail"
  s3_bucket_name                = aws_s3_bucket.audit_logs.id
  kms_key_id                    = aws_kms_key.logs.arn
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_log_file_validation    = true

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_to_cloudwatch.arn

  depends_on = [
    aws_s3_bucket_policy.audit_logs,
    aws_iam_role_policy.cloudtrail_to_cloudwatch
  ]

  tags = {
    Name = "${local.name_prefix}-trail"
    Role = "audit"
  }
}

data "aws_iam_policy_document" "flow_logs_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "flow_logs" {
  name               = "${local.name_prefix}-role-flowlogs"
  assume_role_policy = data.aws_iam_policy_document.flow_logs_assume_role.json

  tags = {
    Name = "${local.name_prefix}-role-flowlogs"
  }
}

data "aws_iam_policy_document" "flow_logs_to_cloudwatch" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]

    resources = [
      aws_cloudwatch_log_group.flow_logs.arn,
      "${aws_cloudwatch_log_group.flow_logs.arn}:*"
    ]
  }
}

resource "aws_iam_role_policy" "flow_logs_to_cloudwatch" {
  name   = "${local.name_prefix}-policy-flowlogs"
  role   = aws_iam_role.flow_logs.id
  policy = data.aws_iam_policy_document.flow_logs_to_cloudwatch.json
}

resource "aws_flow_log" "vpc" {
  iam_role_arn         = aws_iam_role.flow_logs.arn
  log_destination      = aws_cloudwatch_log_group.flow_logs.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-flowlogs-vpc"
    Role = "network-telemetry"
  }
}

# =========================================================
# Phase 4 - Governance Controls and Monitoring
# =========================================================

data "aws_iam_policy_document" "config_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "config" {
  name               = "${local.name_prefix}-role-config"
  assume_role_policy = data.aws_iam_policy_document.config_assume_role.json

  tags = {
    Name = "${local.name_prefix}-role-config"
    Role = "config"
  }
}

resource "aws_iam_role_policy_attachment" "config_managed_policy" {
  role       = aws_iam_role.config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

data "aws_iam_policy_document" "config_bucket_policy" {
  statement {
    sid    = "AWSConfigBucketPermissionsCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.audit_logs.arn
    ]
  }

  statement {
    sid    = "AWSConfigBucketDelivery"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.audit_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

data "aws_iam_policy_document" "merged_audit_bucket_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.cloudtrail_bucket_policy.json,
    data.aws_iam_policy_document.config_bucket_policy.json
  ]
}

resource "aws_s3_bucket_policy" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id
  policy = data.aws_iam_policy_document.merged_audit_bucket_policy.json
}

resource "aws_config_configuration_recorder" "main" {
  name     = "aegis-lz-aws-dev-config-recorder"
  role_arn = "arn:aws:iam::151567229153:role/aegis-lz-aws-dev-aws-config-role"

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.config_managed_policy
  ]
}

resource "aws_config_delivery_channel" "main" {
  name           = "aegis-lz-aws-dev-config-delivery-channel"
  s3_bucket_name = "aegis-lz-aws-dev-151567229153-config-logs"

  snapshot_delivery_properties {
    delivery_frequency = var.config_snapshot_delivery_frequency
  }

  depends_on = [
    aws_config_configuration_recorder.main
  ]
}

resource "aws_config_configuration_recorder_status" "main" {
  name       = aws_config_configuration_recorder.main.name
  is_enabled = true

  depends_on = [
    aws_config_delivery_channel.main
  ]
}

resource "aws_cloudwatch_dashboard" "foundation" {
  count = var.enable_monitoring_dashboard ? 1 : 0

  dashboard_name = "${local.name_prefix}-foundation-overview"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric",
        x      = 0,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          title   = "NAT Gateway Throughput",
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          metrics = [
            ["AWS/NATGateway", "BytesInFromSource", "NatGatewayId", aws_nat_gateway.main.id],
            [".", "BytesOutToDestination", ".", "."]
          ]
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          title   = "NAT Gateway Error Signals",
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          metrics = [
            ["AWS/NATGateway", "ErrorPortAllocation", "NatGatewayId", aws_nat_gateway.main.id],
            [".", "PacketsDropCount", ".", "."],
            [".", "IdleTimeoutCount", ".", "."]
          ]
        }
      },
      {
        type   = "metric",
        x      = 0,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          title   = "CloudWatch Logs Ingestion",
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          metrics = [
            ["AWS/Logs", "IncomingLogEvents", "LogGroupName", aws_cloudwatch_log_group.cloudtrail.name],
            [".", "IncomingLogEvents", "LogGroupName", aws_cloudwatch_log_group.flow_logs.name]
          ]
        }
      },
      {
        type   = "text",
        x      = 12,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          markdown = "# Foundation Monitoring Notes\n- CloudTrail enabled\n- VPC Flow Logs enabled\n- AWS Config recorder enabled\n- SNS wiring deferred to Phase 5"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "nat_error_port_allocation" {
  alarm_name          = "${local.name_prefix}-nat-error-port-allocation"
  alarm_description   = "Detect NAT Gateway port allocation errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ErrorPortAllocation"
  namespace           = "AWS/NATGateway"
  period              = 300
  statistic           = "Sum"
  threshold           = 0
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.foundation_alerts.arn]
  ok_actions          = [aws_sns_topic.foundation_alerts.arn]

  dimensions = {
    NatGatewayId = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${local.name_prefix}-nat-error-port-allocation"
    Role = "monitoring"
  }
}

resource "aws_cloudwatch_metric_alarm" "nat_packets_drop" {
  alarm_name          = "${local.name_prefix}-nat-packets-drop"
  alarm_description   = "Detect packet drops on the NAT Gateway"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "PacketsDropCount"
  namespace           = "AWS/NATGateway"
  period              = 300
  statistic           = "Sum"
  threshold           = 0
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.foundation_alerts.arn]
  ok_actions          = [aws_sns_topic.foundation_alerts.arn]

  dimensions = {
    NatGatewayId = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${local.name_prefix}-nat-packets-drop"
    Role = "monitoring"
  }
}

resource "aws_cloudwatch_metric_alarm" "config_recorder_visibility" {
  alarm_name          = "${local.name_prefix}-config-delivery-failures-visibility"
  alarm_description   = "Visibility alarm placeholder for AWS Config delivery status monitoring design"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "IncomingLogEvents"
  namespace           = "AWS/Logs"
  period              = 300
  statistic           = "Sum"
  threshold           = 0
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.foundation_alerts.arn]
  ok_actions          = [aws_sns_topic.foundation_alerts.arn]

  dimensions = {
    LogGroupName = aws_cloudwatch_log_group.cloudtrail.name
  }

  tags = {
    Name = "${local.name_prefix}-config-delivery-failures-visibility"
    Role = "monitoring-design"
  }
}

resource "aws_sns_topic" "foundation_alerts" {
  name = "${local.name_prefix}-alerts"

  tags = {
    Name = "${local.name_prefix}-alerts"
    Role = "alerting"
  }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.foundation_alerts.arn
  protocol  = "email"
  endpoint  = var.budget_email_address
}

resource "aws_budgets_budget" "monthly_foundation" {
  name         = var.budget_name
  budget_type  = "COST"
  limit_amount = var.budget_limit_amount
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_filter {
    name   = "TagKeyValue"
    values = ["Project$${var.project_name}"]
  }

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 80
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [aws_sns_topic.foundation_alerts.arn]
  }

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 100
    threshold_type            = "PERCENTAGE"
    notification_type         = "FORECASTED"
    subscriber_sns_topic_arns = [aws_sns_topic.foundation_alerts.arn]
  }
}