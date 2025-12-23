# ISO 27001 mapping (learning notes)

This folder contains lightweight compliance mapping notes intended for learning and interview-readiness.

- Primary architecture references: [docs/c4_system.mmd](../docs/c4_system.mmd) and [docs/c4_container.mmd](../docs/c4_container.mmd)
- Security overlay: [SECURITY.md](../SECURITY.md)

## Mapping approach

- Map *components* to *control themes* (access control, change management, network controls, redundancy).
- Keep mappings short and verifiable ("what is implemented"), not aspirational.

## Component mapping (starter)

| Component | Control theme | Evidence you can point to |
| --- | --- | --- |
| WireGuard | Administrative access control | Firewall rules + no public API exposure + WG peer config. |
| Argo CD | Change management / audit trail | Git history, PR reviews, Argo sync status. |
| Vault (host-level) | Secrets management | Vault policies, audit logs (optional), backup/snapshot procedure. |
| External Secrets Operator | Secrets distribution | `ExternalSecret` definitions in Git, Kubernetes Secrets created/updated. |
| Cilium/Hubble | Network controls | NetworkPolicies, Hubble flows, policy deny events. |
| Object storage backups | Availability / redundancy | Backup job manifests and restore runbook. |

## TODO for future (optional)

- If targeting ISO/IEC 27001:2022 specifically, add a second column with the 2022 control numbering for your chosen mappings.
