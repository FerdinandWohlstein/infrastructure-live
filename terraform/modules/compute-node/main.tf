resource "aws_key_pair" "this" {
  count      = var.ssh_public_key != "" ? 1 : 0
  key_name   = "${var.name}-ssh"
  public_key = var.ssh_public_key
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.name}-node-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name        = "${var.name}-node-role"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
}

data "aws_iam_policy_document" "sops_decrypt" {
  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = [var.sops_kms_key_arn]
  }
}

resource "aws_iam_role_policy" "sops_decrypt" {
  name   = "${var.name}-sops-kms-decrypt"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.sops_decrypt.json
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-node-profile"
  role = aws_iam_role.this.name
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.ssh_public_key != "" ? aws_key_pair.this[0].key_name : null
  iam_instance_profile   = aws_iam_instance_profile.this.name

  user_data = file("${path.module}/bootstrap.sh")

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name        = "${var.name}-root"
      Environment = var.environment
      Project     = var.project
      ManagedBy   = "terraform"
    }
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name        = var.name
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
}

resource "aws_eip" "this" {
  count  = var.allocate_eip ? 1 : 0
  domain = "vpc"

  tags = {
    Name        = "${var.name}-eip"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
}

resource "aws_eip_association" "this" {
  count         = var.allocate_eip ? 1 : 0
  allocation_id = aws_eip.this[0].id
  instance_id   = aws_instance.this.id
}
