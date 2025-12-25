data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "this" {
  name        = var.name
  description = "Security group for single-node K3s host"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.public_http ? [1] : []
    content {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = var.admin_cidrs
      ipv6_cidr_blocks = []
    }
  }

  dynamic "ingress" {
    for_each = var.public_https ? [1] : []
    content {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = var.admin_cidrs
      ipv6_cidr_blocks = []
    }
  }

  dynamic "ingress" {
    for_each = var.enable_ssh ? [1] : []
    content {
      description      = "SSH (bootstrap/admin)"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = length(var.admin_cidrs) > 0 ? var.admin_cidrs : []
      ipv6_cidr_blocks = []
    }
  }

  ingress {
    description      = "WireGuard VPN"
    from_port        = var.wireguard_port
    to_port          = var.wireguard_port
    protocol         = "udp"
    cidr_blocks      = length(var.admin_cidrs) > 0 ? var.admin_cidrs : []
    ipv6_cidr_blocks = []
  }

  egress {
    description      = "Allow all outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
