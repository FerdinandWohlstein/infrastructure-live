# terraform/k3s-cluster

Provisions a single budget-friendly AWS EC2 host for a "K3s - single-node first" learning setup.

## What this creates

- 1x EC2 instance (default VPC + subnet in your chosen AZ)
- 1x Security Group:
  - Public: 80/443 (optional)
  - Admin: SSH (optional) + WireGuard UDP from `admin_cidrs`
  - No public Kubernetes API (6443)
- Optional: 1x Elastic IP (stable IPv4)

## Usage

```bash
cd terraform/k3s-cluster
terraform init
terraform apply \
  -var "aws_region=us-east-1" \
  -var "availability_zone=us-east-1f" \
  -var "ssh_public_key=$(cat ~/.ssh/id_ed25519.pub)" \
  -var 'admin_cidrs=["203.0.113.10/32"]'
```

Then use the `public_ipv4` output for your Ansible inventory / DNS.

## Notes

- This repo already contains Ansible; prefer configuring K3s/WireGuard/Vault via Ansible after the host exists.
- If `us-east-1f` is not available in your AWS account, set `availability_zone` to a zone you have (e.g. `us-east-1a`).
