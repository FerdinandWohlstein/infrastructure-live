# Infrastructure Live

Enterprise-grade GitOps Platform built with K3s, Terraform, and Ansible. This repository manages the lifecycle of a secure, scalable infrastructure with a focus on Zero-Trust security, ISO 27001 compliance, and comprehensive observability.

## 🛠️ Core Technologies

- **Infrastructure as Code:** Terraform for cloud resource provisioning.
- **Configuration Management:** Ansible with FQCN and SOPS integration for host-level hardening.
- **VPN:** WireGuard for secure administrative access and node-to-node communication.
- **Orchestration:** K3s (Lightweight Kubernetes) for containerized workloads.
- **Security:** HashiCorp Vault, SOPS (Age/KMS), and Cilium for secret management and network security.
- **GitOps:** Argo CD using the **App-of-Apps** pattern for declarative delivery.
- **CI/CD Security:** GitHub Actions with **Trivy** and **Kube-Linter** for automated vulnerability and configuration scanning.

## 📁 Repository Structure

- `ansible/`: Modular roles for server configuration (WireGuard, K3s, Vault).
- `kubernetes/`:
  - `bootstrap/`: Root ArgoCD application and foundational manifests.
  - `apps/`: Application definitions and namespaces.
- `terraform/`: Platform-specific resource definitions.
- `docs/`: Architecture diagrams and compliance documentation.

## 🛡️ CI/CD & Security

Every push and PR to `main` triggers:
1. **Trivy Scan:** Vulnerability scanning for Kubernetes and Ansible configurations.
2. **Kube-Linter:** Best-practice analysis for Kubernetes manifests.

## 🚀 Getting Started

1. **Provision Infrastructure:** Navigate to `terraform/k3s-cluster` and run `terraform apply`.
2. **Configure Hosts:** Bootstrap nodes with Ansible:
   ```bash
   cd ansible
   ansible-playbook site.yml
   ```
3. **Deploy Applications:** Argo CD automatically syncs from `kubernetes/bootstrap/root.yaml` pointing to the `main` branch.

## ⚙️ Maintenance & Operations

### Certificate Rotation
To rotate K3s certificates and update the local kubeconfig:
```bash
ansible-playbook -i inventory/hosts.yml rotate_certs.yml
```

### Secret Management
Encrypt new secrets using SOPS:
```bash
sops --encrypt --kms <KMS_ARN> new_secret.yaml > new_secret.sops.yaml
```

## 📖 Documentation

- **Architecture:** [C4 System Diagram](docs/c4_system.mmd), [C4 Container Diagram](docs/c4_container.mmd)
- **Security:** [Security Checklist](docs/learnings/infrastructure_checklist.md)
- **Learnings:** [DevOps Best Practices](docs/learnings/infrastructure_checklist.md)
