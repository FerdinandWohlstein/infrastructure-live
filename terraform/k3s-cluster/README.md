# K3s Cluster Infrastructure

Provisions a secure single-node K3s cluster on AWS EC2.

## Infrastructure Components

- **Compute:** EC2 instance running Ubuntu 24.04 LTS.
- **Networking:** Security Group with restricted ingress (SSH, WireGuard, HTTPS) and optional Elastic IP.
- **Security:** Integration with AWS KMS for secret management and state encryption.

## Deployment

```bash
cd terraform/k3s-cluster
terraform init
terraform apply
```

## Configuration

Set the required variables in `terraform.tfvars`, including `ssh_public_key` and `admin_cidrs`.

## Post-Provisioning

After the infrastructure is provisioned, use the provided Ansible playbooks in the `ansible/` directory to bootstrap the node and deploy services.
