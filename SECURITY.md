# Security Architecture and Compliance

This document outlines the security controls and architectural decisions implemented to ensure a robust, auditable, and secure infrastructure. The platform is designed with "security as a first-class citizen," following industry best practices and mapping to ISO 27001 controls.

## Architecture Overview

- The C4 diagrams in [docs/c4_system.mmd](docs/c4_system.mmd) and [docs/c4_container.mmd](docs/c4_container.mmd) provide the primary architectural views.
- Components are mapped to ISO/IEC 27001:2022 controls where applicable to ensure compliance.

## Security Control Mapping

| Component | ISO 27001 (example IDs) | Implementation intent |
| --- | --- | --- |
| WireGuard | A.9.2.1 (User access provisioning) | Admin access to Kubernetes API/Argo only via VPN (no public control plane). |
| Traefik Ingress + cert-manager | A.13.1.1 (Network controls) | Controlled ingress, TLS termination, certificate automation. |
| HashiCorp Vault (host-level) | A.9.4 (System and application access control), A.10.1 (Cryptographic controls) | Central secrets store outside K3s to avoid bootstrapping loop; short-lived access for ESO. |
| External Secrets Operator (ESO) | A.9.4, A.12.1.2 (Change management) | GitOps-managed secret sync from Vault into Kubernetes Secrets. |
| Argo CD (GitOps) | A.12.1.2 (Change management) | Declarative change history, PR-based review/audit trail. |
| Cilium / Hubble | A.13.1.1 (Network controls) | Network policy enforcement and traffic observability. |
| Object storage backups | A.17.1.2 (Redundancy) | Off-site backups for datastore/Vault snapshots and optionally observability exports. |

## Trust boundaries (threat-model-lite)

A lightweight trust-boundary view lives in [docs/security_trust_boundaries.mmd](docs/security_trust_boundaries.mmd).

## Practical hardening checklist (budget-friendly)

- Default-deny firewall on the VPS; expose `443/80` only to allow-listed Admin CIDRs (initial setup), keep `6443` private behind WireGuard.
- Enable NetworkPolicies (Cilium) at least for critical namespaces.
- Enforce PR reviews for GitOps repos and protect `main`.
- Use off-site backups and routinely test restore.
