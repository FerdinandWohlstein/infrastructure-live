variable "name" {
  type        = string
  description = "Server name"
}

variable "availability_zone" {
  type        = string
  description = "AWS availability zone"
}

variable "subnet_id" {
  type        = string
  description = "Subnet id for the instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "ami_id" {
  type        = string
  description = "AMI id"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key material"
}

variable "security_group_id" {
  type        = string
  description = "Security group id to attach to the instance"
}

variable "allocate_eip" {
  type        = bool
  description = "Allocate and associate an Elastic IP"
  default     = true
}

variable "root_volume_size" {
  type        = number
  description = "Root volume size in GB"
  default     = 30
}

variable "environment" {
  type        = string
  description = "Environment tag (e.g., dev, staging, prod)"
  default     = "prod"
}

variable "project" {
  type        = string
  description = "Project name for tagging"
  default     = "k3s-cluster"
}
