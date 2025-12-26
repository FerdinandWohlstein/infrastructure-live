# Infrastructure Live

Enterprise-grade GitOps Platform built with K3s, Terraform, and Ansible. This repository manages the lifecycle of a secure, scalable infrastructure with a focus on Zero-Trust security, ISO 27001 compliance, and comprehensive observability.

## Core Technologies

- **Infrastructure as Code:** Terraform for cloud resource provisioning.
- **Configuration Management:** Ansible for host-level hardening and service deployment.
- **Orchestration:** K3s (Lightweight Kubernetes) for containerized workloads.
- **Security:** HashiCorp Vault, SOPS, and Cilium for secret management and network security.
- **GitOps:** Argo CD for declarative application delivery.

## Documentation

- **Architecture:** [C4 System Diagram](docs/c4_system.mmd), [C4 Container Diagram](docs/c4_container.mmd)
- **Security & Compliance:** [Security Architecture](SECURITY.md), [ISO 27001 Mapping](compliance/iso27001-mapping.md)

## Getting Started

1. **Provision Infrastructure:** Navigate to `terraform/k3s-cluster` and run `terraform apply`.
2. **Configure Hosts:** Use Ansible to bootstrap the nodes: `cd ansible && ansible-playbook site.yml`.
3. **Deploy Applications:** Argo CD will automatically sync manifests from the `kubernetes/` directory.
