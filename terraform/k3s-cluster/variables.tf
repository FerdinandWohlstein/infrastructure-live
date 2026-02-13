variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use for authentication"
  type        = string
  default     = "elite-devops"
}

variable "terraform_role_arn" {
  description = "IAM Role ARN for Terraform to assume (enables cross-account and least-privilege access)"
  type        = string
  sensitive   = true
}

variable "availability_zone" {
  description = "AWS availability zone for resource deployment"
  type        = string
  default     = "us-east-1f"
}

variable "name" {
  description = "Infrastructure resource name"
  type        = string
  default     = "k3s-single"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "ami_id" {
  description = "Optional AMI ID override. If null, Ubuntu 24.04 LTS is auto-selected."
  type        = string
  default     = null
}

variable "allocate_eip" {
  description = "Allocate and associate an Elastic IP for a stable IPv4 address."
  type        = bool
  default     = true
}

variable "ssh_public_key" {
  description = "SSH public key material (contents of id_ed25519.pub)"
  type        = string
  default     = ""
}

variable "admin_cidrs" {
  description = "List of administrator CIDR blocks for SSH and WireGuard access"
  type        = list(string)
  default     = []
}

variable "enable_ssh" {
  description = "Whether to allow SSH from admin_cidrs (recommended true for bootstrap)"
  type        = bool
  default     = true
}

variable "wireguard_port" {
  description = "WireGuard UDP port"
  type        = number
  default     = 51820
}

variable "public_http" {
  description = "Expose HTTP 80 publicly (optional; useful for ACME HTTP-01 redirects)"
  type        = bool
  default     = true
}

variable "public_https" {
  description = "Expose HTTPS 443 publicly"
  type        = bool
  default     = true
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 30
}

variable "environment" {
  description = "Environment tag (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "project" {
  description = "Project name for tagging"
  type        = string
  default     = "k3s-cluster"
}
