provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Sentinel-Foundation-AWS"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "Fernando"
    }
  }
}