# K3s Cluster Infrastructure

Provisions a secure AWS EC2 host for a single-node K3s deployment. This module manages the core infrastructure components required for a production-ready GitOps platform.

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

Ensure `terraform.tfvars` is populated with the required variables, including `ssh_public_key` and `admin_cidrs`.

## Post-Provisioning

After the infrastructure is provisioned, use the provided Ansible playbooks in the `ansible/` directory to bootstrap the node and deploy services.
