provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  assume_role {
    role_arn     = var.terraform_role_arn
    session_name = "TerraformClusterDeployment"
  }

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Project     = var.project
      Environment = var.environment
    }
  }
}
