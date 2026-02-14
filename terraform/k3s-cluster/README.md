# K3s Cluster Infrastructure

Provisions a secure AWS EC2 host for a single-node K3s deployment. This module manages the core infrastructure components required for a production-ready GitOps platform.

## Infrastructure Components

- **Compute:** EC2 instance running Ubuntu 24.04 LTS.
- **Networking:** Security Group with restricted ingress (SSH, WireGuard, HTTPS) and optional Elastic IP.
- **Security:** Integration with AWS KMS for secret management and state encryption.
- **Automatic Bootstrap:** The `compute-node` module includes a `bootstrap.sh` script executed via EC2 `user_data` that:
  - Installs core dependencies (git, curl, Python, Ansible, SOPS, WireGuard)
  - Detects system architecture for proper SOPS binary installation
  - Clones this repository and runs `ansible-pull` for initial configuration
  - Logs all output to `/var/log/user-data.log` for troubleshooting

## Deployment

```bash
cd terraform/k3s-cluster
terraform init
terraform apply
```

## Configuration

Ensure `terraform.tfvars` is populated with the required variables, including `ssh_public_key` and `admin_cidrs`.

## Post-Provisioning

After Terraform provisions the infrastructure:

1. **Automatic Bootstrap:** The EC2 instance runs `bootstrap.sh` automatically via `user_data`, which:
   - Installs system packages and dependencies
   - Pulls Ansible configuration from the repository
   - Applies the initial configuration via `ansible-pull`

2. **Manual Configuration (Optional):** For additional configuration or updates, run Ansible playbooks manually:
   ```bash
   cd ../../ansible
   ansible-playbook -i inventory site.yml
   ```

3. **Monitoring Bootstrap:** Check bootstrap progress via system logs:
   ```bash
   ssh ubuntu@<instance-ip> tail -f /var/log/user-data.log
   ```

See [POST_SETUP.md](../../docs/POST_SETUP.md) for detailed post-provisioning steps including WireGuard setup and kubeconfig configuration.
