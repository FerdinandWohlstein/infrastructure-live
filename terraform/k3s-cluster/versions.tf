terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.3.0"
    }
  }  
    backend "s3" {
    bucket         = "infrastructure-live-terraform-state-43287"
    key            = "k3s-cluster/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id     = "alias/terraform-state"
    dynamodb_table = "terraform-locks"
    profile        = "terraform-provisioner"
  }
}
