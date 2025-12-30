provider "aws" {
  region = var.aws_region
  profile = "elite-devops"

  assume_role {
    role_arn     = "arn:aws:iam::428207760481:role/TerraformProvisionerRole"

    session_name = "TerraformClusterDeployment"
  }
    default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Project     = "k3s-cluster"
      Environment = var.environment
    }
  }
}

provider "sops" {
}
