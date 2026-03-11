provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project            = var.project_name
      Environment        = var.environment
      Owner              = "Fernando"
      ManagedBy          = "Terraform"
      CostCenter         = "Platform"
      DataClassification = "Internal"
      SecurityTier       = "Foundation"
      BusinessUnit       = "Northbound"
    }
  }
}