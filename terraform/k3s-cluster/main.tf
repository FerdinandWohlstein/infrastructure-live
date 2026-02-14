module "firewall" {
  source = "../modules/security-group"

  name           = "${var.name}-fw"
  admin_cidrs    = var.admin_cidrs
  enable_ssh     = var.enable_ssh
  public_http    = var.public_http
  public_https   = var.public_https
  wireguard_port = var.wireguard_port
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_vpc" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = [var.availability_zone]
  }
}

locals {
  subnet_id = data.aws_subnets.default_vpc.ids[0]
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

module "node" {
  source = "../modules/compute-node"

  name              = var.name
  availability_zone = var.availability_zone
  subnet_id         = local.subnet_id
  instance_type     = var.instance_type
  ami_id            = coalesce(var.ami_id, data.aws_ami.ubuntu.id)
  ssh_public_key    = var.ssh_public_key

  allocate_eip     = var.allocate_eip
  root_volume_size = var.root_volume_size
  environment      = var.environment
  project          = var.project
  sops_kms_key_arn = var.sops_kms_key_arn

  security_group_id = module.firewall.security_group_id
}
