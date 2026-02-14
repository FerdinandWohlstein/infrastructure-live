# ISO 27001 Control Mapping

Infrastructure components mapped to ISO/IEC 27001:2022 control themes.

- Primary Architecture: [docs/c4_system.mmd](../docs/c4_system.mmd) and [docs/c4_container.mmd](../docs/c4_container.mmd)
- Security Policy: [SECURITY.md](../SECURITY.md)

## Mapping Methodology

Each component is mapped to relevant control themes (access control, change management, network security, redundancy) with verifiable evidence.

## Component Mapping Matrix

| Component | Control theme | Evidence |
| --- | --- | --- |
| WireGuard | Administrative access control | Firewall rules + no public API exposure + WG peer config. |
| Argo CD | Change management / audit trail | Git history, PR reviews, Argo sync status. |
| Vault (host-level) | Secrets management | Vault policies, audit logs (optional), backup/snapshot procedure. |
| External Secrets Operator | Secrets distribution | `ExternalSecret` definitions in Git, Kubernetes Secrets created/updated. |
| Cilium/Hubble | Network controls | NetworkPolicies, Hubble flows, policy deny events. |
| Object storage backups | Availability / redundancy | Backup job manifests and restore runbook. |
