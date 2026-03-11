variable "aws_region" {
  description = "AWS region for the environment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "Sentinel-Foundation-AWS"
}

variable "org_prefix" {
  description = "Organization prefix for naming"
  type        = string
  default     = "nbf"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for public subnet A"
  type        = string
  default     = "10.20.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for public subnet B"
  type        = string
  default     = "10.20.2.0/24"
}

variable "private_subnet_a_cidr" {
  description = "CIDR block for private subnet A"
  type        = string
  default     = "10.20.11.0/24"
}

variable "private_subnet_b_cidr" {
  description = "CIDR block for private subnet B"
  type        = string
  default     = "10.20.12.0/24"
}

variable "admin_cidr" {
  description = "Trusted admin IP in /32 format for bastion SSH access"
  type        = string
}

variable "cloudtrail_log_retention_days" {
  description = "Retention in days for CloudTrail CloudWatch log group"
  type        = number
  default     = 30
}

variable "flow_logs_retention_days" {
  description = "Retention in days for VPC Flow Logs CloudWatch log group"
  type        = number
  default     = 14
}

variable "config_snapshot_delivery_frequency" {
  description = "AWS Config snapshot delivery frequency"
  type        = string
  default     = "TwentyFour_Hours"
}

variable "enable_monitoring_dashboard" {
  description = "Whether to create a CloudWatch dashboard"
  type        = bool
  default     = true
}

variable "budget_limit_amount" {
  description = "Monthly budget limit amount in USD"
  type        = string
  default     = "25"
}

variable "budget_email_address" {
  description = "Email address for budget and alert notifications"
  type        = string
}

variable "budget_name" {
  description = "Name of the monthly AWS budget"
  type        = string
  default     = "sentinel-foundation-monthly-budget"
}