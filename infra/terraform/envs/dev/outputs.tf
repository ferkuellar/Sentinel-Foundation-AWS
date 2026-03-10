output "project_name" {
  value = var.project_name
}

output "aws_region" {
  value = var.aws_region
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.main.id
}

output "bastion_security_group_id" {
  value = aws_security_group.bastion.id
}

output "private_workload_security_group_id" {
  value = aws_security_group.private_workload.id
}

output "web_security_group_id" {
  value = aws_security_group.alb_or_web.id
}

output "availability_zones_used" {
  value = [local.az_a, local.az_b]
}

output "kms_key_arn" {
  value = aws_kms_key.logs.arn
}

output "kms_key_alias" {
  value = aws_kms_alias.logs.name
}

output "audit_logs_bucket_name" {
  value = aws_s3_bucket.audit_logs.id
}

output "cloudtrail_name" {
  value = aws_cloudtrail.main.name
}

output "cloudtrail_arn" {
  value = aws_cloudtrail.main.arn
}

output "cloudtrail_log_group_name" {
  value = aws_cloudwatch_log_group.cloudtrail.name
}

output "flow_logs_log_group_name" {
  value = aws_cloudwatch_log_group.flow_logs.name
}

output "flow_log_id" {
  value = aws_flow_log.vpc.id
}

output "config_recorder_name" {
  value = aws_config_configuration_recorder.main.name
}

output "config_delivery_channel_name" {
  value = aws_config_delivery_channel.main.name
}

output "config_role_arn" {
  value = aws_iam_role.config.arn
}

output "config_recorder_enabled" {
  value = aws_config_configuration_recorder_status.main.is_enabled
}

output "monitoring_dashboard_name" {
  value = var.enable_monitoring_dashboard ? aws_cloudwatch_dashboard.foundation[0].dashboard_name : null
}

output "nat_error_alarm_name" {
  value = aws_cloudwatch_metric_alarm.nat_error_port_allocation.alarm_name
}

output "nat_packets_drop_alarm_name" {
  value = aws_cloudwatch_metric_alarm.nat_packets_drop.alarm_name
}